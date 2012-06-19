#import <Foundation/Foundation.h>
#include <ObjcScopedGuard/ObjcGuardBlocks.h>

@interface ObjcReferendeCountGuard : NSObject

-(id)initWithBlock:( GuardCallbackBlock )block_;
-(void)releaseGuard;

@end
