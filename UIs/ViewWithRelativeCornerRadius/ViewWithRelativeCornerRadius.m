//
//  ViewWithRelativeCornerRadius.m
//

#import "ViewWithRelativeCornerRadius.h"

@interface ViewWithRelativeCornerRadius ()

@property (nonatomic) CGFloat internalRelativeCornerRadius;

@end

@implementation ViewWithRelativeCornerRadius

-(void)setRelativeCornerRadius:(CGFloat)relativeCornerRadius
{
    [self setInternalRelativeCornerRadius:relativeCornerRadius];
    [self setNeedsLayout];
}
-(CGFloat)relativeCornerRadius
{
    return [self internalRelativeCornerRadius];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [self frame].size;
    CGFloat newMinSideSize = (size.height>size.width?size.width:size.height);
    CGFloat oldCornerRadius = [[self layer] cornerRadius];
    CGFloat newCornerRadius = newMinSideSize * [self relativeCornerRadius];
    if( oldCornerRadius != newCornerRadius )
    {
        [[self layer] setCornerRadius:newCornerRadius];
    }
}

@end
