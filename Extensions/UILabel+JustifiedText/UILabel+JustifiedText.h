//
//  UILabel+JustifiedText.h
//

#ifndef UILabel_JustifiedText_h
#define UILabel_JustifiedText_h

#import <UIKit/UIKit.h>

@interface UILabel(JustifiedText)

-(void)setJustifiedText:(NSString *)text;
-(void)setJustifiedText:(NSString *)text firstLineHeadIndent:(CGFloat)firstLineHeadIndent;

@end

#endif
