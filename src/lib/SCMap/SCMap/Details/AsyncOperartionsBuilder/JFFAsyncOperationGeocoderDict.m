#import "JFFAsyncOperationGeocoderDict.h"

@implementation JFFAsyncOperationGeocoderDict

-(SCAsyncOp)asyncOperation
{
    NSDictionary* dict_ = self->_addressDictionary;
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
        
        [ geocoder_ geocodeAddressDictionary: dict_
                           completionHandler: completionHandler_ ];
    };
}

@end

