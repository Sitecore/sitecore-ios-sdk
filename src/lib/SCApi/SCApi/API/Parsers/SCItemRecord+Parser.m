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

                result_.displayName  = [ json_ objectForKey: @"DisplayName" ];
                result_.path         = [ [ json_ objectForKey: @"Path" ] lowercaseString ];
                result_.hasChildren  = [ [ json_ objectForKey: @"HasChildren" ] boolValue ];
                result_.itemId       = [ json_ objectForKey: @"ID" ];
                result_.itemTemplate = [ json_ objectForKey: @"Template" ];
                result_.longID       = [ json_ objectForKey: @"LongID" ];
                result_.language     = [ json_ objectForKey: @"Language" ];

                result_.fieldsByName = [ allFieldsByName_ fieldsByNameDictionary ];

                return result_;
            };

            //parse fields
            {
                NSDictionary* fields_ = [ json_ objectForKey: @"Fields" ];
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
