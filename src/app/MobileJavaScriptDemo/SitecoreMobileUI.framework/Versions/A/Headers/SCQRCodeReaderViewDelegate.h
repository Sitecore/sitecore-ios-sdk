#import <Foundation/Foundation.h>

@class SCQRCodeReaderView;

@protocol SCQRCodeReaderViewDelegate <NSObject>

@optional
/**
 This method calls when result is fully scaned
 */
- (void)qrCodeReaderView:(SCQRCodeReaderView *)readerView
        didGetScanResult:(NSString *)resultString;

@end
