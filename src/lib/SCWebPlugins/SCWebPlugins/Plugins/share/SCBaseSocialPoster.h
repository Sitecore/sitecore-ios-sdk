#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SCApi.h>

@interface SCBaseSocialPoster : NSObject

@property ( nonatomic ) NSString * text  ;
@property ( nonatomic ) NSArray  * images;
@property ( nonatomic ) NSArray  * links ;

@property ( nonatomic ) UIViewController* viewControllerForDialog;

-(void)postWithCompletion:( SCAsyncOpResult )handler;
-(BOOL)canPost;

@end
