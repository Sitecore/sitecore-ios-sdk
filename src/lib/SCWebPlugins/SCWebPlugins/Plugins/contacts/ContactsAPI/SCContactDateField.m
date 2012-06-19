#import "SCContactDateField.h"

@implementation SCContactDateField

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    CFStringRef value_ = ABRecordCopyValue( record_, self.propertyID );
    self.value = ( __bridge_transfer NSDate* )value_;
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
    NSString* value_ = [ components_ firstValueIfExsistsForKey: self.name ];
    NSTimeInterval timeInterval_ = [ value_ longLongValue ] / 1000.;
    self.value = timeInterval_ == 0. ? nil : [ NSDate dateWithTimeIntervalSince1970: timeInterval_ ];
    NSTimeZone* gmtTimezone_ = [ NSTimeZone timeZoneWithName: @"GMT" ];
    self.value = [ self.value dateByAdjustingToLocalTimeZoneFromTimeZone: gmtTimezone_ ];

    CFErrorRef error_ = NULL;
    bool didSet = ABRecordSetValue( record_
                                   , self.propertyID
                                   , (__bridge CFTypeRef)self.value
                                   , &error_);
    if (!didSet) { NSLog( @"can not set %@", self.name ); }
}

-(NSString*)jsonValue
{
    NSDate* jsDate_;
    if ( self.value )
    {
        NSTimeZone* gmtTimezone_ = [ NSTimeZone timeZoneWithName: @"GMT" ];
        jsDate_ = [ self.value dateByAdjustingFromLocalTimeZoneToTimeZone: gmtTimezone_ ];
    }
    return jsDate_
        ? [ NSString stringWithFormat: @"%f", [ jsDate_ timeIntervalSince1970 ] * 1000. ]
        : @"";
}

@end
