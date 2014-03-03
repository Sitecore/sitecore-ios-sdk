#import "SCAsyncTestCase.h"

@interface LanguageReaderNegativeTest : SCAsyncTestCase
@end

@implementation LanguageReaderNegativeTest

-(void)testContextWrongDefaultLanguage
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
 
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                             login: SCWebApiAdminLogin
                                                          password: SCWebApiAdminPassword ];
            apiContext_ = strongContext_;
            apiContext_.defaultSite = @"/sitecore/shell";
            
            
            apiContext_.defaultLanguage = @"en";
            apiContext_.defaultLanguage = @"fr";
            NSString* path_ = SCLanguageItemPath;
            NSSet* fieldNames_ = [ NSSet setWithObject: @"Title" ];
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: path_
                                                                            fieldsNames: fieldNames_ ];
            [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = da_result_[ 0 ];
                NSLog( @"%@:", item_ );
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( item_ != nil, @"OK" );
    SCField* field_ = [ item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"" ] == TRUE, @"OK" );
}

-(void)testWrongRequestLanguage
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* default_item_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                 login: SCWebApiAdminLogin
                                                              password: SCWebApiAdminPassword ];
                apiContext_ = strongContext_;
                apiContext_.defaultSite = @"/sitecore/shell";
                
                NSSet* fields_ = [ NSSet setWithObject: @"Title" ];
                SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: fields_ ];
                request_.language = @"xx";
                apiContext_.defaultLanguage = @"da";
                
                [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
                {
                    if ( [ da_result_ count ] == 0 )
                    {
                        didFinishCallback_();
                        return;
                    }
                    da_item_ = da_result_[ 0 ];

                    
                    request_.language = nil;
                    apiContext_.defaultLanguage = nil;
                    [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* default_result_, NSError* error_ )
                     {
                         if ( [ default_result_ count ] == 0 )
                         {
                             didFinishCallback_();
                             return;
                         }
                         
                         default_item_ = default_result_[0];
                         didFinishCallback_();
                     } );
                } );
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( da_item_ != nil, @"OK" );
    SCField* field_ = [ da_item_ fieldWithName: @"Title" ];
    NSLog( @":%@", field_ );
    
    SCField* defaultField = [ default_item_ fieldWithName: @"Title" ];
    
    // @adk : web API returns default language ("en") #394160
    NSString* rawValue = field_.rawValue;
    NSString* expectedRawValue = defaultField.rawValue;
    
    //FIXME: @igk test should not pass!!!
    GHAssertEqualObjects(rawValue, expectedRawValue, @"field mismatch : [%@] not equal to [%@]", rawValue, expectedRawValue );
    GHAssertTrue( field_.item == da_item_, @"OK" );
}

-(void)testLanguageReadNotExistedItems
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* base_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObjects: @"Title", nil ];
 
    SCItemSourcePOD* webShellDanish = [ SCItemSourcePOD new ];
    {
        webShellDanish.database = @"web";
        webShellDanish.site = @"/sitecore/shell";
        webShellDanish.language = @"da";
    }
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
         void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
         {
             @autoreleasepool
             {
                 strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                                  login: SCWebApiAdminLogin
                                                               password: SCWebApiAdminPassword ];
                 apiContext_ = strongContext_;
                 apiContext_.defaultSite = @"/sitecore/shell";
                 
                 
                 SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                 request_.requestType = SCReadItemRequestQuery;
                 request_.request = SCHomePath;
                 request_.language = @"da";
                 request_.fieldNames = field_names_;
                 [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
                 {
                     base_item_ = [ apiContext_ itemWithPath: SCHomePath
                                                      source: webShellDanish ];
                     NSLog( @"base_item_.field: %@", [ [ base_item_ fieldWithName: @"Title" ] rawValue ]);
         
                     didFinishCallback_();
                 } );
             }
         };
     
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    //Test base item (is available in danish)
    GHAssertTrue( base_item_ != nil, @"OK" );
    SCField* field_ = [ base_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == base_item_, @"OK" );
}

@end