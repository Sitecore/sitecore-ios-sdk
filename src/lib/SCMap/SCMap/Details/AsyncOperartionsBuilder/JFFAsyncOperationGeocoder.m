#import "JFFAsyncOperationGeocoder.h"

@interface JFFAsyncOperationGeocoderBase : NSObject < JFFAsyncOperationInterface >

@property ( nonatomic, readonly ) CLGeocoder* geocoder;

@end

@interface JFFAsyncOperationGeocoderBase ()

@property ( nonatomic ) CLGeocoder* geocoder;

@end

@implementation JFFAsyncOperationGeocoderBase

-(id)init
{
    self = [ super init ];

    if ( self )
    {
        self.geocoder = [ CLGeocoder new ];
    }

    return self;
}

-(void)cancel:( BOOL )canceled_
{
    [ self.geocoder cancelGeocode ];
    self.geocoder = nil;
}

-(void (^)( void (^)( id, NSError* ) ))asyncOperation
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(void)asyncOperationWithResultHandler:( void (^)( id, NSError* ) )handler_
                       progressHandler:( void (^)( id ) )progress_
{
    if ( !self.geocoder )
        return;

    [ self asyncOperation ]( ^( id result_, NSError* error_ )
    {
        if ( progress_ && result_ )
            progress_( result_ );

        if ( handler_ )
            handler_( result_, error_ );
    } );
}

@end

@interface JFFAsyncOperationGeocoderDict : JFFAsyncOperationGeocoderBase

@property ( nonatomic ) NSDictionary* addressDictionary;

@end

@implementation JFFAsyncOperationGeocoderDict

-(void (^)( void (^)( id, NSError* ) ))asyncOperation
{
    return ^void( void (^handler_)( id, NSError* ) )
    {
        handler_ = [ handler_ copy ];
        CLGeocodeCompletionHandler completionHandler_ = ^( NSArray* placemarks_, NSError* error_ )
        {
            if ( handler_ )
                handler_( placemarks_, error_ );
        };

        [ self.geocoder geocodeAddressDictionary: self.addressDictionary
                               completionHandler: completionHandler_ ];
    };
}

@end

@interface JFFAsyncOperationGeocoderAddress : JFFAsyncOperationGeocoderBase

@property ( nonatomic ) NSString* address;
@property ( nonatomic ) CLRegion* region;

@end

@implementation JFFAsyncOperationGeocoderAddress

@synthesize address = _address;
@synthesize region  = _region;

-(void (^)( void (^)( id, NSError* ) ))asyncOperation
{
    return ^void( void (^handler_)( id, NSError* ) )
    {
        handler_ = [ handler_ copy ];
        CLGeocodeCompletionHandler completionHandler_ = ^( NSArray* placemarks_, NSError* error_ )
        {
            if ( handler_ )
                handler_( placemarks_, error_ );
        };

        [ self.geocoder geocodeAddressString: self.address
                                    inRegion: self.region
                           completionHandler: completionHandler_ ];
    };
}

@end

JFFAsyncOperation placemarksLoaderWithAddressDict( NSDictionary* addressDictionary_ )
{
    JFFAsyncOperationGeocoderDict* object_ = [ JFFAsyncOperationGeocoderDict new ];
    object_.addressDictionary = addressDictionary_;

    return buildAsyncOperationWithInterface( object_ );
}

JFFAsyncOperation placemarksLoaderWithAddress( NSString* address_ )
{
    return placemarksLoaderWithAddressAndRegion( address_, nil );
}

JFFAsyncOperation placemarksLoaderWithAddressAndRegion( NSString* address_, CLRegion* region_ )
{
    JFFAsyncOperationGeocoderAddress* object_ = [ JFFAsyncOperationGeocoderAddress new ];
    object_.address = address_;
    object_.region  = region_;

    return buildAsyncOperationWithInterface( object_ );
}
