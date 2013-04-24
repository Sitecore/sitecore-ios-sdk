#import "SCContentApiCreateItem.h"


#import "NSDictionary+SCItemFieldsWithURLParam.h"
#import "NSArray+scItemsToJSON.h"

#include "createMediaItem.js.h"

#import <UIKit/UIKit.h>

static NSTimeInterval imageCachePeriod_ = 60*60*24.;

@interface SCApiContext (SCContentApiCreateItem)

-(JFFAsyncOperation)mediaItemCreatLoaderWithRequest:( SCCreateMediaItemRequest* )createMediaItemRequest_;
-(JFFAsyncOperation)editItemsLoaderWithRequest:( SCEditItemsRequest* )request_;

@end

@implementation SCContentApiCreateItem
{
    NSURLRequest* _request;
    NSString    * _location;
    NSString    * _login;
    NSString    * _password;
    NSString    * _database;
    NSString    * _folder;
    NSString    * _itemName;
    NSURL       * _imageUrl;
    CGFloat       _compressionQuality;
    NSDictionary* _fields;
}

+(BOOL)canInitWithRequest:( NSURLRequest* )request_
{
    return [ request_.URL.path isEqualToString: @"/scmobile/contentapi/create_media_item" ];
}

-(id)initWithRequest:( NSURLRequest* )request_
{
    self = [ super init ];

    if ( self )
    {
        self->_request = request_;
    }

    return self;
}

+(NSString*)pluginJavascript
{
    return [ [ NSString alloc ] initWithBytes: __SCWebContentApi_createMediaItem_js
                                       length: __SCWebContentApi_createMediaItem_js_len
                                     encoding: NSUTF8StringEncoding ];
}

-(JFFAsyncOperation)imageLoaderForURLString:( NSString* )urlString_
{
    return imageLoaderForURLString( urlString_, imageCachePeriod_ );
}

-(JFFAsyncOperationBinder)createItemWithImage
{
    return ^JFFAsyncOperation( id image_ )
    {
        SCApiContext* context_ = [ SCApiContext contextWithHost: self->_location
                                                          login: self->_login
                                                       password: self->_password ];

        context_.defaultDatabase = self->_database;

        SCCreateMediaItemRequest* request_ = [ SCCreateMediaItemRequest new ];
        request_.itemName     = self->_itemName;
        request_.itemTemplate = @"System/Media/Unversioned/Image";

        NSData* imageData_ = UIImageJPEGRepresentation( image_, self->_compressionQuality );
        request_.mediaItemData = imageData_;

        NSString* fileName_  = [ self->_imageUrl.path lastPathComponent ];
        request_.fileName    = fileName_?:@"defaulFileName.jpg";
        request_.contentType = @"image/jpeg";
        request_.folder      = self->_folder;
        request_.fieldNames  = [ NSSet new ];

        return [ context_ mediaItemCreatLoaderWithRequest: request_ ];
    };
}

-(JFFAsyncOperationBinder)editItem
{
    return ^JFFAsyncOperation( SCItem* itemPtr_ )
    {
        if ( [ self->_fields count ] == 0 )
        {
            id result_ = [ [ NSArray alloc ] initWithObjects: itemPtr_, nil ];
            return asyncOperationWithResult( result_ );
        }

        SCItem* item_ = itemPtr_;

        SCApiContext* context_ = [ SCApiContext contextWithHost: self->_location
                                                          login: self->_login
                                                       password: self->_password ];

        SCEditItemsRequest* request_ = [ SCEditItemsRequest requestWithItemId: item_.itemId ];

        request_.fieldsRawValuesByName = self->_fields;

        return [ context_ editItemsLoaderWithRequest: request_ ];
    };
}

-(void)createMediaItemWithImagePath:( NSString* )imagePath_
{
    JFFAsyncOperation imageLoader_ = [ self imageLoaderForURLString: imagePath_ ];

    JFFAsyncOperation loader_ = bindSequenceOfAsyncOperations( imageLoader_
                                                              , [ self createItemWithImage ]
                                                              , [ self editItem ]
                                                              , nil );

    loader_( nil, nil, ^( NSArray* items_, NSError* error_ )
    {
        NSString* message_;

        if ( items_ )
        {
            NSDictionary* json_ = [ NSDictionary dictionaryWithObject: [ items_ scItemsToJSON ]
                                                               forKey: @"items" ];

            NSData* data_ = [ NSJSONSerialization dataWithJSONObject: json_
                                                             options: NSJSONWritingPrettyPrinted
                                                               error: nil ];

            if ( data_ )
            {
                message_ = [ [ NSString alloc ] initWithBytes: data_.bytes
                                                       length: data_.length
                                                     encoding: NSUTF8StringEncoding ];
            }
            else
            {
                message_ = [ [ NSString alloc ] initWithFormat: @"{ error: 'Can not serialize the JSON object' }" ];
            }
        }
        else
        {
            message_ = [ [ NSString alloc ] initWithFormat: @"{ error: '%@' }", [ error_ description ] ];
        }

        [ self.delegate sendMessage: message_ ];
        [ self.delegate close ];
    } );
}

-(void)setCompressionQualityForArgs:( NSDictionary* )args_
{
    CGFloat compressionQuality_ = [ [ args_ firstValueIfExsistsForKey: @"compressionQuality" ] floatValue ];
    if ( compressionQuality_ <= 0.f || compressionQuality_ > 1.f )
    {
        compressionQuality_ = 1.f;
    }
    self->_compressionQuality = compressionQuality_;
}

-(void)didOpenInWebView:( UIWebView* )webView_
{
    NSDictionary* args_  = [ self->_request.URL queryComponents ];
    NSString* imagePath_ = [ args_ firstValueIfExsistsForKey: @"imageUrl" ];

    NSString* location_  = [ args_ firstValueIfExsistsForKey: @"location" ];
    self->_location = [ [ NSString alloc ] initWithFormat: @"%@/-/item", location_ ];

    self->_login    = [ args_ firstValueIfExsistsForKey: @"login"    ];
    self->_password = [ args_ firstValueIfExsistsForKey: @"password" ];
    self->_database = [ args_ firstValueIfExsistsForKey: @"database" ];
    self->_folder   = [ args_ firstValueIfExsistsForKey: @"path"     ];
    self->_itemName = [ args_ firstValueIfExsistsForKey: @"itemName" ];

    [ self setCompressionQualityForArgs: args_ ];

    //STODO remove stringByReplacingPercentEscapesUsingEncoding
    NSString* newImagePath_ = [ imagePath_ stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
    newImagePath_ = [ newImagePath_ stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
    self->_imageUrl = [ NSURL URLWithString: newImagePath_ ];

    NSString* fields_ = [ args_ firstValueIfExsistsForKey: @"fields" ];
    self->_fields = [ NSDictionary scItemFieldsWithURLParam: fields_ ];

    [ self createMediaItemWithImagePath: imagePath_ ];
}

@end
