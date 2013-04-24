#import "SCAsyncTestCase.h"

@interface ZRemoveAllNegativeItems : SCAsyncTestCase
@end

@implementation ZRemoveAllNegativeItems

-(void)testRemoveAllItems
{
    __block SCApiContext* apiContext_ = nil;
    
    void (^delete_system_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];
        
        apiContext_.defaultDatabase = @"master";
        SCItemsReaderRequest* request_ =
        [ SCItemsReaderRequest requestWithItemPath: SCCreateItemPath ];
        request_.scope = SCItemReaderChildrenScope;
        [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
        {
            request_.request = SCCreateMediaPath;
            [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
            {
                apiContext_.defaultDatabase = @"web";
                request_.request = SCCreateItemPath;
                [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                {
                    request_.request = SCCreateMediaPath;
                    [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                    {
                        apiContext_.defaultDatabase = @"core";
                        request_.request = SCCreateItemPath;
                        [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                        {
                            request_.request = SCCreateMediaPath;
                            [ apiContext_ removeItemsWithRequest: request_ ]( ^( id response_, NSError* error_ )
                            {
                                didFinishCallback_();
                            } );
                        } );
                    } );
                } );
            } );
        } );
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: delete_system_block_
                                           selector: _cmd ];
    
}

@end
