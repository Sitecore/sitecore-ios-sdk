#import "QRCodeReaderOverlayView.h"

@implementation QRCodeReaderOverlayView

-(void)drawRect:( CGRect )rect_ 
      inContext:( CGContextRef )context_
{
	CGContextBeginPath( context_ );
	CGContextMoveToPoint( context_, rect_.origin.x, rect_.origin.y);
	CGContextAddLineToPoint( context_, rect_.origin.x + rect_.size.width, rect_.origin.y);
	CGContextAddLineToPoint( context_, rect_.origin.x + rect_.size.width, rect_.origin.y + rect_.size.height);
	CGContextAddLineToPoint( context_, rect_.origin.x, rect_.origin.y + rect_.size.height);
	CGContextAddLineToPoint( context_, rect_.origin.x, rect_.origin.y);
	CGContextStrokePath( context_ );
}

-(void)drawRect:( CGRect )rect_
{
    [ super drawRect: rect_ ];

    CGContextRef context_ = UIGraphicsGetCurrentContext();

    CGFloat white_[ 4 ] = { 1.0f, 1.0f, 1.0f, 1.0f };

	CGContextSetStrokeColor( context_, white_ );
	CGContextSetFillColor( context_, white_);

	[ self drawRect: CGRectMake( 50.f, 50.f, 200.f, 200.f) inContext: context_ ];

	CGContextSaveGState( context_ );
}

@end
