# Sitecore Mobile SDK ver. 1.0.0

# Introduction

Sitecore Mobile SDK is a framework that is designed to help the developer produce iOS based applications that use and serve content that is managed by Sitecore. This should enable you to rapidly develop iPhone applications utilizing the full phone features (camera, location, accelerometer and gestures for example). The applications can then request content from Sitecore efficiently and securely.

Details on what is contained in the Sitecore package and the iOS project template and libraries can be found below.

The framework comes with a sample project that makes it very easy to start writing apps, along with comprehensive developer documentation, and several sample projects, including the iPhone/iPad application based on the Nicam demonstration site.

The Mobile SDK requires Sitecore Item Web API to be installed on the server. Web API is a new Sitecore REST-style web service that outputs JSON, that enables the mobile applications to get content from Sitecore efficiently and securely. However this service is also useful for many other purposes outside of iOS development, including Android/Windows Phone development and even desktop apps and tools, and for this reason it is packaged and documented separately. Please see the Chapter 1 below for a download link.

Please follow these chapters for more details:

* **The Mobile SDK Components** This chapter contains a brief description for the components of the Sitecore Mobile SDK.
* **The Mobile SDK Installation** This chapter describes how to install the Mobile SDK on the client and the server sides.
* **Getting Started** This chapter describes requirements and procedures to start using the Mobile SDK.

**Link to download complete** [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_SC65-66-USLetter.pdf)

License : SITECORE SHARED SOURCE LICENSE

***

## 1. The Mobile SDK Components
### 1.1 The Server

The Sitecore Mobile SDK server package contains components that allow you to use iOS features in your website.

The Sitecore Mobile SDK server package requires:

* .Net Framework version 2.0 and later for the Application Pool of your website.
* Sitecore CMS version 6.5 or later.

**Link to download** [Sitecore Mobile SDK server](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/Mobile%20SDK%20Server%20Package-1.0.0%20rev.%20120906.zip) **package**

The Mobile SDK API is called the "Sitecore Item Web API" and is web service based. This web service is designed with the REST principles to make the Sitecore content accessible through HTTP requests in the JSON format.

The Web API supports accessing the content through items paths, IDs, or by running queries. The output produced by the service is highly customizable and optimized to reduce the number of requests.

**Link to download** [Sitecore Item Web API](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/Sitecore%20Item%20Web%20API%201.0.0%20rev.%20120810.zip) **package**

**Link to download** [Sitecore Item Web API PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/Sitecore_Web_API_User_Guide_USLetter.pdf) **documentation**

### 1.2 The Client

The client is an iOS project that contains the "SitecoreMobileSDK.framework" that provides an Objective-C API. You can use this API to access Sitecore content through the web service and use this content in your application. The API also supports advanced features such as caching.

You can use the Mobile SDK to display the existing HTML presentation while having access to the native iOS hardware and software abilities. You can reuse the elements of the website and reduce the implementation cost. You can also use native Objective-C.

The list of native features available in HTML environment includes:

* Left-Right swipe navigation.
* Access to the camera and the photo library.
* Accelerometer data.
* Device information.
* Access to the contact list and easy creation of new contacts.
* Creating tweets through the system-wide twitter accounts
* Sending email messages using the email account

**Link to download** [SitecoreMobileSDK.framework](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SitecoreMobileSDK.framework-ver.1.0.0%20rev.120625.zip)

***
## 2. The Mobile SDK Installation

This chapter describes how to install the Mobile SDK components.
This chapter contains the following sections:

* Installing the Server Side Components
* Installing the Client Side Components


### 2.1 Installing the Server Side Components
##### 2.1.1 Installing the Sitecore Item Web API Service
Use the Sitecore Installation Wizard to install the Sitecore Item Web API service:

