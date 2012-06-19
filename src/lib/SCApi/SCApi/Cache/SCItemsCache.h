#import <Foundation/Foundation.h>

@class SCItemInfo;
@class SCItemRecord;
@class SCApiContext;
@class SCFieldRecord;
@class SCItemsReaderRequest;
@class JFFMutableAssignArray;
@class JFFMutableAssignDictionary;

@interface SCItemsCache : NSObject

@property ( nonatomic, readonly ) NSMutableDictionary* itemRecordsById;
@property ( nonatomic, readonly ) NSMutableDictionary* fieldsByItemIdAndLanguage;

-(SCItemRecord*)itemRecordWithItemInfo:( SCItemInfo* )itemInfo_;

-(JFFMutableAssignArray*)itemRecordsWithItemId:( NSString* )itemId_;

-(SCFieldRecord*)fieldWithName:( NSString* )fieldName_
                        itemId:( NSString* )itemId_
                      language:( NSString* )language_;

-(JFFMutableAssignDictionary*)readFieldsByNameForItemId:( NSString* )itemId_
                                               language:( NSString* )language_;

-(NSArray*)allChildrenForItemWithItemInfo:( SCItemInfo* )info_;

-(NSArray*)cachedChildrenForItemWithId:( NSString* )itemId_
                              language:( NSString* )language_;
-(NSArray*)cachedChildrenForItemWithPath:( NSString* )itemPath_
                                language:( NSString* )language_;

-(void)cacheResponseItems:( NSArray* )items_
               forRequest:( SCItemsReaderRequest* )request_
               apiContext:( SCApiContext* )apiContext_;

-(void)didRemovedItemRecord:( SCItemRecord* )record_;

@end
