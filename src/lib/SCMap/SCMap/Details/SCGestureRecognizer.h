#import <Foundation/Foundation.h>

@protocol SCGestureRecognizerDelegate;

@interface SCGestureRecognizer : UITapGestureRecognizer

@property ( nonatomic, weak ) id< SCGestureRecognizerDelegate > scDelegate;

+(id)recognizerWithView:( UIView* )view_
    viewToIgnoreTouches:( UIView* )viewToIgnoreTouches_;

@end

@protocol SCGestureRecognizerDelegate <NSObject>

@required
-(void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer didReceiveReceiveTouch:(UITouch *)touch;

@end
