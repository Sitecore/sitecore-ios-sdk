#import "SCField.h"


/**
 The SCRichTextField object identifies a Sitecore item's RichText field.
 Any field with [SCField type] is equal to "Rich Text" has the SCRichTextField type.
 
 The field contains text with HTML formatting.
 */
@interface SCRichTextField : SCField

/**
 The value of the field. [SCRichTextField fieldValue] is NSString object. It contains an HTML formatted string which is ready to present in UIWebView. All links to resources from the media library are valid.
 */
@property(nonatomic,readonly) NSString* fieldValue;


@end
