#import "SCApiUtils.h"

#import "SCError.h"
#import "SCItemRecord.h"
#import "SCItemsPage.h"
#import "SCItemRecordsPage.h"
#import "SCItemsReaderRequest.h"
#import "SCCreateMediaItemRequest.h"

#import "SCWebApiParsers.h"

#import "SCItemRecordsPage+JsonParser.h"

#import "NSString+IsSitecoreItemID.h"
#import "NSString+IsSCPathValid.h"

#import "SCSitecoreCredentials.h"
#import "SCRemoteApi.h"

@interface SCError (SCRemoteApi)

+(id)errorWithDescription:( NSString* )description_;

@end

@interface SCInvalidItemIdError (SCApiUtils)

+(id)errorWithItemId:( NSString* )itemId_;

@end

JFFAsyncOperation firstItemFromArrayReader( JFFAsyncOperation loader_ )
{
    JFFAnalyzer analyzer_ = ^id( NSArray* items_, NSError** error_ )
    {
        SCItem* item_ = [ items_ count ] > 0 ? items_[ 0 ] : nil;

        if ( !item_ && error_ )
            *error_ = [ SCNoItemError new ];

        return item_;
    };
    JFFAsyncOperationBinder binder_ = asyncOperationBinderWithAnalyzer( analyzer_ );
    return bindSequenceOfAsyncOperations( loader_, binder_, nil );
}

static JFFAsyncOperation asyncOpForItemPath( NSString* path_ )
{
    if ( ![ path_ isSCPathValid ] )
        return asyncOperationWithError( [ SCInvalidPathError new ] );

    return asyncOperationWithResult( path_ );
}

JFFAsyncOperation asyncOpWithValidPath( JFFAsyncOperationBinder binder_
                                       , NSString* path_ )
{
    JFFAsyncOperation loader_ = asyncOpForItemPath( path_ );
    return bindSequenceOfAsyncOperations( loader_, binder_, nil );
}

static JFFAsyncOperation asyncOpForItemIds( NSArray* ids_ )
{
    NSString* invalidItemId_ = [ ids_ firstMatch: ^BOOL( NSString* itemId_ )
    {
        return ![ itemId_ isSitecoreItemID ];
    } ];
    if ( invalidItemId_ )
    {
        NSError* error_ = [ SCInvalidItemIdError errorWithItemId: invalidItemId_ ];
        return asyncOperationWithError( error_ );
    }

    return asyncOperationWithResult( ids_ );
}

JFFAsyncOperation asyncOpWithValidIds( JFFAsyncOperationBinder binder_, NSArray* ids_ )
{
    JFFAsyncOperation loader_ = asyncOpForItemIds( ids_ );
    return bindSequenceOfAsyncOperations( loader_, binder_, nil );
}

JFFAsyncOperation itemRecordsPageToItemsPage( JFFAsyncOperation asyncOp_ )
{
    JFFAsyncOperationBinder secondLoaderBinder_ = ^JFFAsyncOperation( SCItemRecordsPage* itemRecordsPage_ )
    {
        SCItemsPage* page_ = [ SCItemsPage new ];
        page_.totalCount = itemRecordsPage_.totalCount;
        page_.items = [ itemRecordsPage_.itemRecords map: ^id( SCItemRecord* record_ )
        {
            return record_.item;
        } ];
        return asyncOperationWithResult( page_ );
    };

    return bindSequenceOfAsyncOperations( asyncOp_, secondLoaderBinder_, nil );
}

JFFAsyncOperation itemPageToItems( JFFAsyncOperation loader_ )
{
    return asyncOperationWithChangedResult( loader_, ^id( id result_ )
    {
        SCItemsPage* page_ = result_;
        return page_.items;
    } );
}

JFFAsyncOperation scDataURLResponseLoader( NSURL* url_
                                          , SCSitecoreCredentials* credentials_
                                          , NSData* httpBody_
                                          , NSString* httpMethod_
                                          , NSDictionary* headers_ )
{
    headers_ = headers_ ?: @{};
    if ( [ credentials_.login length ] != 0 )
    {
//        NSString* encryptedPassword_ = credentials_.encryptedPassword;

        NSDictionary* authHeaders_ = @{
        @"X-Scitemwebapi-Username" : credentials_.login,
//        @"X-Scitemwebapi-Password" : credentials_.encryptedPassword,
        @"X-Scitemwebapi-Password" : credentials_.password,
//        @"X-Scitemwebapi-Encrypted" : @"1"
        };
        headers_ = [ authHeaders_ dictionaryByAddingObjectsFromDictionary: headers_ ];
    }

    JFFURLConnectionParams* params_ = [ JFFURLConnectionParams new ];
    params_.url        = url_;
    params_.httpBody   = httpBody_;
    params_.httpMethod = httpMethod_;
    params_.headers    = headers_;

    JFFAsyncOperation loader_ = genericDataURLResponseLoader( params_ );

    JFFChangedErrorBuilder errorBuilder_ = ^NSError*( NSError* error_ )
    {
        return [ SCNetworkError errorWithDescription: error_.localizedDescription ];
    };
    return asyncOperationWithChangedError( loader_, errorBuilder_ );
}
