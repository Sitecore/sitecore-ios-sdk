#import <Foundation/Foundation.h>

@protocol SC_MKDirectionsProtocol <NSObject>

- (instancetype)initWithRequest:(id)request;

- (void)calculateDirectionsWithCompletionHandler:(id)completionHandler;
- (void)calculateETAWithCompletionHandler:(id)completionHandler;
- (void)cancel;


//@property (nonatomic, readonly, getter=isCalculating) BOOL calculating;
-(void)setCalculating:( BOOL )newValue;
-(BOOL)isCalculating;


// ???
//-(BOOL)calculating;

@end
