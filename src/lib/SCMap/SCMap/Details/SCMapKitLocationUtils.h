#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

@class SCApiContext;

JFFAsyncOperationBinder addressDictionaryGeocoder();
JFFAsyncOperationBinder addressDictionariesGeocoder();

JFFAsyncOperation scPlacemarksLoaderWithAddressDict( NSDictionary* addressDictionary_ );
JFFAsyncOperation addressDictionaryGeocoderLoader( NSDictionary* placeMarkAddressDictionary_ );

JFFAsyncOperation itemAddressesGeocoder( SCApiContext* apiContext_, NSString* query_ );
JFFAsyncOperation itemAddressesGeocoderWithPath( SCApiContext* apiContext_, NSString* path_ );
