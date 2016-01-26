//
//  UILabel+JustifiedText.h
//

#import <UIKit/UIKit.h>

@interface UILabel(JustifiedText)

-(void)setJustifiedText:(NSString *)text;
-(void)setJustifiedText:(NSString *)text firstLineHeadIndent:(CGFloat)firstLineHeadIndent;

@end
