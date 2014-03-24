# Version 2.0

## New features:
* Mobile SDK for iOS has been split into 3 parts: 
	* SitecoreMobileSDK
	* SitecoreMobileJavaScript
	* SitecoreMobileUI

* Sample application has been extended with new features

* Public API classes and methods have been renamed for consistency with android SDK.
Full list of renaming can be found at the [Renaming.md](<https://github.com/Sitecore/sitecore-ios-sdk/blob/sdk2.0/Renaming.md>) file.

* Items browser UI component has been implemented

* Added posibility to specify custom path for media library


## Issues resolved:

* Field names are case insensitive now
* removeItem method fixed for case, when database was changed in APISession
* Fixed crash on 64 bit architecture

----------------------

# Version 1.2

## New features:
 * Apple iOS7 is now supported (in addition to iOS 6)
 	* All existing SDK APIs have been reviewed, fixed and tested against the iOS 7
 * New features from iOS 7 incorporated into the JavaScript libraries;
 	* Apple Mapping support (including 3D Maps)
 	* Updated Calendar features 
 * Updated Item Manipulation features
 	* Cancel and progress support for item manipulation operations 
 	* Image scaling options support 
 * As a part of the update we have created a [sample application](https://github.com/Sitecore/sitecore-ios-sdk-sample) that can be used as a starting point to understand the Mobile SDK for iOS and the features available. These include examples of;
 	* Authentication request (to Sitecore instance)
 	* Mapping (Apple Maps and Path-finding) 
 	* Web View (example integration with a Sitecore instance)
 	*  Manipulating Sitecore content through the Sitecore Item Web API
 	* Social network sharing 
 	* Email (Creating and Sending)
 	* Device information retrieval (Camera, Accelerometer, Hardware)
 	* Contacts (create and add contact information locally)
 	* QR code (Scan and use QR codes)
 	* Air Drop (Share local items through Air Drop)

## Issues resolved:
A large number of bugs have been resolved;
 * [Issue #3369] Considering SCItem and SCField item's source parameters (database, language, version) has been added.
 * [Issue #2796] “Site" parameter for request to define what site we want access to is added.
 * [ [Issue #3443] ](https://github.com/Sitecore/sitecore-ios-sdk/issues/18) Using UIWebView control to render text from RichText Field with internal links to media items


# Version 1.1


## New features:

### 1. JavaScript API
* Triggering **page events**
* Triggering **campaigns**
* **Social networks** integration (Facebook, Weibo) for iOS 6.0 and newer devices

### 2. Objective-C API
* Triggering **page events**
* Triggering **campaigns**


## Bugfixes:

* [Demo Package Is not backward compatible with .NET 2.0](https://github.com/Sitecore/sitecore-ios-sdk/issues/16)
* [Nicam App Crash when pressing back button](https://github.com/Sitecore/sitecore-ios-sdk/issues/14)

----------------------


# Version 1.0 (Initial Commit)

## Features:


### 1. JavaScript API
* Left-Right **swipe navigation**
* Access to the **camera** and the **photo library**
* Accelerometer
* Device information
* Access to the built-in **address book** and easy creation of new contacts
* Creating tweets through the system-wide twitter accounts
* Sending **e-mails** using the e-mail account



### 2. Objective-C API

* Accessing data from Sitecore CMS
	* CRUD
	* caching
	* security
	* paging
	* sitecore **queries** and **fast queries** support
* Enchanced Google Maps navigation
* QR code scanner

----------------------

