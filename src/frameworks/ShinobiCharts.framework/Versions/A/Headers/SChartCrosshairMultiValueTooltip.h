//
//  SChartCrosshairMultiValueTooltip.h
//  ShinobiControls_Source
//
//  Copyright (c) 2012 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SChartCrosshairMultiValueTooltip : SChartCrosshairTooltip {
    SChartSeries *lastSeries;
    float maxWidth;
}

@property (nonatomic, retain) NSMutableArray   *labels;

@end