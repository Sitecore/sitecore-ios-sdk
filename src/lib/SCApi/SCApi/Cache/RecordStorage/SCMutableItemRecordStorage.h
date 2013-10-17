#import <Foundation/Foundation.h>

@class SCItemRecord;

@protocol SCMutableItemRecordStorage <NSObject>

-(void)registerItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
             forKey:( NSString* )key;

-(void)unregisterItemForKey:( NSString* )key;

-(void)cleanup;

-(void)setRawValue:( NSString* )newRawValue
        forFieldId:( NSString* )fieldId
            itemId:( NSString* )itemId;

@end
