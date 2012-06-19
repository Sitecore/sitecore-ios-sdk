#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

JFFAsyncOperationBinder itemRecordsPageToLanguageSet( void );

JFFAsyncOperationBinder fieldValuesLoadersForFieldsDict( NSSet* fieldsNames_ );

JFFAsyncOperationBinder fieldsByNameToFieldsValuesByName( NSSet* fieldsNames_
                                                         , NSDictionary*(^fieldgetter_)(void) );
