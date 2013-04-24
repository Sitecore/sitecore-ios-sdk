#import <GHUnitIOS/GHUnit.h>
#import <SitecoreMobileSDK/SCApi.h>
#import <JFFUtils/Blocks/JFFUtilsBlockDefinitions.h>

@interface SCAsyncTestCase : GHAsyncTestCase

-(NSString*)defaultLogin;
-(NSString*)defaultPassword;

-(void)performAsyncRequestOnMainThreadWithBlock:( void (^)(JFFSimpleBlock) )block_
                                       selector:( SEL )selector_;

-(SCAsyncOp)resultIntoArrayReader:( SCAsyncOp )reader_;

@end
