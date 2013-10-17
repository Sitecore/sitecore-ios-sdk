#import <Foundation/Foundation.h>

@class SCItemRecord;

@interface SCItemRecordComparator : NSObject

+(BOOL)metadataOfItemRecord:( SCItemRecord* )first
                  isEqualTo:( SCItemRecord* )second;

+(BOOL)sourceOfItemRecord:( SCItemRecord* )first
                isEqualTo:( SCItemRecord* )second;

@end
