#import "SCMapKitLocationUtils.h"

#import "SCPlacemark.h"

#import "NSDictionary+AddressWithItem.h"
#import "JFFAsyncOperationGeocoder.h"

#import <SitecoreMobileSDK/SCApi.h>

@implementation NSSet (SCMapKitLocationUtils)

+(id)itemAddressFieldsNames
{
    return [ self setWithObjects: @"Street"
            , @"City"
            , @"State"
            , @"ZIP"
            , @"Country"
            , @"Title"
            , @"Icon"
            , nil ];
}

@end

@interface SCExtendedApiContext (SCMapKitLocationUtils)

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCItemsReaderRequest* )request_;

@end

//STODO test
//STODO add "PlacemarkTitle" and "PlacemarkIconReader" as args
JFFAsyncOperation addressDictionaryGeocoderLoader( NSDictionary* placeMarkAddressDictionary_ )
{
    return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                    , JFFCancelAsyncOperationHandler cancelCallback_
                                    , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        NSMutableDictionary* addressDictionary_ = [ [ NSMutableDictionary alloc ]
                                                   initWithDictionary: placeMarkAddressDictionary_ ];

        //STODO remove
        [ addressDictionary_ removeObjectForKey: @"PlacemarkTitle" ];
        [ addressDictionary_ removeObjectForKey: @"PlacemarkIconReader" ];

        JFFAsyncOperation loader_ = placemarksLoaderWithAddressDict( addressDictionary_ );

        loader_ = asyncOperationWithChangedResult( loader_, ^id( NSArray* placemarks_ )
        {
            return [ placemarks_ map: ^id( CLPlacemark* object_ )
            {
                CLLocationCoordinate2D coordinate_ = object_.location.coordinate;
                return [ [ SCPlacemark alloc ] initWithCoordinate: coordinate_
                                                addressDictionary: placeMarkAddressDictionary_ ];
            } ];
        } );
        return loader_( progressCallback_, cancelCallback_, doneCallback_ );
    };
}

JFFAsyncOperationBinder addressDictionaryGeocoder()
{
    return ^JFFAsyncOperation( NSDictionary* addressDictionary_ )
    {
        return addressDictionaryGeocoderLoader( addressDictionary_ );
    };
}

JFFAsyncOperationBinder addressDictionariesGeocoder()
{
    return ^JFFAsyncOperation( NSArray* addressDictionaries_ )
    {
        JFFMappingBlock block_ = ^id( NSDictionary* addressDictionary_ )
        {
            return addressDictionaryGeocoderLoader( addressDictionary_ );                             
        };
        NSArray* geocoderOprations_ = [ addressDictionaries_ map: block_ ];
        JFFAsyncOperation loader_ = sequenceOfAsyncOperationsWithSuccessfullResults( geocoderOprations_ );

        JFFChangedResultBuilder resultBuilder_ = ^id( NSArray* result_ )
        {
            return [ result_ flatten: ^NSArray*( NSArray* array_ )
            {
                return array_;
            } ];
        };
        return asyncOperationWithChangedResult( loader_, resultBuilder_ );
    };
}

static JFFAsyncOperation itemsLoaderForQuery( SCApiContext* apiContext_, NSString* query_ )
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = query_;
    request_.requestType = SCItemReaderRequestQuery;
    request_.fieldNames  = [ NSSet itemAddressFieldsNames ];

    return [ apiContext_.extendedApiContext itemsLoaderWithRequest: request_ ];
}

static JFFAsyncOperation itemsLoaderForPath( SCApiContext* apiContext_, NSString* path_ )
{
    SCItemsReaderRequest* request_ = [ SCItemsReaderRequest new ];
    request_.request     = path_;
    request_.requestType = SCItemReaderRequestItemPath;
    request_.scope       = SCItemReaderChildrenScope;
    request_.fieldNames  = [ NSSet itemAddressFieldsNames ];

    return [ apiContext_.extendedApiContext itemsLoaderWithRequest: request_ ];
}

static JFFAsyncOperation itemAddressesGeocoderWithLoader( SCApiContext* apiContext_
                                                         , JFFAsyncOperation itemsLoader_ )
{
    JFFAsyncOperationBinder itemsToAddressDicts_ = ^JFFAsyncOperation( NSArray* items_ )
    {
        NSArray* result_ = [ items_ map: ^id( SCItem* item_ )
        {
            return [ NSDictionary addressDictionaryWithItem: item_ ];
        } ];
        return asyncOperationWithResult( result_ );
    };

    JFFAsyncOperationBinder geocoder_ = addressDictionariesGeocoder();

    return bindSequenceOfAsyncOperations( itemsLoader_
                                         , itemsToAddressDicts_
                                         , geocoder_
                                         , nil );
}

//STODO test
JFFAsyncOperation itemAddressesGeocoder( SCApiContext* apiContext_, NSString* query_ )
{
    JFFAsyncOperation itemsLoader_ = itemsLoaderForQuery( apiContext_, query_ );
    return itemAddressesGeocoderWithLoader( apiContext_
                                           , itemsLoader_ );
}

//STODO test
JFFAsyncOperation itemAddressesGeocoderWithPath( SCApiContext* apiContext_, NSString* path_ )
{
    JFFAsyncOperation itemsLoader_ = itemsLoaderForPath( apiContext_, path_ );
    return itemAddressesGeocoderWithLoader( apiContext_
                                           , itemsLoader_ );
}
