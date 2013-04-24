#import "JFFAsyncOperationGeocoder.h"

#import "JFFAsyncOperationGeocoderBase.h"
#import "JFFAsyncOperationGeocoderDict.h"
#import "JFFAsyncOperationGeocoderAddress.h"


JFFAsyncOperation placemarksLoaderWithAddressDict( NSDictionary* addressDictionary_ )
{
    JFFAsyncOperationInstanceBuilder objectBuilder_ = ^id< JFFAsyncOperationInterface >()
    {
        JFFAsyncOperationGeocoderDict* object_ = [ JFFAsyncOperationGeocoderDict new ];
        object_.addressDictionary = addressDictionary_;
        
        return object_;
    };
    return buildAsyncOperationWithAdapterFactory( [ objectBuilder_ copy ] );
}

JFFAsyncOperation placemarksLoaderWithAddress( NSString* address_ )
{
    return placemarksLoaderWithAddressAndRegion( address_, nil );
}

JFFAsyncOperation placemarksLoaderWithAddressAndRegion( NSString* address_, CLRegion* region_ )
{
    JFFAsyncOperationInstanceBuilder objectBuilder_ = ^id< JFFAsyncOperationInterface >()
    {
        JFFAsyncOperationGeocoderAddress* object_ = [ JFFAsyncOperationGeocoderAddress new ];
        object_.address = address_;
        object_.region  = region_;

        return object_;
    };
    return buildAsyncOperationWithAdapterFactory( [ objectBuilder_ copy ] );
}
