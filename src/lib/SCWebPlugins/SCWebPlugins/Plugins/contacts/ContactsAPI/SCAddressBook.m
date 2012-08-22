#import "SCAddressBook.h"

@implementation SCAddressBook
{
    ABAddressBookRef _rawBook;
}

@synthesize rawBook = _rawBook;

-(void)dealloc
{
    CFRelease( self->_rawBook );
}

-(id)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(id)initWithRawBook:( ABAddressBookRef )rawBook_
{
    NSParameterAssert( NULL != rawBook_ );

    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_rawBook = rawBook_;
    
    return self;
}

@end
