#ifndef SCApi_SCRecordStorageBase_OOP_Protected_h
#define SCApi_SCRecordStorageBase_OOP_Protected_h

#import "SCRecordStorageBase.h"

@class NSString;
@class SCItemRecord;

@interface SCRecordStorageBase(OOP_Protected)

-(NSString*)normalizeItemKey:( NSString* )itemKey;

-(void)registerItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
             forKey:( NSString* )itemKey;

-(void)mergeEntity:( SCItemAndFields* )entity
           forItem:( SCItemRecord* )item
withAllFieldsInCache:( BOOL )isAllFieldsCached
withAllChildrenInCache:( BOOL )isAllChildrenCached
           withKey:( NSString* )itemKey;

@end

#endif
