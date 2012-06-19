#import "SCFieldRecord+Parser.h"

@implementation SCFieldRecord (Parser)

+(id)fieldRecordWithJson:( NSDictionary* )json_
                 fieldId:( NSString* )fieldId_
              apiContext:( SCApiContext* )apiContext_
{
    SCFieldRecord* result_ = [ self new ];

    result_.fieldId    = fieldId_;
    result_.name       = [ json_ objectForKey: @"Name" ];
    result_.type       = [ json_ objectForKey: @"Type" ];
    result_.rawValue   = [ [ json_ objectForKey: @"Value" ] stringByTrimmingWhitespaces ];
    result_.apiContext = apiContext_;

    return result_;
}

@end
