#ifndef ObjcScopedGuard_FloatComparator_hpp
#define ObjcScopedGuard_FloatComparator_hpp

#include <cmath>

// use more sophisticated and precise comparisson methods
// http://www.cygnus-software.com/papers/comparingfloats/comparingfloats.htm

namespace Utils
{
    template <typename FLOAT, typename BOOLEAN=bool>
    BOOLEAN IsEqualFloatToFloatWithPrecision( FLOAT first_, FLOAT second_, FLOAT precision_ = 0.001 )
    {
        return static_cast<BOOLEAN>( fabs( first_ - second_ ) <= precision_ );
    }
}

#endif
