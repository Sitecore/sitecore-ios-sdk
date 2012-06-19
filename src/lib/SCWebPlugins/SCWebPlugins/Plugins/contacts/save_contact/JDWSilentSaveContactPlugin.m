
#import "SCWebPlugin.h"

#import "SCContact.h"

#import <AddressBook/AddressBook.h>

@interface JDWSilentSaveContactPlugin : NSObject < SCWebPlugin >
@end

@implementation JDWSilentSaveContactPlugin
{
    NSURLRequest* _request;
}

@synthesize delegate;

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    _request = request_;

    return self;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/contacts/silent_save_contact" ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* args_ = [ _request.URL queryComponents ];
    SCContact* arg_ = [ [ SCContact alloc ] initWithArguments: args_ ];

    [ arg_ save ];

    [ self.delegate sendMessage: [ NSString stringWithFormat: @"%d", arg_.contactInternalId ] ];
    [ self.delegate close ];
}

@end
