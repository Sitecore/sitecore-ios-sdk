#import <JFFAsyncOperations/JFFAsyncOperations.h>
#import <Foundation/Foundation.h>

@protocol SCWebPluginDelegate;


@interface SCAbstractTriggerPlugin : NSObject

+(NSString*)pluginJavascript;
-(id)initWithRequest:( NSURLRequest* )request;

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@property ( nonatomic ) NSString* itemRenderingUrl;
@property ( nonatomic ) NSString* triggerId;

-(JFFAsyncOperation)triggeringAction;

@end
