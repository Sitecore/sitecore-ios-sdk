#import "JFFAsyncOperationGeocoderAddress.h"

@implementation JFFAsyncOperationGeocoderAddress

@synthesize address = _address;
@synthesize region  = _region;

-(SCAsyncOp)asyncOperation
{
    NSString* address_    = self.address ;
    CLRegion* region_     = self.region  ;
    CLGeocoder* geocoder_ = self.geocoder;
    
    return ^void( SCAsyncOpResult handler_ )
    {
        handler_ = [ handler_ copy ];
        CLGeocodeCompletionHandler completionHandler_ = ^( NSArray* placemarks_, NSError* error_ )
        {
            if ( handler_ )
            {
                handler_( placemarks_, error_ );
            }
        };
        
        [ geocoder_ geocodeAddressString: address_
                                inRegion: region_
                       completionHandler: completionHandler_ ];
    };
}

@end
