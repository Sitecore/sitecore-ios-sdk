#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

@class SCApiSession;

JFFAsyncOperationBinder addressDictionaryGeocoder();
JFFAsyncOperationBinder addressDictionariesGeocoder();

JFFAsyncOperation scPlacemarksLoaderWithAddressDict( NSDictionary* addressDictionary_ );
JFFAsyncOperation addressDictionaryGeocoderLoader( NSDictionary* placeMarkAddressDictionary_ );

JFFAsyncOperation itemAddressesGeocoder( SCApiSession * apiSession_, NSString* query_ );
JFFAsyncOperation itemAddressesGeocoderWithPath( SCApiSession * apiSession_, NSString* path_ );
