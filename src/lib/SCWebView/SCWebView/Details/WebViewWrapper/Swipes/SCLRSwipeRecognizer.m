#import "SCLRSwipeRecognizer.h"

#import "SCLRSwipeRecognizerDelegate.h"

@interface SCWebViewSwipeGestureRecognizer : UISwipeGestureRecognizer
@end

@implementation SCWebViewSwipeGestureRecognizer

-(BOOL)canBePreventedByGestureRecognizer:( UIGestureRecognizer* )preventingGestureRecognizer
{
    return NO;
}

@end

@interface SCLRSwipeRecognizer () < UIGestureRecognizerDelegate >
@end

@implementation SCLRSwipeRecognizer
{
    __weak id< SCLRSwipeRecognizerDelegate > _delegate;

    UIWebView* _view;
    SCWebViewSwipeGestureRecognizer* _gestureRecognizer;
}

-(void)dealloc
{
    [ _gestureRecognizer removeTarget: self action: @selector( leftSwipeRecognized: ) ];
    [ _gestureRecognizer removeTarget: self action: @selector( rightSwipeRecognized: ) ];
    
    [ _view removeGestureRecognizer: _gestureRecognizer ];
}

-(void)addSwipeRecognizerWithDirection:( UISwipeGestureRecognizerDirection )direction_
                        targetSelector:( SEL )selector_
{
    _gestureRecognizer = [ SCWebViewSwipeGestureRecognizer new ];
    _gestureRecognizer.direction = direction_;
    _gestureRecognizer.delegate = self;
    
    [ _gestureRecognizer addTarget: self
                            action: selector_ ];
    
    [ _view addGestureRecognizer: _gestureRecognizer ];
}

-(void)addSwipeRecognizer
{
    [ self addSwipeRecognizerWithDirection: UISwipeGestureRecognizerDirectionLeft
                            targetSelector: @selector( leftSwipeRecognized: ) ];

    [ self addSwipeRecognizerWithDirection: UISwipeGestureRecognizerDirectionRight
                            targetSelector: @selector( rightSwipeRecognized: ) ];
}

-(id)initWithDelegate:( id< SCLRSwipeRecognizerDelegate > )delegate_
                 view:( UIWebView* )view_
{
    self = [ super init ];

    if ( self )
    {
        _delegate = delegate_;
        _view     = view_;

        [ self addSwipeRecognizer ];
    }

    return self;
}

#pragma mark UIGestureRecognizerDelegate

-(BOOL)gestureRecognizerShouldBegin:( UISwipeGestureRecognizer* )gestureRecognizer_
{
    UIScrollView* scrollView_ = [_view scrollView];
    
    if ( gestureRecognizer_.direction == UISwipeGestureRecognizerDirectionRight )
    {
        //<--
        if ( scrollView_.contentOffset.x > 0.f )
            return NO;
    }
    if ( gestureRecognizer_.direction == UISwipeGestureRecognizerDirectionLeft )
    {
        //-->
        if ( scrollView_.contentOffset.x + scrollView_.bounds.size.width < scrollView_.contentSize.width )
            return NO;
    }
    
    return YES;
}

#pragma mark UISwipeGestureRecognizer Notifications

-(void)leftSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_
{
    [ _delegate leftSwipeRecognized: self ];
}

-(void)rightSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_
{
    [ _delegate rightSwipeRecognized: self ];
}

@end
