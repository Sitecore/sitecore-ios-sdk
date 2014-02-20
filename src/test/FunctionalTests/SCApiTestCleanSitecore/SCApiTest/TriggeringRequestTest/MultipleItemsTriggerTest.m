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
    NSString* itemPath = [ NSString stringWithFormat: @"/sitecore/content/Triggering Events/Copy%ld", (long)itemNameIndex ];    
    
    SCPageEventTriggeringRequest *request_ =
    [ [ SCPageEventTriggeringRequest alloc ] initWithPath: itemPath
                                                eventName: @"Logout" ];
    
    return request_;
}

-(SCAsyncOp)asyncTrigger12WithContext:( SCApiSession* )apiContext_
{
    SCPageEventTriggeringRequest* first  = [ self kodLogout: 1 ];
    SCPageEventTriggeringRequest* second = [ self kodLogout: 2 ];

    SCAsyncOp triggerFirst  = [ apiContext_ triggerOperationWithRequest: first ];
    SCAsyncOp triggerSecond = [ apiContext_ triggerOperationWithRequest: second ];

    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCAsyncOp trigger = [ SCAsyncOpRelationsBuilder sequence: sequence ];

    return trigger;
}

-(SCAsyncOp)asyncTrigger34WithContext:( SCApiSession* )apiContext_
{
    SCPageEventTriggeringRequest* first  = [ self kodLogout: 3 ];
    SCPageEventTriggeringRequest* second = [ self kodLogout: 4 ];
    
    SCAsyncOp triggerFirst  = [ apiContext_ triggerOperationWithRequest: first ];
    SCAsyncOp triggerSecond = [ apiContext_ triggerOperationWithRequest: second ];
    
    NSArray* sequence = @[ triggerFirst, triggerSecond ];
    SCAsyncOp trigger = [ SCAsyncOpRelationsBuilder sequence: sequence ];
    
    return trigger;
}

-(SCAsyncOp)asyncTriggerAllWithContext:( SCApiSession* )apiContext_
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
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName ];
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
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName ];
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
    __weak __block SCApiSession* apiContext_ = nil;
    __block NSString *requestResult_ = nil;
    
    @autoreleasepool
    {
        __block SCApiSession* strongContext_ = nil;
        void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
        {
            @autoreleasepool
            {
                strongContext_ = [ [ SCApiSession alloc ] initWithHost: SCWebApiAnalyticsHostName ];
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
