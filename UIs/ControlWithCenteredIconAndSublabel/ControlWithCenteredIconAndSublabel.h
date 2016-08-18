//
//  ControlWithCenteredIconAndSublabel.h
//

#import <UIKit/UIKit.h>

#if __has_include("UIImageView+AFNetworking.h")
#import "UIImageView+AFNetworking.h"
#endif

#if __has_include("FLAnimatedImageView.h")
#import "FLAnimatedImageView.h"
#endif

@interface ControlWithCenteredIconAndSublabel : UIControl

#pragma mark - SubLabel

-(void)setTextColor:(UIColor*)newTextColor;
-(void)setText:(NSString*)newText;
-(void)setTextFont:(UIFont*)newFont;
-(void)setTextFontSize:(CGFloat)newFontSize;
-(void)setTextHidden:(BOOL)hidden;
-(void)setSpaceBetweenIconAndText:(CGFloat)spaceBetweenIconAndText;

#pragma mark - Background Image

-(void)setBackgroundImage:(UIImage*)image;
#if __has_include("UIImageView+AFNetworking.h")
-(void)setBackgroundImageFromUrlString:(NSString*)imageUrlString;
#endif
-(void)setBackgroundImageContentMode:(UIViewContentMode)contentMode;

@property (nonatomic, retain) UIImage* backgroundImagePlaceholder;

#pragma mark - SubIcon

-(void)setImage:(UIImage *)image;
#if __has_include("FLAnimatedImageView.h")
-(void)setAnimatedImage:(FLAnimatedImage*)animatedImage;
#endif
-(void)setImageSize:(CGSize)imageSize;
-(void)setIconVerticalOffset:(CGFloat)iconVerticalOffset;

#pragma mark - SubActivityIndicator

-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style;
-(void)setActivityIndicatorViewColor:(UIColor*)color;
-(void)activityIndicatorStartAnimating;
-(void)activityIndicatorStopAnimating;

@end
