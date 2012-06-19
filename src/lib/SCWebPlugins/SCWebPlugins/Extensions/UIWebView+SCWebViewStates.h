#import <UIKit/UIKit.h>

@class JFFMutableAssignDictionary;

@interface UIWebView (SCWebViewStates)

@property ( nonatomic ) BOOL scHookTouchesViewEnabled;
@property ( nonatomic ) NSString* scLastTouchLocationPoint;
@property ( nonatomic, strong ) JFFMutableAssignDictionary* pluginBySocketGuid;

@end
