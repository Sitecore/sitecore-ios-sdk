#import "SCItemAndFields.h"

@implementation SCItemAndFields

-(void)dealloc
{
    [ self cleanupChecklistRetainCycles ];
}

-(void)cleanupChecklistRetainCycles
{
    for ( SCFieldRecord* field in self.cachedItemRecord.fieldsByName.allValues )
    {
        // @adk : non SCFieldRecord objects are used in unit tests
        if ( ![ field isKindOfClass: [ SCFieldRecord class ] ] )
        {
            // @adk : fields must have the same type.
            // That's why we do not use "continue" instruction.
            break;
        }
        field.fieldValue = nil;
    }
    self.cachedItemRecord.fieldsByName = nil;
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithItemRecord:( SCItemRecord* ) cachedItemRecord
                           fields:( NSDictionary* ) cachedItemFieldsByName
              isAllFieldsReceived:( BOOL ) isAllFieldItemsCached
            isAllChildrenReceived:( BOOL ) isAllChildItemsCached
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_cachedItemRecord       = cachedItemRecord      ;
    self->_cachedItemFieldsByName = cachedItemFieldsByName;
    self->_isAllFieldItemsCached  = isAllFieldItemsCached ;
    self->_isAllChildItemsCached  = isAllChildItemsCached ;
    
    return self;
}

@end
