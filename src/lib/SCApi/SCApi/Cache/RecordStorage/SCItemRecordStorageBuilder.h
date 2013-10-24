#import <Foundation/Foundation.h>

@class SCItemStorageKinds;
@class SCItemSourcePOD;

@protocol SCItemRecordStorageBuilder <NSObject>

-(SCItemStorageKinds*)newRecordStorageNodeForItemSource:( SCItemSourcePOD* )itemSource;

@end
