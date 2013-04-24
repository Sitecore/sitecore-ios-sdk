#import "SCAsyncTestCase.h"

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

#import <SCMap/GoogleAPI/SCGoogleAPI.h>

@interface NSObject ( SCGoogleAPITest )

+(JFFAsyncOperation)routePointsReaderWithRouteLoader:( JFFAsyncOperation )routeLoader_;

@end

@interface SCGoogleAPITest : SCAsyncTestCase
@end

@implementation SCGoogleAPITest

-(void)testReaderWithDataFromFile
{
    __block NSMutableArray* testsResults_ = [ NSMutableArray array ];
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        
        JFFDidFinishAsyncOperationHandler doneCallBack_ = ^( NSArray* points_, NSError* error_ )
        {
            NSUInteger expectedPointsCount_ = 357;

            if ( points_.count != expectedPointsCount_ )
            {
                [ testsResults_ addObject: [ NSString stringWithFormat: @"Route points count is not valid should be %d instead of %d", expectedPointsCount_, points_.count ] ];
            }

            CLLocation* firstLocation_ = [ points_ objectAtIndex: 0 ];
            CLLocation* lastLocation_  = [ points_ lastObject ];

            CLLocation* myFirstLocation_ = [ [ CLLocation alloc ] initWithLatitude: 51.20122147 longitude: 0.00151 ];
            CLLocation* myLastLocation_  = [ [ CLLocation alloc ] initWithLatitude: 51.39984131 longitude: 0.0002 ];

            double litleValue_ = 0.00001;

            if ( abs( [ myFirstLocation_ distanceFromLocation: firstLocation_ ] ) > litleValue_ )
            {
                [ testsResults_ addObject: @"First location coordinate is not valid" ];
            }

            if ( abs( [ myLastLocation_ distanceFromLocation: lastLocation_ ] ) > litleValue_ )
            {
                [ testsResults_ addObject: @"Last location coordinate is not valid" ];
            }

            didFinishCallback_();
        };
        
        JFFAsyncOperation routeLoader_ =  ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                                                   , JFFCancelAsyncOperationHandler cancelCallback_
                                                                   , JFFDidFinishAsyncOperationHandler doneCallback_ )
        {
            if ( doneCallback_ )
            {
                NSString* responseFilePath_ = [ [ NSBundle mainBundle ] pathForResource: @"gApiRouteResponce" ofType: @"json" ];
                doneCallback_( [ NSData dataWithContentsOfFile: responseFilePath_ ], nil );
            }
            
            return ^void( BOOL cancel_ ){  };
        };
        
        JFFAsyncOperation loader_ = [ SCGoogleAPI routePointsReaderWithRouteLoader: routeLoader_ ];
        
        loader_( nil, nil, doneCallBack_ );
    };
    
    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];
    
    for ( NSString* errorDescription_ in testsResults_ )
    {
        GHAssertTrue( NO, errorDescription_ );
    }
}

-(void)testBadReader
{
     __block NSMutableArray* testsResults_ = [ NSMutableArray array ];

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        
        JFFDidFinishAsyncOperationHandler doneCallBack_ = ^( NSArray* points_, NSError* error_ )
        {
            if ( nil != points_ )
            {
                [ testsResults_ addObject: @"bad parser responce , points should be nil" ];
            }
            
            if ( nil == error_ )
            {
                [ testsResults_ addObject: @"bad parser responce , error_ should be not nil" ];
            }

            didFinishCallback_();
        };

        JFFAsyncOperation routeLoader_ =  ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                                                   , JFFCancelAsyncOperationHandler cancelCallback_
                                                                   , JFFDidFinishAsyncOperationHandler doneCallback_ )
        {
            if ( doneCallback_ )
            {
                doneCallback_( @"abra katabra", nil );
            }

            return ^void( BOOL cancel_ ){  };
        };

        JFFAsyncOperation loader_ = [ SCGoogleAPI routePointsReaderWithRouteLoader: routeLoader_ ];
        
        loader_( nil, nil, doneCallBack_ );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    for ( NSString* errorDescription_ in testsResults_ )
    {
       GHAssertTrue( NO, errorDescription_ );
    }
}

-(void)testRealReadRoute
{
    __block NSString* errorDescription_;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        JFFDidFinishAsyncOperationHandler doneCallBack_ = ^( NSArray* points_, NSError* error_ )
        {
            if ( points_.count == 0 )
            {
                errorDescription_ = @"Route points is not valid";
                didFinishCallback_();
                return;
            }

            CLLocation* firstLocation_ = [ points_ objectAtIndex: 0 ];
            CLLocation* lastLocation_  = [ points_ lastObject ];

            // @adk - may fail from time to time since real requests to google are sent
            // respomse is subject to change
            CLLocation* myFirstLocation_ = [ [ CLLocation alloc ] initWithLatitude: 51.20121002 longitude: 0.00151 ];
            CLLocation* myLastLocation_  = [ [ CLLocation alloc ] initWithLatitude: 51.39981842 longitude: 0.00016000 ];

            double litleValue_ = 0.005;
            double distance = 0.0;

            distance = fabs( [ myFirstLocation_ distanceFromLocation: firstLocation_ ] );
            if ( distance > litleValue_ )
            {
                errorDescription_ = @"First location coordinate is not valid";
                didFinishCallback_();
                return;
            }

            distance = fabs( [ myLastLocation_ distanceFromLocation: lastLocation_ ] );
            if ( distance > litleValue_ )
            {
                errorDescription_ = @"First location coordinate is not valid";
                didFinishCallback_();
                return;
            }

            didFinishCallback_();
        };

        CLLocationCoordinate2D startLocation_ = CLLocationCoordinate2DMake( 51.2, 0 );
        CLLocationCoordinate2D endLocation_   = CLLocationCoordinate2DMake( 51.4, 0 );

        JFFAsyncOperation loader_ = [ SCGoogleAPI routePointsReaderForStartLocation: startLocation_
                                                                        destination: endLocation_ ];
        loader_( nil, nil, doneCallBack_ );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertNil( errorDescription_, errorDescription_ );
}

@end
