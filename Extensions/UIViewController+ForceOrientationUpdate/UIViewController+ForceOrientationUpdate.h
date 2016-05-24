//
//  UIViewController+ForceOrientationUpdate.h
//

#import <UIKit/UIKit.h>

@interface UIViewController(ForceOrientationUpdate)

-(void)forceOrientationUpdate;
-(void)forceOrientationUpdateWithCompletion:(void (^ __nullable)(void))completion;

@end
