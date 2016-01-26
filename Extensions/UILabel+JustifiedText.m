//
//  UILabel+JustifiedText.m
//

#import "UILabel+JustifiedText.h"

@implementation UILabel(JustifiedText)

-(void)setJustifiedText:(NSString *)text
{
    [self setJustifiedText:text firstLineHeadIndent:0.1];
}

-(void)setJustifiedText:(NSString *)text firstLineHeadIndent:(CGFloat)firstLineHeadIndent
{
    // NOTE : done as explain at http://stackoverflow.com/questions/30886610/how-to-justify-label-text
    NSMutableParagraphStyle *paragraphStyles = [[NSMutableParagraphStyle alloc] init];
    paragraphStyles.alignment = NSTextAlignmentJustified;      // justified text
    paragraphStyles.firstLineHeadIndent = firstLineHeadIndent; // must have a value to make it work (!=0)
    
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName:paragraphStyles };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    [self setAttributedText:attributedString];
}

@end
