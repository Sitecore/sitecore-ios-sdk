#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//STODO move to SCUI
@interface SCWaitView : UIView

-(instancetype)initWithFrame:( CGRect )frame
                cornerRadius:( CGFloat )cornerRadius
                   superview:( UIView* )superview;

-(void)show;
-(void)hide;

@end
