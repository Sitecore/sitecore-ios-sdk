#import "SCAsyncTestCase.h"

#import <SCMap/Details/SCMapKitLocationUtils.h>
#import <SCMap/Details/AsyncOperartionsBuilder/JFFAsyncOperationGeocoder.h>

#import <SCMap/MapKitLocations/NSDictionary+ContacAddressBuilder.h>

#import <CoreLocation/CLRegion.h>

#import <SitecoreMobileSDK/SCApi.h>

@interface SCMapKitLocationUtilsTest : SCAsyncTestCase
@end

@implementation SCMapKitLocationUtilsTest

-(void)testInvalidAddressDict
{
    __block BOOL resultOk_ = NO;
    
    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        // @adk : see valid location example in Apple's tutorial
        // http://developer.apple.com/library/ios/#samplecode/GeocoderDemo/Introduction/Intro.html#//apple_ref/doc/uid/DTS40011097
        NSDictionary* address_ =
        [ NSDictionary contactAddressWithStreet: @"V.I. Lenina square"
                                           city: @"Dnipropetrovsk"
                                          state: @""
                                            ZIP: @"49000"
                                        country: @"Ukraine" ];

        placemarksLoaderWithAddressDict( address_ )( nil, nil, ^( id result_, NSError* error_ )
        {
            if ( error_ )
                NSLog( @"failed: %@", error_ );
            resultOk_ = [ result_ count ] != 0;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertFalse( resultOk_, @"Nicam item should be read" );
}

-(void)testValidUkrainAddressDict
{
    __block BOOL resultOk_ = NO;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSDictionary* address_ = [ NSDictionary contactAddressWithStreet: @"пл. В.І. Леніна 1"
                                                                    city: @"Дніпропетровськ"
                                                                   state: @"Дніпропетровська область"
                                                                     ZIP: @"49000"
                                                                 country: @"" ];

        placemarksLoaderWithAddressDict( address_ )( nil, nil, ^( id result_, NSError* error_ )
        {
            if ( error_ )
                NSLog( @"failed: %@", error_ );
            resultOk_ = [ result_ count ] != 0;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( resultOk_, @"Nicam item should be read" );
}

-(void)testValidAddressDict
{
    __block BOOL resultOk_ = NO;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSDictionary* address_ = [ NSDictionary contactAddressWithStreet: @"45 Avenue Jean Zay"
                                                                    city: @"Paris"
                                                                   state: @"Livry-Gargan"
                                                                     ZIP: @"93190"
                                                                 country: @"France" ];

        placemarksLoaderWithAddressDict( address_ )( nil, nil, ^( id result_, NSError* error_ )
        {
            if ( error_ )
                NSLog( @"failed: %@", error_ );
            resultOk_ = [ result_ count ] != 0;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( resultOk_, @"Nicam item should be read" );
}

-(void)testValidUkrainAddress
{
    __block BOOL resultOk_ = NO;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        NSString* address_ = @"пл. В.І. Леніна, 1, Дніпропетровськ, Дніпропетровська область, 49000";

        placemarksLoaderWithAddress( address_ )( nil, nil, ^( id result_, NSError* error_ )
        {
            if ( error_ )
                NSLog( @"failed: %@", error_ );
            resultOk_ = [ result_ count ] != 0;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( resultOk_, @"Nicam item should be read" );
}

//STODO

-(void)testNormalItemAddressesFromNicam
{
    __block BOOL resultOk_ = NO;

    void (^block_)(JFFSimpleBlock) = ^void( JFFSimpleBlock didFinishCallback_ )
    {
        SCApiContext* context_ = [ SCApiContext contextWithHost: @"ws-alr1.dk.sitecore.net/-/item" ];
        NSString* path_ = @"/sitecore/content/Test Data/Maps";
        itemAddressesGeocoderWithPath( context_, path_ )( nil, nil, ^( id result_, NSError* error_ )
        {
            if ( error_ )
                NSLog( @"failed: %@", error_ );
            else 
                NSLog( @"addresses: %@", result_ );
            resultOk_ = [ result_ count ] == 6;
            didFinishCallback_();
        } );
    };

    [ self performAsyncRequestOnMainThreadWithBlock: block_
                                           selector: _cmd ];

    GHAssertTrue( resultOk_, @"Nicam item should be read" );
}

//STODO
// itemAddressesGeocoder

@end
