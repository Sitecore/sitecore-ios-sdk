#import "SCItemRecordStorageRW.h"
#import "SCRecordStorageBase.h"
#import <Foundation/Foundation.h>

@class SCItemSourcePOD;
@class SCExtendedApiSession;

@protocol ESReadOnlyDbWrapper;
@protocol ESWritableDbWrapper;
@protocol ESTransactionsWrapper;


@interface SCPersistentRecordStorage : SCRecordStorageBase< SCItemRecordStorageRW >

-(instancetype)initWithApiSession:( SCExtendedApiSession* )apiSession
                       itemSource:( SCItemSourcePOD* )itemSource
                     readDatabase:( id<ESReadOnlyDbWrapper> )readDb
                    writeDatabase:( id<ESWritableDbWrapper, ESTransactionsWrapper> )writeDb
                itemKeyColumnName:( NSString* )itemKeyColumnName;

@property ( nonatomic ) BOOL shouldCloseReadDb ;
@property ( nonatomic ) BOOL shouldCloseWriteDb;

@property ( nonatomic, readonly, weak ) SCExtendedApiSession* apiSession;
@property ( nonatomic, readonly ) NSString* itemKeyColumnName;
@property ( nonatomic, readonly ) id<ESReadOnlyDbWrapper> readDb ;
@property ( nonatomic, readonly ) id<ESWritableDbWrapper, ESTransactionsWrapper> writeDb;

+(NSString*)itemIdColumn;
+(NSString*)itemPathColumn;

@end
