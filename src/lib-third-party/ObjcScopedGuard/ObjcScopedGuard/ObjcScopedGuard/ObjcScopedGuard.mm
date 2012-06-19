#import "ObjcScopedGuard.h"

using namespace Utils;

ObjcScopedGuard::ObjcScopedGuard( GuardCallbackBlock callback_ ) : 
    _block( [ callback_ copy ] ),
    _isActive( true )
{
}

ObjcScopedGuard::~ObjcScopedGuard() throw()
{
    if ( this->_isActive )
    {
        _block();
    }
}

void ObjcScopedGuard::Release()
{
    this->_isActive = false;
}
