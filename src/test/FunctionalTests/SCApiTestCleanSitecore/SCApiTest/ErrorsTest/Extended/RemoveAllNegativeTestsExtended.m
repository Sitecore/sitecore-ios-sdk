#import "SCAsyncTestCase.h"

@interface ZRemoveAllNegativeItemsExtended : SCAsyncTestCase
@end

@implementation ZRemoveAllNegativeItemsExtended

static NSString* master_path_ = @"/sitecore/content/Test Data/Create Edit Delete Tests/Negative";
static NSString* web_path_ = @"/sitecore/layout/Layouts/Test Data/Negative Tests";
static NSString* media_path_ = @"/sitecore/media library/Test Data/Negative Media";

-(void)testRemoveAllItems
{
    __block SCApiContext* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSString* deleteResponse_ = @"";

    void (^delete_block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: master_path_ ];
        request_.scope = SCItemReaderChildrenScope;
        
        SCDidFinishAsyncOperationHandler doneHandler =^( id response_, NSError* error_ )
        {
            deleteResponse_ = [ NSString stringWithFormat:@"%@", response_ ];
            SCItemsReaderRequest* item_request_ = [ SCItemsReaderRequest requestWithItemPath: master_path_ ];
            item_request_.scope = SCItemReaderChildrenScope;
            item_request_.flags = SCItemReaderRequestIngnoreCache;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* read_items_, NSError* read_error_ )
            {
                items_ = read_items_;
                NSLog( @"items: %@", items_ );
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext itemsReaderWithRequest: item_request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext removeItemsWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };
    void (^deleteSystemBlock_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName 
                                               login: SCWebApiAdminLogin
                                            password: SCWebApiAdminPassword ];

        apiContext_.defaultDatabase = @"master";
        SCItemsReaderRequest* request_ = 
        [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/system/Settings/Workflow/Test Data/Create Edit Delete Tests" ];
        request_.scope = SCItemReaderChildrenScope;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( id response_, NSError* error_ )
        {
            apiContext_.defaultDatabase = @"web";
            request_.request = web_path_;
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( id response_, NSError* error_ )
             {
                 request_.request = media_path_;
                 
                 SCDidFinishAsyncOperationHandler doneHandler2 = ^( id response_, NSError* error_ )
                  {
                      apiContext_.defaultDatabase = @"core";
                      request_.request = web_path_;
                      
                      
                      SCDidFinishAsyncOperationHandler doneHandler3 = ^( id response_, NSError* error_ )
                      {
                          request_.request = media_path_;
                          
                          SCDidFinishAsyncOperationHandler doneHandler4 = ^( id response_, NSError* error_ )
                          {
                              didFinishCallback_();
                          };
                          
                          SCExtendedAsyncOp loader4 = [ apiContext_.extendedApiContext removeItemsWithRequest: request_ ];
                          loader4(nil, nil, doneHandler4);
                      };
                      
                      SCExtendedAsyncOp loader3 = [ apiContext_.extendedApiContext removeItemsWithRequest: request_ ];
                      loader3(nil, nil, doneHandler3);
                  };
                 
                 SCExtendedAsyncOp loader2 = [ apiContext_.extendedApiContext removeItemsWithRequest: request_ ];
                 loader2(nil, nil, doneHandler2);
             };
            
            SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiContext removeItemsWithRequest: request_ ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ apiContext_.extendedApiContext removeItemsWithRequest: request_ ];
        loader(nil, nil, doneHandler);
        
    };

    [ self performAsyncRequestOnMainThreadWithBlock: deleteSystemBlock_
                                           selector: _cmd ];

    [ self performAsyncRequestOnMainThreadWithBlock: delete_block_
                                           selector: _cmd ];
}

@end
