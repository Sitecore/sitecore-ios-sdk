#import <UIKit/UIKit.h>

@class QRCodeReaderOverlayView;

@interface QRCodeReaderViewController : UIViewController

@property ( nonatomic, weak ) IBOutlet UIView*                    scanerPlaceholderView;
@property ( nonatomic, weak ) IBOutlet QRCodeReaderOverlayView*   scanerOverlayView;
@property ( nonatomic, weak ) IBOutlet UIButton*                  changeCaptureStateButton;
@property ( nonatomic, weak ) IBOutlet UILabel*                   scanResultLabel;

@property ( nonatomic, weak ) IBOutlet UIImageView* imageView;

-(IBAction)changeCaptureStateAction:( id )sender_;

@end
