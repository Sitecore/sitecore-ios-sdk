
#import <JFFNetwork/JFFNetwork.h>
#import <SCApi/Api/NSURL+URLWithItemsReaderRequest.h>

@interface SCReadItemsRequestTest : GHTestCase
@end

@implementation SCReadItemsRequestTest

-(NSString*)scopeURLParamWithScope:( SCItemReaderScopeType )scope_
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];

    request_.scope = scope_;

    NSURL* url_ = [ NSURL URLWithItemsReaderRequest: request_
                                               host: @"host" ];

    NSDictionary* components_ = [ url_ queryComponents ];

    return [ [ components_ objectForKey: @"scope" ] noThrowObjectAtIndex: 0 ];
}

-(NSString*)pathURLParamWithPath:( NSString* )path_
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];

    request_.requestType = SCItemReaderRequestItemPath;
    request_.request = path_;

    NSURL* url_ = [ NSURL URLWithItemsReaderRequest: request_
                                               host: @"host" ];

    return url_.path;
}

-(NSString*)itemIdURLParamWithItemId:( NSString* )itemId_
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];

    request_.requestType = SCItemReaderRequestItemId;
    request_.request = itemId_;

    NSURL* url_ = [ NSURL URLWithItemsReaderRequest: request_
                                               host: @"host" ];

    NSDictionary* components_ = [ url_ queryComponents ];

    return [ [ components_ objectForKey: @"sc_itemid" ] noThrowObjectAtIndex: 0 ];
}

-(NSString*)queryURLParamWithQuery:( NSString* )query_
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];

    request_.requestType = SCItemReaderRequestQuery;
    request_.request     = query_;

    NSURL* url_ = [ NSURL URLWithItemsReaderRequest: request_
                                               host: @"host" ];

    NSDictionary* components_ = [ url_ queryComponents ];

    return [ [ components_ objectForKey: @"query" ] noThrowObjectAtIndex: 0 ];
}

-(void)testScopeParam
{
    SCItemReaderScopeType scope_ = SCItemReaderSelfScope;
    NSString* scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"s" isEqualToString: scopeStr_ ], @"OK" );

    scopeStr_ = [ self scopeURLParamWithScope: 0 ];
    GHAssertTrue( [ @"s" isEqualToString: scopeStr_ ], @"OK" );

    scope_ = SCItemReaderChildrenScope;
    scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"c" isEqualToString: scopeStr_ ], @"OK" );

    scope_ = SCItemReaderParentScope;
    scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"p" isEqualToString: scopeStr_ ], @"OK" );

    scope_ = SCItemReaderSelfScope | SCItemReaderChildrenScope;
    scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"s|c" isEqualToString: scopeStr_ ], @"OK" );

    scope_ = SCItemReaderSelfScope | SCItemReaderParentScope;
    scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"p|s" isEqualToString: scopeStr_ ], @"OK" );

    scope_ = SCItemReaderChildrenScope | SCItemReaderParentScope;
    scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"p|c" isEqualToString: scopeStr_ ], @"OK" );

    scope_ = SCItemReaderSelfScope | SCItemReaderChildrenScope | SCItemReaderParentScope;
    scopeStr_ = [ self scopeURLParamWithScope: scope_ ];
    GHAssertTrue( [ @"p|s|c" isEqualToString: scopeStr_ ], @"OK" );
}

-(void)testPathParam
{
    NSString* path_ = [ self pathURLParamWithPath: @"/path" ];
    GHAssertTrue( [ @"/v1/path" isEqualToString: path_ ], @"OK" );

    path_ = [ self pathURLParamWithPath: @"/path 1" ];
    GHAssertTrue( [ @"/v1/path 1" isEqualToString: path_ ], @"OK" );

    path_ = [ self pathURLParamWithPath: @"/path <>#%'\";?:@&=+$/,{}|\\^~[]`-_*!()" ];
    GHAssertTrue( [ @"/v1/path <>#%'\";?:@&=+$/,{}|\\^~[]`-_*!()" isEqualToString: path_ ], @"OK" );

    path_ = [ self pathURLParamWithPath: nil ];
    GHAssertTrue( [ @"/v1" isEqualToString: path_ ], @"OK" );
}

