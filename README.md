# Sitecore Mobile SDK 1.1 for iOS

# Introduction

Sitecore Mobile SDK is a framework that is designed to help the developer produce iOS based applications that use and serve content that is managed by Sitecore. The framework offers both **Objective-C** and **JavaScript** API. This should enable you to **rapidly develop** iPhone applications utilizing phone features such as  

* Left-Right **swipe navigation**
* Access to the **camera** and the **photo library**
* Accelerometer
* Device information
* Access to the built-in **address book** and easy creation of new contacts
* Creating tweets through the system-wide twitter accounts
* Sending **e-mails** using the e-mail account
* **Social networks** integration (Facebook, Weibo) for iOS 6.0 and newer devices


The applications powered by this SDK can request content from Sitecore efficiently and securely via **Sitecore Item Web API** RESTful web service component.



This repository contains:

* Source code of the **Sitecore SDK for iOS** framework
* A [SampleApp](https://github.com/Sitecore/sitecore-ios-sdk/tree/master/src/app/SampleApp) project template 





# Download Links 
* Product page on SDN : <http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK.aspx>
* Landing page at github : <https://github.com/Sitecore/sitecore-mobile-sdk/>
* **Sitecore Item Web API** page on SDN : <http://sdn.sitecore.net/Products/Sitecore%20Item%20Web%20API.aspx>


```
License : SITECORE SHARED SOURCE LICENSE
```

***

## 1. The Mobile SDK Components
### 1.1 The Server

The Sitecore Mobile SDK server package contains components that allow you to use the iOS features in your website.
The Sitecore Mobile SDK server package requires:

* .Net Framework version 2.0 and later for the Application Pool of your website.
* Sitecore CMS version 6.5 or later.
* Sitecore Item Web API.

**Link to download** [Sitecore Mobile SDK demo](http://sdn.sitecore.net/downloads/MobileSDKDemoIos11.download) **package**

### 1.2 The Client

The client is an iOS project that contains the "SitecoreMobileSDK.framework". The framework provides an Objective-C API. You can use this API to access Sitecore content and use it in your application. The API also supports advanced features such as caching.

You can use the Mobile SDK to display the existing HTML presentation while having access to the native iOS hardware and software abilities. You can reuse the elements of the website and reduce the implementation cost. You can also use native Objective-C.

See the [landing page](https://github.com/Sitecore/sitecore-mobile-sdk/) for more details on how it works.


***
## 2. The Mobile SDK Installation

This chapter describes how to install the Mobile SDK components.
This chapter contains the following sections:

* Installing the Server Side Components
* Installing the Client Side Components


### 2.1 Installing the Server Side Components

```
You must install the Sitecore Item Web API service and the Mobile SDK components before you can access Sitecore content.
```

The Mobile SDK Demo for iOS is distributed as a Sitecore package. To install it, use the Sitecore Installation Wizard.
 After you install the package, in the web.config file, the < xslExtensions > section, add the following string:
 
**Example:**

```xml
	<xslExtensions>
	...
	<extension mode="on" type="Sitecore.XslHelpers.MobileExtensions, Sitecore.Mobile" namespace="http://www.sitecore.net/scmobile" />
	...
	</xslExtensions>
```	

**Now, you can use the Sitecore Mobile SDK server side component.**


```
Note :
￼￼The installation of Mobile SDK Demo for iOS package is optional. You can implement your own custom mobile renderings that use the native features of the device.

```


### 2.2 Installing the Client Side Components
To start the client side installation, you must have the SitecoreMobileSDK.framework bundle.
To use the Sitecore Mobile SDK framework in your application please follow steps below:

1) Create a simple XCode Single View Application project. For more information, see the Getting Started section in the Apple Developer Manual. If you have already created an XCode Single View Application project, you can skip this step.

2) Drag the SitecoreMobileSDK.framework bundle and drop it into the project's Frameworks source group.

![Finish](https://github.com/Sitecore/sitecore-ios-sdk/raw/master/resources/SitecoreMobileSDK.framework_bundle.png)

3) Add the -ObjC flag to the Other linker flag in the XCode Build Settings. For more
information, see the section Build Setting Reference in the Apple Developer Manual.

![Finish](https://github.com/Sitecore/sitecore-ios-sdk/raw/master/resources/OtherLinkerFlag.png)

4) Link the following frameworks to the project: 

* CFNetwork.framework 
* CoreMotion.framework
* CoreLocation.framework
* CoreMedia.framework
* CoreVideo.framework
* AddressBook.framework
* AudioToolbox.framework
* AddressBookUI.framework
* Twitter.framework
* MessageUI.framework
* MapKit.framework
* AVFoundation.framework
* Social.framework (optional)

5) Link the following libraries to the project: 

