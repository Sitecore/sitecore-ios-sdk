#import "SCWebPlugin.h"

#import "NSArray+CameraSourceTypes.h"
#import "UIPopoverController+PresentPopoverInWebView.h"

#import "SCWaitView.h"

#import "SCCameraPluginError.h"

#import "camera.js.h"
#import "cameraSourceType.js.h"

//src: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;

@end

@implementation UIImage (fixOrientation)

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    static const CGFloat M_PI_F = (CGFloat)M_PI;
    static const CGFloat M_PI_2_F = (CGFloat)M_PI_2;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI_F);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2_F);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2_F);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.

    CGContextRef ctx = NULL;
#if defined(__LP64__) && __LP64__
    {
        ctx = CGBitmapContextCreate(
            NULL,
            (size_t)lround( self.size.width  ),
            (size_t)lround( self.size.height ),
            CGImageGetBitsPerComponent(self.CGImage), 0,
            CGImageGetColorSpace(self.CGImage),
            CGImageGetBitmapInfo(self.CGImage));
    }
#else
    {
        ctx = CGBitmapContextCreate(
            NULL,
            (size_t)lroundf( self.size.width  ),
            (size_t)lroundf( self.size.height ),
            CGImageGetBitsPerComponent(self.CGImage), 0,
            CGImageGetColorSpace(self.CGImage),
            CGImageGetBitmapInfo(self.CGImage));
    }
#endif
    
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

//STODO remove
@interface UIImage (StoreTmpFileSCGetPicturePlugin)

-(NSString*)tmpPathToPNGImage;

@end

//STODO remove
@interface NSString (PathToDWFileURLSCGetPicturePlugin)

-(NSString*)dwFilePath;

@end

@interface SCGetPicturePlugin : NSObject
<
    SCWebPlugin
    , UIImagePickerControllerDelegate
    , UINavigationControllerDelegate
    , UIPopoverControllerDelegate
>

@property ( nonatomic ) UIImagePickerController* imagePickerController;
@property ( nonatomic ) UIPopoverController* popover;
@property ( nonatomic ) NSURLRequest* request;
@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation SCGetPicturePlugin
{
    __weak UIView* _webView;
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        self->_request = request_;
    }

    return self;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/camera/get_picture" ];
}

-(BOOL)closeWhenBackground
{
    return YES;
}

+(NSString*)pluginJavascript
{
    NSString* js_ = [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_camera_camera_js
                                                length: __SCWebPlugins_Plugins_camera_camera_js_len
                                              encoding: NSUTF8StringEncoding ];
    NSString* jsCameraOptions_ = [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_camera_cameraSourceType_js
                                                             length: __SCWebPlugins_Plugins_camera_cameraSourceType_js_len
                                                           encoding: NSUTF8StringEncoding ];

    NSArray* sourceTypes_ = [ NSArray cameraSourceTypes ];
    jsCameraOptions_ = [ [ NSString alloc ] initWithFormat: jsCameraOptions_
                        , [ sourceTypes_ componentsJoinedByString: @", " ] ];

    return [ js_ stringByAppendingString: jsCameraOptions_ ];
}

-(void)showPopoverWithController:( UIViewController* )controller_
                            view:( UIWebView* )view_
{
    self->_popover = [ [ UIPopoverController alloc ] initWithContentViewController: controller_ ];
    self->_popover.delegate = self;

    [ self->_popover presentPopoverFromRect: CGRectMake( 0.f, 0.f, 400.f, 600.f )
                                  inWebView: view_ ];
}

