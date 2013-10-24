#import <Foundation/Foundation.h>

@class JFFMutableAssignDictionary;
@class SCItemRecord;

@interface SCItemAndFields : NSObject

-(instancetype)initWithItemRecord:( SCItemRecord* ) cachedItemRecord
                           fields:( NSDictionary* ) cachedItemFieldsByName
              isAllFieldsReceived:( BOOL ) isAllFieldItemsCached
            isAllChildrenReceived:( BOOL ) isAllChildItemsCached;

@property ( nonatomic, readonly ) SCItemRecord* cachedItemRecord      ;
@property ( nonatomic, readonly ) NSDictionary* cachedItemFieldsByName;
@property ( nonatomic, readonly ) BOOL          isAllFieldItemsCached ;
@property ( nonatomic, readonly ) BOOL          isAllChildItemsCached ;

@end
