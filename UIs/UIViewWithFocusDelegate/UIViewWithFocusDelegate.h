//
//  UIViewWithFocusDelegate.h
//

#import <UIKit/UIKit.h>

@protocol UIViewFocusDelegate<NSObject>

@optional

-(BOOL)canBecomeFocusedForView:(UIView*)view withSuperValue:(BOOL)superValue;

-(void)setNeedsFocusUpdateForView:(UIView*)view;

-(void)updateFocusIfNeededForView:(UIView*)view;

-(BOOL)shouldUpdateFocusInContext:(UIFocusUpdateContext *)context forView:(UIView*)view withSuperValue:(BOOL)superValue;

-(void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator forView:(UIView*)view;

-(UIView *)preferredFocusedViewForView:(UIView*)view withSuperValue:(UIView*)superValue;

@end

@interface UIViewWithFocusDelegate : UIView

@property (nonatomic, weak) NSObject<UIViewFocusDelegate>* focusDelegate;

@end