1. Log in to the Sitecore Desktop.
2. Click Sitecore, Development Tools, Installation Wizard. The wizard will guide you through the installation process.
3. In the Select Package dialog box, specify the package that you want to install.
4. Click Browse to locate the package or click Upload to upload the package. The folder, to which the packages are uploaded, is specified in the web.config file.
5. In the License Agreement dialog box, accept the license agreement.
6. In the Ready to Install dialog box, you can review the package information and then click
Install.
7. When the installation is complete, you can choose to restart the Sitecore client or the Sitecore server and then click Finish. To test that the Sitecore Item Web API Service is working, make a simple request to the service.
8. In a browser, enter the URL: http://yoursite/-/item/v1/sitecore/Content/Home.
![simple request](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/SimpleRequest.png)
9. If you want to create/edit/remove items using Sitecore Item Web Api, you need to disable WebDav: (see 'WebDAV.Enabled' setting in Sitecore.WebDAV.config)

##### 2.1.2 Installing the Sitecore Mobile SDK server package

Use the Sitecore Installation Wizard to install the Sitecore "Mobile SDK server package" on the server side:

1. Log in to the Sitecore Desktop.
2. Click Sitecore, Development Tools, Installation Wizard.
The wizard will guide you through the installation process.
3. In the Select Package dialog box, specify the package that you want to install.
4. Click Browse to browse for an existing package or Upload to upload a new one.
5. In the Ready to Install dialog box, you can review the package information and then click
Install.
6. When the installation is complete, you can choose to restart the Sitecore client or the Sitecore server and then click Finish.
7. After package installation add the following string to < xslExtensions > section of web.config file:

**Example:**

	<xslExtensions>
	...
	<extension mode="on" type="Sitecore.XslHelpers.MobileExtensions, Sitecore.Mobile" namespace="http://www.sitecore.net/scmobile" />
	...
	</xslExtensions>

**Now, you can use the Sitecore Mobile SDK server side component.**

### 2.2 Installing the Client Side Components
To start the client side installation, you must have the SitecoreMobileSDK.framework bundle.
##### 2.2.1 Installing the Sitecore Mobile SDK server package
To use the Sitecore Mobile SDK framework in your application:

1. Create a simple XCode Single View Application project. For more information, see the Getting Started section in the Apple Developer Manual. If you have already created an XCode Single View Application project, you can skip this step.
2. Drag the SitecoreMobileSDK.framework bundle and drop it into the project's Frameworks source group.
![Finish](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/SitecoreMobileSDK.framework_bundle.png)
3. Add the -ObjC flag to the Other linker flag in the XCode Build Settings. For more
information, see the section Build Setting Reference in the Apple Developer Manual.
![Finish](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/OtherLinkerFlag.png)
4. Link the following frameworks to the project: ***CFNetwork.framework***, ***CoreMotion.framework***, ***CoreLocation.framework***, ***CoreMedia.framework***, ***CoreVideo.framework***, ***AddressBook.framework***, ***AudioToolbox.framework***, ***AddressBookUI.framework***, ***Twitter.framework***, ***MessageUI.framework***, ***MapKit.framework***, ***AVFoundation.framework***. For more information, see the section Linking to Library or Framework in the Project Editor
Help in the Apple Developer Manual.
5. Link the following libraries to the project: ***libxml2.dylib***, ***libz.dylib***, ***libsqlite3.dylib***, ***libstdc++.dylib***, ***libc++.dylib***, ***libiconv.dylib*** For more information, see the section Linking to Library or Framework in the Project Editor Help in the Apple Developer Manual.
6. Add line - "#import <SitecoreMobileSDK/SitecoreMobileSDK.h>" to your project's *.pch or GCC_PREFIX_HEADER file. For more information, see the section Build Setting Reference in the Apple Developer Manual.

**Here is an example:**

	#ifdef __OBJC
    #import <SitecoreMobileSDK/SitecoreMobileSDK.h>
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #endif

## 3. Getting Started
### 3.1 Models of Working with the Mobile SDK
There are three models that you can apply to make your application work with the Sitecore Mobile SDK:

