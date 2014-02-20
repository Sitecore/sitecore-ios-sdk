#import <Foundation/Foundation.h>

@class SCReadItemsRequest;
@class SCExtendedApiSession;
@class SCItemRecord;

@protocol SCItemSource;

@protocol SCMutableItemRecordCache <NSObject>

// NSArray<ItemRecord>
-(void)cacheResponseItems:( NSArray* )items_
               forRequest:( SCReadItemsRequest * )request_
               apiSession:( SCExtendedApiSession* )apiSession_;


// SCItemRecord
-(void)didRemovedItemRecord:( SCItemRecord* )record_;

-(void)cleanupSource:( id<SCItemSource> )itemSource;
-(void)cleanupAll;

-(void)setRawValue:( NSString* )newRawValue
        forFieldId:( NSString* )fieldId
            itemId:( NSString* )itemId
        itemSource:( id<SCItemSource> )itemSource;

@end
