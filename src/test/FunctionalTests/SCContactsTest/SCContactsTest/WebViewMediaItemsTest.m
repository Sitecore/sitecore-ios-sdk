#import "SCAsyncTestCase.h"
#import <SitecoreMobileSDK/SitecoreMobileSDK.h>

@interface WebViewMediaItemsTest : SCAsyncTestCase
@end

@implementation WebViewMediaItemsTest

-(void)testCreateMediaItem
{
    __block NSString* failDescription_;

    void (^afterTest_)( NSDictionary* ) = ^( NSDictionary* result_ )
    {
        NSString* itemId_ = [ [ result_ objectForKey: @"itemId" ] lastObject ];

        if ( [ itemId_ length ] == 0 )
        {
            failDescription_ = @"no item id from js";
            return;
        }

        [ self prepare ];

        SCApiContext* apiContext_ = [ SCApiContext contextWithHost: @"ws-alr1.dk.sitecore.net/-/item"
                                                             login: @"admin"
                                                          password: @"b" ];

        //STODO test fields
        [ apiContext_ itemReaderForItemId: itemId_ ]( ^( SCItem* result_, NSError* error_ )
        {
            if ( result_ )
                [ result_ removeItem ]( nil );
            failDescription_ = [ error_ description ];

            [ self notify: kGHUnitWaitStatusSuccess forSelector: _cmd ];
        } );

        [ self waitForStatus: kGHUnitWaitStatusSuccess
                     timeout: 300. ];
    };

    [ self runTestWithSelector: _cmd
                     testsPath: @"media_items"
                     javasript: @"testCreateMediaItem()"
                     afterTest: afterTest_ ];

    if ( failDescription_ )
    {
        GHFail( failDescription_ );
    }
}

-(void)testCreateLargeMediaItem
{
    __block NSString* failDescription_;
    
    void (^afterTest_)( NSDictionary* ) = ^( NSDictionary* result_ )
    {
        NSString* itemId_ = [ [ result_ objectForKey: @"itemId" ] lastObject ];
        
        if ( [ itemId_ length ] == 0 )
        {
            failDescription_ = @"no item id from js";
            return;
        }
        
        [ self prepare ];
        
        SCApiContext* apiContext_ = [ SCApiContext contextWithHost: @"ws-alr1.dk.sitecore.net/-/item"
                                                             login: @"admin"
                                                          password: @"b" ];
        apiContext_.defaultDatabase = @"core";
        
        //STODO test fields
        [ apiContext_ itemReaderForItemId: itemId_ ]( ^( SCItem* result_, NSError* error_ )
                                                     {
                                                         if ( result_ )
                                                         {
                                                             [ result_ removeItem ]( nil );
                                                             failDescription_ = [ error_ description ];
                                                         }
                                                         [ self notify: kGHUnitWaitStatusSuccess forSelector: _cmd ];
                                                         
                                                     } );
        
        [ self waitForStatus: kGHUnitWaitStatusSuccess
                     timeout: 300. ];
    };
    
    [ self runTestWithSelector: _cmd
                     testsPath: @"media_items"
                     javasript: @"testCreateLargeMediaItem()"
                     afterTest: afterTest_ ];
    
    if ( failDescription_ )
    {
        GHFail( failDescription_ );
    }
}


@end
