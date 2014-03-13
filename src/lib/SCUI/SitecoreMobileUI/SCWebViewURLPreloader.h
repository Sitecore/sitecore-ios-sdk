#import <Foundation/Foundation.h>

@interface SCWebViewURLPreloader : NSObject

- (id)initWithURLs:(NSArray *)URLs;

- (void)startPreloadWithFinishCallback:( void(^)(NSError *error) )finishCallback;

@end
