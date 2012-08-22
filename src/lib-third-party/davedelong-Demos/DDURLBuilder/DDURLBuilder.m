//
//  DDURLBuilder.m
//  EmptyFoundation
//
//  Created by Dave DeLong on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDURLBuilder.h"



@implementation DDURLBuilder

-(NSString*)ddurlbuilder_percentEncode:(NSString*)string
{
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[string UTF8String];
    size_t sourceLen = strlen((const char *)source);
    for (size_t i = 0; i < sourceLen; ++i) 
    {
        const unsigned char thisChar = source[i];
        if ( thisChar == ' ' && !self.shouldEncodeSpaceAsHex )
        {
            [output appendString:@"+"];
        } 
        else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || 
                 (thisChar >= 'a' && thisChar <= 'z') ||
                 (thisChar >= 'A' && thisChar <= 'Z') ||
                 (thisChar >= '0' && thisChar <= '9')) 
        {
            [output appendFormat:@"%c", thisChar];
        }
        else 
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (id) URLBuilderWithURL:(NSURL *)url {
    return [[[self alloc] initWithURL:url] autorelease];
}

- (id) initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self->_queryValues = [[NSMutableDictionary alloc] init];
        [self setUsesSchemeSeparators:YES];
        if (url) {
            [self setURL:url];
        }
    }
    return self;
}

- (void)dealloc {
    [ self->_scheme release];
    [ self->_user release];
    [ self->_password release];
    [ self->_host release];
    [ self->_port release];
    [ self->_path release];
    [ self->_queryValues release];
    [ self->_fragment release];
    [super dealloc];
}

- (void) setURL:(NSURL *)URL {
    [self setScheme:[URL scheme]];
    [self setUser:[URL user]];
    [self setPassword:[URL password]];
    [self setPath:[URL path]];
    [self setHost:[URL host]];
    [self setFragment:[URL fragment]];
    [self setPort:[URL port]];
    
    NSString *absolute = [URL absoluteString];
    [self setUsesSchemeSeparators:([absolute hasPrefix:[NSString stringWithFormat:@"%@://", [self scheme]]])];
    
    [self->_queryValues removeAllObjects];
    NSString *query = [URL query];
    NSArray *components = [query componentsSeparatedByString:@"&"];
    for (NSString *component in components) {
        NSArray *bits = [component componentsSeparatedByString:@"="];
        if ([bits count] != 2) {
            NSLog(@"illegal query string component: %@", component);
            continue;
        }

        NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self addQueryValue:value forKey:key];
    }
}

- (NSURL *)URL {
    if ([self scheme] == nil || [self host] == nil) { return nil; }
    
    NSMutableString *urlString = [NSMutableString string];
    
    [urlString appendFormat:@"%@:", [self scheme]];
    if ([self usesSchemeSeparators]) {
        [urlString appendString:@"//"];
    }
    if ([self user]) {
        [urlString appendString: [ self ddurlbuilder_percentEncode: [self user] ]];
        if ([self password]) {
            [urlString appendFormat:@":%@", [ self ddurlbuilder_percentEncode: [self password] ] ];
        }
        [urlString appendString:@"@"];
    }
    
    [urlString appendString: [ self ddurlbuilder_percentEncode: [self host] ] ];
    if ([self port]) {
        [urlString appendFormat:@":%@", [self port]];
    }
    
    
    if ([self path]) {
        NSArray *pathComponents = [[self path] pathComponents];
        for (NSString *component in pathComponents) {
            if ([component isEqualToString:@"/"]) { continue; }
            [urlString appendFormat:@"/%@", [ self ddurlbuilder_percentEncode: component ] ];
        }
    }
    
    if ([ self->_queryValues count] > 0)
    {
        NSMutableArray *components = [NSMutableArray array];
        for (NSString *key in self->_queryValues )
        {
            NSArray *values = [ self->_queryValues objectForKey:key];
            key = [ self ddurlbuilder_percentEncode: key ];
            for (NSString *value in values) 
            {
                value = [ self ddurlbuilder_percentEncode: value ];
                NSString *component = [NSString stringWithFormat:@"%@=%@", key, value];
                [components addObject:component];
            }
        }
        NSString *queryString = [components componentsJoinedByString:@"&"];
        [urlString appendFormat:@"?%@", queryString];
    }
    
    if ([self fragment]) {
        [urlString appendFormat:@"#%@", [self fragment]];
    }
    
    return [NSURL URLWithString:urlString];
}

- (NSArray *) queryValuesForKey:(NSString *)key {
    if (key == nil) { return nil; }
    return [[[ self->_queryValues objectForKey:key] copy] autorelease];
}

- (void) addQueryValue:(NSString *)value forKey:(NSString *)key {
    if (value == nil || key == nil) { return; }
    NSMutableArray *values = [ self->_queryValues objectForKey:key];
    if (values == nil) {
        values = [NSMutableArray array];
        [ self->_queryValues setObject:values forKey:key];
    }
    [values addObject:value];
}

- (void) removeQueryValue:(NSString *)value forKey:(NSString *)key {
    if (value == nil || key == nil) { return; }
    NSMutableArray *values = [ self->_queryValues objectForKey:key];
    if (values) {
        [values removeObject:value];
    }
}

- (void) removeQueryValuesForKey:(NSString *)key {
    if (key == nil) { return; }
    [ self->_queryValues removeObjectForKey:key];
}

@end
