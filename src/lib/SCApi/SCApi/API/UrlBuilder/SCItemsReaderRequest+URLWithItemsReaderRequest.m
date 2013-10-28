#import "SCItemsReaderRequest+URLWithItemsReaderRequest.h"

#import "SCRestArgsBuilder.h"


@implementation SCItemsReaderRequest (URLWithItemsReaderRequest)

-(NSString*)pathURLParam
{
    BOOL isPathRequest = ( self.requestType == SCItemReaderRequestItemPath );
    BOOL isRequestExist = ( nil != self.request );
    
    NSString* result = @"";
    
    if ( isPathRequest && isRequestExist )
    {
        result = [ self.request stringByEncodingURLFormat ];
    }
    
    return result;
}

-(NSString*)itemIdURLParam
{
    NSString* request_ = [ ( self.request ?: @"" ) stringByEncodingURLFormat ];
    return ( self.requestType == SCItemReaderRequestItemId )
    ? [ [ NSString alloc ] initWithFormat: @"sc_itemid=%@", request_ ]
    : @"";
}

-(NSString*)scopeURLParam
{
    if ( self.requestType == SCItemReaderRequestQuery )
        return @"";
    
    NSArray* scopes_ = @[ @"p"
                          , @"s"
                          , @"c" ];
    
    scopes_ = [ scopes_ selectWithIndex: ^BOOL( id object_, NSUInteger index_ )
               {
                   NSUInteger paw_ = (NSUInteger)lroundf( powf( 2, index_ ) );
                   return ( self.scope & paw_ );
               } ];
    
    NSString* result_ = [ scopes_ componentsJoinedByString: @"|" ];
    result_ = [ result_ stringByEncodingURLFormat ];
    return [ [ NSString alloc ] initWithFormat: @"scope=%@", result_ ];
}

-(NSString*)queryURLParam
{
    if ( self.requestType != SCItemReaderRequestQuery )
        return @"";
    
    NSString* request_ = [ self.request ?: @"" stringByEncodingURLFormat ];
    return [ [ NSString alloc ] initWithFormat: @"query=%@", request_ ];
}

-(NSString*)fieldsURLParam
{
    return [ SCRestArgsBuilder fieldsURLParam: self.fieldNames ];
}

-(NSString*)pagesURLParam
{
    return self.pageSize == 0
    ? @""
    : [ [ NSString alloc ] initWithFormat: @"pageSize=%lu&page=%lu", (unsigned long)self.pageSize, (unsigned long)self.page ];
}

-(NSString*)itemVersionURLParam
{
    if ( nil == self.itemVersion )
    {
        return @"";
    }
    
    NSString* result = [ NSString stringWithFormat: @"sc_itemversion=%@", self.itemVersion ];
    return result;
}

@end

