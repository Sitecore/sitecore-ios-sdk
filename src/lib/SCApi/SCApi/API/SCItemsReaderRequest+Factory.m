#import "SCItemsReaderRequest+Factory.h"

#import "SCApiContext.h"
#import "SCEditItemsRequest.h"
#import "SCExtendedApiContext.h"

@implementation SCItemsReaderRequest (Factory)

-(SCItemsReaderRequest*)itemsReaderRequestWithApiContext:( SCExtendedApiContext* )context_
{
    SCItemsReaderRequest* result_ = [ self copy ];
 
    result_.language        = result_.language ?: context_.defaultLanguage;
    result_.database        = result_.database ?: context_.defaultDatabase;
    result_.site            = result_.site     ?: context_.defaultSite    ;
    
    result_.lifeTimeInCache = self.lifeTimeInCache;
    
    if ( 0.0 == result_.lifeTimeInCache )
    {
        result_.lifeTimeInCache = context_.defaultLifeTimeInCache;
    }

    return result_;
}

@end

@implementation SCEditItemsRequest (Factory)

-(SCItemsReaderRequest*)itemsReaderRequestWithApiContext:( SCExtendedApiContext* )context_
{
    SCEditItemsRequest* result_ = (SCEditItemsRequest*)[ super itemsReaderRequestWithApiContext: context_ ];

    NSArray* allFieldsNamesToEdit_ = [ self.fieldsRawValuesByName allKeys ];
    result_.fieldNames = [ [ NSSet alloc ] initWithArray: allFieldsNamesToEdit_ ];

    return result_;
}

@end
