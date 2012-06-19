//
//  SChartLegendItem.h
//  SChart
//
//  Copyright (c) 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SChartLegendSymbol;

/** Specifies the interface required by the legend to display data. A series should adopt this protocol if it wishes to display its own information in the legend. The SChartSeries base class implements this protocol and therefore any subclasses can be legend items by overriding the methods here. */
@protocol SChartLegendItem <NSObject>
@optional


/** The text displayed in the legend for the series. 
 
 To be implemented for cartesian series. */
- (NSString*)titleForSeriesInLegend;


/** The text displayed in the legend for the 'slice' at this index of the series.
 
 To be implemented for radial series, this method will be called per index of the first series in the chart and `symbolForSeriesInLegend` will not be called.*/
- (NSString*)titleForSliceInLegend:(int)index;


/** An optional color for the text in the legend.
 
 If not set, the default is set by the theme. */
- (UIColor*)textColorForSeriesTitleInLegend;


/** An optional symbol representing a cartesian series.
 
 Custom symbols can be created through the subclassing of SChartLegendSymbol. */
- (SChartLegendSymbol*)symbolForSeriesInLegend;


/** An optional symbol representing a slice in a radial series.
 
 Custom symbols can be created through the subclassing of SChartLegendSymbol.*/
- (SChartLegendSymbol*)symbolForSliceInLegend:(int)index;


@end
