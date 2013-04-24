#import "JFFAsyncOperationGeocoderBase.h"


@implementation JFFAsyncOperationGeocoderBase

-(id)init
{
    self = [ super init ];
    
    if ( nil == self )
    {
        return nil;
    }
    
    self->_geocoder = [ CLGeocoder new ];
    
    return self;
}

-(void)cancel:( BOOL )canceled_
{
    [ self->_geocoder cancelGeocode ];
    self->_geocoder = nil;
}

-(SCAsyncOp)asyncOperation
{
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
}

-(void)asyncOperationWithResultHandler:( JFFAsyncOperationInterfaceResultHandler )handler_
                         cancelHandler:(JFFAsyncOperationInterfaceCancelHandler)cancelHandler
                       progressHandler:( JFFAsyncOperationInterfaceProgressHandler )progress_
{
    if ( !self->_geocoder )
    {
        return;
    }
    
    [ self asyncOperation ]( ^( id result_, NSError* error_ )
    {
        if ( progress_ && result_ )
        {
            progress_( result_ );
        }
        
        if ( handler_ )
        {
            handler_( result_, error_ );
        }
    } );
}

@end

