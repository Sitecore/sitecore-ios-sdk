#import "SCContactStringField.h"
#import "GTMNSString+HTML.h"

@implementation SCContactStringField

-(void)readPropertyFromRecord:( ABRecordRef )record_
{
    CFStringRef value_ = ABRecordCopyValue( record_, self.propertyID );
    self.value = ( __bridge_transfer NSString* )value_;
}

-(void)setPropertyFromValues:( NSDictionary* )components_
                    toRecord:( ABRecordRef )record_
{
    NSString *rawValue = [ components_ firstValueIfExsistsForKey: self.name ];
    self.value = [ rawValue gtm_stringByUnescapingFromHTML ];

    CFErrorRef error_ = NULL;
    bool didSet = ABRecordSetValue( record_
                                   , self.propertyID
                                   , (__bridge CFTypeRef)self.value
                                   , &error_);
    if (!didSet) { NSLog( @"can not set %@", self.name ); }
}

-(NSString*)jsonValue
{
    return self.value ? self.value : @"";
}

@end
