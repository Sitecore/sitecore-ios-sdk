#import "SCFieldRecord+Parser.h"

@implementation SCFieldRecord (Parser)

+(instancetype)fieldRecordWithJson:( NSDictionary* )json_
                           fieldId:( NSString* )fieldId_
                        apiSession:( SCExtendedApiSession* )apiSession_
{
    SCFieldRecord* result_ = [ self new ];

    result_.fieldId    = fieldId_;
    result_.name       = json_[ @"Name" ];
    result_.type       = json_[ @"Type" ];
    result_.rawValue   = [ json_[ @"Value" ] stringByTrimmingWhitespaces ];
    result_.apiSession = apiSession_;

    return result_;
}

@end
