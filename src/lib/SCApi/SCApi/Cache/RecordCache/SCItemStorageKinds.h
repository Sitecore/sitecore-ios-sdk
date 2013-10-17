#import <Foundation/Foundation.h>

@protocol SCItemRecordStorageRW;


@interface SCItemStorageKinds : NSObject

@property ( nonatomic ) id<SCItemRecordStorageRW> itemRecordById;
@property ( nonatomic ) id<SCItemRecordStorageRW> itemRecordByPath;

@end
