#import <Foundation/Foundation.h>

@class SCDownloadMediaOptions;
@class SCExtendedApiSession;

typedef SCExtendedAsyncOp (^ImageLoaderBuilder)( SCExtendedApiSession* blockSelf, NSString* mediaPath, SCDownloadMediaOptions* options );

@interface ImageLoaderBuilderHook : NSObject

-(instancetype)initWithHookImpl:(ImageLoaderBuilder)hookImpl;

-(void)enableHook;
-(void)disableHook;

@end
