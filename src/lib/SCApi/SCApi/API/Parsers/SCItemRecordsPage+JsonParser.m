#import "SCItemRecordsPage+JsonParser.h"

#import "SCError.h"

#import "SCItemRecord+Parser.h"

@implementation SCItemRecordsPage (JsonParser)

+(JFFAsyncOperationBinder)itemRecordsWithResponseData:( NSData* )responseData_
                                           apiContext:( SCApiContext* )apiContext_
{
    return ^JFFAsyncOperation( id json_ )
    {
        return ^JFFCancelAsyncOperation( JFFAsyncOperationProgressHandler progressCallback_
                                        , JFFCancelAsyncOperationHandler cancelCallback_
                                        , JFFDidFinishAsyncOperationHandler doneCallback_ )
        {
            NSDictionary* resultJson_ = json_[ @"result" ];

            NSNumber* totalCount_ = resultJson_[ @"totalCount" ];
            NSArray* itemsJson_   = resultJson_[ @"items" ];

            if ( !totalCount_ || !itemsJson_ )
            {
                SCInvalidResponseFormatError* error_ = [ SCInvalidResponseFormatError new ];
                error_.responseData = responseData_;
                if ( doneCallback_ )
                    doneCallback_( nil, error_ );
                return JFFStubCancelAsyncOperationBlock;
            }

            JFFAsyncOperation loader_ = [ itemsJson_ asyncMap: ^JFFAsyncOperation( id object_ )
            {
                return [ SCItemRecord itemRecordWithApiContext: apiContext_ ]( object_ );
            } ];

            JFFChangedResultBuilder resultBuilder_ = ^id( id localResult_ )
            {
                SCItemRecordsPage* result_ = [ self new ];

                result_.totalCount  = [ totalCount_ unsignedIntegerValue ];
                result_.itemRecords = localResult_;

                return result_;
            };
            loader_ = asyncOperationWithChangedResult( loader_, resultBuilder_ );

            return loader_( progressCallback_, cancelCallback_, doneCallback_ );
        };
    };
}

@end
