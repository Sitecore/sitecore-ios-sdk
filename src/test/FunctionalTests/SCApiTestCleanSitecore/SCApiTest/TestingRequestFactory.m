#import "TestingRequestFactory.h"

#import "SCGlobalSettings.h"

@implementation TestingRequestFactory

+(SCReadItemsRequest*)removeAllTestItemsFromWebAsSitecoreAdmin
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCCreateItemPath ];
    request_.scope = SCItemReaderChildrenScope;
    request_.site = @"/sitecore/shell";
    request_.database = @"web";
    
    return request_;
}

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase
{
    void (^result)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiSession* context =
        [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                        login: SCWebApiAdminLogin
                                     password: SCWebApiAdminPassword ];
        
        SCReadItemsRequest* item_request_ = [ TestingRequestFactory removeAllTestItemsFromWebAsSitecoreAdmin ];
        [ context deleteItemsOperationWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
          didFinishCallback_();
        } );
    };

    return result;
}

+(SCReadItemsRequest*)removeAllTestItemsFromMasterAsSitecoreAdmin
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCCreateItemPath ];
    request_.scope = SCItemReaderChildrenScope;
    request_.site = @"/sitecore/shell";
    request_.database = @"master";
    
    return request_;
}

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterAsSitecoreAdminForTestCase
{
    void (^result)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiSession* context =
        [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                        login: SCWebApiAdminLogin
                                     password: SCWebApiAdminPassword ];
        
        SCReadItemsRequest* item_request_ = [ TestingRequestFactory removeAllTestItemsFromMasterAsSitecoreAdmin ];
        [ context deleteItemsOperationWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
          didFinishCallback_();
        } );
    };
    
    return result;
}

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterForContext:( SCApiSession* )context
{
    void (^result)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCReadItemsRequest* item_request_ = [ TestingRequestFactory removeAllTestItemsFromMasterAsSitecoreAdmin ];
        [ context deleteItemsOperationWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
            didFinishCallback_();
        } );
    };
    
    return result;   
}

+(SCApiSession*)getNewAnonymousContext
{
    SCApiSession* result = nil;
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        result = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName ];
    }
    else
    {
        result = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                 login: SCWebApiFakeAnonymousLogin
                                              password: SCWebApiFakeAnonymousPassword
                                               version: SCWebApiV1 ];
    }
    
    return result;
}

+(SCApiSession*)getNewAdminContextWithShell
{
    SCApiSession* result = nil;
    result = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                             login: SCWebApiAdminLogin
                                          password: SCWebApiAdminPassword
                                           version: SCWebApiV1 ];
    result.defaultSite = @"/sitecore/shell";
    
    return result;
}

@end