* libxml2.dylib
* libz.dylib
* libsqlite3.dylib
* libstdc++.dylib 
* libc++.dylib
* libiconv.dylib

```
For more information, see the section Linking to Library or Framework in the Project Editor Help in the Apple Developer Manual.
```

6) Add line - "#import <SitecoreMobileSDK/SitecoreMobileSDK.h>" to your project's *.pch or GCC_PREFIX_HEADER file. For more information, see the section Build Setting Reference in the Apple Developer Manual.

**Here is an example:**

```objc
	#ifdef __OBJC
    #import <SitecoreMobileSDK/SitecoreMobileSDK.h>
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #endif
```

## 3. Getting Started
### 3.1 Getting Started with the Embedded Browser
The Sitecore Mobile SDK contains the SCWebView classes that extend the WebView class with additional features such as sharing on Twitter and left-right swiping. For more information, see the chapter Using the Enhanced Web View Reference: [Mobile SDK documentation](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx).
You can use SCWebView in the same way as UIWebView, as all of their methods are similar. The following example illustrates how to use the SCWebView class:
	
```objc
	-(void)viewDidLoad
    {
        [super viewDidLoad];
        
        SCWebView* webView = [[SCWebView alloc] initWithFrame: self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        NSURL* url = [NSURL URLWithString: @"http://<host_name>/"];
        [webView loadURL: url];
        [self.view addSubview: webView];
    }
```	

You are now ready to use the SCWebView class. You can use the WebView enhancements, such as,
left-right swipes with any website that is displayed with SCWebView.
For example, if you want to browse to http://<host_name>/Home.aspx on the right swipe and to http://<host_name>/Products.aspx on the left swipe, you must turn on swiping and add the links to the web page as follows:

```html
	<html>
    <head>
        <link rel="scm-forward" href="http://<host_name>/Home.aspx" />
        <link rel="scm-back" href="http://<host_name>/Products.aspx" />
```	

Swiping is now enabled.
If you also want to use the browser's Back and Forward navigation controls, use SCWebBrowser instead of SCWebView. This is because SCWebBrowser inherits methods and properties of SCWebView and adds additional navigation controls.
For a complete list of the features that are available in the Embedded Web View, see the chapter Using the Enhanced Web View Reference: [Mobile SDK documentation](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx).
### 3.2 Getting Started with the Web API Service
To start working with the Web API service, you must create an XCode project and install the Sitecore Mobile SDK.
The following list is an overview of how to use the Web API service:
#### Establish an anonymous session for a website

```objc
	SCApiContext *context = [SCApiContext contextWithHost: @"<host_name>/-/item"];
```

Use the [SCApiContext itemReaderForItemPath:] and [SCApiContext
itemReaderForItemId:] methods to read the item with the item's path and ID, for example:

#### Get a single item

Now, use the SCApiContext object to access the required items and fields.
For more information, see the section Installing the Client Side. [Mobile SDK documentation](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx)

```objc
	//Read an item with path
	[context itemReaderForItemPath: @"/sitecore/content/MyItem"](^(id result, NSError *error)
	{
	    SCItem* item = result;
	    NSLog(@"item display name: %@", item.displayName);
	} );
```

**For more information, see the section Accessing an Item.** [Mobile SDK documentation](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx)

#### Get the main properties of the item

Use the Web API service to get the items and the following properties:

* DisplayName
* ID
* LongID
* Path
* Template

Use the SCItem class to access these properties:

  Property   |         Class         |
------------ | --------------------- |
 DisplayName | [SCItem displayName]  |
     ID      | [SCItem itemId]       |
   LongID    | [SCItem longID]       |
    Path     | [SCItem path]         |
  Template   | [SCItem itemTemplate] |


For example, the following method shows the item’s display name in the console:
	NSLog(@"item display name: %@", item.displayName);

**For more information about the properties of the SCItem class, see the section Requirements to
Access an Item.** [Mobile SDK documentation](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx)

