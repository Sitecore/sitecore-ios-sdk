# Sitecore's Mobile SDK ver. 1.0

# Introduction

**Sitecore Mobile SDK is a framework that is designed to help developers produce iOS based applications that use and serve the Sitecore content.**

**This guide describes the Sitecore Mobile SDK Framework should be useful for developers who are looking for information about the framework’s API.**

**Please follow this chapters for more details:**

* **The Mobile SDK Components** This chapter contains a brief description for the components of the Sitecore Mobile SDK.
* **The Mobile SDK Installation** This chapter describes how to install the Mobile SDK on the client and the server sides.
* **Getting Started** This chapter describes requirements and procedures to start using the Mobile SDK.

**TODO Link to download complete "Mobile SDK documentation PDF file"**

***

## 1. The Mobile SDK Components
### 1.1 The Server

**The Sitecore Mobile SDK server package contains components that allow you to use iOS features in your website.**

**The Sitecore Mobile SDK server package requires:**

* **.Net Framework version 4.0 for the Application Pool of your website.**
* **Sitecore CMS version 6.5 or later.**

**TODO Link to download  "Sitecore Mobile SDK server package"**

**The Mobile SDK API is called the "Sitecore Web API" and is web service based. This web service is designed with the REST principles to make the Sitecore content accessible through HTTP requests in the JSON format.**

**The Web API supports accessing the content through items paths, IDs, or by running queries. The output produced by the service is highly customizable and optimized to reduce the number of requests.**

**TODO Link to download  "Sitecore Web API"**

### 1.2 The Client

**The client is an iOS project that contains the "SitecoreMobileSDK.framework" that provides an Objective-C API. You can use this API to access Sitecore content through the web service and use this content in your application. The API also supports advanced features such as preloading and caching.**

**You can use the Mobile SDK to display the existing HTML presentation while having access to the native iOS hardware and software abilities. You can reuse the elements of the website and reduce the implementation cost. You can also use native Objective-C.**

**The list of native features available in HTML environment includes:**

* **Left-Right swipe navigation.**
* **Access to the camera and the photo library.**
* **Accelerometer data.**
* **Device information.**
* **Access to the contact list and easy creation of new contacts.**
* **Creating tweets through the system-wide twitter accounts**
* **Sending email messages using the email account**

**TODO Link to download "SitecoreMobileSDK.framework"**

***
## 2. The Mobile SDK Installation

**This chapter describes how to install the Mobile SDK components.**
**This chapter contains the following sections:**

* **Installing the Server Side Components**
* **Installing the Client Side Components**


### 2.1 Installing the Server Side Components
##### 2.1.1 Installing the Sitecore Web API Service
**Use the Sitecore Installation Wizard to install the Sitecore Web API service:**

* **1. Log in to the Sitecore Desktop.** 
* **2. Click Sitecore, Development Tools, Installation Wizard. The wizard will guide you through the installation process.**
* **3. In the Select Package dialog box, specify the package that you want to install.**
![Select Package](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/SelectPackageDialogBox.png)
* **4. Click Browse to locate the package or click Upload to upload the package. The folder, to which the packages are uploaded, is specified in the web.config file.**
* **5. In the License Agreement dialog box, accept the license agreement.**
![License Agreement](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/LicenseAgreementDialogBox.png)
* **6. In the Ready to Install dialog box, you can review the package information and then click
Install.**
![Ready to Install](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/ReadyToInstallDialogBox.png)
* **7. When the installation is complete, you can choose to restart the Sitecore client or the Sitecore server and then click Finish. To test that the Sitecore Web API Service is working, make a simple request to the service.**
![Finish](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/FinishDialogBox.png)
* **8. In a browser, enter the URL: http://yoursite/-/webapi/v1/sitecore/Content/Home.**
![simple request](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/SimpleRequest.png)
##### 2.1.1 Installing the Sitecore Mobile SDK server package
**Use the Sitecore Installation Wizard to install the Sitecore "Mobile SDK server package" on the server side:**

