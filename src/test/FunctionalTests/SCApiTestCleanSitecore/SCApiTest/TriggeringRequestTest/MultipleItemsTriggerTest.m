#import <SitecoreMobileSDK/SCAsyncOpRelationsBuilder.h>

@interface MultipleItemsTriggerTest : SCAsyncTestCase
@end


@implementation MultipleItemsTriggerTest

-(SCPageEventTriggeringRequest*)homeLogout
{
    SCPageEventTriggeringRequest *request_ =
    [ [ SCPageEventTriggeringRequest alloc ] initWithPath: SCTriggeringPath
                                                eventName: @"Logout" ];
    
    return request_;
}

-(SCPageEventTriggeringRequest*)kodLogout:( NSInteger )itemNameIndex
{
    NSString* itemPath = [ NSString stringWithFormat: @"/sitecore/content/Triggering Events/Copy%d", itemNameIndex ];    
    
    SCPageEventTriggeringRequest *request_ =
    [ [ SCPageEventTriggeringRequest alloc ] initWithPath: itemPath
                                                eventName: @"Logout" ];
    
    return request_;
}

-(SCAsyncOp)asyncTrigger12WithContext:( SCApiContext* )apiContext_
{
    SCPageEventTriggeringRequest* first  = [ self kodLogout: 1 ];
    SCPageEventTriggeringRequest* second = [ self kodLogout: 2 ];

    SCAsyncOp triggerFirst  = [ apiContext_ triggerLoaderForRequest: first ];
    SCAsyncOp triggerSecond = [ apiContext_ triggerLoaderForRequest: second ];

    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCAsyncOp trigger = [ SCAsyncOpRelationsBuilder sequence: sequence ];

    return trigger;
}

-(SCAsyncOp)asyncTrigger34WithContext:( SCApiContext* )apiContext_
{
    SCPageEventTriggeringRequest* first  = [ self kodLogout: 3 ];
    SCPageEventTriggeringRequest* second = [ self kodLogout: 4 ];
    
    SCAsyncOp triggerFirst  = [ apiContext_ triggerLoaderForRequest: first ];
    SCAsyncOp triggerSecond = [ apiContext_ triggerLoaderForRequest: second ];
    
    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCAsyncOp trigger = [ SCAsyncOpRelationsBuilder sequence: sequence ];
    
    return trigger;
}

-(SCAsyncOp)asyncTriggerAllWithContext:( SCApiContext* )apiContext_
{
    SCAsyncOp triggerFirst  = [ self asyncTrigger12WithContext: apiContext_ ];
    SCAsyncOp triggerSecond = [ self asyncTrigger34WithContext: apiContext_ ];
    
    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCAsyncOp trigger = [ SCAsyncOpRelationsBuilder sequence: sequence ];
    
    return trigger;
}

-(void)testTrigger12
{
    __weak MultipleItemsTriggerTest* weakSelf = self;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCAsyncOp trigger = [ weakSelf asyncTrigger12WithContext: apiContext_ ];
                trigger( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;

                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
//    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
}

-(void)testTrigger34
{
    __weak MultipleItemsTriggerTest* weakSelf = self;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCAsyncOp trigger = [ weakSelf asyncTrigger34WithContext: apiContext_ ];
                trigger( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;
                    
                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
//    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
}

-(void)testTrigger1234
{
    __weak MultipleItemsTriggerTest* weakSelf = self;
    __weak __block SCApiContext* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiContext* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiContext alloc ] initWithHost: SCWebApiAnalyticsHostName ];
                apiContext_ = strongContext_;
                
                SCAsyncOp trigger = [ weakSelf asyncTriggerAllWithContext: apiContext_ ];
                trigger( ^( id result_, NSError* error_ )
                {
                    if ( error_ )
                    {
                        didFinishCallback_();
                        return;
                    }
                    requestResult_ = result_;
                    
                    didFinishCallback_();
                } );
            }
        };
        
        [ self performAsyncRequestOnMainThreadWithBlock: block_
                                               selector: _cmd ];
    }
//    GHAssertTrue( requestResult_ != nil, @"requestResult  shouldn't be nil" );
}

@end
