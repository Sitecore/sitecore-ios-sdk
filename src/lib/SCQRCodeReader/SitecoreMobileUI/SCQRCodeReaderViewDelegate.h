#import <Foundation/Foundation.h>

@class SCQRCodeReaderView;



/**
 This protocol describes the events that will occur while scannign QR code data using the SCQRCodeReaderView widget.
 */
@protocol SCQRCodeReaderViewDelegate <NSObject>

@optional
/**
 This method calls when result is fully scaned
 
 @param readerView A view that sent the event. If you have multiple instances of the SCQRCodeReaderView on your screen it will help you understand which instance has scanned the code.
 @param resultString The data encoded in the QR code. The user is responsible for processing it properly.
 */
- (void)qrCodeReaderView:(SCQRCodeReaderView *)readerView
        didGetScanResult:(NSString *)resultString;

@end
