#import "QRCodeViewController.h"
#import "ProductDetailsViewController.h"

@implementation QRCodeViewController

@synthesize qrcodeView;

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    //start recognizing
    [ self.qrcodeView startCapture ];
}
-(void)viewDidUnload
{
    [ super viewDidUnload ];
    //stop recognizing
    [ self.qrcodeView stopCapture ];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear: YES ];
    //start recognizing
    [ self.qrcodeView startCapture ];
}

#pragma mark- SCQRCodeReaderViewDelegate

-(void)qrCodeReaderView:( SCQRCodeReaderView* )readerView
        didGetScanResult:( NSString* )resultString
{
    if ( resultString )
    {
        [ self.qrcodeView stopCapture ];
        SCApiContext* context_ = [ SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/webapi" ];
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