* Embedded Browser – If you already have a website that is running on Sitecore and optimized for the mobile application, you must use the website presentation. Then, you can display the embedded browser window inside your application. The native device features are typically unavailable in a normal website but you can access them through a set of HTML and Javascript APIs. For more information about this approach, see the section Getting Started with the Embedded Browser.
* Web API – If you are familiar with Objective-C development, you can use the native code to develop all or part of your application and access the content in Sitecore to get all benefits of the Sitecore CMS. For more information about Objective-C API, see the section Getting Started with the Web API Service.
* Creating a Hybrid of the Embedded Browser and the Web API – For example, you can use the native code and UI elements for parts of the screen, such as the standard navigation elements like the tab bar and the navigation bar, and use the embedded browser to display your content. For more information about this approach, see the section Combining the Embedded Browser and the Web API Service.

### 3.2 Getting Started with the Embedded Browser
The Sitecore Mobile SDK contains the SCWebView classes that extend the WebView class with additional features such as sharing on Twitter and left-right swiping. For more information, see the chapter Using the Enhanced Web View Reference: [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf).
You can use SCWebView in the same way as UIWebView, as all of their methods are similar. The following example illustrates how to use the SCWebView class:
	
	
	-(void)viewDidLoad
    {
        [super viewDidLoad];
        
        SCWebView* webView = [[SCWebView alloc] initWithFrame: self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        NSURL* url = [NSURL URLWithString: @"http://mobilesdk.sc-demo.net/"];
        [webView loadURL: url];
        [self.view addSubview: webView];
    }

You are now ready to use the SCWebView class. You can use the WebView enhancements, such as,
left-right swipes with any website that is displayed with SCWebView.
For example, if you want to browse to http://mobilesdk.sc-demo.net/Nicam.aspx on the right swipe and to http://mobilesdk.sc-demo.net/Products.aspx on the left swipe, you must turn on swiping and add the links to the web page as follows:

	<html>
    <head>
        <link rel="scm-forward" href="http://mobilesdk.sc-demo.net/Nicam.aspx" />
        <link rel="scm-back" href="http://mobilesdk.sc-demo.net/Products.aspx" />

Swiping is now enabled.
If you also want to use the browser's Back and Forward navigation controls, use SCWebBrowser instead of SCWebView. This is because SCWebBrowser inherits methods and properties of SCWebView and adds additional navigation controls.
For a complete list of the features that are available in the Embedded Web View, see the chapter Using the Enhanced Web View Reference: [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf).
### 3.3 Getting Started with the Web API Service
To start working with the Web API service, you must create an XCode project and install the Sitecore Mobile SDK.
The following list is an overview of how to use the Web API service:
#### Establish an anonymous session for a website

	SCApiContext *context = [SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item"];

Use the [SCApiContext itemReaderForItemPath:] and [SCApiContext
itemReaderForItemId:] methods to read the item with the item's path and ID, for example:

#### Get a single item

Now, use the SCApiContext object to access the required items and fields.
For more information, see the section Installing the Client Side. [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf)

	//Read an item with path
	[context itemReaderForItemPath: @"/sitecore/content/nicam"](^(id result, NSError *error)
	{
	    SCItem* item = result;
	    NSLog(@"item display name: %@", item.displayName);
	} );

**For more information, see the section Accessing an Item.** [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf)

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
Access an Item.** [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf)

The SCItem object may contain some or all Sitecore item's fields according to the type value of the
[SCItemsReaderRequest fieldNames] property of the request.
The fieldNames property of the request can be of type: nil, empty set, or set of strings.

* If the type is nil, all the fields are read for the item.
* If the type is empty set, only the item is read without the fields.
* If the type is set of field names, only the fields in the set are read.

	Note:
    To read a field, its Read property must be set to Allow in the Field Remote Read security settings of Sitecore.

**For more information, see the section Accessing the Fields of an Item.** [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf)

#### Get the item’s children

You must use the [SCApiContext itemsReaderWithRequest:] method to load an item and its children:

*1. Create an SCItemsReaderRequest object that contains the set of parameters:*
	
	SCItemsReaderRequest *request = [SCItemsReaderRequest new];
    //The path of item
    request.request = @"/sitecore/content/Nicam";
    //Specifies the type of request option, now item path used
    request.requestType = SCItemReaderRequestItemPath;
    //Specifies the set of the items which will be loaded. Here item and its children will be loaded
    request.scope = SCItemReaderSelfScope | SCItemReaderChildrenScope;
    ￼//The set of the field’s names which will be read with each item. Here no fields will be read.
    request.fieldNames = [NSSet set];

*2. Load the items with the created request object:*
	
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

**For more information, see the section Accessing the Children of an Item.** [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf)

#### Use the children of a particular item to populate the tab bar

You must use the SCItemsReaderRequest class with the SCItemReaderRequestReadFieldsValues flag and the SCItemReaderChildrenScope scope to load the field values of the item’s children.

To populate the tab bar:

1. Create an XCode Single View Application project.
2. Install the Sitecore Mobile SDK. For more information about installing the Mobile SDK, see the chapter The Mobile SDK Installation.
3. Add a Tab Bar Controller to the project – in the implementation of ViewController

Then add the following code:


	- (void)viewDidLoad
    {
        [super viewDidLoad];
        NSMutableArray *listOfViewControllers = [NSMutableArray new];
        SCApiContext *session = [SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item"];
        NSSet* fieldNames = [NSSet setWithObjects: @"Menu title", @"Tab Icon", nil ];
        SCItemsReaderRequest* request_ = [SCItemsReaderRequest requestWithItemPath: @"/sitecore/content/Nicam/"
    ￼    fieldsNames: fieldNames];
        request_.flags = SCItemReaderRequestReadFieldsValues; //to read field values
        request_.scope = SCItemReaderChildrenScope; //to read children of the item
        [session itemsReaderWithRequest: request_](^(id result, NSError *errors)
        {
            for (SCItem* item in result)
            {
                NSString* title = [item fieldValueWithName: @"Menu title"];
                UIImage* icon = [item fieldValueWithName: @"Tab Icon"];
                UIViewController* viewController = [UIViewController new];
                viewController.title = title;
                viewController.tabBarItem.image = icon;
                [listOfViewControllers addObject: viewController];
            }
            [self performSegueWithIdentifier: @"showTabBar" sender: self];
            UITabBarController* tabBar = (UITabBarController*)self.modalViewController;
            [tabBar setViewControllers:listOfViewControllers animated:YES];
        });
    }

**For more information, see the section Populating the Tab Bar.** [Mobile SDK documentation PDF](https://github.com/downloads/Sitecore/sitecore-mobile-sdk/SC_Mobile_SDK_Developer_Guide_100_USLetter.pdf)

### 3.4 Combining the Embedded Browser and the Web API Service

You can retrieve Sitecore content, and use it in both the Xcode Web View controls and the embedded browser. This example describes how to create a Tab Bar menu that contains the Sitecore items, titles, and icons and then load the web page in a web browser for each item.

The following procedure describes this scenario:

*1. Install the Sitecore Mobile SDK.*

*2. Create an XCode project.*

*3. Create a tab bar menu. For more information about creating a tab bar menu, see the chapter "Populating the Tab Bar".*

*4. Extend the project with the following code:*

	ViewController.m
	
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
	    SCApiContext* context_ = [ SCApiContext contextWithHost: @"mobilesdk.sc-demo.net/-/item" ];
	    
        NSMutableArray *listOfViewControllers = [NSMutableArray new];
		SCItemsReaderRequest *request = [SCItemsReaderRequest new];
		request_.request = @"/sitecore/content/Nicam/*[@@templatename='Site Section']";
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
	    } );
	}

*5. Build and run the application*

![Embedded Browser](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/EmbeddedBrowser.png)