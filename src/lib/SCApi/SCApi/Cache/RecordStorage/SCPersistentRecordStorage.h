#import "SCItemRecordStorageRW.h"
#import "SCRecordStorageBase.h"
#import <Foundation/Foundation.h>

@class SCItemSourcePOD;
@class SCExtendedApiContext;

@protocol ESReadOnlyDbWrapper;
@protocol ESWritableDbWrapper;
@protocol ESTransactionsWrapper;


@interface SCPersistentRecordStorage : SCRecordStorageBase< SCItemRecordStorageRW >

-(instancetype)initWithApiContext:( SCExtendedApiContext* )apiContext
                       itemSource:( SCItemSourcePOD* )itemSource
                     readDatabase:( id<ESReadOnlyDbWrapper> )readDb
                    writeDatabase:( id<ESWritableDbWrapper, ESTransactionsWrapper> )writeDb
                itemKeyColumnName:( NSString* )itemKeyColumnName;

@property ( nonatomic ) BOOL shouldCloseReadDb ;
@property ( nonatomic ) BOOL shouldCloseWriteDb;

@property ( nonatomic, readonly, weak ) SCExtendedApiContext* apiContext;
@property ( nonatomic, readonly ) NSString* itemKeyColumnName;
@property ( nonatomic, readonly ) id<ESReadOnlyDbWrapper> readDb ;
@property ( nonatomic, readonly ) id<ESWritableDbWrapper, ESTransactionsWrapper> writeDb;

+(NSString*)itemIdColumn;
+(NSString*)itemPathColumn;

@end
