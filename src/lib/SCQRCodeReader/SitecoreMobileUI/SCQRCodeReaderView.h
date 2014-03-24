#import <UIKit/UIKit.h>

@protocol SCQRCodeReaderViewDelegate;

/**
 A view to scan the QR code. It shows the camera capture data and a frame the QR code should fit in.
 */
@interface SCQRCodeReaderView : UIView



/**
 Specifies a rect for direct scan result from.
 If captureRect was not specified -[SCQRCodeReaderView bounds] will be used. This means that the marker will be searched for within the entire area of the captured frame.
*/
@property (nonatomic) CGRect captureRect;



/**
 Specifies an object that will get scan status changes from SCQRCodeReaderView
 See SCQRCodeReaderViewDelegate protocol reference for more details.
*/
@property (nonatomic,weak) IBOutlet id< SCQRCodeReaderViewDelegate > delegate;



/**
 Rreates a new instance of SCQRCodeReaderView
 
 @param delegate the object which will handle events wfom SCQRCodeReaderView
 @param captureRect specifies rect for direct scan result from.
*/
+ (instancetype)viewWithDelegate:(id <SCQRCodeReaderViewDelegate>)delegate
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
