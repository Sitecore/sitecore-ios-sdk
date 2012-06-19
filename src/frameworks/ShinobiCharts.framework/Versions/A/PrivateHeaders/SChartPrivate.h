//
//  ShinobiChartPrivate.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

@class ShinobiChart;
@class SChartAxisStyle;

@interface ShinobiChart () // methods private to chart

@property (nonatomic, retain) NSMutableArray *chartSeries;
@property (nonatomic, retain) NSMutableArray *seriesGroups;
@property (nonatomic) BOOL isRadial;
@property (nonatomic, assign) BOOL shouldReloadData;

- (void)applyThemeToChart;
- (void)applyStyle:(SChartAxisStyle *)style toAxis:(SChartAxis*)axis preservingSetValues:(BOOL)preserveValues;
- (void)applyThemeToSeries:(SChartSeries*)series atIndex:(int)seriesIndex preservingSetValues:(BOOL)preserveValues;

- (float)spaceRequiredForXAxesNormal;
- (float)spaceRequiredForYAxesNormal;
- (float)spaceRequiredForXAxesReverse;
- (float)spaceRequiredForYAxesReverse;

- (BOOL)isOwningAxis:(SChartAxis *)axis;

- (void)callDelegateIfResponds:(SEL)selector withObject:(id)obj1 withObject:(id)obj2;

- (void)callDelegateIfResponds:(SEL)selector withObject:(id)obj1;



@end