The SCItem object may contain some or all Sitecore item's fields according to the type value of the
[SCItemsReaderRequest fieldNames] property of the request.
The fieldNames property of the request can be of type: nil, empty set, or set of strings.

* If the type is nil, all the fields are read for the item.
* If the type is empty set, only the item is read without the fields.
* If the type is set of field names, only the fields in the set are read.

	Note:
    To read a field, its Read property must be set to Allow in the Field Remote Read security settings of Sitecore.

**For more information, see the section Accessing the Fields of an Item.** [Mobile SDK documentation ](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx)

#### Get the item’s children

You must use the [SCApiContext itemsReaderWithRequest:] method to load an item and its children:

*1. Create an SCItemsReaderRequest object that contains the set of parameters:*
```objc
	SCItemsReaderRequest *request = [SCItemsReaderRequest new];
    //The path of item
    request.request = @"/sitecore/content/MyItem";
    //Specifies the type of request option, now item path used
    request.requestType = SCItemReaderRequestItemPath;
    //Specifies the set of the items which will be loaded. Here item and its children will be loaded
    request.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
    ￼//The set of the field’s names which will be read with each item. Here no fields will be read.
    request.fieldNames = [NSSet set];
```

*2. Load the items with the created request object:*
```objc
	[context itemsReaderWithRequest: request](^(id result, NSError *error)
    {
        //result - is NSArray object where fist element is item and left items - its children
        SCItem *item = [result objectAtIndex:0];
        NSLog(@"item display name: %@", item.displayName);
        for (NSUInteger index = 1; index < [result count]; ++index)
        {
            SCItem *child = [result objectAtIndex:index];
            NSLog( @"child display name: %@", child.displayName);
        }
    });
```

**For more information, see the section Accessing the Children of an Item.** [Mobile SDK documentation](http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Mobile%20SDK%201,-d-,1/Documentation.aspx)


### 3.3 Combining the Embedded Browser and the Web API Service

You can retrieve Sitecore content, and use it in both the Xcode Web View controls and the embedded browser. This example describes how to create a Tab Bar menu that contains the Sitecore items, titles, and icons and then load the web page in a web browser for each item.

The following procedure describes this scenario:

*1. Install the Sitecore Mobile SDK.*

*2. Create an XCode project.*

*3. Extend the project with the following code:*


	
```objc
	// ViewController.m

	@interface BrowserViewController : UIViewController
	
	@property ( nonatomic, retain ) NSString* urlString;
	
	@end
	
	@implementation BrowserViewController
	
	@synthesize urlString;
	
	-(SCWebBrowser*)webView
	{
	    return (SCWebBrowser*)self.view;
	}
	-(void)loadView
	{
	    self.view = [SCWebBrowser new];
	}
	- (void)viewDidLoad
	{
	    SCApiContext* context_ = [ SCApiContext contextWithHost: @"<host_name>/-/item" ];
	    
        NSMutableArray *listOfViewControllers = [NSMutableArray new];
		SCItemsReaderRequest *request = [SCItemsReaderRequest new];
		request_.request = @"/sitecore/content/MyItem/*[@@templatename='Site Section']";
		request_.requestType = SCItemReaderRequestQuery;
		request_.fieldNames = [ [ NSSet alloc ] initWithObjects: @"Title", @"Tab Icon", nil ];
		request_.flags = SCItemReaderRequestReadFieldsValues;
		
		[ context itemsReaderWithRequest: request ]( ^( id result, NSError* error_ )
	    {
	        for (SCItem* item in result)
	        {
	            NSString* title = [item fieldValueWithName: @"Menu title"];
	            UIImage* icon = [item fieldValueWithName: @"Tab Icon"];
	            BrowserViewController* viewController = [BrowserViewController new];
	            viewController.title = title;
	            viewController.tabBarItem.image = icon;
	            [listOfViewControllers addObject: viewController];
	        }
	        [self performSegueWithIdentifier: @"showTabBar" sender: self];
	        UITabBarController *tabBar = (UITabBarController*)self.modalViewController;
	        [tabBar setViewControllers:listOfViewControllers animated:YES];
	        
	        ￼NSURL* url = [NSURL URLWithString: self.urlString ]; 
            [self.webView loadURL: url];
	    } );
	}
```

*5. Build and run the application*

![Embedded Browser](https://github.com/Sitecore/sitecore-ios-sdk/raw/master/resources/EmbeddedBrowser.png)
