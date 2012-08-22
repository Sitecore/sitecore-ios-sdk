#import "SCWebPlugin.h"

#import <CoreMotion/CoreMotion.h>

#include "motion_manager.js.h"

#import <Foundation/Foundation.h>

@interface JWSAccelerometerListener : NSObject < SCWebPlugin >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JWSAccelerometerListener
{
    NSURLRequest* _request;
    CMMotionManager* _motionManager;
}

-(void)dealloc
{
    [ self->_motionManager stopAccelerometerUpdates ];
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        self->_request = request_;
    }

    return self;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/motion_manager/accelerometer" ];
}

+(NSString*)pluginJavascript
{
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_motion_manager_motion_manager_js
                                       length: __SCWebPlugins_Plugins_motion_manager_motion_manager_js_len
                                     encoding: NSUTF8StringEncoding ];
}

-(void)startAccelerometionToQueue:(NSOperationQueue *)queue
{
    _motionManager = [ CMMotionManager new ];
    //STODO pass as argument from JS
    _motionManager.accelerometerUpdateInterval = 0.2;

    CMAccelerometerHandler handler_ = ^void( CMAccelerometerData* accelerometerData
                                            , NSError* error_ )
    {
        if ( error_ )
            return;

        NSString* jsFormat_ = @"{ x: %f, y: %f, z: %f, timestamp: %f }";
        NSString* js_ = [ [ NSString alloc ] initWithFormat: jsFormat_
                         , accelerometerData.acceleration.x
                         , accelerometerData.acceleration.y
                         , accelerometerData.acceleration.z
                         , accelerometerData.timestamp ];

        [ self.delegate sendMessage: js_ ];
    };

    [ _motionManager startAccelerometerUpdatesToQueue: queue
                                          withHandler: handler_ ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    [ self startAccelerometionToQueue: [ NSOperationQueue currentQueue ] ];
}

-(void)didClose
{
    [ self->_motionManager stopAccelerometerUpdates ];
    self->_motionManager = nil;
}

@end