-(void)getPictureForWebView:( UIWebView* )webView_
                 sourceType:( NSString* )sourceTypeStr_
{
    UIViewController* rootController_ = webView_.window.rootViewController;
    if ( !rootController_ )
    {
        SCCameraPluginError* error = [ SCCameraPluginError noRootViewControllerError ];
        
        [ self.delegate sendMessage: [ error toJson ] ];
        [ self.delegate close ];
        return;
    }

    UIImagePickerControllerSourceType sourceType_ = (UIImagePickerControllerSourceType)[ sourceTypeStr_ integerValue ];

    if ( ![ UIImagePickerController isSourceTypeAvailable: sourceType_ ] )
    {
        SCCameraPluginError* error = [ SCCameraPluginError cameraSourceUnavailableError ];
        [ self.delegate sendMessage: [ error toJson ] ];
        [ self.delegate close ];
        return;
    }

    UIImagePickerController* imagePicker = [ UIImagePickerController new ];
    self->_imagePickerController = imagePicker;
    self->_imagePickerController.delegate = self;

    if ( sourceType_ > UIImagePickerControllerSourceTypeSavedPhotosAlbum )
    {
        sourceType_ = UIImagePickerControllerSourceTypePhotoLibrary;
    }

#if TARGET_IPHONE_SIMULATOR
    //fix crash for simulator only
    if ( sourceType_ == UIImagePickerControllerSourceTypeSavedPhotosAlbum )
    {
        sourceType_ = UIImagePickerControllerSourceTypePhotoLibrary;
    }
#endif //TARGET_IPHONE_SIMULATOR

    self->_imagePickerController.sourceType = sourceType_;
    
    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        [ rootController_ presentTopViewController: self->_imagePickerController
                                          animated: YES
                                        completion: nil ];
    }
    else
    {
        [ self showPopoverWithController: self->_imagePickerController
                                    view: webView_ ];
    }
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    self->_webView = webView_;
    
    NSDictionary* components_ = [ self.request.URL queryComponents ];
    NSString* sourceType_     = [ components_ firstValueIfExsistsForKey: @"sourceType" ];

   [ self getPictureForWebView: webView_
                    sourceType: sourceType_ ];
}

-(void)hideImagePicker
{
    if ( self.popover )
    {
        [ self.popover dismissPopoverAnimated: YES ];
    }
    else
    {
        UIImagePickerController* imagePicker = self.imagePickerController;
        [ imagePicker dismissViewControllerAnimated: NO
                                         completion: nil ];
    }

    self.popover = nil;
    self.imagePickerController = nil;
}

-(void)onStop
{
    [ self.delegate close ];

    self.popover = nil;
    [ self performSelector: @selector( setImagePickerController: )
                withObject: nil
                afterDelay: 0.2 ];
}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:( UIImagePickerController* )picker_
didFinishPickingMediaWithInfo:( NSDictionary* )info_
{
    UIImage* image_ = info_[ UIImagePickerControllerOriginalImage ];
    image_ = [ image_ fixOrientation ];

    [ self hideImagePicker ];

    JFFAsyncOperation loader_ = asyncOperationWithSyncOperation( ^id( NSError** error_ )
    {
        return [ image_ tmpPathToPNGImage ];
    } );

    static const CGRect PROGRESS_VIEW_DIMENSIONS = { {0.f, 0.f}, {300.f, 100.f} };
    
    SCWaitView* waitView_ =
    [ [ SCWaitView alloc ] initWithFrame: PROGRESS_VIEW_DIMENSIONS
                            cornerRadius: 15.f
                               superview: self->_webView ];
    [ waitView_ show ];

    loader_( nil, nil, ^( id path_, NSError* error_ )
    {
        [ waitView_ hide ];

        NSString* arguments_ = [ [ NSString alloc ] initWithFormat: @"{ url: '%@' }", [ path_ dwFilePath ] ];
        [ self.delegate sendMessage: arguments_ ];
        [ self onStop ];
    } );
}

-(void)imagePickerControllerDidCancel:( UIImagePickerController* )picker_
{
    SCCameraPluginError* error = [ SCCameraPluginError operationCancelledError ];
    [ self.delegate sendMessage: [ error toJson ] ];

    [ self hideImagePicker ];

    [ self onStop ];
}

#pragma mark UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:( UIPopoverController* )popoverController_
{
    SCCameraPluginError* error = [ SCCameraPluginError operationCancelledError ];
    [ self.delegate sendMessage: [ error toJson ] ];

    [ self onStop ];
}

-(void)didClose
{
    [ self hideImagePicker ];
}

@end
