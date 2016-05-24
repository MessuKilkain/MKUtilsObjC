//
//  ControlWithCenteredIconAndSublabel.m
//

#import "ControlWithCenteredIconAndSublabel.h"

// Utils
#import "UIView+AutoLayout.h"
#import "NSString+Empty.h"

@interface ControlWithCenteredIconAndSublabel ()

#if __has_include("FLAnimatedImageView.h")
@property (nonatomic, retain) FLAnimatedImageView* backgroundImageView;
@property (nonatomic, retain) FLAnimatedImageView* subIcon;
#else
@property (nonatomic, retain) UIImageView* backgroundImageView;
@property (nonatomic, retain) UIImageView* subIcon;
#endif
@property (nonatomic, retain) UILabel* subLabel;
@property (nonatomic, retain) UIActivityIndicatorView* subActivityIndicator;

@property (nonatomic, retain) NSLayoutConstraint* subIconVerticalOffsetConstraint;
@property (nonatomic, retain) NSLayoutConstraint* subIconHeight;
@property (nonatomic, retain) NSLayoutConstraint* subIconWidth;
@property (nonatomic, retain) NSLayoutConstraint* subLabelTopSpace;

@end

@implementation ControlWithCenteredIconAndSublabel

#pragma mark - Background Image

-(void)createBackgroundImageIfNecessary
{
    if( [self backgroundImageView] == nil )
    {
        [self setClipsToBounds:YES]; // NOTE : this can be done elsewhere
        
#if __has_include("FLAnimatedImageView.h")
        FLAnimatedImageView* backgroundImageView = [[FLAnimatedImageView alloc] init];
#else
        UIImageView* backgroundImageView = [[UIImageView alloc] init];
#endif
        [backgroundImageView setHidden:YES];
        [self setBackgroundImageView:backgroundImageView];
        [backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [backgroundImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:backgroundImageView];
        [backgroundImageView pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
    }
}
-(void)setBackgroundImage:(UIImage*)image
{
    [self createBackgroundImageIfNecessary];
#if __has_include("UIImageView+AFNetworking.h")
    [[self backgroundImageView] cancelImageDownloadTask];
#endif
    [[self backgroundImageView] setHidden:(image == nil)];
    [[self backgroundImageView] setImage:image];
}
#if __has_include("UIImageView+AFNetworking.h")
-(void)setBackgroundImageFromUrlString:(NSString*)imageUrlString
{
    [self createBackgroundImageIfNecessary];
    if( ![NSString isNilOrEmptyString:imageUrlString] )
    {
        NSString* urlString = imageUrlString;
        [[self backgroundImageView] setHidden:YES];
        [[self backgroundImageView]
         setImageWithURL:[NSURL URLWithString:urlString]
         placeholderImage:[self backgroundImagePlaceholder]
         ];
    }
    else
    {
        [[self backgroundImageView] cancelImageDownloadTask];
        [[self backgroundImageView] setHidden:YES];
    }
}
#endif
-(void)setBackgroundImageContentMode:(UIViewContentMode)contentMode
{
    [self createBackgroundImageIfNecessary];
    [[self backgroundImageView] setContentMode:contentMode];
}

#pragma mark - SubLabel

-(void)createSubLabelIfNecessary
{
    [self createBackgroundImageIfNecessary];
    [self createSubIconIfNecessary];
    if( [self subLabel] == nil )
    {
        [self setSubLabel:[[UILabel alloc] init]];
        [[self subLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self subLabel] setBackgroundColor:[UIColor clearColor]];
        [[self subLabel] setLineBreakMode:NSLineBreakByWordWrapping];
        [[self subLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self subLabel] setText:@""];
        [self addSubview:[self subLabel]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:[self subLabel]
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0
                             ]];
        [self setSubLabelTopSpace:[NSLayoutConstraint constraintWithItem:[self subLabel]
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:[self subIcon]
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0
                                   ]];
        [self addConstraint:[self subLabelTopSpace]];
    }
}

-(void)setTextColor:(UIColor*)newTextColor
{
    [self createSubLabelIfNecessary];
    [[self subLabel] setTextColor:newTextColor];
}

-(void)setText:(NSString*)newText
{
    [self createSubLabelIfNecessary];
    [[self subLabel] setText:newText];
}

-(void)setTextFont:(UIFont*)newFont
{
    [self createSubLabelIfNecessary];
    [[self subLabel] setFont:newFont];
}

-(void)setTextFontSize:(CGFloat)newFontSize
{
    [self createSubLabelIfNecessary];
    [[self subLabel] setFont:[[[self subLabel] font] fontWithSize:newFontSize]];
}

-(void)setTextHidden:(BOOL)hidden
{
    [self createSubLabelIfNecessary];
    [[self subLabel] setHidden:hidden];
}

-(void)setSpaceBetweenIconAndText:(CGFloat)spaceBetweenIconAndText
{
    [self createSubLabelIfNecessary];
    [[self subLabelTopSpace] setConstant:spaceBetweenIconAndText];
}

#pragma mark - SubIcon

-(void)createSubIconIfNecessary
{
    [self createBackgroundImageIfNecessary];
    if( [self subIcon] == nil )
    {
        [self setClipsToBounds:YES]; // NOTE : this can be done elsewhere
        
#if __has_include("FLAnimatedImageView.h")
        [self setSubIcon:[[FLAnimatedImageView alloc] init]];
#else
        [self setSubIcon:[[UIImageView alloc] init]];
#endif
        [[self subIcon] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self subIcon] setContentMode:UIViewContentModeScaleAspectFill];
        [[self subIcon] setBackgroundColor:[UIColor clearColor]];
        [self addSubview:[self subIcon]];
        CGFloat iconWidth = [self frame].size.width * 0.5;
        CGFloat iconHeight = [self frame].size.height * 0.5;
        if( iconWidth <= 0 )
        {
            iconWidth = 10;
        }
        if( iconHeight <= 0 )
        {
            iconHeight = 10;
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:[self subIcon]
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0
                             ]];
        [self setSubIconVerticalOffsetConstraint:
         [NSLayoutConstraint constraintWithItem:[self subIcon]
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1
                                       constant:0
          ]];
        [self addConstraint:[self subIconVerticalOffsetConstraint]];
        [self setSubIconWidth:[NSLayoutConstraint constraintWithItem:[self subIcon]
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:iconWidth
                               ]];
        [self addConstraint:[self subIconWidth]];
        [self setSubIconHeight:[NSLayoutConstraint constraintWithItem:[self subIcon]
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1
                                                             constant:iconHeight
                                ]];
        [self addConstraint:[self subIconHeight]];
    }
}

