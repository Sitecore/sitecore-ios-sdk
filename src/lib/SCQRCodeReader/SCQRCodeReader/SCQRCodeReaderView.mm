#import "SCQRCodeReaderView.h"

#import "SCQRCodeReaderViewDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <zxing/common/Counted.h>
#import <DecoderDelegate.h>
#import <Decoder.h>
#import <QRCodeReader.h>
#import <TwoDDecoderResult.h>

#if !TARGET_IPHONE_SIMULATOR
#define HAS_AVFF 1
#endif

@interface SCQRCodeReaderView () < AVCaptureVideoDataOutputSampleBufferDelegate
                                 , DecoderDelegate >

@property ( nonatomic ) AVCaptureSession*           captureSession;
@property ( nonatomic ) AVCaptureVideoPreviewLayer* prevLayer;
@property ( nonatomic ) NSSet*                      readers;
@property ( nonatomic ) BOOL                        decoding;

-(void)initCapture;
-(void)setup;

@end

@implementation SCQRCodeReaderView

@synthesize readers;
@synthesize delegate = _delegate;

@synthesize captureSession = _captureSession;
@synthesize prevLayer;
@synthesize decoding;
@synthesize captureRect = _captureRect;

+ (id)viewWithDelegate:(id<SCQRCodeReaderViewDelegate>)delegate_
           captureRect:(CGRect)captureRect_;
{
    SCQRCodeReaderView* view_ = [ SCQRCodeReaderView new ];
    view_.delegate = delegate_;

    view_->_captureRect = captureRect_;

    [ view_ setup ];

    return view_;
}

-(void)setup
{
    readers = [ [ NSSet alloc ] initWithObjects: [ QRCodeReader new ], nil ];
}

-(void)awakeFromNib
{
    [ super awakeFromNib ];

    [ self setup ];

    self.captureRect = CGRectZero;
}

-(void)startCapture
{
    if ( TARGET_IPHONE_SIMULATOR || self.decoding )
    {
        return;
    }

    self.decoding = YES;

    [ self initCapture ];
    [ self.captureSession startRunning ];
}

-(void)stopCapture
{
    if ( !self.decoding )
        return;

    self.decoding = NO;

    [ self.captureSession stopRunning ];

    [ self.prevLayer removeFromSuperlayer ];
    self.prevLayer = nil;    
}

-(BOOL)isCaptureInProgress
{
    return self.decoding;
}

-(AVCaptureSession*)captureSession
{
    if ( !_captureSession )
    {
        _captureSession = [ AVCaptureSession new ];
        _captureSession.sessionPreset = AVCaptureSessionPresetMedium;

        AVCaptureDevice* device_           = [ AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo ];
        AVCaptureDeviceInput* captureInput = [ AVCaptureDeviceInput deviceInputWithDevice: device_
                                                                                    error: nil ];

        AVCaptureVideoDataOutput* captureOutput     = [ AVCaptureVideoDataOutput new ];
        captureOutput.alwaysDiscardsLateVideoFrames = YES; 

        [ captureOutput setSampleBufferDelegate: self queue: dispatch_get_main_queue() ];

        NSString* key               = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
        NSNumber* value             = [ NSNumber numberWithUnsignedInt: kCVPixelFormatType_32BGRA ]; 
        NSDictionary* videoSettings = [ NSDictionary dictionaryWithObject: value forKey: key]; 

        [ captureOutput setVideoSettings: videoSettings ];

        [ _captureSession addInput: captureInput ];
        [ _captureSession addOutput: captureOutput ];
     }
    return _captureSession;
}

-(void)initCapture
{
    if ( !self.prevLayer)
    {
        self.prevLayer = [ AVCaptureVideoPreviewLayer layerWithSession: self.captureSession ];
    }

    self.prevLayer.frame = self.bounds;
    self.prevLayer.videoGravity = AVLayerVideoGravityResize;

    if ( CGRectIsEmpty( self.captureRect ) )
    {
        self.captureRect = self.bounds;
    }

    [ self.layer addSublayer: self.prevLayer ];
}

