#import <Foundation/Foundation.h>

@interface TestHostConfig : NSObject

+(NSString*)testInstance;
+(NSString*)mobileSdkTestPath;


+(NSString*)testHostUrlScheme;
+(NSString*)testHost;
+(NSString*)testHostSuffix;
+(NSString*)testHostSuffixPath;

@end
