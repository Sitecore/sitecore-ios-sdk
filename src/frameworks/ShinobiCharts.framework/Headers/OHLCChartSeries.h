//
//  SChartGLView+OHLCChartSeries.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import "SChartGLView.h"

@interface SChartGLView (OHLCChartSeries)

- (void)drawOHLCPoints:(float *)series 
              withSize:(int)size 
            withColors:(NSMutableArray *)colors 
    withGradientColors:(NSMutableArray *)gradientColors  
       withOrientation:(int)orientation 
         withOHLCWidth:(float)ohlcWidth 
        withTrunkWidth:(float)trunkWidth
          withArmWidth:(float)armWidth
        andTranslation:(const SChartGLTranslation *)transform;

@end
