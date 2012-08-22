//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import "NSString+MD5Addition.h"

#include <vector>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress
{
    static const unsigned int MIB_SIZE = 6;
    int mib[6] =
    {
        CTL_NET,
        AF_ROUTE,
        0,
        AF_LINK,
        NET_RT_IFLIST
    };
    
    size_t              len = 0;
    char                *buf = NULL;
    unsigned char       *ptr = NULL;
    struct if_msghdr    *ifm = {0};
    struct sockaddr_dl  *sdl = {0};

    std::vector<unsigned char> bufGuard;

    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        NSLog(@"Error: if_nametoindex error\n");
        return nil;
    }
    if (sysctl(mib, MIB_SIZE, NULL, &len, NULL, 0) < 0)
    {
        NSLog(@"Error: sysctl, take 1\n");
        return nil;
    }

    
    bufGuard.resize( len, 0 );
    if ( 0 == len || bufGuard.empty() )
    {
        NSLog( @"Could not allocate memory. error!\n" );
        return nil;
    }
    buf = reinterpret_cast<char*>( &bufGuard[ 0 ] );
    
    
    if (sysctl(mib, MIB_SIZE, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = reinterpret_cast<struct if_msghdr *>( buf );
    sdl = reinterpret_cast<struct sockaddr_dl *>(ifm + 1);
    ptr = reinterpret_cast<unsigned char *>( LLADDR(sdl) );
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *) uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash stringFromMD5];
    
    return uniqueIdentifier;
}

- (NSString *) uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress stringFromMD5];
    
    return uniqueIdentifier;
}

@end
