#import "ImageLoaderBuilderHook.h"

#import <objc/message.h>
#import <objc/runtime.h>


@implementation ImageLoaderBuilderHook
{
    BOOL _isHookEnabled;
 
    ImageLoaderBuilder _hookImpl;
    
    SEL _methodToHookSelector;
    Method _methodToHook;
    IMP _newImpl     ;
    IMP _originalImpl;
}

-(void)dealloc
{
    [ self disableHook ];
}

-(instancetype)init
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(instancetype)initWithHookImpl:( ImageLoaderBuilder )hookImpl
{
    self = [ super init ];
    if ( nil == self )
    {
        return nil;
    }
    
    self->_hookImpl   = hookImpl  ;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    self->_methodToHookSelector = @selector( downloadResourceOperationForMediaPath:imageParams: );
#pragma clang diagnostic pop
    
    
    self->_methodToHook = class_getInstanceMethod( [ SCExtendedApiSession class ], self->_methodToHookSelector );
    self->_originalImpl = class_getMethodImplementation( [ SCExtendedApiSession class ], self->_methodToHookSelector );
    

    self->_newImpl = imp_implementationWithBlock( self->_hookImpl );

    return self;
}

-(void)enableHook
{
    if ( self->_isHookEnabled )
    {
        return;
    }

    method_setImplementation( self->_methodToHook, self->_newImpl );
    self->_isHookEnabled = YES;
}

-(void)disableHook
{
    if ( !self->_isHookEnabled )
    {
        return;
    }

    method_setImplementation( self->_methodToHook, self->_originalImpl );
    self->_isHookEnabled = NO;
}

@end