-(CGImageRef)CGImageRotated90:( CGImageRef )imgRef_ CF_RETURNS_RETAINED
{
    CGFloat angleInRadians_ = -90 * ( M_PI / 180 );
    CGFloat width_          = CGImageGetWidth ( imgRef_ );
    CGFloat height_         = CGImageGetHeight( imgRef_ );

    CGRect rotatedRect_          = CGRectMake( 0.f, 0.f, height_, width_ );

    CGColorSpaceRef colorSpace_ = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext_     = CGBitmapContextCreate( NULL
                                                        , rotatedRect_.size.width
                                                        , rotatedRect_.size.height
                                                        , 8
                                                        , 0
                                                        , colorSpace_
                                                        , kCGImageAlphaPremultipliedFirst );

    CGContextSetAllowsAntialiasing  ( bmContext_, FALSE );
    CGContextSetInterpolationQuality( bmContext_, kCGInterpolationNone);
    CGColorSpaceRelease             ( colorSpace_ );

    CGContextScaleCTM    ( bmContext_, rotatedRect_.size.width / rotatedRect_.size.height, 1.0 );
    CGContextTranslateCTM( bmContext_, 0.0, rotatedRect_.size.height);
    CGContextRotateCTM   ( bmContext_, angleInRadians_);
    CGContextDrawImage   ( bmContext_, rotatedRect_, imgRef_ );

    CGImageRef rotatedImage_ = CGBitmapContextCreateImage( bmContext_ );

    CGContextRelease( bmContext_ );

    return rotatedImage_;
}

- (void)captureOutput:( AVCaptureOutput* )capture_output_ 
didOutputSampleBuffer:( CMSampleBufferRef )sample_buffer_ 
       fromConnection:( AVCaptureConnection* )connection_ 
{
    if ( !self.decoding )
    {
        return;
    }
 
    CVImageBufferRef imageBuffer_ = CMSampleBufferGetImageBuffer( sample_buffer_ );

    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress( imageBuffer_, 0 );

    /*Get information about the image*/
    size_t bytes_per_row_ = CVPixelBufferGetBytesPerRow( imageBuffer_ ); 
    size_t width_         = CVPixelBufferGetWidth      ( imageBuffer_ );
    size_t height_        = CVPixelBufferGetHeight     ( imageBuffer_ );

    uint8_t* base_address_ = (uint8_t*)CVPixelBufferGetBaseAddress( imageBuffer_ );

    void* free_me_ = 0;
    
    if (true)
    { // iOS bug?
        uint8_t* tmp_      = base_address_;
        int bytes_         = bytes_per_row_ * height_;
        free_me_           = base_address_ = (uint8_t*)malloc( bytes_ );
        base_address_[ 0 ] = 0xdb;

        memcpy( base_address_, tmp_, bytes_ );
    }

    CGColorSpaceRef colorSpace_ = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef newContext_ = CGBitmapContextCreate( base_address_
                                                     , width_
                                                     , height_
                                                     , 8
                                                     , bytes_per_row_
                                                     , colorSpace_
                                                     , kCGBitmapByteOrder32Little |kCGImageAlphaNoneSkipFirst ); 
    
    CGImageRef capture_ = CGBitmapContextCreateImage( newContext_ ); 

    CVPixelBufferUnlockBaseAddress( imageBuffer_, 0 );
    free( free_me_ );

    CGContextRelease   ( newContext_ ); 
    CGColorSpaceRelease( colorSpace_ );

    CGImageRef rotatedCapture_ = [ self CGImageRotated90: capture_ ];

    CGFloat xKoef_ = fminf( width_, height_ ) / self.bounds.size.width;
    CGFloat yKoef_ = fminf( width_, height_ ) / self.bounds.size.height;


    CGImageRef trancatedRef_   = CGImageCreateWithImageInRect( rotatedCapture_, CGRectMake( _captureRect.origin.x * xKoef_
                                                                                           , _captureRect.origin.y * yKoef_
                                                                                           , _captureRect.size.width * xKoef_
                                                                                           , _captureRect.size.height * yKoef_ ));

    UIImage* scrn_ = [ UIImage imageWithCGImage: trancatedRef_ ];

    CGImageRelease( capture_        );
    CGImageRelease( rotatedCapture_ );
    CGImageRelease( trancatedRef_   );
    
    Decoder* decoder_ = [ Decoder new ];
    decoder_.readers  = self.readers;
    decoder_.delegate = self;

    [ decoder_ decodeImage: scrn_ ];
}

#pragma mark- DecoderDelegate

-(void)decoder:( Decoder* )decoder_
willDecodeImage:( UIImage* )image_
   usingSubset:( UIImage* )subset
{
    //[ self.delegate qrCodeReader: self didTryDecodeImage: image_ ];
}

-(void)decoder:( Decoder* )decoder_ 
failedToDecodeImage:( UIImage* )image_ 
   usingSubset:( UIImage* )subset_
        reason:( NSString* )reason_
{
    decoder_.delegate = nil;
}

-(void)decoder:( Decoder* )decoder_
foundPossibleResultPoint:( CGPoint )point_
{
}

-(void)decoder:( Decoder* )decoder_
didDecodeImage:( UIImage* )image_
   usingSubset:( UIImage* )subset_
    withResult:( TwoDDecoderResult* )result_
{
    decoder_.delegate = nil;
    [ self.delegate qrCodeReaderView: self didGetScanResult: result_.text ];
}

@end
