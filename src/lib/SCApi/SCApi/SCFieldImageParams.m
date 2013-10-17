#import "SCFieldImageParams.h"
#import "SCWebApiConfig.h"

@implementation SCFieldImageParams

-(id)init
{
    if (( self = [ super init ] ))
    {
        self.width              = -1;
        self.height             = -1;
        self.maxWidth           = -1;
        self.maxHeight          = -1;
        self.language           = nil;
        self.version            = nil;
        self.database           = nil;
        self.backgroundColor    = nil;
        self.disableMediaCache  = NO;
        self.allowStrech        = NO;
        self.scale              = -1;
        self.displayAsThumbnail = NO;
    }
    
    return self;
}

-(NSString *)paramsString
{
    NSMutableArray *args = [ NSMutableArray new ];
    
    if ( self.width >= 0 )
    {
        [ args addObject: [NSString stringWithFormat:@"w=%.f", self.width ] ];
    }
    
    if ( self.height >= 0 )
    {
        [ args addObject: [NSString stringWithFormat:@"h=%.f", self.height ] ];
    }
    
    if ( self.maxWidth >= 0 )
    {
        [ args addObject: [NSString stringWithFormat:@"mw=%.f", self.maxWidth ] ];
    }
    
    if ( self.maxHeight >= 0 )
    {
        [ args addObject: [NSString stringWithFormat:@"mh=%.f", self.maxHeight ] ];
    }
    
    if ( self.language )
    {
        [ args addObject: [NSString stringWithFormat:@"la=%@", self.language ] ];
    }
    
    if ( self.version )
    {
        [ args addObject: [NSString stringWithFormat:@"vs=%@", self.version ] ];
    }
    
    if ( self.database )
    {
        [ args addObject: [NSString stringWithFormat:@"db=%@", self.database ] ];
    }
    
    if ( self.backgroundColor )
    {
        [ args addObject: [NSString stringWithFormat:@"bc=%@", self.backgroundColor ] ];
    }

    if ( self.disableMediaCache )
    {
        [ args addObject: @"dmc=1" ];
    }
    
    if ( self.disableMediaCache )
    {
        [ args addObject: @"as=1" ];
    }
    
    if ( self.displayAsThumbnail )
    {
        [ args addObject: @"thn=1" ];
    }
    
    if ( self.scale >=0 )
    {
        [ args addObject: [NSString stringWithFormat:@"sc=%.2f", self.scale ] ];
    }
    
    if ( [ args count ] == 0 )
        return @"";
    
    SCWebApiConfig *config = [SCWebApiConfig webApiV1Config];
    NSString *separator = config.restArgSeparator;
    NSString *argsStart = config.restArgsStart;
    NSString *srgsString = [ args componentsJoinedByString: separator ];
    
    NSString *result = [ NSString stringWithFormat:@"%@%@", argsStart, srgsString ];
    
    return result;
}

@end
