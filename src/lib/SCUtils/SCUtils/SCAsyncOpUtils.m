#import "SCAsyncOpUtils.h"

SCAsyncOp asyncOpWithJAsyncOp( JFFAsyncOperation loader_ )
{
    loader_ = [ loader_ copy ];
    return ^( SCAsyncOpResult handler_ )
    {
        handler_ = [ handler_ copy ];
        loader_( nil, nil, ^( id result_, NSError* error_ )
        {
            if ( handler_ )
                handler_( result_, error_ );
        } );
    };
}
