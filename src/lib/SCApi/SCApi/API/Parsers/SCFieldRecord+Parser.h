#import <SCApi/Data/SCFieldRecord.h>

@class SCApiContext;

@interface SCFieldRecord (Parser)

+(id)fieldRecordWithJson:( NSDictionary* )json_
                 fieldId:( NSString* )fieldId_
              apiContext:( SCApiContext* )apiContext_;

@end
