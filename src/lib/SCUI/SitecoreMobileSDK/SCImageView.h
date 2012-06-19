#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>

#import <UIKit/UIKit.h>

@protocol SCMediaItemReader;

@interface SCImageView : UIImageView

- (void)setImageReader:(SCAsyncOp)path;

@end
