//
//  SChartGLView+BandChartSeries.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import "SChartGLView.h"

@interface SChartGLView (BandChartSeries)

- (void)drawBandSeriesFill:(float *)seriesHigh
              andLowSeries:(float *)seriesLow
                  withSize:(int)size 
         withAreaColorHigh:(UIColor *)areaColorHigh 
          withAreaColorLow:(UIColor *)areaColorLow  
           withOrientation:(int)orientation 
            withNumCrosses:(int)numCrosses
            andTranslation:(const SChartGLTranslation *)transform;

@end