-(void)testItemIdParam
{
    NSString* itemId_   = @"XWdsf";
    NSString* paramStr_ = [ self itemIdURLParamWithItemId: itemId_ ];
    GHAssertTrue( [ itemId_ isEqualToString: paramStr_ ], @"OK" );

    paramStr_ = [ self itemIdURLParamWithItemId: nil ];
    GHAssertNotNil( paramStr_, @"OK" );
    GHAssertTrue( [ @"" isEqualToString: paramStr_ ], @"OK" );
}

-(void)testQueryParam
{
    NSString* query_ = [ self queryURLParamWithQuery: @"query" ];
    GHAssertTrue( [ @"query" isEqualToString: query_ ], @"OK" );

    query_ = [ self queryURLParamWithQuery: @"query 1" ];
    GHAssertTrue( [ @"query 1" isEqualToString: query_ ], @"OK" );

    query_ = [ self queryURLParamWithQuery: @"/path <>#%'\";?:@&=+$/,{}|\\^~[]`-_*!()" ];
    GHAssertTrue( [ @"/path <>#%'\";?:@&=+$/,{}|\\^~[]`-_*!()" isEqualToString: query_ ], @"OK" );

    query_ = [ self queryURLParamWithQuery: nil ];
    GHAssertNotNil( query_, @"OK" );
    GHAssertTrue( [ @"" isEqualToString: query_ ], @"OK" );
}

-(void)testURLWithItemsReaderRequestWithPath
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];

    request_.request = @"/path";
    request_.scope = SCItemReaderChildrenScope;
    request_.requestType = SCItemReaderRequestItemPath;
    request_.fieldNames = [ NSSet setWithObjects: @"f1", @"f2", nil ];
    request_.flags = 0;
    request_.page = 1;
    request_.pageSize = 2;
    request_.language = @"ru";

    NSURL* url_ = [ NSURL URLWithItemsReaderRequest: request_
                                               host: @"host" ];

    GHAssertTrue( [ url_.path isEqualToString: @"/v1/path" ], @"OK" );
    GHAssertTrue( [ url_.host isEqualToString: @"host" ], @"OK" );

    NSDictionary* components_ = [ url_ queryComponents ];

    NSString* scope_ = [ components_ firstValueIfExsistsForKey: @"scope" ];
    GHAssertTrue( [ scope_ isEqualToString: @"c" ], @"OK" );

    NSString* fields_ = [ components_ firstValueIfExsistsForKey: @"fields" ];
    GHAssertTrue( [ fields_ isEqualToString: @"f1|f2" ], @"OK" );
    NSString* payload_ = [ components_ firstValueIfExsistsForKey: @"payload" ];
    GHAssertTrue( payload_ == nil, @"OK" );

    NSString* page_ = [ components_ firstValueIfExsistsForKey: @"page" ];
    GHAssertTrue( [ page_ isEqualToString: @"1" ], @"OK" );

    NSString* pageSize_ = [ components_ firstValueIfExsistsForKey: @"pageSize" ];
    GHAssertTrue( [ pageSize_ isEqualToString: @"2" ], @"OK" );

    NSString* lang_ = [ components_ firstValueIfExsistsForKey: @"sc_lang" ];
    GHAssertTrue( [ lang_ isEqualToString: @"ru" ], @"OK" );
}

