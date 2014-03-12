#import "SCItemRecord+Parser.h"

#import "SCFieldRecord+Parser.h"
#import "SCItemRecord+SCItemSource.h"

#import "SCItemSourcePOD.h"

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

+(JFFAsyncOperationBinder)itemRecordWithApiSession:( SCExtendedApiSession* )apiSession_
                                forRequestedSource:( id<SCItemSource> )requestedSource_
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

                
                // @adk : TODO : extract a parser
                SCItemSourcePOD* itemSource = [ SCItemSourcePOD new ];
                {
                    itemSource.database = json_[ @"Database" ];
                    itemSource.language    = json_[ @"Language" ];
                    itemSource.site        = [ requestedSource_ site ];
                    itemSource.itemVersion = [ json_[ @"Version" ] stringValue ];
                }
                result_.itemSource = itemSource;
                
                result_.fieldsByName = [ allFieldsByName_ fieldsByNameDictionary ];

                return result_;
            };

            //parse fields
            {
                NSDictionary* fields_ = json_[ @"Fields" ];
                fields_ = [ self convertFieldNamesToUppercase: fields_ ];
                JFFAsyncOperation loader_ = [ fields_ asyncMap: ^JFFAsyncOperation( id fieldId_, id json_ )
                {
                    id result_ = [ SCFieldRecord fieldRecordWithJson: json_
                                                             fieldId: fieldId_
                                                          apiSession: apiSession_ ];
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

+(NSDictionary *)convertFieldNamesToUppercase:(NSDictionary *)fields
{
    NSMutableDictionary *mutableFields = [ NSMutableDictionary dictionaryWithDictionary:fields ];
    NSArray *keys = [ mutableFields allKeys ];
    
    for ( NSString  *key in keys )
    {
        NSDictionary *elem = [ fields objectForKey: key ];
        NSMutableDictionary *mutableElem = [ NSMutableDictionary dictionaryWithDictionary: elem ];
        
        if ([mutableElem isKindOfClass:[NSDictionary class]])
        {
            NSString *nameParamValue = [ elem valueForKey:@"Name" ];
            
            NSLocale* posixLocale_ = [ [ NSLocale alloc ] initWithLocaleIdentifier: @"en_US_POSIX" ];
            NSString *upperNameParamValue = [ nameParamValue uppercaseStringWithLocale:posixLocale_ ];
            [ mutableElem setValue: upperNameParamValue
                            forKey: @"Name" ];
        }
        [ mutableFields setObject: mutableElem
                           forKey: key ];
    }
    
    return mutableFields;
}

@end
