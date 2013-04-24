
#import <GHUnitIOS/GHUnit.h>
#import <JFFUtils/Blocks/JFFUtilsBlockDefinitions.h>
#import <Foundation/Foundation.h>

@interface SCAsyncTestCase : GHAsyncTestCase

-(void)runTestWithSelector:( SEL )sel_
                 testsPath:( NSString* )jsPath_
                 javasript:( NSString* )javasript_;

-(void)runTestWithSelector:( SEL )sel_
                 testsPath:( NSString* )jsPath_
                 javasript:( NSString* )javasript_
                 afterTest:( void (^)( NSDictionary* result_ ) )afterTestBlock_;

@end
