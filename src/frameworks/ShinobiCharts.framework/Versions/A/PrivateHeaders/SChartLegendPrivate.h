//
//  SChartLegendPrivate.h
//  ShinobiControls_Source
//
//  Copyright 2012 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SChartLegend (hidden)

- (void) setUserSetFrame:(BOOL)frameSet;
- (BOOL) userSetFrame;
- (void) populateLegendWithChartSeries:(NSArray *)chartSeries andLabelHeight:(float)seriesLabelHeight andLabelWidth:(float)seriesLabelWidth;
- (void) populateLegendWithRadialChartSeries:(NSArray *)chartSeries andLabelHeight:(float)seriesLabelHeight andLabelWidth:(float)seriesLabelWidth;

@end
