#import <Foundation/Foundation.h>
#import <SitecoreMobileSDK/SCParams.h>


/**
 SCDownloadMediaOptions class contains properties to configure image download.
 The options are the same as those for "Dynamic Media Parameters" and "sc:image" XSLT tag.
 */
@interface SCDownloadMediaOptions : SCParams



/**
 Width (in pixels)
 For example : "w=1024"
 
```
 mediaOptions.width = 1024;
```
 */
@property(nonatomic) float      width;



/**
 Height (in pixels)
 For example : "h=768" 
 
```
  mediaOptions.height = 768;
```
 */
@property(nonatomic) float      height;


/**
 MaxWidth (pixels) 
 For example : "mw=1920"
 
```
 mediaOptions.maxWidth = 1920;
```
 */
@property(nonatomic) float      maxWidth;


/**
 MaxHeight (pixels)
 For example : "mh=1080"
 
```
 mediaOptions.maxHeight = 1080;
```
 */
@property(nonatomic) float      maxHeight;



/**
 For example : "la=en"
 
```
 mediaOptions.language = @"en"
```
 */
@property(nonatomic) NSString   *language;



/**
 For example : "vs=latest"

```
 mediaOptions.version = @"latest";
```
 */
@property(nonatomic) NSString   *version;



/**
 Sitecore database where media file is stored.
 
 For example : "db=master"
 
```
 mediaOptions.database = @"master";
```
 */
@property(nonatomic) NSString   *database;



/**
 It accepts both human friendly color names 
 For example : "bc=cyan"
```
 mediaOptions.database = @"cyan";
```
 
 
 It also accepts [HTML colors](http://www.w3schools.com/html/html_colors.asp)
 Hex values are written as 3 double digit numbers, starting with a # sign.
 
 For example : #00FFFF, "bc=%2300FFFF"

```
 mediaOptions.database = @"%2300FFFF"; // cyan
```
 */
@property(nonatomic) NSString   *backgroundColor;



/**
 Tells the instance to not use the server side cache.
 Client side cache should be configured using SCApiSession or SCExtendedApiSession class.
 
 "dmc=1" - server cache disbled
 "dmc=0" - server cache enabled
 
 Default value is "NO"
 */
@property(nonatomic) BOOL       disableMediaCache;



/**
 If set to YES, the image will be resized. Otherwise it will be centered. Other space will be filled with the background color.
 See [SCDownloadMediaOptions backgroundColor] for details.

 "as=1" - stretching enabled
 "as=0" - stretching disabled

 
 Default value is "NO"
 */
@property(nonatomic) BOOL       allowStrech;




/**
 Scale factor for image resizing. 
 Set "1" for actual size.
 Set "0.25" to reduce the image size to 25% of the original one.
 You can also enlarge the image by setting positive values larger than "1"
 
 Negative values lead to undefined behaviour.
 */
@property(nonatomic) float      scale;




/**
 Reduces the image to the thumbnail size if set to YES.
 
 
 "as=1" - display as a thumbnail
 "as=0" - display in a full size
 */
@property(nonatomic) BOOL       displayAsThumbnail;


@end

