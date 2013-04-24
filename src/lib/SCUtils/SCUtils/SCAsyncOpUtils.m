#import "SCAsyncOpUtils.h"

SCAsyncOp asyncOpWithJAsyncOp( JFFAsyncOperation loader_ )
{
    loader_ = [ loader_ copy ];
    return ^void( SCAsyncOpResult handler_ )
    {
        handler_ = [ handler_ copy ];
        loader_( nil, nil, handler_ );
    };
}
