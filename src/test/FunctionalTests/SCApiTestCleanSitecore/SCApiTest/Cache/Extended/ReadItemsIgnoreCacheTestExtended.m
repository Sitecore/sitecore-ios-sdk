#import "SCAsyncTestCase.h"

@interface ReadItemsIgnoreCacheTestExtended : SCAsyncTestCase
{
    JNConnectionMock* _mock;
}

@property ( nonatomic ) NSInteger connectionOpenCounter;

@end



@implementation ReadItemsIgnoreCacheTestExtended

-(void)setUp
{
    __weak ReadItemsIgnoreCacheTestExtended* weakSelf = self;
    
    
    JFFSimpleBlock action = ^void()
    {
        ++weakSelf.connectionOpenCounter;
    };
    
    self->_mock =
    [ [ JNConnectionMock alloc ] initWithConnectionClass: [ JNNsUrlConnection class ]
                                                  action: action
                                     executeOriginalImpl: YES ];
    
    self.connectionOpenCounter = 0;
}

-(void)tearDown
{
    [ self->_mock disableMock ];
    self->_mock = nil;
    self.connectionOpenCounter = 0;
}

//TODO: @igk fix after SCExtendedApi and SCApiSession will be merged
//-(void)testReadItemsWithCache
//{
//    __weak ReadItemsIgnoreCacheTestExtended* weakSelf = self;
//    JNConnectionMock* mock_ = self->_mock;
//    
//    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
//    {
//        SCApiSession* context = [ [ SCApiSession alloc ] initWithHost: SCWebApiHostName
//                                                                login: SCWebApiAdminLogin
//                                                             password: SCWebApiAdminPassword
//                                 version: SCWebApiV1 ];
//        
//        SCReadItemsRequest* request = [ SCReadItemsRequest new ];
//        request.request = SCHomePath;
//        request.requestType = SCReadItemRequestItemPath;
//        request.fieldNames = [ NSSet new ];
//        
//        [ context readItemsOperationWithRequest: request ]( ^( id result, NSError* error )
//        {
//            if ( [ result count ] == 0 )
//            {
//                didFinishCallback_();
//                return;
//            }
//            SCItem* item = result[ 0 ];
//            SCAsyncOp readChildrenOperation = [ item readChildrenOperation ];
//            
//
//            
//            //load children here
//            readChildrenOperation( ^( id result, NSError *error )
//           {
//               if ( error )
//               {
//                   weakSelf.connectionOpenCounter = -1; // fail the test
//                   didFinishCallback_();
//                   return;
//               }
//
//               [ mock_ enableMock ];
//               weakSelf.connectionOpenCounter = 0;
//               readChildrenOperation( ^( id result, NSError *error )
//               {
//                   didFinishCallback_();
//               } );
//           });
//        } );
//    };
//    [ self performAsyncRequestOnMainThreadWithBlock: block_
//                                           selector: _cmd ];
//    
//    GHAssertTrue( 0 == self.connectionOpenCounter, @"Only one connection must be opened with cache " );
//}

-(void)testReadItemsIgnoreCache
{
    __weak ReadItemsIgnoreCacheTestExtended* weakSelf = self;
    JNConnectionMock* mock_ = self->_mock;
    
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiSession* context = [ TestingRequestFactory getNewAdminContextWithShell ];
        
        SCReadItemsRequest* request = [ SCReadItemsRequest new ];
        request.request = @"/sitecore/content/home/child::*";
        request.requestType = SCReadItemRequestQuery;
        request.fieldNames  = [ NSSet new ];
        request.flags = SCReadItemRequestIngnoreCache;
        
        SCDidFinishAsyncOperationHandler doneHandler = ^( NSArray* result, NSError* error )
        {
            if ( error )
            {
                weakSelf.connectionOpenCounter = -1; // fail the test
                didFinishCallback_();
                
                return;
            }
            
            [ mock_ enableMock ];
            
            SCDidFinishAsyncOperationHandler doneHandler1 = ^( NSArray* result, NSError* error )
            {
                didFinishCallback_();
            };
            
            SCExtendedAsyncOp loader1 = [ context.extendedApiSession readItemsOperationWithRequest: request ];
            loader1(nil, nil, doneHandler1);
        };
        
        SCExtendedAsyncOp loader = [ context.extendedApiSession readItemsOperationWithRequest: request ];
        loader(nil, nil, doneHandler);
    };
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    GHAssertTrue( 1 == self.connectionOpenCounter, @"When cache is ignored data must come from network" );
}

@end
