#import "QRCodeViewController.h"
#import "ProductDetailsViewController.h"

@implementation QRCodeViewController

@synthesize qrcodeView;

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    //start recognizing
   // [ self.qrcodeView startCapture ];
}
-(void)viewDidUnload
{
    [ super viewDidUnload ];
    //stop recognizing
    [ self.qrcodeView stopCapture ];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: animated ];
    //start recognizing
    self.qrcodeView.frame = self.view.bounds;
    [ self.qrcodeView startCapture ];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear: animated ];
    [ self.qrcodeView stopCapture ];
}

#pragma mark- SCQRCodeReaderViewDelegate

-(void)qrCodeReaderView:( SCQRCodeReaderView* )readerView
        didGetScanResult:( NSString* )resultString
{
    if ( resultString )
    {
        [ self.qrcodeView stopCapture ];
        SCApiContext* context_ = [ SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item" ];
        [ context_ itemReaderForItemPath: resultString ]( ^( id result_, NSError* error_ )
        {
            if ( !error_ )
            {
                [ self performSegueWithIdentifier: @"qrcode" sender: self ];

                ProductDetailsViewController* presentedController_ = ( ProductDetailsViewController* )[ [ self navigationController ] topViewController ];
                [ presentedController_ productsViewController: self
                                         didSelectProductItem: result_ ];
            }
            else
            {
                [ self.qrcodeView startCapture ];
            }
        } );
    }
}

-(void)qrCodeReaderViewDidCancel:( SCQRCodeReaderView* )readerView
{
}

@end
