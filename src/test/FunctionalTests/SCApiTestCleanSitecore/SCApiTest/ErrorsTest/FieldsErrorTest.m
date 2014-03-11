#import "SCAsyncTestCase.h"

@interface FieldsErrorTest : SCAsyncTestCase
@end

@implementation FieldsErrorTest

-(void)testPagedFieldValueReaderWrongField
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* result_field_ = nil;
    __block SCApiError* field_error_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;

            SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
            request_.requestType = SCReadItemRequestItemPath;
            request_.request     = SCHomePath;
            request_.pageSize    = 2;

            pagedItems_ = [ SCPagedItems pagedItemsWithApiSession: apiContext_
                                                          request: request_ ];
            [ pagedItems_ readItemOperationForIndex: 0 ]( ^( id result_, NSError* error_ )
            {
                if ( !result_ )
                {
                    did_finish_callback_();
                    return;
                }
                [ result_ readFieldValueOperationForFieldName: @"WrongField" ]( ^( id result_, NSError* error_ )
                {
                    result_field_ = result_;
                    field_error_ = (SCApiError*)error_;
                    did_finish_callback_();
                } );
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    GHAssertTrue( result_field_ == nil, @"OK" );
    GHAssertTrue( field_error_ != nil, @"OK" );
    GHAssertTrue( [ field_error_ isKindOfClass: [ SCNoFieldError class ] ] == TRUE, @"OK" );
}

-(void)testQueryFieldsReaderWrongFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* items_ = nil;
    __block NSDictionary* result_fields_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
        request_.request = @"/sitecore/content/Home/descendant-or-self::*[@@templatename='Sample Item']";
        request_.requestType = SCReadItemRequestQuery;
        request_.fieldNames = [ NSSet set ];
        [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* result_, NSError* error_ )
        {
            items_ = result_;
            if ( [ items_ count ] == 0 )
            {
                did_finish_callback_();
                return;
            }
            SCAsyncOp asyncOp_ = [ items_[ 0 ] fieldsReaderForFieldsNames: fields_ ];
            asyncOp_( ^( id result_, NSError* error_ )
            {
                result_fields_ = result_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    // Old fields from SQLite. rm -rf Cache.db will help
    NSLog( @"products_items_: %@", items_ );
    NSLog( @"result_fields_: %@", result_fields_ );
    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( items_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldsValuesReaderWrongFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* result_items_ = nil;
    __block NSDictionary* result_fields_ = nil;

    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock did_finish_callback_ )
    {
        strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
        apiContext_ = strongContext_;
        
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: @"/sitecore/content/home"
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
        {
            result_items_ = items_;
            if ( [ result_items_ count ] == 0 )
            {
                did_finish_callback_();
                return;
            }
            SCAsyncOp asyncOp_ = [ result_items_[ 0 ] readFieldsValuesOperationForFieldsNames: fields_ ];
            asyncOp_( ^( id result_, NSError* error_ )
            {
                result_fields_ = result_;
                did_finish_callback_();
            } );
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"session should be retained" );
    GHAssertTrue( result_items_ != nil, @"OK" );

    GHAssertTrue( result_fields_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldValueReaderWrongFieldName 
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCItem* item_   = nil;
    __block SCField* field_ = nil;
    __block NSDictionary* fields_result_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            strongContext_ = [ TestingRequestFactory getNewAdminContextWithShell ];
            apiContext_ = strongContext_;
            
            [ apiContext_ readItemOperationForItemPath:  SCHomePath ]( ^( id result_, NSError* error_ )
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
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( item_ != nil, @"OK" );
    GHAssertTrue( field_ == nil, @"OK" );
    GHAssertTrue( [ fields_result_ count ] == 0, @"OK" );
}

@end
