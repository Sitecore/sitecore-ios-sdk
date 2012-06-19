#import <JFFAsyncOperations/JFFAsyncOperationsBlockDefinitions.h>

#import <Foundation/Foundation.h>

@class CLRegion;

JFFAsyncOperation placemarksLoaderWithAddressDict( NSDictionary* addressDictionary_ );

JFFAsyncOperation placemarksLoaderWithAddress( NSString* address_ );
JFFAsyncOperation placemarksLoaderWithAddressAndRegion( NSString* address_, CLRegion* region_ );
