#import "SCReadItemsRequest.h"

@class SCItemRecord;

@interface SCReadItemsRequest (AllFields)

-(BOOL)isAllFieldsRequested;
-(NSUInteger)indexOfFirstChildItemInResponse;

-(SCItemRecord*)getAnyChildItemRecordFromItems:( NSArray* )receivedItems;

@end
