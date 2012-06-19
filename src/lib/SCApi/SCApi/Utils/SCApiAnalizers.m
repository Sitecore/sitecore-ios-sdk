#import "SCApiAnalizers.h"

#import "SCItemRecord.h"
#import "SCField.h"
#import "SCItemRecordsPage.h"

@interface SCField (SCItem)

-(JFFAsyncOperation)fieldValueLoader;

@end

JFFAsyncOperationBinder itemRecordsPageToLanguageSet()
{
    JFFAnalyzer analyzer_ = ^id( SCItemRecordsPage* page_, NSError **error_ )
    {
        NSArray* items_ = [ page_.itemRecords select: ^BOOL( SCItemRecord* item_ )
        {
            return [ item_.itemTemplate isEqualToString: @"System/Language" ];
        } ];
        NSArray* names_ = [ items_ map: ^id( SCItemRecord* item_ )
        {
            return item_.displayName;
        } ];
        return [ [ NSSet alloc ] initWithArray: names_ ];
    };
    return asyncOperationBinderWithAnalyzer( analyzer_ );
}

JFFAsyncOperationBinder fieldValuesLoadersForFieldsDict( NSSet* fieldsNames_ )
{
    return ^JFFAsyncOperation( NSDictionary* fieldsByName_ )
    {
        NSArray* fieldsNamesArr_ = [ fieldsNames_ allObjects ];

        fieldsNamesArr_ = [ fieldsNamesArr_ select: ^BOOL( NSString* fieldName_ )
        {
            SCField* field_ = [ fieldsByName_ objectForKey: fieldName_ ];
            return [ field_ fieldValueLoader ] != nil;
        } ];

        return [ fieldsNamesArr_ tolerantFaultAsyncMap: ^JFFAsyncOperation( NSString* fieldName_ )
        {
            SCField* field_ = [ fieldsByName_ objectForKey: fieldName_ ];
            return [ field_ fieldValueLoader ];
        } ];
    };
}

JFFAsyncOperationBinder fieldsByNameToFieldsValuesByName( NSSet* fieldsNames_
                                                         , NSDictionary*(^fieldsGetter_)(void) )
{
    JFFAsyncOperationBinder readValuesBinder_ = fieldValuesLoadersForFieldsDict( fieldsNames_ );

    JFFAsyncOperationBinder changeResultBinder_ = asyncOperationBinderWithAnalyzer(^id(id result_, NSError** error_)
    {
        NSDictionary* fieldValuesByName_ = [ fieldsGetter_() map: ^id( id key_, SCField* field_ )
        {
            return field_.fieldValue;
        } ];
       return fieldValuesByName_ ?: [ NSDictionary new ];
    } );

    return binderAsSequenceOfBinders( readValuesBinder_, changeResultBinder_, nil );
}
