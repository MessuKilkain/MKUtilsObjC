//
//  UIViewController+ForceOrientationUpdate.m
//

#import "UIViewController+ForceOrientationUpdate.h"

@implementation UIViewController(ForceOrientationUpdate)

-(void)forceOrientationUpdate
{
    [self forceOrientationUpdateWithCompletion:nil];
}
-(void)forceOrientationUpdateWithCompletion:(void (^ __nullable)(void))completion
{
    UIViewController *vc = [[UIViewController alloc]init];
    [[vc view] setBackgroundColor:[UIColor clearColor]];
    [vc setModalPresentationStyle:(UIModalPresentationOverFullScreen)];
    [self presentViewController:vc animated:NO completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc dismissViewControllerAnimated:YES completion:completion];
        });
    }];
}

@end
