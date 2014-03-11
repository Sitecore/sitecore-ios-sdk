#import "SCAsyncTestCase.h"

@interface NoItemFieldErrorTest : SCAsyncTestCase
@end

@implementation NoItemFieldErrorTest

-(void)testPagedFieldValueReaderWrongField
{
    __block SCPagedItems* pagedItems_;
    __weak __block SCApiSession* apiContext_ = nil;
    __block SCApiError* field_error_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultSite = @"/sitecore/shell";
        
        SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
        request_.requestType = SCReadItemRequestItemPath;
        request_.scope       = SCReadItemChildrenScope;
        request_.request     = SCHomePath;
        request_.pageSize    = 2;
        
        pagedItems_ = [ SCPagedItems pagedItemsWithApiSession: apiContext_
                                                      request: request_ ];
        [ pagedItems_ readItemOperationForIndex: 0 ]( ^( id result_, NSError* error_ )
        {
            if ( error_ )
            {
                didFinishCallback_();
                return;
            }
            [ result_ readFieldValueOperationForFieldName: @"WrongField" ]( ^( id result_, NSError* error_ )
            {
                field_error_ = (SCApiError*) error_;
                didFinishCallback_();
            } );
        } );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    NSLog(@"[ pagedItems_ itemForIndex: 2 ]: %@", [ pagedItems_ itemForIndex: 2 ] );
    GHAssertTrue( apiContext_ != nil, @"OK" );
    GHAssertTrue( [ pagedItems_ itemForIndex: 0 ] != nil, @"OK" );
    GHAssertTrue( field_error_ != nil, @"OK" );
    GHAssertTrue( [ field_error_ isKindOfClass: [ SCNoFieldError class ] ] == TRUE, @"OK" );
}

-(void)testQueryFieldsReaderWrongFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSDictionary* result_fields_ = nil;
    
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultSite = @"/sitecore/shell";
        
        
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest new ];
        request_.request = @"/sitecore/content/home/descendant-or-self::*[@@templatename='Sample Item']";
        request_.requestType = SCReadItemRequestQuery;
        request_.fieldNames = [ NSSet new ];
        [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
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
    }
    
    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );
    GHAssertTrue( result_fields_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

-(void)testFieldsValuesReaderWrongFields
{
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block NSDictionary* result_fields_ = nil;

    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
                                                         login: SCWebApiAdminLogin
                                                      password: SCWebApiAdminPassword ];
        apiContext_ = strongContext_;
        apiContext_.defaultSite = @"/sitecore/shell";
        
        NSSet* fields_ = [ NSSet setWithObjects: @"WrongField1", @"WrongField2", nil ];
        SCReadItemsRequest* request_ = [ SCReadItemsRequest requestWithItemPath: SCHomePath
                                                                        fieldsNames: [ NSSet new ] ];
        [ apiContext_ readItemsOperationWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
         {
             if ( [ items_ count ] == 0 )
             {
                 didFinishCallback_();
                 return;
             }
             products_items_ = items_;
             SCItem* item_ = products_items_[ 0 ];
             [ item_ readFieldsValuesOperationForFieldsNames: fields_ ]( ^( id result_
                                                                    , NSError* error_ )
             {
                 result_fields_ = result_;
                 didFinishCallback_();
             } );
         } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    }
    
    
    GHAssertTrue( apiContext_ != nil, @"session should be deallocated" );
    GHAssertTrue( products_items_ != nil, @"OK" );

    GHAssertTrue( result_fields_ != nil, @"OK" );
    GHAssertTrue( [ result_fields_ count ] == 0, @"OK" );
}

@end
