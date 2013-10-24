#import "SCApiContext.h"

@interface SCApiContext (Private)

-(JFFAsyncOperation)itemLoaderWithFieldsNames:( NSSet* )fieldNames_
                                       itemId:( NSString* )itemId_;

-(JFFAsyncOperation)itemsLoaderWithRequest:( SCItemsReaderRequest* )request_;

-(JFFAsyncOperation)privateImageLoaderForSCMediaPath:( NSString* )path_
                                              params:( SCFieldImageParams* )params;

-(SCRemoteApi *)getApi;

-(JFFAsyncOperation)cachedItemsPageLoader:( JFFAsyncOperation )loader_
                                  request:( SCItemsReaderRequest* )request_;

-(JFFAsyncOperation)removeItemsLoaderWithRequest:( SCItemsReaderRequest* )request_;

-(JFFAsyncOperation)mediaItemCreatLoaderWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_;

-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )request_;

-(JFFAsyncOperation)itemRecordLoaderForRequest:( SCItemsReaderRequest* )request_;

-(JFFAsyncOperation)privateTriggerLoaderForRequest:( SCTriggeringRequest* )request_;

@end
