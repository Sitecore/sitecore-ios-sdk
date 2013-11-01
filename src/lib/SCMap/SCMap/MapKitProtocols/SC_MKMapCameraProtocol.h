#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>


@protocol SC_MKMapCameraProtocol <NSObject>

-(CLLocationCoordinate2D)centerCoordinate;
-(void)setCenterCoordinate:(CLLocationCoordinate2D)newValue;

-(CLLocationDirection)heading;
-(void)setHeading:(CLLocationDirection)newValue;

// In degrees where 0 is looking straight down. Pitch may be clamped to an appropriate value.
-(CGFloat)pitch;
-(void)setPitch:(CGFloat)newValue;

-(CLLocationDistance)altitude;
-(void)setAltitude:(CLLocationDistance)newValue;

+(instancetype)camera;

+(instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                             fromEyeCoordinate:(CLLocationCoordinate2D)eyeCoordinate
                                   eyeAltitude:(CLLocationDistance)eyeAltitude;

@end
