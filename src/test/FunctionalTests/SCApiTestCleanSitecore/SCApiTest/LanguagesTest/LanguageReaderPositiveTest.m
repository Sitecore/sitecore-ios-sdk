#import "SCAsyncTestCase.h"

@interface LanguageReaderPositiveTest : SCAsyncTestCase
@end

@implementation LanguageReaderPositiveTest

-(void)testSystemLanguagesReader
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSSet* resultLanguages_ = nil;

    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
            apiContext_ = strongContext_;
            
            [ apiContext_ systemLanguagesReader ]( ^( NSSet *languages_, NSError *error_ )
            {
                resultLanguages_ = languages_;
                didFinishCallback_();
            } );         
        }

    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"Should be nil" );
    GHAssertTrue( resultLanguages_ != nil, @"OK" );
    GHAssertTrue( [ resultLanguages_ count ] == 2, @"OK" );
    GHAssertTrue( [ resultLanguages_ containsObject: @"en" ] == TRUE, @"OK" );
    GHAssertTrue( [ resultLanguages_ containsObject: @"da" ] == TRUE, @"OK" );
}

-(void)testContextDefaultLanguageSameItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block BOOL isDanishItem_ = false;
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultLanguage = @"da";
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: [ NSSet setWithObject: @"Title" ] ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = da_result_[ 0 ];
                SCField* field_ = [ item_ fieldWithName: @"Title" ];
                isDanishItem_ = [ field_.rawValue isEqualToString: @"Danish" ];
                apiContext_.defaultLanguage = @"en";
                [ apiContext_ itemReaderWithFieldsNames: [ NSSet setWithObject: @"Title" ]
                                               itemPath: SCLanguageItemPath ]( ^( id en_result_, NSError* error_ )
                {
                    item_ = en_result_;
                    didFinishCallback_();
                });
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    
    GHAssertTrue( item_ != nil, @"OK" );
    //Test danish item
    GHAssertTrue( isDanishItem_, @"OK" );
    //Test english item
    SCField* field_ = [ item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Title" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == item_, @"OK" );
}

-(void)testContextDefaultLanguageDifferentItems
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* en_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObject: @"Title" ];

    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultLanguage = @"da";
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: field_names_ ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = da_result_[ 0 ];
                apiContext_.defaultLanguage = @"en";
                [ apiContext_ itemReaderWithFieldsNames: field_names_
                                               itemPath: SCHomePath ]( ^( id en_result_, NSError* error_ )
                {
                    en_item_ = en_result_;
                    didFinishCallback_();
                });
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
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Danish" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == da_item_, @"OK" );
    //Test english item
    GHAssertTrue( en_item_ != nil, @"OK" );
    field_ = [ en_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Sitecore" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == en_item_, @"OK" );
}

-(void)testRequestLanguageOneItem
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* en_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObject: @"Title" ];
    
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiHostName ];
            apiContext_ = strongContext_;
            
            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: field_names_ ];
            request_.language = @"da";
            apiContext_.defaultLanguage = @"en";
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = da_result_[ 0 ];
                [ apiContext_ itemReaderWithFieldsNames: field_names_
                                                itemPath: SCHomePath ]( ^( id en_result_, NSError* error_ )
                {
                    en_item_ = en_result_;
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
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Danish" ] == TRUE, @"OK" );
    //Test english item
    GHAssertTrue( en_item_ != nil, @"OK" );
    field_ = [ en_item_ fieldWithName: @"Title" ];
    NSLog( @"field_.rawValue: %@", field_.rawValue );
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Sitecore" ] == TRUE, @"OK" );
}

@end
