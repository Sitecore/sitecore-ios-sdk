#import "SCAddressBook.h"

#import "SCContactPluginError.h"

@implementation SCAddressBook
{
    ABAddressBookRef _rawBook;
}

@synthesize rawBook = _rawBook;

-(void)dealloc
{
    [ self releaseBook ];
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

-(BOOL)removeAllContactsWithError:( NSError** )error_
{
    ABAddressBookRef rawBook_ = self.rawBook;
    if ( NULL == rawBook_ )
    {
        NSString* msg = @"Plug-in not initialized properly : no address book found";
        SCContactPluginError* noBookError =
        [ [ SCContactPluginError alloc ] initWithDescription: msg
                                                        code: 1];
        
        [ noBookError setToPointer: error_ ];
    }
    
    CFErrorRef rawError_ = NULL;
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( rawBook_ );
    {
        NSArray* contacts_ = (__bridge NSArray*)allPeople;
        
        for ( id record_ in contacts_ )
        {
            ABRecordRef rawRecord_ = (__bridge ABRecordRef)record_;
            ABAddressBookRemoveRecord( rawBook_, rawRecord_, &rawError_ );
            if ( NULL != rawError_ )
            {
                // TODO : add scoped guard
                // @adk
                CFRelease( allPeople );
                [ (__bridge NSError*)rawError_ setToPointer: error_ ];
                return NO;
            }
        }
    }
    CFRelease( allPeople );

    ABAddressBookSave( rawBook_, &rawError_ );
    if ( NULL != rawError_ )
    {
        [ (__bridge NSError*)rawError_ setToPointer: error_ ];
        return NO;
    }

    return YES;
}

-(void)releaseBook
{
    if ( NULL != self->_rawBook )
    {
        CFRelease( self->_rawBook );
        self->_rawBook = NULL;
    }
}

@end
