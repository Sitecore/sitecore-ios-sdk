//
//  SChartTickMark.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SChartAxis;

/** An object that represents each tick mark on the chart. The label for the tick mark is also managed by this class.
 
 */
@interface SChartTickMark: NSObject {
@private
    BOOL isNegative;
    // what it says on the tick-mark-shaped tin
    
    BOOL isMajor;
    // whether the tick mark is major or minor
    
    BOOL tickEnabled;
    // should we draw this tick?
    
    double value;
    
    float tickMarkX, tickMarkY;
    // the actual line's position, distinct from frame.origin
    
    UILabel *tickLabel; // if nil, obviously no label
    
    UIView *tickMarkView;
    UIView *gridLineView;
    UIView *gridStripeView;
    
    // whether the stripe below or to the left of this tick mark should be the alternate stripe colour
    BOOL overAlternateStripe;
}

/** @name Initialising a new tickmark */
- (id)init;
/** Create a tick mark with a particular label. */
- (id)initWithLabel:(CGRect)labelFrame andText:(NSString *)text;

/** @name Current status */
/** Is this tick mark visible on the chart? */
@property(nonatomic) BOOL    tickEnabled;


/** @name Sorting tick marks */
/** Compare the X values for this tick mark */
-(NSComparisonResult)compareForXAxis:(SChartTickMark*)tm;
/** Compare the Y values for this tick mark */
-(NSComparisonResult)compareForYAxis:(SChartTickMark*)tm; 

/** @name Labelling the tick mark */
/** The label object to visually represent the value of this tick mark
 
 If this is `nil` then no label will be displayed. */
@property(nonatomic, retain)   UILabel *tickLabel;

/** Called when the axis wishes to remove this tick mark label.
 
 Override this to provide a custom exit routine for the label */
- (void)removeLabel;

@property(nonatomic)           BOOL    isMajor;
@property(nonatomic)           BOOL    isNegative;
@property(nonatomic)           float   tickMarkX, tickMarkY;
@property(nonatomic)           BOOL    overAlternateStripe;
@property(nonatomic)           double  value;
@property(nonatomic, retain)   UIView  *tickMarkView;
@property(nonatomic, retain)   UIView  *gridLineView;
@property(nonatomic, retain)   UIView  *gridStripeView;

- (void)disableTick:(SChartAxis *) axis;
- (float)tickLengthModifier;

- (void)removeTickMarkView;
- (void)removeGridLineView;
- (void)removeGridStripeView;

@end
