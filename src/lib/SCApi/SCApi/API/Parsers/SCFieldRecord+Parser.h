#import <SCApi/Data/SCFieldRecord.h>

@class SCExtendedApiContext;

@interface SCFieldRecord (Parser)

+(id)fieldRecordWithJson:( NSDictionary* )json_
                 fieldId:( NSString* )fieldId_
              apiContext:( SCExtendedApiContext* )apiContext_;

@end
