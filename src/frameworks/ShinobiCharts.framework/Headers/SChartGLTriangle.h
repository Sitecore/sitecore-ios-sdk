//
//  SChartGLTriangle.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SChartGLTriangle : NSObject {
    GLTriangle3D triangle;
}

-(id)initWithTriangle:(GLTriangle3D)triangle;

@property (nonatomic, assign) GLTriangle3D triangle;

-(NSComparisonResult)compareAlpha:(SChartGLTriangle*)t;

@end
