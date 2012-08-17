#import "SCGoogleAPI.h"

#import "SCTwoPointsRoute.h"

@interface NSString (SCGoogleAPI)
@end

@implementation NSString (SCGoogleAPI)

+(id)googleApiLocationParamWithCCCoordinate:( CLLocationCoordinate2D )coordinate_
{
    return [ [ NSString alloc ] initWithFormat: @"%f,%f", coordinate_.latitude, coordinate_.longitude ];
}

@end

@interface SCGoogleAPI ()

+(JFFAsyncOperationBinder)googleApiDirectionsDataReader;
+(JFFAsyncOperationBinder)googleApiDirectionsDataParser;
+(NSMutableArray*)decodePolyLine:( NSString* )encodedStr_;

@end

@implementation SCGoogleAPI

+(JFFAsyncOperation)routePointsReaderWithRouteLoader:( JFFAsyncOperation )routeLoader_
{
    JFFAsyncOperation firstLoader_ = routeLoader_;
    return bindSequenceOfAsyncOperations( firstLoader_
                                         , [ self googleApiDirectionsDataParser ]
                                         , nil );
}

+(JFFAsyncOperation)routePointsReaderForStartLocation:( CLLocationCoordinate2D )orign_
                                          destination:( CLLocationCoordinate2D )destination_
{
    SCTwoPointsRoute* route_ = [ SCTwoPointsRoute routeWithOrigin: orign_
                                                      destination: destination_ ];

    JFFAsyncOperation routeLoader_ = [ self googleApiDirectionsDataReader ]( route_ );
    return [ self routePointsReaderWithRouteLoader: routeLoader_ ];
}

#pragma mark- Help functions

/**
 Please follow next link to help 
 https://developers.google.com/maps/documentation/directions/#Routes
*/
+(JFFAsyncOperationBinder)googleApiDirectionsDataReader
{
    return ^JFFAsyncOperation( id object_ )
    {
        SCTwoPointsRoute* route_ = object_;

        NSString* queryString_ = [ [ NSString alloc ] initWithFormat: @"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true&mode=driving"
                                  , [ NSString googleApiLocationParamWithCCCoordinate: route_.origin ]
                                  , [ NSString googleApiLocationParamWithCCCoordinate: route_.destination ] ];

        NSURL* url_ = [ NSURL URLWithString: queryString_ ];

//        NSString* filePath_ = [ [ NSBundle mainBundle ] pathForResource: @"directionResponce" ofType: @"json"];
//        NSURL* url_ = [ [ NSURL alloc ] initFileURLWithPath: filePath_ ];

        return dataURLResponseLoader( url_, nil, nil );
    };
}

+(JFFAsyncOperationBinder)googleApiDirectionsDataParser
{
    return ^JFFAsyncOperation( id serverData_ )
    {
        JFFSyncOperation loadDataBlock_ = ^id( NSError** outError_ )
        {
            if ( ![ serverData_ isKindOfClass: [ NSData class ] ] )
            {
                NSError* error_ = [ JFFError newErrorWithDescription: @"ERROR: bad data from reader responce" ];
                [ error_ setToPointer: outError_ ];
                return nil;
            }

            NSDictionary* jsonDict_ = [ NSJSONSerialization JSONObjectWithData: serverData_
                                                                       options: 0
                                                                         error: outError_ ];

            if ( !jsonDict_ )
                return nil;

//            NSDictionary* jsonDict_ = [ NSDictionary dictionaryWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"directionResponce" ofType: @"json"] ];

            if ( ![ jsonDict_ isKindOfClass: [ NSDictionary class ] ] )
            {
                NSError* error_ = [ JFFError newErrorWithDescription: @"ERROR: can't parse directions response from google API" ];
                [ error_ setToPointer: outError_ ];
                return nil;
            }

            NSString* status_ = [ jsonDict_ objectForKey: @"status" ];
            if ( ![ status_ isEqualToString: @"OK" ] )
            {
                NSError* error_ = [ JFFError newErrorWithDescription: @"ERROR: bad status in [directions response from google API]" ];
                [ error_ setToPointer: outError_ ];
                return nil;
            }

            NSArray* routes_ = [ jsonDict_ objectForKey: @"routes" ];

            NSDictionary* route_ = [ routes_ noThrowObjectAtIndex: 0 ];

            if ( ![ route_ isKindOfClass: [ NSDictionary class ] ]  )
            {
                NSError* error_ = [ JFFError newErrorWithDescription: @"ERROR: bad route data in [directions response from google API]" ];
                [ error_ setToPointer: outError_ ];
                return nil;
            }

            NSDictionary* overviewPolyline_ = [ route_ objectForKey: @"overview_polyline" ];
            if ( ![ overviewPolyline_ isKindOfClass: [ NSDictionary class ] ]  )
            {
                NSError* error_ = [ JFFError newErrorWithDescription: @"ERROR: bad route data in [directions response from google API]" ];
                [ error_ setToPointer: outError_ ];
                return nil;
            }

            NSString* codedPoints_ = [ overviewPolyline_ objectForKey: @"points" ];

            if ( !codedPoints_ )
            {
                NSError* error_ = [ JFFError newErrorWithDescription: @"ERROR: no information about overview_polyline->points in [directions response from google API]" ];
                [ error_ setToPointer: outError_ ];
                return nil;
            }

            return [ self decodePolyLine: codedPoints_ ];
        };

        return asyncOperationWithSyncOperation( loadDataBlock_ );
    };
}

+(NSMutableArray*)decodePolyLine:( NSString* )encodedStr_
{  
    NSMutableString* encoded_ = [ [ NSMutableString alloc ] initWithCapacity: [ encodedStr_ length ] ];

    [ encoded_ appendString: encodedStr_ ];

    [ encoded_ replaceOccurrencesOfString: @"\\\\"
                               withString: @"\\"
                                  options: NSLiteralSearch
                                    range: NSMakeRange( 0, [ encoded_ length ] ) ];

    NSInteger       len_   = [ encoded_ length ];  
    NSInteger       index_ = 0;  
    NSMutableArray* array_ = [ [ NSMutableArray alloc ] init ];
    NSInteger       lat_   = 0;
    NSInteger       lng_   = 0;

    while ( index_ < len_ )
    {  
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do
        {  
            if ( index_ >= encoded_.length )
                return nil;

            b = [ encoded_ characterAtIndex: index_++ ] - 63;  
            result |= (b & 0x1f) << shift;
            shift += 5;  
        } while (b >= 0x20);

        NSInteger dlat = ( (result & 1) ? ~(result >> 1) : (result >> 1) );

        lat_  += dlat;  
        shift  = 0;  
        result = 0;  
        do
        {  
            if ( index_ >= encoded_.length )
                return nil;

            b = [ encoded_ characterAtIndex:index_++ ] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
       
        NSInteger dlng = ( (result & 1) ? ~(result >> 1) : (result >> 1));

        lng_ += dlng;

        NSNumber* latitude  = [ [ NSNumber alloc] initWithFloat: lat_ * 1e-5 ];  
        NSNumber* longitude = [ [ NSNumber alloc] initWithFloat: lng_ * 1e-5 ];  
 
        CLLocation* location_ = [ [ CLLocation alloc] initWithLatitude:[ latitude floatValue ] longitude:[ longitude floatValue ] ];
        if ( location_ )
        {
            [ array_ addObject: location_ ];
        }
    }  
 
    return array_;  
}

@end
