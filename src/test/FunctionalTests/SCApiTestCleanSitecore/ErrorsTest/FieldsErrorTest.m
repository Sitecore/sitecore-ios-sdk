#import "SCAsyncTestCase.h"

@interface FieldsErrorTest : SCAsyncTestCase
@end

@implementation FieldsErrorTest

NSString* error_item_id_ = @"{A1FF0BEE-AE21-4BAF-BECD-8029FC89601A}";
NSString* error_item_display_name_ = @"Normal";
NSString* error_item_full_path_ = @"/sitecore/content/Nicam/Products/Lenses/Normal";

-(void)testPagedFieldValueReaderWrongField
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* result_field_ = nil;
    __block SCError* field_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope       = SCItemReaderChildrenScope;
        request_.request     = @"/sitecore/content/Nicam/";
        request_.pageSize    = 2;

        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemReaderForIndex: 2 ]( ^( id result_, NSError* error_ )
        {
            if ( !result_ )
            {
                did_finish_callback_();
                return;
            }
            [ result_ fieldValueReaderForFieldName: @"WrongField" ]( ^( id result_, NSError* error_ )
            {
                result_field_ = result_;
                field_error_ = (SCError*)error_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] == nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 2 ] != nil, @"OK" );
    GHAssertTrue( result_field_ == nil, @"OK" );
    GHAssertTrue( field_error_ != nil, @"OK" );
    GHAssertTrue( [ field_error_ isKindOfClass: [ SCNoFieldError class ] ] == TRUE, @"OK" );
}

-(void)testQueryFieldsReaderWrongFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSDictionary* result_fields_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/Nicam/Products/Lenses/descendant-or-self::*[@@templatename='Product Group']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = [ NSSet new ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            if ( [ products_items_ count ] == 0 )
            {
                did_finish_callback_();
                return;
            }
            SCAsyncOp asyncOp_ = [ products_items_[ 0 ] fieldsReaderForFieldsNames: fields_ ];
            asyncOp_( ^( id result_, NSError* error_ )
            {
                result_fields_ = result_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    NSLog( @"products_items_: %@", products_items_ );
    NSLog( @"result_fields_: %@", result_fields_ );
    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldsValuesReaderWrongFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSDictionary* result_fields_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/nicam"
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            products_items_ = items_;
            if ( [ products_items_ count ] == 0 )
            {
                did_finish_callback_();
                return;
            }
            SCAsyncOp asyncOp_ = [ products_items_[ 0 ] fieldsValuesReaderForFieldsNames: fields_ ];
            asyncOp_( ^( id result_, NSError* error_ )
            {
                result_fields_ = result_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );

    GHAssertTrue( result_fields_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldValueReaderWrongFieldName  //negative test
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCItem* item_   = nil;
    __block SCField* field_ = nil;
    __block NSDictionary* fields_result_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
            [ apiContext_ itemReaderForItemPath:  @"/sitecore/content/Nicam/" ]( ^( id result_, NSError* error_ )
            {
                if ( error_ )
                {
                    didFinishCallback_();
                    return;
                }
                item_ = result_;
                NSSet* fields_ = [ NSSet setWithObject: @"WrongField" ];
                [ item_ fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
                {
                    fields_result_ = result_;
                    didFinishCallback_();
                } );
            } );
        }
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ == nil, @"OK" );
    GHAssertTrue( [ fields_result_ count ] == 0, @"OK" );
}

@end
