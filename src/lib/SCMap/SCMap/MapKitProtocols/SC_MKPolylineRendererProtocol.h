#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

@class UIColor;
@protocol MKOverlay;


@protocol SC_MKPolylineRendererProtocol <NSObject>

-(instancetype)initWithOverlay:(id<MKOverlay>)overlay;

-(void)setLineWidth:( CGFloat )newValue;
-(void)setStrokeColor:( UIColor* )newValue;

@end
