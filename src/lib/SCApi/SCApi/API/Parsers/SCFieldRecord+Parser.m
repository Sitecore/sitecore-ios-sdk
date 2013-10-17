#import "SCFieldRecord+Parser.h"

@implementation SCFieldRecord (Parser)

+(id)fieldRecordWithJson:( NSDictionary* )json_
                 fieldId:( NSString* )fieldId_
              apiContext:( SCExtendedApiContext* )apiContext_
{
    SCFieldRecord* result_ = [ self new ];

    result_.fieldId    = fieldId_;
    result_.name       = json_[ @"Name" ];
    result_.type       = json_[ @"Type" ];
    result_.rawValue   = [ json_[ @"Value" ] stringByTrimmingWhitespaces ];
    result_.apiContext = apiContext_;

    return result_;
}

@end
