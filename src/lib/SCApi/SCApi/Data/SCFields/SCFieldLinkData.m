#import "SCFieldLinkData.h"

#import "SCApiContext.h"

@interface SCApiContext (SCGeneralLinkField)

-(JFFAsyncOperation)itemLoaderWithFieldsNames:( NSSet* )fieldNames
                                       itemId:( NSString* )itemId;

@end

@interface SCFieldLinkData ()

@property ( nonatomic ) SCApiContext* apiContext;
@property ( nonatomic ) NSString* linkDescription;
@property ( nonatomic ) NSString* linkType;
@property ( nonatomic ) NSString* alternateText;
@property ( nonatomic ) NSString* url;

@end

@implementation SCFieldLinkData

-(NSString*)otherFieldsDescription
{
    return @"";
}

-(NSString*)description
{
    NSString* otherFields_ = [ self otherFieldsDescription ];
    return [ [ NSString alloc ] initWithFormat: @"<%@ linkDescription:\"%@\" linkType:\"%@\" alternateText:\"%@\" url:\"%@\" %@ >"
            , [ self class ]
            , self.linkDescription
            , self.linkType
            , self.alternateText
            , self.url
            , otherFields_ ];
}

@end

@interface SCInternalFieldLinkData ()

@property ( nonatomic ) NSString* anchor;
@property ( nonatomic ) NSString* queryString;
@property ( nonatomic ) NSString* itemId;

-(SCAsyncOp)itemReader;

@end


@implementation SCInternalFieldLinkData

-(SCAsyncOp)itemReader
{
    return asyncOpWithJAsyncOp( [ self.apiContext itemLoaderWithFieldsNames: [ NSSet new ]
                                                                     itemId: self.itemId ] );
}

-(NSString*)otherFieldsDescription
{
    return [ [ NSString alloc ] initWithFormat: @"anchor:\"%@\" queryString:\"%@\" itemId:\"%@\""
            , self.anchor
            , self.queryString
            , self.itemId ];
}

@end

@interface SCMediaFieldLinkData ()

@property ( nonatomic ) NSString* itemId;

@end

@implementation SCMediaFieldLinkData

@synthesize itemId;

-(SCAsyncOp)imageReader
{
    return [ self.apiContext imageLoaderForSCMediaPath: self.url ];
}

-(NSString*)otherFieldsDescription
{
    return [ [ NSString alloc ] initWithFormat: @"itemId:\"%@\""
            , self.itemId ];
}

@end

@implementation SCExternalFieldLinkData
@end

@interface SCAnchorFieldLinkData ()

@property ( nonatomic ) NSString *anchor;

@end

@implementation SCAnchorFieldLinkData

@synthesize anchor;

-(NSString*)otherFieldsDescription
{
    return [ [ NSString alloc ] initWithFormat: @"anchor:\"%@\""
            , self.anchor ];
}

@end

@implementation SCEmailFieldLinkData
@end

@implementation SCJavascriptFieldLinkData
@end
