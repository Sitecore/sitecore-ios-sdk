#import "SCMapViewController.h"

#import "SCMapView.h"
#import "SCGestureRecognizer.h"

#import <JFFScheduler/JFFScheduler.h>

static void(^presentControllerHandler_)( SCMapViewController* );

@interface SCMapView (SitecoreAPIPrivate_SCMapViewController)

-(void)addAddressesAnnotations:( NSArray* )addresses_;

@end

@interface SCMapViewController () < UIGestureRecognizerDelegate, SCGestureRecognizerDelegate >
@end

@implementation SCMapViewController
{
    UIToolbar* _toolBar;
    JFFScheduler* _scheduler;
    __weak SCGestureRecognizer* _recognizer;
}

-(void)dealloc
{
    [ self->_recognizer removeTarget: self action: @selector( tapAction ) ];
}

-(SCMapView*)mapView
{
    return (SCMapView*)self.view;
}

-(void)loadView
{
    UIWindow* window_ = [ [ UIApplication sharedApplication ] keyWindow ];
    CGRect frame_ = window_.bounds;
    self.view = [ [ SCMapView alloc ] initWithFrame: frame_ ];
}

-(void)initializeMapView
{
    [ self.mapView addAddressesAnnotations: self.addresses ];

    self.mapView.drawRouteToNearestAddress = self.drawRoute;
    if ( self.regionRadius > 100. )
        self.mapView.regionRadius = self.regionRadius;
    
#ifdef __IPHONE_7_0
    
    BOOL perspectiveParamsAreValid =
           CLLocationCoordinate2DIsValid( self.viewPointPosition )
        && CLLocationCoordinate2DIsValid( self.cameraPosition )
        && ( self.cameraHeight > 0 );
    
    if ( perspectiveParamsAreValid )
    {
        MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate: self.viewPointPosition
                                                         fromEyeCoordinate: self.cameraPosition
                                                               eyeAltitude: self.cameraHeight ];
        self.mapView.camera = camera;
    }
    
#endif
    
}

-(void)addTapRecognizer
{
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    //TODO: @igk delete this code and SCGestureRecognizer class after testing

//    _recognizer =  [ SCGestureRecognizer recognizerWithView: self.view
//                                        viewToIgnoreTouches: _toolBar ];
//    _recognizer.scDelegate = self;
//
//    [ _recognizer addTarget: self
//                     action: @selector( tapAction ) ];
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];

    [ self addToolBar ];
    [ self initializeMapView ];
    [ self addTapRecognizer ];

    if ( presentControllerHandler_ )
        presentControllerHandler_( self );
}

-(void)viewDidUnload
{
    [ _recognizer removeTarget: self action: @selector( tapAction ) ];
    _recognizer = nil;
    _toolBar    = nil;

    [ super viewDidUnload ];
}

-(void)tapAction
{
    if ( _toolBar.hidden )
        [ self showToolBar ];
}

-(void)addToolBar
{
    _toolBar = [ UIToolbar new ];

    _toolBar.barStyle = UIBarStyleBlackOpaque;
    _toolBar.frame    = CGRectMake( 0.f, 0.f, self.view.bounds.size.width, 44.f );
    _toolBar.alpha = 0.75;

    [ _toolBar sizeToFit ];    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 70, _toolBar.frame.size.height)];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button addTarget:self action:@selector( doneAction ) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* doneButton_ = [[ UIBarButtonItem alloc ] initWithCustomView:button];
    
    [ _toolBar setItems: [ NSArray arrayWithObject: doneButton_ ] animated: NO ];

    _toolBar.hidden = YES;

    [ self.view addSubview: _toolBar ];
}

-(void)showToolBar
{
    [ UIView animateWithDuration: 0.2 animations: ^( void )
    {
        _toolBar.hidden = NO;
        _toolBar.alpha = 0.75f;         
    }
    completion: ^( BOOL finished_ )
    {
         [ self sheduleHidingToolbar ];
    } ];
}

-(void)sheduleHidingToolbar
{
    __unsafe_unretained SCMapViewController* self_ = self;
    JFFScheduledBlock hideAnimationBlock_ = ^( JFFCancelScheduledBlock cancel_ )
    {
        cancel_();

        [ UIView animateWithDuration: 0.25 animations: ^( void )
        {
            self_->_toolBar.alpha = 0.0f;
        }
        completion:^( BOOL finished_ )
        {
            self_->_toolBar.hidden = YES;
        } ];
    };

    _scheduler = [ JFFScheduler new ];
    [ _scheduler addBlock: hideAnimationBlock_ duration: 3 ];
}

-(void)hideMapViewController
{
    if ( self.isViewLoaded && self.view.window.rootViewController == self )
    {
        self.view.window.rootViewController = nil;
        return;
    }
    [ self dismissViewControllerAnimated: YES completion: nil ];
}

-(void)doneAction
{
    [ self hideMapViewController ];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:( UIInterfaceOrientation )interfaceOrientation_
{
    if ( [ [ UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone )
    {
        return ( interfaceOrientation_ != UIInterfaceOrientationPortraitUpsideDown );
    }
    else
    {
        return YES;
    }
}

#pragma mark SCGestureRecognizerDelegate

-(void)gestureRecognizer:( UIGestureRecognizer* )gestureRecognizer_
  didReceiveReceiveTouch:( UITouch* )touch_
{
    [ self sheduleHidingToolbar ];
}

@end

@implementation SCMapViewController (TestExtensions)

+(void)setPresentMapViewControllerHendler:( void(^)( SCMapViewController* controller_ ) )handler_
{
    presentControllerHandler_ = [ handler_ copy ];
}

@end
