#import "SCReadItemsRequest+SCApiSession.h"

#import "SCItem.h"
#import "SCField.h"
#import "SCItemInfo.h"
#import "SCApiUtils.h"
#import "SCItemRecord.h"
#import "SCApiSession.h"
#import "SCItemsPage.h"

#import "SCApiAnalizers.h"

#import "SCItem+Private.h"

@interface SCField (SCReadItemsRequestCategory)

-(JFFAsyncOperation)fieldValueLoader;

@end

@interface SCApiSession (SCReadItemsRequestCategory)

@property ( nonatomic ) id<SCItemRecordCacheRW> itemsCache;

@end

@implementation SCReadItemsRequest (SCApiSession)

-(JFFAsyncOperation)asyncOpWithFieldsForAsyncOp:( JFFAsyncOperation )loader_
{
    BOOL isReadFieldsFlagSet = ( self.flags & SCReadItemRequestReadFieldsValues );
    if ( !isReadFieldsFlagSet )
    {
        return loader_;
    }

    JFFAsyncOperationBinder secondLoaderBinder_ = ^JFFAsyncOperation( SCItemsPage* page_ )
    {
        JFFAsyncOperation loader_ = [ page_.items tolerantFaultAsyncMap: ^JFFAsyncOperation( SCItem* item_ )
        {
            NSDictionary* readedFieldsByName_ = item_.readFieldsByName;
            NSSet* fieldsNames_ = [ [ NSSet alloc ] initWithArray: [ readedFieldsByName_ allKeys ] ];
            return fieldValuesLoadersForFieldsDict( fieldsNames_ )( readedFieldsByName_ );
        } ];
        return asyncOperationWithResultOrError( loader_, page_, nil );
    };

    return bindSequenceOfAsyncOperations( loader_, secondLoaderBinder_, nil );
}

-(JFFAsyncOperation)validatedLoader:( JFFAsyncOperation )loader_
{
    loader_ = [ loader_ copy ];

    if ( self.requestType == SCReadItemRequestItemId )
    {
        JFFAsyncOperationBinder binder_ = ^JFFAsyncOperation( NSArray* ids_ )
        {
            return loader_;
        };
        NSArray* ids_ = [ NSArray arrayWithObject: self.request ];
        loader_ = asyncOpWithValidIds( binder_, ids_ );
    }

    if ( self.requestType == SCReadItemRequestItemPath )
    {
        JFFAsyncOperationBinder binder_ = ^JFFAsyncOperation( NSString* newPath_ )
        {
            return loader_;
        };
        loader_ = asyncOpWithValidPath( binder_, self.request );
    }

    return loader_;
}

@end
