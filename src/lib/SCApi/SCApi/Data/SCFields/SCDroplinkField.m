#import "SCDroplinkField.h"

#import "SCError.h"
#import "SCExtendedApiSession.h"
#import "SCItemSourcePOD.h"

@implementation SCDroplinkField

-(id)fieldValue
{
    return [ self.apiSession itemWithId: self.rawValue
                             itemSource: self.itemSource ];
}

-(void)setFieldValue:( id )fieldValue_
{
}

-(JFFAsyncOperation)fieldValueLoader
{
    JFFAsyncOperation loader_ = [ self.apiSession readItemOperationForFieldsNames: [ NSSet new ]
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
