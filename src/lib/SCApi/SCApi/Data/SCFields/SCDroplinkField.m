#import "SCDroplinkField.h"

#import "SCError.h"
#import "SCApiContext.h"

@interface SCApiContext (SCDroplinkField)

-(JFFAsyncOperation)itemLoaderWithFieldsNames:( NSSet* )fieldNames
                                       itemId:( NSString* )itemId;

@end

@implementation SCDroplinkField

-(id)fieldValue
{
    return [ self.apiContext itemWithId: self.rawValue ];
}

-(void)setFieldValue:( id )fieldValue_
{
}

-(JFFAsyncOperation)fieldValueLoader
{
    JFFAsyncOperation loader_ = [ self.apiContext itemLoaderWithFieldsNames: [ NSSet new ]
                                                                     itemId: self.rawValue ];
    return [ self asyncOperationForPropertyWithName: @"fieldValue"
                                     asyncOperation: loader_ ];
}

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
