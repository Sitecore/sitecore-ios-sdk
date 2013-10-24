#import "SCGeneralLinkField.h"

#import "SCItem.h"
#import "SCApiContext.h"
#import "SCError.h"
#import "SCFieldLinkData+XMLParser.h"

@interface SCFieldLinkData (SCGeneralLinkField)

@property ( nonatomic ) SCExtendedApiContext *apiContext;

@end

@interface SCGeneralLinkField ()

@property ( nonatomic ) SCFieldLinkData *linkData;

@end

@implementation SCGeneralLinkField

@dynamic fieldValue;

-(SCFieldLinkData*)linkData
{
    if ( !self->_linkData )
    {
        NSData* data_ = [ self.rawValue dataUsingEncoding: NSUTF8StringEncoding ];
        self->_linkData = [ SCFieldLinkData fieldLinkDataWithXMLData: data_
                                                         error: nil ];
        if ( !self->_linkData )
        {
            self->_linkData = [ SCFieldLinkData new ];
        }

        self->_linkData.apiContext = self.apiContext;
    }
    return self->_linkData;
}

-(id)createFieldValue
{
    return self.linkData;
}

@end
