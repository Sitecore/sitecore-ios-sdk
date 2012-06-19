//
//  SChartLegendSymbol.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**  The legend symbols are the graphical representations of the series on the legend - SChartLegendSymbol is the base class for these symbols. As a part of implementing the SChartLegendItem protocol a series may optionally return a symbol object. 
 
 The symbol is a subclass of UIView and most included symbols override the drawRect: function to produce the symbol. 
 
 *Related Classes*: <br>
 SChartLegendSymbolLineSeries <br>
 SChartLegendSymbolColumnSeries <br>
 SChartLegendSymbolBarSeries <br>
 SChartLegendSymbolScatterSeries <br>
 SChartLegendSymbolPieSeries <br>
 SChartLegendSymbolDonutSeries <br>
 */
@interface SChartLegendSymbol : UIView

@end
