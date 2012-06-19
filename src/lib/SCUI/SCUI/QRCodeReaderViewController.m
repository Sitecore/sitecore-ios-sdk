#import "QRCodeReaderViewController.h"

#import "QRCodeReaderOverlayView.h"

#import <SitecoreMobileSDK/SCQRCodeReaderView.h>
#import <SitecoreMobileSDK/SCQRCodeReaderViewDelegate.h>

@interface QRCodeReaderViewController () < SCQRCodeReaderViewDelegate >

@property ( nonatomic, strong ) SCQRCodeReaderView* qrReaderView;

-(void)updateChangeCaptureStateButton;

@end

@implementation QRCodeReaderViewController

@synthesize scanerPlaceholderView    = _scanerPlaceholderView;
@synthesize scanerOverlayView        = _scanerOverlayView;
@synthesize changeCaptureStateButton = _changeCaptureStateButton;
@synthesize scanResultLabel          = _scanResultLabel;
@synthesize qrReaderView             = _qrReaderView;
@synthesize imageView                = _imageView;

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    [ self.scanerPlaceholderView addSubview: self.qrReaderView ];    
}

-(void)viewWillAppear:(BOOL)animated_
{
    [ super viewWillAppear: animated_ ];
    [ self updateChangeCaptureStateButton ];
}

-(IBAction)changeCaptureStateAction:( id )sender_
{
    if ( [ self.qrReaderView isCaptureInProgress ] )
    {
        [ self.qrReaderView stopCapture ];        
    }
    else
    {
       [ self.qrReaderView startCapture ];
    }

    [ self updateChangeCaptureStateButton ];
}

-(SCQRCodeReaderView*)qrReaderView
{
    if ( !_qrReaderView )
    {
        _qrReaderView = [ SCQRCodeReaderView viewWithDelegate: self captureRect: CGRectMake( 50.f, 50.0, 200.f, 200.f) ];
        _qrReaderView.frame = self.scanerPlaceholderView.bounds;
        _qrReaderView.backgroundColor = [ UIColor greenColor ];
    }
    return _qrReaderView;
}

-(void)updateChangeCaptureStateButton
{
    [ self.changeCaptureStateButton setTitle: [ self.qrReaderView isCaptureInProgress ]
                                              ? @"Stop Capture"
                                              : @"Start Capture"
                                    forState: UIControlStateNormal ];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)to_interface_orientation_
{
    return NO;
}

#pragma mark- SCQRCodeReaderViewDelegate

-(void)qrCodeReaderView:( SCQRCodeReaderView* )reader_view_
       didGetScanResult:( NSString* )result_string_
{
    self.scanResultLabel.text = result_string_;
}

-(void)qrCodeReaderViewDidCancel:( SCQRCodeReaderView* )reader_view_
{
    
}

-(void)qrCodeReader:( SCQRCodeReaderView* )reader_view_ 
  didTryDecodeImage:( UIImage* )image_
{
    self.imageView.image = image_;
}

@end
