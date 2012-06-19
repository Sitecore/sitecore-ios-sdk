//
//  SChartLayer.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
// A ShinobiChart plot area is made up of various layers that are each responsible for different elements of the chart. Each layer must conform to this protocol.
 
// */
@protocol SChartLayer <NSObject>
// @name Rotating layers */
// Layer should begin to rotate */
-(void) viewStartRotateWithDuration:(NSNumber *)duration;
// Layer should stop rotating */
-(void) viewEndRotateWithDuration:  (NSNumber *)duration;

@end
