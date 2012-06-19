#import <Foundation/Foundation.h>

@class SCLRSwipeRecognizer;

@protocol SCLRSwipeRecognizerDelegate <NSObject>

@required
-(void)leftSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_;
-(void)rightSwipeRecognized:( SCLRSwipeRecognizer* )recognizer_;

@end
