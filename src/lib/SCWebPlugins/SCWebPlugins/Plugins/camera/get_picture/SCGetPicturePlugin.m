#import "SCWebPlugin.h"

#import "NSArray+CameraSourceTypes.h"
#import "UIPopoverController+PresentPopoverInWebView.h"

#import "SCWaitView.h"

#include "camera.js.h"
#include "cameraSourceType.js.h"

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
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
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
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
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

@end

@implementation SCGetPicturePlugin

@synthesize delegate;
@synthesize imagePickerController = _imagePickerController;
@synthesize popover               = _popover;
@synthesize request               = _request;

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    self.request = request_;

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
        [ self.delegate sendMessage: @"{ error: 'Can not open window' }" ];
        [ self.delegate close ];
        return;
    }

    UIImagePickerControllerSourceType sourceType_ = [ sourceTypeStr_ integerValue ];

    if ( ![ UIImagePickerController isSourceTypeAvailable: sourceType_ ] )
    {
        [ self.delegate sendMessage: @"{ error: 'Camera source type is not available' }" ];
        [ self.delegate close ];
        return;
    }

    self->_imagePickerController = [ UIImagePickerController new ];
    self->_imagePickerController.delegate = self;

    if ( sourceType_ > UIImagePickerControllerSourceTypeSavedPhotosAlbum )
    {
        sourceType_ = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self->_imagePickerController.sourceType = sourceType_;

    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        [ rootController_ presentTopViewController: self->_imagePickerController ];
    }
    else
    {
        [ self showPopoverWithController: self->_imagePickerController
                                    view: webView_ ];
    }
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
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
        [ self.imagePickerController dismissViewControllerAnimated: NO completion: nil ];
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
    UIImage* image_ = [ info_ objectForKey: UIImagePickerControllerOriginalImage ];
    image_ = [ image_ fixOrientation ];

    [ self hideImagePicker ];

    JFFAsyncOperation loader_ = asyncOperationWithSyncOperation( ^id( NSError** error_ )
    {
        return [ image_ tmpPathToPNGImage ];
    } );

    SCWaitView* waitView_ = [ SCWaitView waitView ];
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
    [ self.delegate sendMessage: @"{ error: 'Did cancel image pick' }" ];

    [ self hideImagePicker ];

    [ self onStop ];
}

#pragma mark UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:( UIPopoverController* )popoverController_
{
    [ self.delegate sendMessage: @"{ error: 'Did cancel image pick' }" ];

    [ self onStop ];
}

-(void)didClose
{
    [ self hideImagePicker ];
}

@end
