//
//  BarColumnChartSeries.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

@interface SChartGLView (BarColumnChartSeries)

- (void)barColumnFill               :(float*)series
                      withBaseSeries:(float*)baseSeries
                            withSize:(GLuint)size
                           withColor:(UIColor*)fillColour
              withColorBelowBaseline:(UIColor*)fillColourBelowBaseline
                   withColorGradient:(UIColor*)fillColourGradient
      withColorGradientBelowBaseline:(UIColor*)fillColourGradientBelowBaseline
                  withBarColumnWidth:(float)barColumnWidth
                      withGLBaseline:(float)glBaseline
                      andOrientation:(int)orientation
                    willDrawLinesToo:(BOOL)willDrawLines
                 animationParameters:(const SChartGLAnimationParams *)animParams
                      andTranslation:(const SChartGLTranslation *)transform;

- (void)barColumnLine               :(float*)series
                      withBaseSeries:(float*)baseSeries
                            withSize:(GLuint)i
                           withColor:(UIColor*)lineColor
              withColorBelowBaseline:(UIColor*)lineColourBelowBaseline
                 withBarColumnWidth:(float)barColumnWidth
                       withLineWidth:(float)lineWidth
                      withGLBaseline:(float)glBaseline
                      andOrientation:(int)orientation
                 animationParameters:(const SChartGLAnimationParams *)animParams
                      andTranslation:(const SChartGLTranslation *)transform;

@end
