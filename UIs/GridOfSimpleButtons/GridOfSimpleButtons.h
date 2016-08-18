//
//  GridOfSimpleButtons.h
//

#import <UIKit/UIKit.h>

#import "ControlWithCenteredIconAndSublabel.h"

#if __has_include("FLAnimatedImageView.h")
#import "FLAnimatedImageView.h"
#endif

@class GridOfSimpleButtons;

@protocol GridOfSimpleButtonsDelegate <NSObject>

@required

-(void)buttonPressedInView:(GridOfSimpleButtons*)buttonParentView xPos:(NSInteger)xPos yPos:(NSInteger)yPos;

@end

@interface GridOfSimpleButtons : UIView

@property (nonatomic, weak) NSObject<GridOfSimpleButtonsDelegate>* gridOfSimpleButtonsDelegate;

#pragma mark - Buttons creation

/*
 // Test Script
 GridOfSimpleButtons* gridOfButtons = [GridOfSimpleButtons autoLayoutView];
 [[self view] addSubview:gridOfButtons];
 
 [gridOfButtons createGridWithRowsConfiguration:@"1:0:3/1,1:2:2/1:2/1:0,1/1:1:2/1:2"];
 [gridOfButtons setImageSize:CGSizeMake(20,20)];
 [gridOfButtons setTextColor:Color0];
 
 for( NSUInteger indexX = 0 ; indexX < 5 ; indexX++ )
 {
 for( NSUInteger indexY = 0 ; indexY < 5 ; indexY++ )
 {
 UIColor* color = nil;
 if( indexX + indexY % 4 == 0 )
 {
 color = Color1;
 }
 else if( indexX + indexY % 4 == 1 )
 {
 color = Color2;
 }
 else if( indexX + indexY % 4 == 2 )
 {
 color = Color3;
 }
 else
 {
 color = Color4;
 }
 [gridOfButtons setForButtonX:indexX y:indexY text:[NSString stringWithFormat:@"%ld:%ld",(unsigned long)indexX,(unsigned long)indexY] icon:[UIImage imageNamed:@"img.png"] backgroundColor:color];
 }
 }
 */

/**
 This method destroy any previous grid created and replace it by the new configuration.
 Each button in the grid is referenced by its stringCode X:Y of its bottom left corner (Y the index of the line, X the index of the column in the row : X can be different depending the row wince each row can have different number of columns).
 @param rowsConfiguration Configuration of the grid.
 
 Each line is separated by ','.
 
 Each contigous block of similar buttons on a same line by '/'.
 
 Configuration for similar buttons in a block can use 1, 2 or 3 parameters in that specific order : number of blocks, the number of lines used (from current line to above lines, 1 meaning use only the current line) and the number of columns occupied by one button. The parameters are separated by ':'.
 
 Defaut value for number of blocks is 0.
 
 Default value for number of lines used is 1.
 
 Default value for number of columns used is 1.
 
 A value of 0 for number of lines make the space be filled by a filler view.
 
 Configuration example:@code
 1:0:3/1,1:2:2/1:2/1:0,1/1:1:2/1:2
 @endcode
 to produce
 @code
 1123
 1124
 5664
 @endcode
 */
-(void)createGridWithRowsConfiguration:(NSString*)rowsConfiguration;

#pragma mark - View Size

-(void)setViewSideSize:(CGFloat)newSideSize;
-(void)setViewSize:(CGSize)newSize;


#pragma mark - Global

-(void)setTextColor:(UIColor*)newTextColor;
-(void)setTextFont:(UIFont*)newFont;
-(void)setTextFontSize:(CGFloat)newFontSize;
-(void)setTextHidden:(BOOL)hidden;
-(void)setSpaceBetweenIconAndText:(CGFloat)spaceBetweenIconAndText;

-(void)setImageSize:(CGSize)imageSize;

-(void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
-(void)setActivityIndicatorColor:(UIColor*)color;

#pragma mark - Button specific - Init

#if __has_include("FLAnimatedImageView.h")
-(void)setForButtonX:(NSInteger)xPos y:(NSInteger)yPos text:(NSString *)newText animatedIcon:(FLAnimatedImage*)newImage backgroundColor:(UIColor *)newBkgdColor;
#endif
-(void)setForButtonX:(NSInteger)xPos y:(NSInteger)yPos text:(NSString*)newText icon:(UIImage*)newImage backgroundColor:(UIColor*)newBkgdColor;

#pragma mark - Button specific - Config

-(void)setText:(NSString*)newText forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setIcon:(UIImage*)newImage forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
#if __has_include("FLAnimatedImageView.h")
-(void)setAnimatedIcon:(FLAnimatedImage*)newImage forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
#endif
-(void)setBackgroundColor:(UIColor*)newBkgdColor forButtonX:(NSInteger)xPos y:(NSInteger)yPos;

-(void)setEnabled:(BOOL)enabled forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setAlpha:(CGFloat)alpha forButtonX:(NSInteger)xPos y:(NSInteger)yPos;

-(void)setTextColor:(UIColor*)newTextColor forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setTextFont:(UIFont*)newFont forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setTextFontSize:(CGFloat)newFontSize forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setTextHidden:(BOOL)hidden forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setSpaceBetweenIconAndText:(CGFloat)spaceBetweenIconAndText forButtonX:(NSInteger)xPos y:(NSInteger)yPos;

-(void)setImageSize:(CGSize)imageSize forButtonX:(NSInteger)xPos y:(NSInteger)yPos;

-(void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)setActivityIndicatorColor:(UIColor*)color forButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)activityIndicatorStartAnimatingForButtonX:(NSInteger)xPos y:(NSInteger)yPos;
-(void)activityIndicatorStopAnimatingForButtonX:(NSInteger)xPos y:(NSInteger)yPos;

@end
