//
//  SChartTitle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/** A title object used by the chart and the axis to display a UILabel with appropriate text. The position will be set automatically - but can be overridden.
 
 */
@interface SChartTitle : UILabel {
    BOOL userSetFrame;
}

@property (nonatomic, assign) BOOL userSetFrame;

@end
