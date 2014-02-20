#import "SCAsyncTestCase.h"

@interface ReadFieldsWithSecurityTestExtended : SCAsyncTestCase
@end

@implementation ReadFieldsWithSecurityTestExtended

-(void)testReadSecurityDenyFieldValue
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* result_item_ = nil;
    __block id deny_field_value_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
                apiContext_ = strongContext_;
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    result_item_ = result_;
                    
                    SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result_, NSError* error_ )
                    {
                        deny_field_value_ = result_;
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader1 = [ result_item_ extendedFieldValueReaderForFieldName: @"Text" ];
                    loader1(nil, nil, doneHandler1);
                };
                
                SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: SCTestFieldsItemPath
                                            itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( result_item_ != nil, @"OK" );
    NSLog( @"result_item_.displayName: %@", result_item_.displayName );
    GHAssertTrue( [ result_item_.displayName isEqualToString: @"Test Fields" ], @"OK" );
    // Deny field test
    GHAssertTrue( deny_field_value_ == nil, @"OK" );
    GHAssertTrue( [ result_item_ fieldWithName: @"Text" ] == nil, @"OK" );
}

-(void)testReadSecurityDenyField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* result_item_ = nil;
    __block SCField* deny_field_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
                apiContext_ = strongContext_;
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    result_item_ = result_;
                    NSSet* fields_ = [ NSSet setWithObject: @"Text" ];
                    
                    SCDidFinishAsyncOperationHandler doneHandler1 = ^( id result, NSError* error_ )
                    {
                        deny_field_ = [ result_item_ fieldWithName: @"Text" ];
                        didFinishCallback_();
                    };
                    
                    SCExtendedAsyncOp loader1 = [ result_item_ extendedFieldsReaderForFieldsNames: fields_ ];
                    loader1(nil, nil, doneHandler1);
                };
                
                
                SCItemSourcePOD* contextSource = [ apiContext_.extendedApiSession contextSource ];
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession itemReaderForItemPath: SCTestFieldsItemPath
                                            itemSource: contextSource ];
                loader(nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];        
    }
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( result_item_ != nil, @"OK" );
    // Deny field test
    GHAssertTrue( deny_field_ == nil, @"OK" );
    GHAssertTrue( [ result_item_ fieldWithName: @"Text" ] == nil, @"OK" );
}

-(void)testReadSecurityAllowAndDenyFields
{
    __weak __block SCApiSession* apiContext_ = nil;

    __block NSArray* result_items_ = nil;
    __block SCField* allow_field_ = nil;
    __block SCField* deny_field_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
                apiContext_ = strongContext_;
            
                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.request = SCTestFieldsItemPath;
                request_.requestType = SCItemReaderRequestQuery;
                request_.fieldNames = [ NSSet setWithObjects: @"Text", @"Normal Text", nil ];

                SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
                {
                    if ( [ items_ count ] == 0 )
                    {
                        didFinishCallback_();
                        return;
                    }
                    result_items_ = items_;
                    allow_field_ = [ items_[ 0 ] fieldWithName: @"Normal Text" ];
                    deny_field_ = [ items_[ 0 ] fieldWithName: @"Text" ];
                    
                    didFinishCallback_();
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
                loader(nil, nil, doneHandler);
            }
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    // Fields test
    GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
    // Allow field test
    GHAssertTrue( allow_field_ != nil, @"OK" );
    GHAssertTrue( [ [ allow_field_ rawValue ] isEqualToString: @"Normal Text" ], @"OK" );
    GHAssertTrue( [ [ allow_field_ type ] isEqualToString: @"Single-Line Text" ], @"OK" );
    GHAssertTrue( [ allow_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Normal Text" ] == allow_field_, @"OK" );
    // Deny field test
    GHAssertTrue( deny_field_ == nil, @"OK" );
    
    apiContext_ = nil;
    result_items_ = nil;
    allow_field_ = nil;
    deny_field_ = nil;
}

-(void)testReadSecurityAllowAndDenyFieldsWithValues
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* result_items_ = nil;
    __block SCField* allow_field_ = nil;
    __block SCField* deny_field_ = nil;

    @autoreleasepool
    {
    __block SCApiSession* strongContext_  = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
            apiContext_ = strongContext_;
            
            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.request = SCTestFieldsItemPath;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames = [ NSSet setWithObjects: @"Text", @"Image", nil ];
            request_.flags = SCItemReaderRequestReadFieldsValues;

            SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
            {
                if ( [ items_ count ] == 0 )
                {
                    didFinishCallback_();
                    return;
                }
                result_items_ = items_;
                allow_field_ = [ items_[ 0 ] fieldWithName: @"Image" ];
                deny_field_  = [ items_[ 0 ] fieldWithName: @"Text" ];
                
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
            loader(nil, nil, doneHandler);
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ result_items_ count ] == 1, @"OK" );
    SCItem* item_ = result_items_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    // Fields test
    GHAssertTrue( [ item_.readFieldsByName count ] == 1, @"OK" );
    // Allow field test
    GHAssertTrue( allow_field_ != nil, @"OK" );
    GHAssertTrue( [ allow_field_ rawValue ] != nil , @"OK" );
    GHAssertTrue( [ [ allow_field_ type ] isEqualToString: @"Image" ], @"OK" );
    GHAssertTrue( [ allow_field_ item ] == item_, @"OK" );
    GHAssertTrue( [ item_ fieldWithName: @"Image" ] == allow_field_, @"OK" );
    id value_ = [ allow_field_ fieldValue ];
    GHAssertTrue( value_ != nil, @"OK" );
    GHAssertTrue( [ value_ isKindOfClass: [ UIImage class ] ] == TRUE, @"OK" );    
    // Deny field test
    GHAssertTrue( deny_field_ == nil, @"OK" );
}

-(void)testReadNotAllowedItemByAllowedField
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* resultItems_ = nil;
    
    __block SCField* field_ = nil;
    __block NSObject* field_result_ = nil;
    
    NSSet* fields_ = [ NSSet setWithObjects: @"NotAllowedItem", nil ];
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_  = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                NSString* path_ = SCTestFieldsItemPath;
                strongContext_ = [ TestingRequestFactory getNewAnonymousContext ];
                apiContext_ = strongContext_;
                
                SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
                request_.request     = path_;
                request_.requestType = SCItemReaderRequestQuery;
                request_.fieldNames  = fields_;
                request_.flags       = SCItemReaderRequestReadFieldsValues;
                
                SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* items_, NSError* error_ )
                {
                    NSLog( @"error:%@", error_ );
                    if ( [ items_ count ] == 0 )
                    {
                        didFinishCallback_();
                    }
                    else
                    {
                        SCItem* item_ = items_[ 0 ];
                        resultItems_ = items_;
                        
                        field_ = [ item_ fieldWithName: @"NotAllowedItem" ];
                        field_result_ = [ field_ fieldValue ];
                        didFinishCallback_();
                    }
                };
                
                SCExtendedAsyncOp loader = [ apiContext_.extendedApiSession readItemsOperationWithRequest: request_ ];
                loader(nil, nil, doneHandler);
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ resultItems_ count ] == 1, @"OK" );
    SCItem* item_ = resultItems_[ 0 ];
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( [ [ item_ readFieldsByName ] count ] == [ fields_ count ], @"OK" );
    // field test
    GHAssertTrue( field_ != nil, @"OK" );
    NSLog(@"%@", [ field_ fieldValue  ] );
    GHAssertTrue( [ [ field_ fieldValue  ] isEqualToString: @"Not_Allowed_Parent" ], @"OK" );
   
}

@end