-(void)setImage:(UIImage *)image
{
    [self createSubIconIfNecessary];
    [[self subIcon] setImage:image];
}

#if __has_include("FLAnimatedImageView.h")
-(void)setAnimatedImage:(FLAnimatedImage*)animatedImage
{
    [self createSubIconIfNecessary];
    [[self subIcon] setAnimatedImage:animatedImage];
}
#endif

-(void)setImageSize:(CGSize)imageSize
{
    [self createSubIconIfNecessary];
    [[self subIconWidth] setConstant:imageSize.width];
    [[self subIconHeight] setConstant:imageSize.height];
}

-(void)setIconVerticalOffset:(CGFloat)iconVerticalOffset
{
    [self createSubIconIfNecessary];
    [[self subIconVerticalOffsetConstraint] setConstant:iconVerticalOffset];
}

#pragma mark - SubActivityIndicator

-(void)createSubActivityIndicatorIfNecessary
{
    [self createBackgroundImageIfNecessary];
    [self createSubIconIfNecessary];
    if( [self subActivityIndicator] == nil )
    {
        UIActivityIndicatorView* activityIndicator = [UIActivityIndicatorView autoLayoutView];
        [self addSubview:activityIndicator];
        [self setSubActivityIndicator:activityIndicator];
        [activityIndicator setBackgroundColor:[UIColor clearColor]];
        [activityIndicator centerInContainer];
        [activityIndicator setHidesWhenStopped:YES];
        [activityIndicator stopAnimating];
    }
}

-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style
{
    [self createSubActivityIndicatorIfNecessary];
    [[self subActivityIndicator] setActivityIndicatorViewStyle:style];
}
-(void)activityIndicatorStartAnimating
{
    [self createSubActivityIndicatorIfNecessary];
    [[self subActivityIndicator] startAnimating];
}
-(void)activityIndicatorStopAnimating
{
    [self createSubActivityIndicatorIfNecessary];
    [[self subActivityIndicator] stopAnimating];
}

@end