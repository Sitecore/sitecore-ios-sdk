//
//  CandlestickChartSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

@interface SChartGLView (CandlestickChartSeries)

- (void)drawCandlesticks:(float *)series 
                withSize:(int)size 
              withColors:(NSMutableArray *)colors 
      withGradientColors:(NSMutableArray *)gradientColors  
        withOutlineColor:(UIColor *)outlineColor 
          withStickColor:(UIColor *)stickColor
         withCandleWidth:(float)candleWidth 
        withOutlineWidth:(float)outlineWidth 
          withStickWidth:(float)stickWidth
         withOrientation:(int)orientation 
          andTranslation:(const SChartGLTranslation *)transform;

@end
