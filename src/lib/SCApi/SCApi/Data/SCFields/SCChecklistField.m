#import "SCChecklistField.h"

#import "SCApiContext.h"

@interface SCApiContext (SCChecklistField)

-(JFFAsyncOperation)itemLoaderForItemId:( NSString* )itemId_;

@end

@implementation SCChecklistField
{
    __weak NSArray* _checklistFieldValue;
}

-(id)fieldValue
{
    return self->_checklistFieldValue;
}

-(void)setFieldValue:( id )fieldValue_
{
    self->_checklistFieldValue = fieldValue_;
}

-(JFFAsyncOperation)fieldValueLoader
{
    NSString* rawValue_ = self.rawValue;
    SCApiContext* apiContext_ = self.apiContext;
    return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                    , JFFCancelAsyncOperationHandler cancelCallback_
                                    , JFFDidFinishAsyncOperationHandler doneCallback_ )
    {
        NSArray* itemsIds_ = [ rawValue_ componentsSeparatedByString: @"|" ];
        NSArray* itemsLoaders_ = [ itemsIds_ map: ^id( id itemId_ )
        {
            return [ apiContext_ itemLoaderForItemId: itemId_ ];
        } ];
        JFFAsyncOperation loader_ = failOnFirstErrorGroupOfAsyncOperationsArray( itemsLoaders_ );
        loader_ = [ self asyncOperationForPropertyWithName: @"fieldValue"
                                            asyncOperation: loader_ ];
        return loader_( progressCallback_, cancelCallback_, doneCallback_ );
    };
}

-(SCAsyncOp)fieldValueReader
{
    return [ super fieldValueReader ];
}

@end
