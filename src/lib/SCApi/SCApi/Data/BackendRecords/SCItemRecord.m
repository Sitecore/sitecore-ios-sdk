#import "SCItemRecord.h"

#import "SCItem.h"
#import "SCItemInfo.h"
#import "SCApiContext.h"
#import "SCItemsCache.h"

#import "NSString+ItemPathLogic.h"
#import "SCItemRecord+Ownerships.h"

@interface SCItemsCache (SCItemRecord)

-(SCItemRecord*)existedItemRecordWithItemInfo:( SCItemInfo* )itemInfo_;

@end

@interface SCApiContext (SCItemRecord)

@property ( nonatomic ) SCItemsCache* itemsCache;

@end

@interface SCItem (SCApiContextPrivate)

+(id)itemWithRecord:( SCItemRecord* )record_
         apiContext:( SCApiContext* )apiContext_;

@end

@implementation SCItemRecord

-(void)dealloc
{
    [ self unregisterFromCacheItemAndChildren: NO ];
}

+(id)rootRecord
{
    SCItemRecord* result_ = [ self new ];

    result_.path        = [ [ self class ] rootItemPath ];
    result_.itemId      = [ [ self class ] rootItemId ];
    result_.hasChildren = YES;
    result_.displayName = @"sitecore";

    return result_;
}

-(NSString*)description
{
    return [ [ NSString alloc ] initWithFormat: @"<SCItemRecord displayName:\"%@\" template:\"%@\" hasChildren:\"%d\" >"
            , self.displayName
            , self.itemTemplate
            , self.hasChildren ];
}

+(id)itemRecord
{
    return [ self new ];
}

+(NSString*)rootItemId
{
    return @"{11111111-1111-1111-1111-111111111111}";
}

+(NSString*)rootItemPath
{
    return @"/sitecore";
}

-(NSString*)parentId
{
    return [ self.longID parentIdOfLongId ];
}

-(NSString*)parentPath
{
    return [ self.path stringByDeletingLastPathComponent ];
}

-(NSArray*)allChildrenRecords
{
    if ( !self.hasChildren )
    {
        return [ NSArray new ];
    }

    SCItemInfo* info_ = [ SCItemInfo new ];
    info_.itemId   = self.itemId;
    info_.itemPath = self.path;
    info_.language = self.language;
    return [ _apiContext.itemsCache allChildrenForItemWithItemInfo: info_ ];
}

-(NSArray*)readChildrenRecords
{
    return [ self->_apiContext.itemsCache cachedChildrenForItemWithId: self.itemId
                                                             language: self.language ];
}

-(SCItem*)item
{
    SCItem* result_ = self->_itemRef;
    if ( !result_ )
    {
        result_ = [ SCItem itemWithRecord: self
                               apiContext: self->_apiContext ];
        self->_itemRef = result_;
    }
    return result_;
}

-(SCItem*)parent
{
    SCItemInfo* itemInfo_ = [ SCItemInfo new ];
    itemInfo_.itemId   = self.parentId;
    itemInfo_.language = self.language;
    SCItemRecord* record_ = [ self->_apiContext.itemsCache existedItemRecordWithItemInfo: itemInfo_ ];
    return record_.item;
}

-(void)unregisterFromCacheItemAndChildren:( BOOL )childrenAlso_
{
    if ( childrenAlso_ )
    {
        for ( SCItemRecord* itemRecord_ in self.readChildrenRecords )
        {
            [ itemRecord_ unregisterFromCacheItemAndChildren: YES ];
        }
    }
    if ( [ self.itemId length ] != 0 )
    {
        [ self removeOwnershipRelations ];
        [ self->_apiContext.itemsCache didRemovedItemRecord: self ];
        self.itemId = nil;
    }
}

@end