1. **Log in to the Sitecore Desktop.** 
2. **Click Sitecore, Development Tools, Installation Wizard.The wizard will guide you through the installation process.**
3. **In the Select Package dialog box, specify the package that you want to install.**
![Select Package](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/SelectPackageDialogBox2.png)
4. **Click Browse to browse for an existing package or Upload to upload a new one.**
5. **In the Ready to Install dialog box, you can review the package information and then clickInstall.**
![Ready to Install](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/ReadyToInstallDialogBox2.png)
6. **When the installation is complete, you can choose to restart the Sitecore client or the Sitecoreserver and then click Finish.**
![Finish](https://github.com/Sitecore/sitecore-mobile-sdk/raw/master/resources/FinishDialogBox.png)

**Now, you can use the Sitecore Mobile SDK server side component.**

### 2.2 Installing the Client Side Components
**To start the client side installation, you must have the SitecoreMobileSDK.framework bundle.**
##### 2.2.1 Installing the Sitecore Mobile SDK server package
**To use the Sitecore Mobile SDK framework in your application:**

* **1. Create a simple XCode Single View Application project. For more information, see the Getting Started section in the Apple Developer Manual. If you have already created a XCode Single View Application project, you can skip this step.** 

# Mou

![Mou icon](http://mouapp.com/Mou_128.png)

## Overview

**Mou**, the missing Markdown editor for *web developers*.

### Syntax

#### Strong and Emphasize 

**strong** or __strong__ ( Cmd + B )

*emphasize* or _emphasize_ ( Cmd + I )

**Sometimes I want a lot of text to be bold.
Like, seriously, a _LOT_ of text**

#### Blockquotes

> Right angle brackets &gt; are used for block quotes.

#### Links and Email

An email <example@example.com> link.

Simple inline link <http://chenluois.com>, another inline link [Smaller](http://smallerapp.com), one more inline link with title [Resize](http://resizesafari.com "a Safari extension").

A [reference style][id] link. Input id, then anywhere in the doc, define the link with corresponding id:

[id]: http://mouapp.com "Markdown editor on Mac OS X"

Titles ( or called tool tips ) in the links are optional.

#### Images

An inline image ![Smaller icon](http://smallerapp.com/favicon.ico "Title here"), title is optional.

A ![Resize icon][2] reference style image.

[2]: http://resizesafari.com/favicon.ico "Title"

#### Inline code and Block code

Inline code are surround by `backtick` key. To create a block code:

	Indent each line by at least 1 tab, or 4 spaces.
    var Mou = exactlyTheAppIwant; 

####  Ordered Lists

Ordered lists are created using "1." + Space:

1. Ordered list item
2. Ordered list item
3. Ordered list item

#### Unordered Lists

Unordered list are created using "*" + Space:

* Unordered list item
* Unordered list item
* Unordered list item 

Or using "-" + Space:

- Unordered list item
- Unordered list item
- Unordered list item

#### Hard Linebreak

End a line with two or more spaces will create a hard linebreak, called `<br />` in HTML. ( Control + Return )  
Above line ended with 2 spaces.

#### Horizontal Rules

Three or more asterisks or dashes:

***

---

- - - -

#### Headers

Setext-style:

This is H1
==========

This is H2
----------

atx-style:

# This is H1
## This is H2
### This is H3
#### This is H4
##### This is H5
###### This is H6


### Extra Syntax

#### Strikethrough

Wrap with 2 tilde characters:

~~Strikethrough~~


#### Fenced Code Blocks

Start with a line containing 3 or more backticks, and ends with the first line with the same number of backticks:

```
Fenced code blocks are like Stardard Markdown’s regular code
blocks, except that they’re not indented and instead rely on
a start and end fence lines to delimit the code block.
```

#### Tables

A simple table looks like this:

First Header | Second Header | Third Header
------------ | ------------- | ------------
Content Cell | Content Cell  | Content Cell
Content Cell | Content Cell  | Content Cell

If you wish, you can add a leading and tailing pipe to each line of the table:

| First Header | Second Header | Third Header |
| ------------ | ------------- | ------------ |
| Content Cell | Content Cell  | Content Cell |
| Content Cell | Content Cell  | Content Cell |

Specify alignement for each column by adding colons to separator lines:

First Header | Second Header | Third Header
:----------- | :-----------: | -----------:
Left         | Center        | Right
Left         | Center        | Right


### Shortcuts

#### View

* Toggle live preview: Shift + Cmd + I
* Left/Right = 1/1: Cmd + 0
* Left/Right = 3/1: Cmd + +
* Left/Right = 1/3: Cmd + -
* Toggle Writing orientation: Cmd + L
* Toggle fullscreen: Control + Cmd + F

#### Actions

* Copy HTML: Option + Cmd + C
* Strong: Select text, Cmd + B
* Emphasize: Select text, Cmd + I
* Inline Code: Select text, Cmd + K
* Strikethrough: Select text, Cmd + U
* List: Select lines, Control + L
* Link: Select text, Control + Shift + L
* Image: Select text, Control + Shift + I
* Uppercase: Select text, Control + U
* Lowercase: Select text, Control + Shift + U
* Titlecase: Select text, Control + Option + U
* Spaces to Tabs: Control + [
* Tabs to Spaces: Control + ]
* Select Word: Control + Option + W
* Select Line: Shift + Cmd + L
* Select All: Cmd + A
* Deselect All: Cmd + D
* Insert entity <: Control + Shift + ,
* Insert entity >: Control + Shift + .
* Insert entity &: Control + Shift + 7
* Insert entity Space: Control + Shift + Space
* Shift Line Left: Select lines, Cmd + [
* Shift Line Right: Select lines, Cmd + ]
* New Line: Cmd + Return
* Comment: Cmd + /
* Hard Linebreak: Control + Return

#### Edit

* Auto complete current word: Esc
* Find: Cmd + F
* Close find bar: Esc

#### Export

* Export HTML: Option + Cmd + E
* Export PDF:  Option + Cmd + P


### And more?

Don't forget to check Preferences, lots of useful options are there. You can Disable/enable **Show Live Preview** in new documents, Disable/enable **Auto pair**, **Make links clickable in Editor view**, change **Base Font**, choose another **Theme** or create your own!

Follow [@chenluois](http://twitter.com/chenluois) on Twitter for the latest news.

For feedback, use the menu `Help` - `Send Feedback`