#import <UIKit/UIKit.h>

@protocol SCQRCodeReaderViewDelegate;

@interface SCQRCodeReaderView : UIView

/**
 captureRect specifies rect for direct scan result from.
 if captureRect was not specified SCQRCodeReaderView.bound will be used
*/
@property (nonatomic) CGRect captureRect;

/**
 delegate specifies object whith will get scan status chamges from SCQRCodeReaderView
*/
@property (nonatomic,weak) IBOutlet id< SCQRCodeReaderViewDelegate > delegate;
/**
 Rreates a new instance of SCQRCodeReaderView
 @param delegate_ the object which will handle events wfom SCQRCodeReaderView
 @param captureRect_ specifies rect for direct scan result from. 
*/

+ (id)viewWithDelegate:(id <SCQRCodeReaderViewDelegate>)delegate
           captureRect:(CGRect)captureRect;

/**
 Starts capture process
*/
- (void)startCapture;
/**
 Stope capture process
*/
- (void)stopCapture;
/**
 Call this method to determine capture is already running or not.
*/
- (BOOL)isCaptureInProgress;

@end
