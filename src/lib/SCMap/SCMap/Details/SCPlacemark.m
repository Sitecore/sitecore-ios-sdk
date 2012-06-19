#import "SCPlacemark.h"

@implementation SCPlacemark
{
    NSString* _title;
    SCAsyncOp _iconReader;
}

- (id)initWithCoordinate:( CLLocationCoordinate2D )coordinate_
       addressDictionary:( NSDictionary* )addressDictionary_
{
    self = [ super initWithCoordinate: coordinate_
                    addressDictionary: addressDictionary_ ];

    if ( self )
    {
        NSString* title_ = [ addressDictionary_ objectForKey: @"PlacemarkTitle" ];
        title_ = [ title_ stringByTrimmingWhitespaces ];
        _title = [ title_ length ] == 0 ? nil : title_;

        _iconReader = [ addressDictionary_ objectForKey: @"PlacemarkIconReader"  ];
    }

    return self;
}

+(NSString*)reuseIdentifier
{
    return @"SCPlacemarkPinAnnotationView";
}

-(NSString*)reuseIdentifier
{
    return [ [ self class ] reuseIdentifier ];
}

-(NSString*)title
{
    return _title ?: [ super title ];
}

-(NSString*)subtitle
{
    return _title ? [ super title ] : nil;
}

-(MKAnnotationView*)annotationViewForMapView:( MKMapView* )mapView_
{
    MKPinAnnotationView* pinView_ = (MKPinAnnotationView*)[ mapView_ dequeueReusableAnnotationViewWithIdentifier: [ self reuseIdentifier ] ];

    if ( !pinView_ )
    {
        // If an existing pin view was not available, create one.
        pinView_ = [ [ MKPinAnnotationView alloc ] initWithAnnotation: self
                                                      reuseIdentifier: [ self reuseIdentifier ] ];

        pinView_.pinColor = MKPinAnnotationColorRed;
        pinView_.animatesDrop = YES;
        pinView_.canShowCallout = YES;

        CGFloat buttonSize_ = pinView_.bounds.size.height * 0.8f;

        // Add a detail disclosure button to the callout.
        UIButton* rightButton_ = [ UIButton buttonWithType: UIButtonTypeRoundedRect ];

        rightButton_.frame = CGRectMake(0, 0, buttonSize_, buttonSize_);

        [ rightButton_ setTitle: @"G"
                       forState: UIControlStateNormal ];

        pinView_.rightCalloutAccessoryView = rightButton_;
 
        if ( _iconReader )
        {
            SCImageView* imageView_ = [ SCImageView new ];
            imageView_.bounds = CGRectMake( 0.f, 0.f, buttonSize_, buttonSize_ );
            [ imageView_ setImageReader: _iconReader ];

            pinView_.leftCalloutAccessoryView = imageView_;
        }
    }
    else
        pinView_.annotation = self;

    return pinView_;
}

-(void)didTappedCalloutAccessoryControl:( UIControl* )control_
                         annotationView:( MKAnnotationView* )annotationView_ 
                                mapView:( MKMapView* )mapView_
{
    MKPinAnnotationView* pinView_ = (MKPinAnnotationView*)annotationView_;

    if ( pinView_.rightCalloutAccessoryView == control_ )
    {
        SCPlacemark* placeMark_ = (SCPlacemark*)pinView_.annotation;

        CLLocationCoordinate2D start_       = { placeMark_.coordinate.latitude, placeMark_.coordinate.longitude };
        CLLocationCoordinate2D destination_ = { mapView_.userLocation.coordinate.latitude, mapView_.userLocation.coordinate.longitude };

        //doc: https://developer.apple.com/library/ios/#featuredarticles/iPhoneURLScheme_Reference/Articles/MapLinks.html
        NSString* format_ = @"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f";
        NSString* googleMapsURLString_ = [ NSString stringWithFormat: format_
                                          , start_.latitude
                                          , start_.longitude
                                          , destination_.latitude
                                          , destination_.longitude ];

        [ [ UIApplication sharedApplication ] openURL: [ NSURL URLWithString: googleMapsURLString_ ] ];
    }
}

@end
