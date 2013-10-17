#import <Foundation/Foundation.h>

@class SCCacheSettings;
@protocol ESReadOnlyDbWrapper;
@protocol ESWritableDbWrapper;

@interface SCCacheSchemeBuilder : NSObject

-(instancetype)initWithDatabase:( id<ESReadOnlyDbWrapper, ESWritableDbWrapper> )db
                       settings:( SCCacheSettings* )settings
                     itemSource:( SCItemSourcePOD* )itemSource;
-(void)setupScheme;

@end