-(void)testURLWithCreateItemRequestWithPath
{
    SCCreateItemRequest* request_ = [ SCCreateItemRequest new ];
    
    request_.request = @"/path";
    request_.requestType = SCItemReaderRequestItemPath;
    request_.scope = SCItemReaderChildrenScope;
    request_.fieldNames = [ NSSet new ];
    request_.flags = 0;
    request_.page = 1;
    request_.pageSize = 2;
    request_.language = @"ru";

    request_.itemName     = @"New=ItemN ame";
    request_.itemTemplate = @"New=ItemN template";

    request_.fieldsRawValuesByName = [ NSDictionary dictionaryWithObjectsAndKeys:
                                      @"val1", @"field1"
                                      , @"val2", @"field2"
                                      , nil ];

    NSURL* url_ = [ NSURL URLToCreateItemWithRequest: request_
                                                host: @"host" ];

    GHAssertTrue( [ url_.path isEqualToString: @"/v1/sitecore/shell/path" ], @"OK" );
    GHAssertTrue( [ url_.host isEqualToString: @"host" ], @"OK" );

    NSDictionary* components_ = [ url_ queryComponents ];

    NSString* scope_ = [ components_ firstValueIfExsistsForKey: @"scope" ];
    GHAssertTrue( [ scope_ isEqualToString: @"c" ], @"OK" );

    NSString* fields_ = [ components_ firstValueIfExsistsForKey: @"fields" ];
    GHAssertTrue( fields_ == nil, @"OK" );
    NSString* payload_ = [ components_ firstValueIfExsistsForKey: @"payload" ];
    GHAssertTrue( [ payload_ isEqualToString: @"1" ], @"OK" );

    NSString* page_ = [ components_ firstValueIfExsistsForKey: @"page" ];
    GHAssertTrue( [ page_ isEqualToString: @"1" ], @"OK" );
    
    NSString* lang_ = [ components_ firstValueIfExsistsForKey: @"sc_lang" ];
    GHAssertTrue( [ lang_ isEqualToString: @"ru" ], @"OK" );
    
    NSString* newItemName_ = [ components_ firstValueIfExsistsForKey: @"name" ];
    GHAssertTrue( [ newItemName_ isEqualToString: @"New=ItemN ame" ], @"OK" );

    NSString* newItemTemplate_ = [ components_ firstValueIfExsistsForKey: @"template" ];
    GHAssertTrue( [ newItemTemplate_ isEqualToString: @"New=ItemN template" ], @"OK" );
}

-(void)testURLReaderWithHttpInHost
{
    SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
    request_.request = @"/path";
    request_.requestType = SCItemReaderRequestItemPath;
    request_.scope = SCItemReaderChildrenScope;
    request_.fieldNames = nil;
    request_.flags      = 0;
    request_.page       = 1;
    request_.pageSize   = 2;
    request_.language   = @"ru";

    NSURL* url_ = [ NSURL URLWithItemsReaderRequest: request_
                                               host: @"http://host" ];

    GHAssertTrue( [ url_.scheme isEqualToString: @"http" ], @"OK" );
    GHAssertTrue( [ url_.host   isEqualToString: @"host" ], @"OK" );

    NSDictionary* components_ = [ url_ queryComponents ];

    NSString* fields_ = [ components_ firstValueIfExsistsForKey: @"fields" ];
    GHAssertTrue( fields_ == nil, @"OK" );
    NSString* payload_ = [ components_ firstValueIfExsistsForKey: @"payload" ];
    GHAssertTrue( payload_ == nil, @"OK" );

    url_ = [ NSURL URLWithItemsReaderRequest: request_
                                        host: @"https://host" ];

    GHAssertTrue( [ url_.scheme isEqualToString: @"https" ], @"OK" );
    GHAssertTrue( [ url_.host   isEqualToString: @"host"  ], @"OK" );
}

-(void)testURLWithCreateMediaItemRequest
{
    {
        
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];

        NSURL* url_ = [ NSURL URLToCreateMediaItemWithRequest: request_
                                                         host: @"host"
                                                   apiContext: nil ];

        GHAssertTrue( [ url_.path isEqualToString: @"/v1/sitecore/shell/sitecore/media library" ], @"OK" );
    }

    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];

        request_.folder = @"/1/";
    
        NSURL* url_ = [ NSURL URLToCreateMediaItemWithRequest: request_
                                                         host: @"host"
                                                   apiContext: nil ];

        GHAssertTrue( [ url_.path isEqualToString: @"/v1/sitecore/shell/sitecore/media library/1" ], @"OK" );
    }

    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];

        request_.folder = @"1";

        NSURL* url_ = [ NSURL URLToCreateMediaItemWithRequest: request_
                                                         host: @"host"
                                                   apiContext: nil ];

        GHAssertTrue( [ url_.path isEqualToString: @"/v1/sitecore/shell/sitecore/media library/1" ], @"OK" );
    }

    {
        SCUploadMediaItemRequest* request_ = [ SCUploadMediaItemRequest new ];
        
        request_.folder = @"1/2/3";
        
        NSURL* url_ = [ NSURL URLToCreateMediaItemWithRequest: request_
                                                         host: @"host"
                                                   apiContext: nil ];
        
        GHAssertTrue( [ url_.path isEqualToString: @"/v1/sitecore/shell/sitecore/media library/1/2/3" ], @"OK" );
    }
}

@end
