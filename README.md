Sitecore Mobile SDK 2.1 for iOS
======================================

Sitecore Mobile SDK is a framework that is designed to help the developer produce iOS based applications that use and serve content that is managed by Sitecore. The framework offers both Objective-C and JavaScriptAPI that enable developers to rapidly develop applications utilising their existing IOS or web development skill sets. The SDK includes the following features:

 * Left-Right swipe navigation
 * Access to the camera and the photo library
 * QR code usage (scan and use QR Codes)
 * Accelerometer functions
 * Device information
 * Access to the built-in address book and easy creation of new contacts
 * Sending emails using the e-mail account
 * Social networks integration (Facebook, Twitter)
 * Mapping integration (with both Apple Maps and Google Maps)


The applications powered by this SDK support both **iOS 6** and **iOS 7**, and can request content from Sitecore efficiently and securely via [Sitecore Item Web API][2] RESTful web service.

You can also download a sample application that can be used as a starting point to understand the Mobile SDK for iOS and the features available. This project can be found in a corresponding [github repository][6]

Documentation, including installation and developer guides can be found on the [Sitecore Developer Network (SDN)][3]


## Framework Structure
The Sitecore Mobile SDK consists of three primary modules. They are

* **SitecoreMobileSDK.framework** – a set of core classes that interact with the [Sitecore Item Web Api][2] service.
* **SitecoreMobileJavaScript.framework** – a library that allows using native features of iOS in mobile optimized Sitecore renderings. It contains an **enhanced web view** and **web plug-ins**.
* **SitecoreMobileUI.framework** – UI extensions on top of **SitecoreMobileSDK.framework**. It contains a map view capable of building path and a self-loading image view.


The frameworks have some dependencies between each other. The dependencies are described in the following diagram :
![Framework Dependencies](https://github.com/Sitecore/sitecore-ios-sdk/raw/sdk2.0/resources-readme/FrameworkDependencies.png)


## The SDK includes the following features:

### Objective-C API to Access data from Sitecore CMS

* Authentication
* CRUD operations on items
* Access item fields and properties
* Upload media items
* Getting html rendering of an item

 

### JavaScript API
 * Show native alert
 * Left-Right swipe navigation
 * Accelerometer
 * Device information
 * Access to camera and media library
 * Share to social networks
 * Send emails
 * Access to the device address book
 * Mapping integration
 * Create calendar events
 * Upload media files to the Sitecore media library


### UI components
 * [Items Browser component][8] for browsing through content tree with customizable UI
 * QR Code reader
 * MapView with pathfinding features for **iOS 6**
 * Self-loading UIImageView category

As a part of the release we have created a sample application that can be used as a starting point to understand the Mobile SDK for iOS and the features available.  This project can be found [on Github][4]




## This repository contains:
 * Source code of the Sitecore SDK for iOS framework
 * Binaries of the Sitecore SDK for iOS framework in [releases section][7]



## Items Browser Component
Other extensions and components can be built on top of the Sitecore Mobile SDK for iOS. For example, we have a separate framework for the [Items Browser component][8]. For more details see

* The Items Browser component [repository][8]
* **“Sitecore Items Browser Component 1.0 for iOS”** documentation




## Further Information
 * [Product page on SDN][1]
 * [Sitecore Item Web API module page on SDN][2]
 * [API documentation on Github][5]
 * [Sample App – SDK for IOS][6]
 * [CocoaPods][9]

 
# Licence
```
SITECORE SHARED SOURCE LICENSE
```


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Sitecore/sitecore-ios-sdk/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


 [1]: http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Sitecore%20Mobile%20SDK%20for%20iOS.aspx
 [2]: http://sdn.sitecore.net/Products/Sitecore%20Item%20Web%20API.aspx
 [3]: http://sdn.sitecore.net/Products/Sitecore%20Mobile%20SDK/Sitecore%20Mobile%20SDK%20for%20iOS/Mobile%20SDK%201,-d-,2%20for%20iOS/Documentation.aspx
 [5]: http://sitecore.github.io/sitecore-ios-sdk/v2.0/
 [6]: https://github.com/Sitecore/sitecore-ios-sdk-sample
 [7]: https://github.com/Sitecore/sitecore-ios-sdk/releases
 [8]: https://github.com/sitecore/scitemsbrowser-ios
 [9]: http://cocoapods.org/?q=sitecore
