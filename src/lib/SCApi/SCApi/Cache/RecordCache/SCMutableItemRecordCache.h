#import <Foundation/Foundation.h>

@class SCItemsReaderRequest;
@class SCExtendedApiContext;
@class SCItemRecord;

@protocol SCItemSource;

@protocol SCMutableItemRecordCache <NSObject>

// NSArray<ItemRecord>
-(void)cacheResponseItems:( NSArray* )items_
               forRequest:( SCItemsReaderRequest* )request_
               apiContext:( SCExtendedApiContext* )apiContext_;


// SCItemRecord
-(void)didRemovedItemRecord:( SCItemRecord* )record_;

-(void)cleanupSource:( id<SCItemSource> )itemSource;
-(void)cleanupAll;

-(void)setRawValue:( NSString* )newRawValue
        forFieldId:( NSString* )fieldId
            itemId:( NSString* )itemId
        itemSource:( id<SCItemSource> )itemSource;

@end
