#import "SCEmailFields.h"

//STODO remove
@interface NSArray (ArrayWithEmailOnly_JDWTwitterPlugin)

-(id)scSelectWithEmailOnly;
-(id)scSelectNotEmptyStrings;

@end

@interface SCEmailFields ()

@property ( nonatomic ) NSArray*  toRecipients;
@property ( nonatomic ) NSArray*  ccRecipients;
@property ( nonatomic ) NSArray*  bccRecipients;
@property ( nonatomic ) NSString* subject;
@property ( nonatomic ) NSString* body;
@property ( nonatomic ) BOOL      isHTML;

@end

@implementation SCEmailFields

+(id)emailFieldsWithComponents:( NSDictionary* )components_
{
    SCEmailFields* result_ = [ self new ];

    result_.toRecipients   = [ components_[ @"to"  ] scSelectWithEmailOnly ];
    result_.ccRecipients   = [ components_[ @"cc"  ] scSelectWithEmailOnly ];
    result_.bccRecipients  = [ components_[ @"bcc" ] scSelectWithEmailOnly ];
    result_.subject        = [ components_ firstValueIfExsistsForKey: @"subject" ];
    result_.body           = [ components_ firstValueIfExsistsForKey: @"body" ];
    result_.isHTML         = [ [ components_ firstValueIfExsistsForKey: @"isHTML" ] boolValue ];

    return result_;
}

@end
