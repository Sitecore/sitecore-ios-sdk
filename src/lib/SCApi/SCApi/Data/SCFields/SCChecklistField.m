#import "SCChecklistField.h"

#import "SCExtendedApiSession.h"
#import "SCItemSourcePOD.h"

#define IS_CACHE_ALLOW_CYCLIC_RETAIN 1

@interface SCExtendedApiSession (SCChecklistField)

-(JFFAsyncOperation)itemLoaderForItemId:( NSString* )itemId_
                             itemSource:(id<SCItemSource>)itemSource;

@end

@interface SCField (SCFieldRecord)

@property ( nonatomic ) SCFieldRecord *fieldRecord;

@end

@implementation SCChecklistField
#if !IS_CACHE_ALLOW_CYCLIC_RETAIN
{
    __weak NSArray* _checklistFieldValue;
}

-(id)fieldValue
{
    return self->_checklistFieldValue;
}

-(void)setFieldValue:( id )fieldValue
{
    self->_checklistFieldValue = fieldValue;
}
#else

-(id)fieldValue
{
    return self.fieldRecord.fieldValue;
}

-(void)setFieldValue:( id )fieldValue
{
    self.fieldRecord.fieldValue = fieldValue;
}

#endif

-(JFFAsyncOperation)fieldValueLoader
{
    NSString* rawValue_ = self.rawValue;
    SCExtendedApiSession* apiSession_ = self.apiSession;
    return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                    , JFFCancelAsyncOperationHandler cancelCallback_
                                    , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        NSArray* itemsIds_ = [ rawValue_ componentsSeparatedByString: @"|" ];
        NSArray* itemsLoaders_ = [ itemsIds_ map: ^id( id itemId_ )
        {
            return [ apiSession_ itemLoaderForItemId: itemId_
                                          itemSource: self.itemSource ];
        } ];
        JFFAsyncOperation loader_ = failOnFirstErrorGroupOfAsyncOperationsArray( itemsLoaders_ );
        loader_ = [ self asyncOperationForPropertyWithName: @"fieldValue"
                                            asyncOperation: loader_ ];
        return loader_( progressCallback_, cancelCallback_, doneCallback_ );
    };
}

-(SCAsyncOp)readFieldValueOperation
{
    return [ super readFieldValueOperation ];
}

@end
