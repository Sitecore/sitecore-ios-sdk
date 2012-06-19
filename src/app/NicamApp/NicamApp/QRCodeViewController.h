#import <UIKit/UIKit.h>

@class SCQRCodeReaderView;

@interface QRCodeViewController : UIViewController < SCQRCodeReaderViewDelegate >

@property(nonatomic,strong) IBOutlet SCQRCodeReaderView *qrcodeView;

@end
