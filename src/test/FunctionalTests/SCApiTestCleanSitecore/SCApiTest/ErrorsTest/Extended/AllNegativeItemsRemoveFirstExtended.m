#import "SCAsyncTestCase.h"

@interface AllNegativeItemsRemoveFirstExtended : SCAsyncTestCase
@end

@implementation AllNegativeItemsRemoveFirstExtended

-(void)testRemoveAllItems
{
    __block SCApiSession* apiContext_ = nil;
    
    void (^delete_system_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                              login: SCWebApiAdminLogin
                                                           password: SCWebApiAdminPassword
                                                            version: SCWebApiV1 ];
        
        apiContext_.defaultDatabase = @"master";
        SCReadItemsRequest* request_ =
        [ SCReadItemsRequest requestWithItemPath: SCCreateItemPath ];
        request_.scope = SCItemReaderChildrenScope;
        
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id response_, NSError* error_ )
        {
            request_.request = SCCreateMediaPath;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( id response_, NSError* error_ )
            {
                apiContext_.defaultDatabase = @"web";
                request_.request = SCCreateItemPath;
                
                SCDidFinishAsyncOperationHandler doneHandler2 = ^( id response_, NSError* error_ )
                {
                    request_.request = SCCreateMediaPath;
                    
                    SCDidFinishAsyncOperationHandler doneHandler3 = ^( id response_, NSError* error_ )
                    {
                        apiContext_.defaultDatabase = @"core";
                        request_.request = SCCreateItemPath;
                        
                        SCDidFinishAsyncOperationHandler doneHandler4 = ^( id response_, NSError* error_ )
                        {
                            request_.request = SCCreateMediaPath;
                            
                            SCDidFinishAsyncOperationHandler doneHandler5 = ^( id response_, NSError* error_ )
                            {
                                didFinishCallback_();
                            };
                            
                            SCExtendedAsyncOp loader5 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                            loader5(nil, nil, doneHandler5);
                        };
                        
                        SCExtendedAsyncOp loader4 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                        loader4(nil, nil, doneHandler4);
                    };
                    
                    SCExtendedAsyncOp loader3 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                    loader3(nil, nil, doneHandler3);
                };
                
                SCExtendedAsyncOp loader2 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
                loader2(nil, nil, doneHandler2);
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession deleteItemsOperationWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: delete_system_block_
                                           selector: _cmd ];
    
}

@end
