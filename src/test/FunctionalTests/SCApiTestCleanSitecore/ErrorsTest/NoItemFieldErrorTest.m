#import "SCAsyncTestCase.h"

@interface NoItemFieldErrorTest : SCAsyncTestCase
@end

@implementation NoItemFieldErrorTest

-(void)testPagedFieldValueReaderWrongField
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiContext* apiContext_ = nil;
    __block SCError* field_error_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.requestType = SCItemReaderRequestItemPath;
        request_.scope       = SCItemReaderChildrenScope;
        request_.request     = SCHomePath;
        request_.pageSize    = 2;
        
        pagedItems_ = [ SCPagedItems pagedItemsWithApiContext: apiContext_
                                                      request: request_ ];
        [ pagedItems_ itemReaderForIndex: 0 ]( ^( id result_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            [ result_ fieldValueReaderForFieldName: @"WrongField" ]( ^( id result_, NSError* error_ )
            {
                field_error_ = (SCError*) error_;
                didFinishCallback_();
            } );
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    NSLog(@"[ pagedItems_ itemForIndex: 2 ]: %@", [ pagedItems_ itemForIndex: 2 ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    GHAssertTrue( field_error_ != nil, @"OK" );
    GHAssertTrue( [ field_error_ isKindOfClass: [ SCNoFieldError class ] ] == TRUE, @"OK" );
}

-(void)testQueryFieldsReaderWrongFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSDictionary* result_fields_ = nil;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
        request_.request = @"/sitecore/content/home/descendant-or-self::*[@@templatename='Sample Item']";
        request_.requestType = SCItemReaderRequestQuery;
        request_.fieldNames = [ NSSet new ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
         {
             if ( [ items_ count ] == 0 )
             {
                 didFinishCallback_();
                 return;
             }
             products_items_ = items_;
             [ products_items_[ 0 ] fieldsReaderForFieldsNames: fields_ ]( ^( id result_, NSError* error_ )
             {
                 result_fields_ = result_;
                 didFinishCallback_();
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

-(void)testFieldsValuesReaderWrongFields
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSDictionary* result_fields_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCItemsReaderRequest* request_ = [ SCItemsReaderRequest requestWithItemPath: SCHomePath
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
         {
             if ( [ items_ count ] == 0 )
             {
                 didFinishCallback_();
                 return;
             }
             products_items_ = items_;
             SCItem* item_ = products_items_[ 0 ];
             [ item_ fieldsValuesReaderForFieldsNames: fields_ ]( ^( id result_
                                                                    , NSError* error_ )
             {
                 result_fields_ = result_;
                 didFinishCallback_();
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

@end
