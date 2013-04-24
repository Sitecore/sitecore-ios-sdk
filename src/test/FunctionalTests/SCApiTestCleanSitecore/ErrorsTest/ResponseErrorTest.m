#import "SCAsyncTestCase.h"

@interface ResponseErrorTest : SCAsyncTestCase
@end

@implementation ResponseErrorTest

-(void)RtestItemParentQueryWithInvalidQuery
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* productsItems_ = nil;
    __block SCResponseError* itemError_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = @"[./22@>";
            request_.scope       = SCItemReaderParentScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.fieldNames  = [ NSSet new ];
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                itemError_ = (SCResponseError*)error_;
                productsItems_ = items_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( productsItems_ == nil, @"OK" );
    GHAssertTrue( itemError_ != nil, @"OK" );

    GHAssertTrue( itemError_.statusCode == 400, @"OK" );
    GHAssertTrue( [ itemError_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)RtestItemQueryWithHighDataSize
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCResponseError* item_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request     = @"/sitecore/content/descendant::*/child::*/descendant::*/child::*/descendant::*";
            request_.scope       = SCItemReaderParentScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.flags       = SCItemReaderRequestReadFieldsValues;
            request_.fieldNames = nil;
            if( !apiContext_ )
            {
                didFinishCallback_();
                return;
            }
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                item_error_ = (SCResponseError*)error_;
                products_items_ = items_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 0, @"OK" );
    GHAssertTrue( item_error_ != nil, @"OK" );
    GHAssertTrue( item_error_.statusCode == 500, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

-(void)RtestItemQueryWithWrongItemPath
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCError* item_error_ = nil;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        @autoreleasepool
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request = @"/sitecore/content/home/WrongItem/*";
            request_.scope = SCItemReaderSelfScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.flags = SCItemReaderRequestReadFieldsValues;
            request_.fieldNames = nil;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                item_error_ = (SCError*)error_;
                products_items_ = items_;
                didFinishCallback_();
            } );
        }
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 0, @"OK" );
    GHAssertTrue( item_error_ == nil, @"OK" );
}

-(void)testItemQueryWithWrongQueryFormat
{
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSArray* products_items_ = nil;
    __block SCResponseError* item_error_ = nil;

    @autoreleasepool
    {
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            apiContext_ = [ SCApiContext contextWithHost: SCWebApiHostName ];

            SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
            request_.request = @"/sitecore/content/nicam/products/*[@@@template='WrongTemplate']";
            request_.scope = SCItemReaderSelfScope;
            request_.requestType = SCItemReaderRequestQuery;
            request_.flags = SCItemReaderRequestReadFieldsValues;
            request_.fieldNames = nil;
            [ apiContext_ itemsReaderWithRequest: request_ ]( ^( NSArray* items_, NSError* error_ )
            {
                item_error_ = (SCResponseError*)error_;
                products_items_ = items_;
                didFinishCallback_();
            } );
        };

        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }

    //GHAssertTrue( apiContext_ == nil, @"OK" );
    GHAssertTrue( [ products_items_ count ] == 0, @"OK" );

    GHAssertTrue( item_error_.statusCode == 400, @"OK" );
    GHAssertTrue( [ item_error_ isKindOfClass: [ SCResponseError class ] ], @"OK" );
}

@end

