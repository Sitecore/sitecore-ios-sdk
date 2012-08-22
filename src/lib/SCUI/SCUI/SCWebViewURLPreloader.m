#import "SCWebViewURLPreloader.h"

//#import <SCApi/Cache/SCWebCache.h>

@interface SCWebViewURLPreloader ()

//STODO remove
@property ( nonatomic ) NSArray* urls;

@end

@implementation SCWebViewURLPreloader

-(id)initWithURLs:( NSArray* )URLs_
{
    self = [ super init ];

    if ( self )
    {
        self->_urls = URLs_;
    }

    return self;
}

-(JFFAsyncOperation)urlsLoaderForURLs:( NSArray* )urls_
{
    NSArray* loaders_ = [ urls_ map: ^id( id url_or_string_ )
    {
//      NSURL* url_ = [ url_or_string_ toURL ];
//      return [ [ SCWebCache sharedWebCache ] cachedURLDataLoaderForURL: url_ ];
        return nil;
    } ];
    return groupOfAsyncOperationsArray( loaders_ );
}

-(void)didFinishPreloadWithCallback:( void(^)( NSError* error_ ) )finish_callback_
                              error:( NSError* )error_
{
    if ( finish_callback_ )
        finish_callback_( error_ );
}

-(void)startPreloadWithFinishCallback:( void(^)( NSError* error_ ) )finish_callback_
{
    JFFAsyncOperation loader_ = [ self urlsLoaderForURLs: self.urls ];

    finish_callback_ = [ finish_callback_ copy ];
    loader_( nil, nil, ^( id result_, NSError* error_ )
    {
        [ self didFinishPreloadWithCallback: finish_callback_
                                      error: error_ ];
    } );
}

@end
