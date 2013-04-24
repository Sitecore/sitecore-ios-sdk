#import "SCCacheDBAdaptor.h"

#import <JFFRestKit/JFFRestKitCache.h>
#import <JFFRestKit/Details/JFFResponseDataWithUpdateData.h>

@implementation SCCacheDBAdaptor

-(void)setData:( NSData* )data_ forKey:( NSString* )key_
{
    [ self->_jffCacheDB setData: data_ forKey: key_ ];
}

-(NSData*)dataForKey:( NSString* )data_ lastUpdateDate:( NSDate** )date_
{
    return  [ self->_jffCacheDB dataForKey: data_ lastUpdateTime: date_ ];
}

-(JFFAsyncOperation)loaderToSetData:(NSData *)data_
                             forKey:(NSString *)key_
{
    __weak SCCacheDBAdaptor* weakSelf_ = self;
    
    return asyncOperationWithSyncOperation( ^id(NSError *__autoreleasing *outError)
    {
       [ weakSelf_ setData: data_
                    forKey: key_ ];
       
       return [ NSNull null ];
    } );
}

-(JFFAsyncOperation)cachedDataLoaderForKey:(NSString *)key_
{
    __weak SCCacheDBAdaptor* weakSelf_ = self;
    
    return asyncOperationWithSyncOperation( ^id(NSError *__autoreleasing *outError)
    {
       JFFResponseDataWithUpdateData* result_ = [ JFFResponseDataWithUpdateData new ];
       NSDate* updateDate_ = nil;
       
       result_.data = [ weakSelf_ dataForKey: key_
                              lastUpdateDate: &updateDate_ ];
       result_.updateDate = updateDate_;
       
       return result_;
    } );
}

@end
