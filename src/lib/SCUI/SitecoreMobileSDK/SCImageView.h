#include <SitecoreMobileSDK/SCAsyncOpDefinitions.h>

#import <UIKit/UIKit.h>

@protocol SCMediaItemReader;

@interface SCImageView : UIImageView

- (void)setReadImageOperation:(SCAsyncOp)path;

@end
