#import <SCApi/Data/SCFieldRecord.h>

@class SCExtendedApiSession;

@interface SCFieldRecord (Parser)

+(id)fieldRecordWithJson:( NSDictionary* )json_
                 fieldId:( NSString* )fieldId_
              apiSession:( SCExtendedApiSession* )apiSession_;

@end
