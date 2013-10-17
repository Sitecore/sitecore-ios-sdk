#import "TestingRequestFactory.h"

#import "SCGlobalSettings.h"

@implementation TestingRequestFactory

+(SCItemsReaderRequest*)removeAllTestItemsFromWebAsSitecoreAdmin
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCCreateItemPath ];
    request_.scope = SCItemReaderChildrenScope;
    request_.site = @"/sitecore/shell";
    request_.database = @"web";
    
    return request_;
}

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromWebAsSitecoreAdminForTestCase
{
    void (^result)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* context =
        [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                        login: SCWebApiAdminLogin
                                     password: SCWebApiAdminPassword ];
        
        SCItemsReaderRequest* item_request_ = [ TestingRequestFactory removeAllTestItemsFromWebAsSitecoreAdmin ];
        [ context removeItemsWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
          didFinishCallback_();
        } );
    };

    return result;
}

+(SCItemsReaderRequest*)removeAllTestItemsFromMasterAsSitecoreAdmin
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCCreateItemPath ];
    request_.scope = SCItemReaderChildrenScope;
    request_.site = @"/sitecore/shell";
    request_.database = @"master";
    
    return request_;
}

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterAsSitecoreAdminForTestCase
{
    void (^result)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* context =
        [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                        login: SCWebApiAdminLogin
                                     password: SCWebApiAdminPassword ];
        
        SCItemsReaderRequest* item_request_ = [ TestingRequestFactory removeAllTestItemsFromMasterAsSitecoreAdmin ];
        [ context removeItemsWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
          didFinishCallback_();
        } );
    };
    
    return result;
}

+(CLEANUP_BLOCK)doRemoveAllTestItemsFromMasterForContext:( SCApiContext* )context
{
    void (^result)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCItemsReaderRequest* item_request_ = [ TestingRequestFactory removeAllTestItemsFromMasterAsSitecoreAdmin ];
        [ context removeItemsWithRequest: item_request_ ]( ^( id response_, NSError* read_error_ )
        {
            didFinishCallback_();
        } );
    };
    
    return result;   
}

+(SCApiContext*)getNewAnonymousContext
{
    SCApiContext* result = nil;
    
    if ( IS_ANONYMOUS_ACCESS_ENABLED )
    {
        result = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
    }
    else
    {
        result = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                                 login: SCWebApiFakeAnonymousLogin
                                              password: SCWebApiFakeAnonymousPassword
                                               version: SCWebApiV1 ];
    }
    
    return result;
}

+(SCApiContext*)getNewAdminContextWithShell
{
    SCApiContext* result = nil;
    result = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName
                                             login: SCWebApiAdminLogin
                                          password: SCWebApiAdminPassword
                                           version: SCWebApiV1 ];
    result.defaultSite = @"/sitecore/shell";
    
    return result;
}

@end
