#import "SCItemsReaderRequest.h"

@class SCItemRecord;

@interface SCItemsReaderRequest (AllFields)

-(BOOL)isAllFieldsRequested;
-(NSUInteger)indexOfFirstChildItemInResponse;

-(SCItemRecord*)getAnyChildItemRecordFromItems:( NSArray* )receivedItems;

@end
