//
//  SCBaseItemRequest.m
//  SCApi
//
//  Created by Igor on 10/3/13.
//
//

#import "SCBaseItemRequest.h"

@implementation SCBaseItemRequest

#pragma mark filling parameters

-(SCItemSourcePOD *)itemSource
{
    if ( !self->_itemSource )
        self->_itemSource = [ SCItemSourcePOD new ];
    
    return self->_itemSource;
}

-(void)setSite:(NSString *)site
{
    self.itemSource.site = site;
}

-(void)setDatabase:(NSString *)database
{
    self.itemSource.database = database;
}

-(void)setLanguage:(NSString *)language
{
    self.itemSource.language = language;
}

-(void)setItemVersion:(NSString *)itemVersion
{
    self.itemSource.itemVersion = itemVersion;
}

#pragma mark reading parameters

-(NSString *)site
{
    return self.itemSource.site;
}

-(NSString *)database
{
    return self.itemSource.database;
}

-(NSString *)language
{
    return self.itemSource.language;
}

-(NSString *)itemVersion
{
    return self.itemSource.itemVersion;
}

@end
