#import <Foundation/Foundation.h>

@class SCItem;
@class SCExtendedApiContext;
@class SCApiContext;

@interface SCItemRecord : NSObject

@property ( nonatomic ) NSString* path;
@property ( nonatomic ) NSString* itemId;
@property ( nonatomic ) BOOL hasChildren;
@property ( nonatomic ) NSString* displayName;
@property ( nonatomic ) NSString* itemTemplate;
@property ( nonatomic ) NSString* longID;
@property ( nonatomic ) NSString* language;

@property ( nonatomic, readonly ) NSString* parentId;
@property ( nonatomic, readonly ) NSString* parentLongId;
@property ( nonatomic, readonly ) NSString* parentPath;

@property ( nonatomic, readonly ) NSArray* allChildrenRecords;
@property ( nonatomic, readonly ) NSArray* readChildrenRecords;

@property ( nonatomic ) NSDictionary *fieldsByName;

@property ( nonatomic, weak ) SCItem* itemRef;
@property ( nonatomic, weak, readonly ) SCItem* parent;
@property ( nonatomic, weak, readonly ) SCItem* item;
@property ( nonatomic ) SCExtendedApiContext* apiContext;
@property ( nonatomic ) SCApiContext* mainApiContext;

+(instancetype)itemRecord;
+(instancetype)rootRecord;

+(NSString*)rootItemId;
+(NSString*)rootItemPath;

-(void)unregisterFromCacheItemAndChildren:( BOOL )childrenAlso_;

@end
