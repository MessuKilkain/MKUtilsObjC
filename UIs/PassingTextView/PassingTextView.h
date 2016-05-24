//
//  PassingTextView.h
//

#import <UIKit/UIKit.h>

@interface PassingTextView : UIView

#pragma mark - Simulated properties

-(void)setFont:(UIFont*)newFont;
-(UIFont*)font;
-(void)setTextColor:(UIColor*)newTextColor;
-(UIColor*)textColor;

-(void)setStaticTextAlignment:(NSTextAlignment)newTextAlignment;

#pragma mark - Title Text

-(NSString*)titleText;
-(void)setTitleText:(NSString*)newTitleText;

#pragma mark - Animation configuration

@property (nonatomic) NSTimeInterval expectedDurationForOneWidth; // NOTE : minimum 0.1 seconds
@property (nonatomic) NSTimeInterval delayForAnimation;

@end
