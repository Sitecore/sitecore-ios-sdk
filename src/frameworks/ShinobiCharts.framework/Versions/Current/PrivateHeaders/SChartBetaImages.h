//
//  SChartBetaImages.h
//  SChart
//
//  Copyright 2011 Scott Logic Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef SHINOBI_WATERMARK_ENABLE

@class SChartWatermark;

void watermarkCreate(UIView *view,  NSObject *verificationData[2]);
void watermarkVerify(SChartWatermark *watermark, NSObject *verificationData[2], UIView *superview, int nViews, CGRect frame);

#define WATERMARK_TAG 6372
#define GET_WATERMARK() (SChartWatermark *)[self viewWithTag:WATERMARK_TAG]


#endif
