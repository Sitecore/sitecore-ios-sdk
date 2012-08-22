#import "SCItemRecord+Parser.h"

#import "SCFieldRecord+Parser.h"

@implementation NSDictionary (SCItemRecord_Parser)

-(NSDictionary*)fieldsByNameDictionary
{
    return [ self mapKey: ^( id key_, SCFieldRecord* fieldRecord_ )
    {
        return fieldRecord_.name;
    } ];
}

@end

@implementation SCItemRecord (Parser)

+(JFFAsyncOperationBinder)itemRecordWithApiContext:( SCApiContext* )apiContext_
{
    return ^JFFAsyncOperation( id json_ )
    {
        return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                        , JFFCancelAsyncOperationHandler cancelCallback_
                                        , JFFDidFinishAsyncOperationHandler doneCallback_ )
        {
            JFFChangedResultBuilder resultBuilder_ = ^id( NSDictionary* allFieldsByName_ )
            {
                SCItemRecord* result_ = [ self new ];

                result_.displayName  = json_[ @"DisplayName" ];
                result_.path         = [ json_[ @"Path" ] lowercaseString ];
                result_.hasChildren  = [ json_[ @"HasChildren" ] boolValue ];
                result_.itemId       = json_[ @"ID"       ];
                result_.itemTemplate = json_[ @"Template" ];
                result_.longID       = json_[ @"LongID"   ];
                result_.language     = json_[ @"Language" ];

                result_.fieldsByName = [ allFieldsByName_ fieldsByNameDictionary ];

                return result_;
            };

            //parse fields
            {
                NSDictionary* fields_ = json_[ @"Fields" ];
                JFFAsyncOperation loader_ = [ fields_ asyncMap: ^JFFAsyncOperation( id fieldId_, id json_ )
                {
                    id result_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                             fieldId: fieldId_
                                                          apiContext: apiContext_ ];
                    return asyncOperationWithResult( result_ );
                } ];
                loader_ = asyncOperationWithChangedResult( loader_, resultBuilder_ );
                return loader_( progressCallback_, cancelCallback_, doneCallback_ );
            }

            if ( doneCallback_ )
                doneCallback_( resultBuilder_( nil ), nil );
            return JFFStubCancelAsyncOperationBlock;
        };
    };
}

@end
