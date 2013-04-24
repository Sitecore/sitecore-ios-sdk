#import "SCItemRecord+Ownerships.h"

#import "SCItemInfo.h"
#import "SCApiContext.h"
#import "SCItemsCache.h"

@interface SCItemsCache (SCItemRecordOwnerships)

-(SCItemRecord*)existedItemRecordWithItemInfo:( SCItemInfo* )itemInfo_;

@end

@interface SCApiContext (SCItemRecordOwnerships)

@property ( nonatomic ) SCItemsCache* itemsCache;

@end

@implementation SCItemRecord (Ownerships)

-(SCItemsCache*)itemsCache
{
    return self.apiContext.itemsCache;
}

-(SCItemRecord*)findNearestParent
{
    NSString* parentLongId_ = [ self.longID stringByDeletingLastPathComponent ];
    NSString* parentId_     = [ parentLongId_ lastPathComponent ];
    while ( [ parentId_ length ] != 0 && ![ parentId_ isEqualToString: @"/" ] )
    {
        SCItemInfo* itemInfo_ = [ SCItemInfo new ];
        itemInfo_.itemId = parentId_;
        itemInfo_.language = self.language;
        SCItemRecord* parent_ = [ self.itemsCache existedItemRecordWithItemInfo: itemInfo_ ];
        if ( parent_ )
            return parent_;
        parentLongId_ = [ parentLongId_ stringByDeletingLastPathComponent ];
        parentId_     = [ parentLongId_ lastPathComponent ];
    }
    return nil;
}

-(void)removeOwnershipRelations
{
    SCItemRecord* parent_ = [ self findNearestParent ];
    while ( parent_ )
    {
        [ parent_ addOwnedObject: self ];
        parent_ = [ parent_ findNearestParent ];
    }
}

-(void)setOwnershipsForParent
{
    SCItemRecord* parent_ = [ self findNearestParent ];
    [ parent_ addOwnedObject: self ];
}

-(void)setOwnershipsForChildren
{
    //STODO to slow method
    NSArray* arrayOfArrays_ = [ self.itemsCache.itemRecordsById allValues ];
    NSArray* allItemReceords_ = [ arrayOfArrays_ flatten: ^NSArray*(JFFMutableAssignArray* object_)
    {
        return [ object_ array ];
    } ];
    for ( SCItemRecord* itemRecord_ in allItemReceords_ )
    {
        if ( itemRecord_ != self
            && [ itemRecord_.language isEqualToString: self.language ]
            && [ [ itemRecord_.longID pathComponents ] containsObject: self.itemId ] )
        {
            [ self addOwnedObject: itemRecord_ ];
        }
    }
}

-(void)setOwnershipRelations
{
    [ self setOwnershipsForParent ];
    [ self setOwnershipsForChildren ];

    SCItemInfo* itemInfo_ = [ SCItemInfo new ];
    itemInfo_.itemId   = self.itemId;
    itemInfo_.language = self.language;
    SCItemRecord* previousItem_ = [ self.itemsCache existedItemRecordWithItemInfo: itemInfo_ ];
    [ previousItem_ removeOwnershipRelations ];
}

@end
