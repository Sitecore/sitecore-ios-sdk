#import "SCAsyncTestCase.h"

@interface LanguageReaderPositiveTestExtended : SCAsyncTestCase
@end

@implementation LanguageReaderPositiveTestExtended
{
    SCItemSourcePOD* _srcEnglish;
    SCItemSourcePOD* _srcDanish ;
}


-(void)setUp
{
    [ super setUp ];
    
    SCItemSourcePOD* srcEnglish = [ SCItemSourcePOD new ];
    {
        srcEnglish.language = @"en";
        srcEnglish.site     = @"/sitecore/shell";
        srcEnglish.database = @"web";
    }
    self->_srcEnglish = srcEnglish;
    
    SCItemSourcePOD* srcDanish  = [ srcEnglish copy ];
    srcDanish.language = @"da";
    self->_srcDanish = srcDanish;
}

-(void)testSystemLanguagesReader
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSSet* resultLanguages_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {

            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSSet *languages_, NSError *error_ )
            {
                resultLanguages_ = languages_;
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession systemLanguagesReader ];
            loader(nil, nil, doneHandler);
        }

    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
        [ [ apiContext_.extendedApiSession itemsCache ] cleanupAll ];
    }
    
    
    GHAssertTrue( apiContext_ == nil, @"Should be nil" );
    GHAssertTrue( resultLanguages_ != nil, @"OK" );
    GHAssertTrue( [ resultLanguages_ count ] == 2, @"OK" );
    GHAssertTrue( [ resultLanguages_ containsObject: @"en" ] == TRUE, @"OK" );
    GHAssertTrue( [ resultLanguages_ containsObject: @"da" ] == TRUE, @"OK" );
}

-(void)testContextDefaultLanguageSameItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_ = nil;
    __block BOOL isDanishItem_ = false;
    
    SCItemSourcePOD* srcEnglish = self->_srcEnglish;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {

            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultLanguage = @"da";
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: [ NSSet setWithObject: @"Title" ] ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* da_result_, NSError* error_ )
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
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id en_result_, NSError* error_ )
                {
                    item_ = en_result_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader1 =
                [ apiContext_.extendedApiSession itemReaderWithFieldsNames: [ NSSet setWithObject: @"Title" ]
                                                                  itemPath: SCLanguageItemPath
                                                                itemSource: srcEnglish ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertNotNil( apiContext_, @"OK" );
    
    GHAssertNotNil( item_, @"OK" );
    //Test danish item
    GHAssertTrue( isDanishItem_, @"OK" );
    //Test english item
    SCField* field_ = [ item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Title" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == item_, @"OK" );
}

-(void)testContextDefaultLanguageDifferentItems
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* en_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObject: @"Title" ];

    SCItemSourcePOD* srcEnglish = self->_srcEnglish;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {

            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            apiContext_.defaultLanguage = @"da";
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: field_names_ ];

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = da_result_[ 0 ];
                apiContext_.defaultLanguage = @"en";
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id en_result_, NSError* error_ )
                {
                    en_item_ = en_result_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader1 = [ apiContext_.extendedApiSession itemReaderWithFieldsNames: field_names_
                                             itemPath: @"/sitecore/content/Language Test/Language Item 2"
                                             itemSource: srcEnglish ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertNotNil( apiContext_, @"OK" );
    //Test danish item
    GHAssertNotNil( da_item_, @"OK" );
    SCField* field_ = [ da_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Danish" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == da_item_, @"OK" );
    //Test english item
    GHAssertNotNil( en_item_, @"OK" );
    field_ = [ en_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Language Item 2" ] == TRUE, @"OK" );
    GHAssertTrue( field_.item == en_item_, @"OK" );
}

-(void)testRequestLanguageOneItem
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* da_item_ = nil;
    __block SCItem* en_item_ = nil;
    __block NSSet* field_names_ = [ NSSet setWithObject: @"Title" ];
    
    SCItemSourcePOD* srcEnglish = self->_srcEnglish;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {

            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCLanguageItemPath
                                                                            fieldsNames: field_names_ ];
            request_.language = @"da";
            apiContext_.defaultLanguage = @"en";
            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* da_result_, NSError* error_ )
            {
                if ( [ da_result_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                da_item_ = da_result_[ 0 ];
                apiContext_.defaultLanguage = @"en";
                
                SCDidFinishAsyncOperationHandler doneHandler1 = ^( id en_result_, NSError* error_ )
                {
                    en_item_ = en_result_;
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader1 =
                [ apiContext_.extendedApiSession itemReaderWithFieldsNames: field_names_
                                                                  itemPath: SCLanguageItemPath
                                                                itemSource: srcEnglish ];
                loader1(nil, nil, doneHandler1);
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    GHAssertNotNil( apiContext_, @"OK" );
    //Test danish item
    GHAssertNotNil( da_item_, @"OK" );
    SCField* field_ = [ da_item_ fieldWithName: @"Title" ];
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Danish" ] == TRUE, @"OK" );
    //Test english item
    GHAssertNotNil( en_item_, @"OK" );
    field_ = [ en_item_ fieldWithName: @"Title" ];
    NSLog( @"field_.rawValue: %@", field_.rawValue );
    GHAssertTrue( [ field_.rawValue isEqualToString: @"Title" ] == TRUE, @"OK" );
}

@end
