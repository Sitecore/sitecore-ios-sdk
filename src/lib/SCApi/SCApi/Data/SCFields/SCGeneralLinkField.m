#import "SCGeneralLinkField.h"

#import "SCItem.h"
#import "SCApiContext.h"
#import "SCError.h"
#import "SCFieldLinkData+XMLParser.h"

@interface SCFieldLinkData (SCGeneralLinkField)

@property(nonatomic) SCApiContext *apiContext;

@end

@interface SCGeneralLinkField ()

@property(nonatomic) SCFieldLinkData *linkData;

@end

@implementation SCGeneralLinkField

@synthesize linkData = _linkData;
@dynamic fieldValue;

-(SCFieldLinkData*)linkData
{
    if ( !_linkData )
    {
        NSData* data_ = [ self.rawValue dataUsingEncoding: NSUTF8StringEncoding ];
        _linkData = [ SCFieldLinkData fieldLinkDataWithXMLData: data_
                                                         error: nil ];
        if ( !_linkData )
            _linkData = [ SCFieldLinkData new ];

        _linkData.apiContext = self.apiContext;
    }
    return _linkData;
}

-(id)createFieldValue
{
    return self.linkData;
}

@end
