#import "SCDroplinkField.h"

#import "SCError.h"
#import "SCExtendedApiContext.h"
#import "SCItemSourcePOD.h"

@implementation SCDroplinkField

-(id)fieldValue
{
    return [ self.apiContext itemWithId: self.rawValue
                             itemSource: self.itemSource ];
}

-(void)setFieldValue:( id )fieldValue_
{
}

-(JFFAsyncOperation)fieldValueLoader
{
    JFFAsyncOperation loader_ = [ self.apiContext itemReaderWithFieldsNames: [ NSSet new ]
                                                                     itemId: self.rawValue
                                                                 itemSource: self.itemSource ];
    return [ self asyncOperationForPropertyWithName: @"fieldValue"
                                     asyncOperation: loader_ ];
}

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
