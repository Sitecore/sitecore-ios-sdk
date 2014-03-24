#Classes
SDK 1.2 | SDK 2.0 |
--- | --- |
SCApiContext 							| SCApiSession 
SCCreateMediaItemRequest 		 		| SCUploadMediaItemRequest
SCHTMLReaderRequest 			 		| SCGetRenderingHtmlRequest
SCItemsReaderRequest 			 		| SCReadItemsRequest
SCFieldImageParams 				 		| SCDownloadMediaOptions

*all occurrences "context" string in params and methods replaced with "session"


#Methods & Properties
SDK 1.2 | SDK 2.0 |
--- | --- |
itemsReaderWithRequest			 		| readItemsOperationWithRequest
itemCreatorWithRequest			 		| createItemsOperationWithRequest
editItemsWithRequest             		| editItemsOperationWithRequest         
removeItemsWithRequest           		| deleteItemsOperationWithRequest       
renderingHTMLReaderWithRequest   		| getRenderingHtmlOperationWithRequest
mediaItemCreatorWithRequest      		| uploadMediaOperationWithRequest
credentialsCheckerForSite        		| checkCredentialsOperationForSite 
triggerLoaderForRequest          		| triggerOperationWithRequest
itemReaderForItemId				 		| readItemOperationForItemId
itemReaderForItemPath			 		| readItemOperationForItemPath
itemReaderWithFieldsNames		 		| readItemOperationForFieldsNames
itemReaderForItemPath 					| readItemOperationForPath:
itemReaderForItemId 					| readItemOperationForItemId
itemReaderWithFieldsNames				| readItemOperationForFieldsNames
childrenReaderWithItemId 				| readChildrenOperationForItemId
childrenReaderWithItemPath 				| readChildrenOperationForItemPath
systemLanguagesReader 					| readSystemLanguagesOperation
renderingHTMLLoaderForRenderingWithId 	| getRenderingHtmlOperationForRenderingWithId
imageLoaderForSCMediaPath 				| downloadResourceOperationForMediaPath
fieldValueReader 						| readFieldValueOperation
extendedFieldValueReader 				| readFieldValueExtendedOperation
imageReader 							| readImageOperation
extendedImageReader 					| readImageExtendedOperation
setImageReader 							| setReadImageOperation
fieldsValuesReader 						| readFieldsValuesOperation
extendedFieldsValuesReader 				| readFieldsValuesExtendedOperation
childrenReader							| readChildrenOperation
extendedChildrenReader					| readChildrenExtendedOperation
itemsTotalCountReader 					| readItemsTotalCountOperation
extendedItemsTotalCountReader 			| readItemsTotalCountExtendedOperation
itemReaderForIndex 						| readItemOperationForIndex
extendedItemReaderForIndex 				| readItemExtendedOperationForIndex
fieldsReaderForFieldsNames 				| readFieldsOperationForFieldsNames
saveItem 								| saveItemOperation
removeItem 								| removeItemOperation
itemReader 								| readItemOperation
extendedFieldsReaderForFieldsNames 		| readFieldsExtendedOperationForFieldsNames
extendedSaveItem  						| saveItemExtendedOperation
extendedRemoveItem  					| removeItemExtendedOperation
mediaLoaderWithOptions  				| downloadMediaExtendedOperationWithOptions
mainContext 							| mainSession


#Types
SDK 1.2 | SDK 2.0 |
--- | --- |
SCItemReaderParentScope 			| SCReadItemParentScope
SCItemReaderSelfScope 				| SCReadItemSelfScope
SCItemReaderChildrenScope 			| SCReadItemChildrenScope
SCItemReaderScopeType 				| SCReadItemScopeType
SCItemReaderRequestItemId 			| SCReadItemRequestItemId
SCItemReaderRequestItemPath 		| SCReadItemRequestItemPath
SCItemReaderRequestQuery 			| SCReadItemRequestQuery
SCItemReaderRequestType 			| SCReadItemRequestType
SCItemReaderRequestFlags 			| SCReadItemRequestFlags
SCItemReaderRequestIngnoreCache 	| SCReadItemRequestIngnoreCache
SCItemReaderRequestReadFieldsValues | SCReadItemRequestReadFieldsValues



