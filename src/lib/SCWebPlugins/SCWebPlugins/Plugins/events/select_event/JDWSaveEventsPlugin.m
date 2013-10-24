#import "SCWebPlugin.h"
#import "UIPopoverController+PresentPopoverInWebView.h"
#import "SCEventsStoreFactory.h"
#import "SCEventValuesParser.h"

#import "events.js.h"

#include <EventKit/EventKit.h>
#include <EventKitUI/EventKitUI.h>

@interface JDWSaveEventsPlugin : NSObject < SCWebPlugin, EKEventEditViewDelegate >

@property ( nonatomic, weak ) id< SCWebPluginDelegate > delegate;

@end

@implementation JDWSaveEventsPlugin
{
    NSURLRequest* _request;
    UIPopoverController* _popover;
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

+(NSString*)pluginJavascript
{
    return [ [ NSString alloc ] initWithBytes: __SCWebPlugins_Plugins_events_events_js
                                       length: __SCWebPlugins_Plugins_events_events_js_len
                                     encoding: NSUTF8StringEncoding ];
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/events/save_event" ];
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSLog(@"[BEGIN] - %@.", NSStringFromClass( [ self class ] ) );
    
    __weak JDWSaveEventsPlugin *weakSelf_ = self;
    
    SCEventStoreSuccessCallback storeReseived = ^(EKEventStore *store_) {
        
        NSDictionary* args_  = [ _request.URL queryComponents ];

        EKEvent *event =    [ EKEvent eventWithEventStore: store_ ];
        
        event.startDate = [ SCEventValuesParser getStartDateValueFromDict: args_ ];
        event.endDate   = [ SCEventValuesParser getEndDateValueFromDict: args_ ];
        event.title     = [ SCEventValuesParser getTitleValueFromDict: args_ ];
        event.location  = [ SCEventValuesParser getLocationValueFromDict: args_ ];
        event.notes     = [ SCEventValuesParser getNotesValueFromDict: args_ ];
        
        NSTimeInterval positiveAlarmOffcet = [ SCEventValuesParser getAlarmValueFromDict: args_ ];
        EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset: -positiveAlarmOffcet ];
        event.alarms = @[alarm];
        
        [event setCalendar:[store_ defaultCalendarForNewEvents]];

        [ weakSelf_ showEventEditViewController: event
                                          store:store_
                                      inWebView: webView_ ];
    };
    
    SCEventStoreErrorCallback storeError = ^(NSError *error_) {
        
        [ weakSelf_.delegate sendMessage: [ error_ toJson ] ];
        [ weakSelf_.delegate close ];
        
    };
    
    [ SCEventsStoreFactory asyncEventsStoreWithSuccessBlock: storeReseived
                                              errorCallback: storeError ];
    
}

-(void)showEventEditViewController:(EKEvent *)event store:(EKEventStore *)store_ inWebView:( UIWebView* )webView_
{
    EKEventEditViewController *eventViewController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    eventViewController.eventStore = store_;
    eventViewController.event = event;
    eventViewController.editViewDelegate = self;
    
    UIViewController* rootController_ = webView_.window.rootViewController;
    
    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        [ rootController_ presentTopViewController: eventViewController ];
    }
    else
    {
        [ self showPopoverWithController: eventViewController
                                    view: webView_ ];
    }
}

-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        [ controller  dismissViewControllerAnimated:YES
                                         completion:nil ];
    }
    else
    {
        if ( _popover )
            [ _popover dismissPopoverAnimated:YES ];
    }

}

-(void)showPopoverWithController:( UIViewController* )controller_
                            view:( UIWebView* )view_
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _popover = [ [ UIPopoverController alloc ] initWithContentViewController: controller_ ];
        
        [ _popover presentPopoverFromRect: CGRectMake( 0.f, 0.f, 480.f, 320.f )
                                inWebView: view_ ];
    });
}


@end
