//
//  GridOfSimpleButtons.m
//

#import "GridOfSimpleButtons.h"

// Utils
#import "UIView+AutoLayout.h"
#import "NSString+Empty.h"


@interface GridOfSimpleButtons_Cell : ControlWithCenteredIconAndSublabel

@property (nonatomic) NSInteger xPos;
@property (nonatomic) NSInteger yPos;

/**
 * stringCode is x:y
 *
 **/
-(NSString*)stringCode;
+(NSString*)stringCodeForCell:(GridOfSimpleButtons_Cell*)cell;
+(NSString*)stringCodeForX:(NSInteger)x y:(NSInteger)y;

@end

@implementation GridOfSimpleButtons_Cell

-(NSString*)stringCode
{
    return [[self class] stringCodeForCell:self];
}
+(NSString*)stringCodeForCell:(GridOfSimpleButtons_Cell*)cell
{
    if( cell != nil )
    {
        return [self stringCodeForX:[cell xPos] y:[cell yPos]];
    }
    else
    {
        return @"";
    }
}
+(NSString*)stringCodeForX:(NSInteger)x y:(NSInteger)y
{
    return [NSString stringWithFormat:@"%@:%@",[[NSNumber numberWithInteger:x] stringValue],[[NSNumber numberWithInteger:y] stringValue]];
}

@end

@interface GridOfSimpleButtons ()


@property (nonatomic,retain) NSDictionary<NSString*,GridOfSimpleButtons_Cell*>* buttons;
@property (nonatomic,retain) NSArray<UIView*>* fillerViews;
@property (nonatomic,retain) NSArray<UIView*>* rowViews;

@end

@implementation GridOfSimpleButtons

#pragma mark - View Size

-(void)setViewSideSize:(CGFloat)newSideSize
{
    [self setViewSize:CGSizeMake(newSideSize, newSideSize)];
}

-(void)setViewSize:(CGSize)newSize
{
    CGRect newFrame = [self frame];
    newFrame.size = newSize;
    [self setFrame:newFrame];
}

#pragma mark - Buttons actions

-(void)buttonPressed:(id)sender
{
    if(
       sender != nil
       && [sender isKindOfClass:[GridOfSimpleButtons_Cell class]]
       )
    {
        GridOfSimpleButtons_Cell* button = sender;
        if(
           [self gridOfSimpleButtonsDelegate] != nil
           && [[self gridOfSimpleButtonsDelegate] respondsToSelector:@selector(buttonPressedInView:xPos:yPos:)]
           )
        {
            [[self gridOfSimpleButtonsDelegate] buttonPressedInView:self xPos:[button xPos] yPos:[button yPos]];
        }
    }
}

#pragma mark - Buttons creation

-(void)destroyRows
{
    // NOTE : destroy old rows
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange removeFromSuperview];
            }
        }
        [self setButtons:nil];
    }
    if( [self fillerViews] != nil )
    {
        NSUInteger numberOfFillerViews = [[self fillerViews] count];
        for( NSUInteger fillerViewIndex = 0 ; fillerViewIndex < numberOfFillerViews ; fillerViewIndex++ )
        {
            UIView* fillerView = [[self fillerViews] objectAtIndex:fillerViewIndex];
            if( fillerView != nil )
            {
                [fillerView removeFromSuperview];
            }
        }
        [self setFillerViews:nil];
    }
    if( [self rowViews] != nil )
    {
        NSUInteger numberOfRows = [[self rowViews] count];
        for( NSUInteger rowIndex = 0 ; rowIndex < numberOfRows ; rowIndex++ )
        {
            UIView* row = [[self rowViews] objectAtIndex:rowIndex];
            if( row != nil )
            {
                [row removeFromSuperview];
            }
        }
        [self setRowViews:nil];
    }
}

-(void)createGridWithRowsConfiguration:(NSString*)rowsConfiguration
{
    [self destroyRows];
    
    // NOTE : create new rows
    if( [NSString isNilOrEmptyString:rowsConfiguration] )
    {
        // NSLog(@"rowsConfiguration is nil or empty");
    }
    else
    {
        NSArray* rows = [rowsConfiguration componentsSeparatedByString:@","];
        if(
           rows != nil
           && [rows count] > 0
           )
        {
            NSMutableArray<UIView*>* rowViews = [NSMutableArray<UIView*> array];
            NSMutableArray<UIView*>* viewsInRows = [NSMutableArray<UIView*> array];
            {
                NSUInteger numberOfRows = [rows count];
                CGFloat rowRelativeHeight = 1.0/numberOfRows;
                {
                    UIView* lastRowView = nil;
                    for( NSUInteger rowIndex = 0 ; rowIndex < numberOfRows ; rowIndex++ )
                    {
                        UIView* newRowView = [self rowWithPreviousRowView:lastRowView relativeHeight:rowRelativeHeight];
                        [rowViews addObject:newRowView];
                        lastRowView = newRowView;
                    }
                    if( lastRowView != nil ) // It should NEVER EVER be nil, but just in case
                    {
                        [lastRowView pinToSuperviewEdges:JRTViewPinBottomEdge inset:0];
                    }
                }
                [self setRowViews:rowViews];
                // NOTE : the cells must be above rowViews, that is why we are doing a second for loop
                for( NSUInteger rowIndex = 0 ; rowIndex < numberOfRows ; rowIndex++ )
                {
                    UIView* rowView = [rowViews objectAtIndex:rowIndex];
                    NSString* rowConfigurationString = [rows objectAtIndex:rowIndex];
                    if( [NSString isNilOrEmptyString:rowConfigurationString] )
                    {
                        // NSLog(@"Empty row : %u", rowIndex);
                    }
                    else
                    {
                        [viewsInRows addObjectsFromArray:[self fillRowView:rowView withRowIndex:rowIndex rowConfiguration:rowConfigurationString]];
                    }
                }
            }
            {
                NSUInteger numberOfViews = [viewsInRows count];
                NSMutableDictionary<NSString*,GridOfSimpleButtons_Cell*>* buttons = [NSMutableDictionary<NSString*,GridOfSimpleButtons_Cell*> dictionary];
                NSMutableArray<UIView*>* fillerViews = [NSMutableArray<UIView*> array];
                for( NSUInteger viewIndex = 0 ; viewIndex < numberOfViews ; viewIndex++ )
                {
                    UIView* view = [viewsInRows objectAtIndex:viewIndex];
                    if( view != nil )
                    {
                        if( [view isKindOfClass:[GridOfSimpleButtons_Cell class]] )
                        {
                            GridOfSimpleButtons_Cell* cell = (GridOfSimpleButtons_Cell*)view;
                            [buttons setObject:cell forKey:[cell stringCode]];
                        }
                        else
                        {
                            [fillerViews addObject:view];
                        }
                    }
                }
                [self setButtons:buttons];
                [self setFillerViews:fillerViews];
            }
        }
    }
}

-(UIView*)rowWithPreviousRowView:(UIView*)previousRowView relativeHeight:(CGFloat)relativeHeight
{
    UIView* rowView = [[UIView alloc] init];
    [rowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:rowView];
    // Constraints
    [rowView pinToSuperviewEdges:JRTViewPinLeftEdge|JRTViewPinRightEdge inset:0];
    if( previousRowView != nil )
    {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:rowView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:previousRowView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0
                             ]];
        // NOTE : The first line will only fill the gap between the top of the view and the second line (or the bottom if only one line)
        [self addConstraint:[NSLayoutConstraint constraintWithItem:rowView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:relativeHeight
                                                          constant:0
                             ]];
    }
    else
    {
        [rowView pinToSuperviewEdges:JRTViewPinTopEdge inset:0];
    }
    return rowView;
}
-(NSArray*)fillRowView:(UIView*)rowView withRowIndex:(NSUInteger)rowIndex numberOfButton:(NSUInteger)numberOfColumnInRow
{
    return [self fillRowView:rowView withRowIndex:rowIndex rowConfiguration:[[NSNumber numberWithInteger:numberOfColumnInRow] stringValue]];
}
-(NSArray*)fillRowView:(UIView*)rowView withRowIndex:(NSUInteger)rowIndex rowConfiguration:(NSString*)rowConfiguration
{
    // NSLog(@"rowConfiguration %@", rowConfiguration);
    NSMutableArray* viewsForLine = [NSMutableArray array];
    if( rowView != nil )
    {
        NSArray<NSString*>* blocks = [rowConfiguration componentsSeparatedByString:@"/"];
        if(
           blocks != nil
           && [blocks count] > 0
           )
        {
            NSUInteger numberOfBlocks = [blocks count];
            NSUInteger numberOfColumnInRow = 0;
            for( NSUInteger blockIndex = 0 ; blockIndex < numberOfBlocks ; blockIndex++ )
            {
                NSString* blockConfiguration = [blocks objectAtIndex:blockIndex];
                if( [NSString isNilOrEmptyString:blockConfiguration] )
                {
                    // NSLog(@"blockConfiguration is nil or empty at index %ld",(long)blockIndex);
                }
                else
                {
                    NSUInteger numberOfButtonsInBlock = 0;
                    NSUInteger numberOfLinesUsedByButtonsInBlock = 1;
                    NSUInteger numberOfUnitWidthUsedByButtonsInBlock = 1;
                    NSArray<NSString*>* blockConfigurationParts = [blockConfiguration componentsSeparatedByString:@":"];
                    if( blockConfigurationParts != nil )
                    {
                        NSUInteger numberOfParts = [blockConfigurationParts count];
                        if( numberOfParts <= 0 )
                        {
                            // NSLog(@"blockConfigurationParts has no parts for index %ld",(long)blockIndex);
                        }
                        if( numberOfParts > 0 )
                        {
                            NSString* part = [blockConfigurationParts objectAtIndex:0];
                            if( ![NSString isNilOrEmptyString:part] )
                            {
                                numberOfButtonsInBlock = [part integerValue];
                            }
                        }
                        if( numberOfParts > 1 )
                        {
                            NSString* part = [blockConfigurationParts objectAtIndex:1];
                            if( ![NSString isNilOrEmptyString:part] )
                            {
                                numberOfLinesUsedByButtonsInBlock = [part integerValue];
                            }
                        }
                        if( numberOfParts > 2 )
                        {
                            NSString* part = [blockConfigurationParts objectAtIndex:2];
                            if( ![NSString isNilOrEmptyString:part] )
                            {
                                numberOfUnitWidthUsedByButtonsInBlock = [part integerValue];
                            }
                        }
                        if( numberOfParts > 3 )
                        {
                            // NSLog(@"WARNING : too much parts (%ld) in blockConfiguration %@",(long)numberOfParts,blockConfiguration);
                        }
                    }
                    numberOfColumnInRow += numberOfButtonsInBlock * numberOfUnitWidthUsedByButtonsInBlock;
                }
            }
            CGFloat buttonsMargin = 0;
            if( numberOfColumnInRow > 0 )
            {
                CGFloat relativeWidth = 1.0/numberOfColumnInRow;
                NSUInteger columnIndex = 0;
                UIView* lastCreatedView = nil;
                
                for( NSUInteger blockIndex = 0 ; blockIndex < numberOfBlocks ; blockIndex++ )
                {
                    NSString* blockConfiguration = [blocks objectAtIndex:blockIndex];
                    if( [NSString isNilOrEmptyString:blockConfiguration] )
                    {
                        // NSLog(@"blockConfiguration is nil or empty at index %ld",(long)blockIndex);
                    }
                    else
                    {
                        NSUInteger numberOfButtonsInBlock = 0;
                        NSUInteger numberOfLinesUsedByButtonsInBlock = 1;
                        NSUInteger numberOfUnitWidthUsedByButtonsInBlock = 1;
                        NSArray<NSString*>* blockConfigurationParts = [blockConfiguration componentsSeparatedByString:@":"];
                        if( blockConfigurationParts != nil )
                        {
                            NSUInteger numberOfParts = [blockConfigurationParts count];
                            if( numberOfParts <= 0 )
                            {
                                // NSLog(@"blockConfigurationParts has no parts for index %ld",(long)blockIndex);
                            }
                            if( numberOfParts > 0 )
                            {
                                NSString* part = [blockConfigurationParts objectAtIndex:0];
                                if( ![NSString isNilOrEmptyString:part] )
                                {
                                    numberOfButtonsInBlock = [part integerValue];
                                }
                            }
                            if( numberOfParts > 1 )
                            {
                                NSString* part = [blockConfigurationParts objectAtIndex:1];
                                if( ![NSString isNilOrEmptyString:part] )
                                {
                                    numberOfLinesUsedByButtonsInBlock = [part integerValue];
                                }
                            }
                            if( numberOfParts > 2 )
                            {
                                NSString* part = [blockConfigurationParts objectAtIndex:2];
                                if( ![NSString isNilOrEmptyString:part] )
                                {
                                    numberOfUnitWidthUsedByButtonsInBlock = [part integerValue];
                                }
                            }
                        }
                        if( numberOfUnitWidthUsedByButtonsInBlock > 0 )
                        {
                            for( NSUInteger buttonInBlockIndex = 0 ; buttonInBlockIndex < numberOfButtonsInBlock ; buttonInBlockIndex++ )
                            {
                                UIView* newView = nil;
                                if( numberOfLinesUsedByButtonsInBlock > 0 )
                                {
                                    GridOfSimpleButtons_Cell* newButton = [[GridOfSimpleButtons_Cell alloc] init];
                                    newView = newButton;
                                    [newButton setTranslatesAutoresizingMaskIntoConstraints:NO];
                                    [newButton setBackgroundColor:[UIColor clearColor]];
#if TARGET_OS_TV
                                    [newButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventPrimaryActionTriggered];
#else
                                    [newButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
#endif
                                    [newButton setXPos:columnIndex];
                                    [newButton setYPos:rowIndex];
                                }
                                else
                                {
                                    UIView* fillerView = [[UIView alloc] init];
                                    [fillerView setTranslatesAutoresizingMaskIntoConstraints:NO];
                                    [fillerView setBackgroundColor:[UIColor clearColor]];
                                    newView = fillerView;
                                }
                                if( newView == nil )
                                {
                                    // NSLog(@"newView is nil for block index %ld and rowIndex %ld",(long)blockIndex,(long)rowIndex);
                                }
                                else
                                {
                                    [self addSubview:newView];
                                    [viewsForLine addObject:newView];
                                    [newView pinEdges:JRTViewPinBottomEdge toSameEdgesOfView:rowView inset:buttonsMargin];
                                    UIView* rowViewForTopEdge = rowView;
                                    if( numberOfLinesUsedByButtonsInBlock > 1 )
                                    {
                                        NSInteger rowForTopEdgeIndex = rowIndex - ( numberOfLinesUsedByButtonsInBlock - 1 );
                                        if( rowForTopEdgeIndex < 0 )
                                        {
                                            // NSLog(@"rowForTopEdgeIndex is negative for block index %ld and rowIndex %ld",(long)blockIndex,(long)rowIndex);
                                        }
                                        else if ( [self rowViews] == nil )
                                        {
                                            // NSLog(@"[self rowViews] is nil for block index %ld and rowIndex %ld",(long)blockIndex,(long)rowIndex);
                                        }
                                        else
                                        {
                                            UIView* rowViewForTopEdgeCandidate = [[self rowViews] objectAtIndex:rowForTopEdgeIndex];
                                            if( rowViewForTopEdgeCandidate == nil )
                                            {
                                                // NSLog(@"rowViewForTopEdgeCandidate is nil for block index %ld and rowIndex %ld",(long)blockIndex,(long)rowIndex);
                                            }
                                            else
                                            {
                                                rowViewForTopEdge = rowViewForTopEdgeCandidate;
                                            }
                                        }
                                    }
                                    [newView pinEdges:JRTViewPinTopEdge toSameEdgesOfView:rowViewForTopEdge inset:buttonsMargin];
                                    if( lastCreatedView != nil )
                                    {
                                        [self addConstraint:
                                         [NSLayoutConstraint
                                          constraintWithItem:newView
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:rowView
                                          attribute:NSLayoutAttributeWidth
                                          multiplier:relativeWidth * numberOfUnitWidthUsedByButtonsInBlock + buttonsMargin * ( numberOfUnitWidthUsedByButtonsInBlock - 1 )
                                          constant:0
                                          ]];
                                        [self addConstraint:
                                         [NSLayoutConstraint
                                          constraintWithItem:newView
                                          attribute:NSLayoutAttributeLeft
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:lastCreatedView
                                          attribute:NSLayoutAttributeRight
                                          multiplier:1
                                          constant:buttonsMargin
                                          ]];
                                    }
                                    else
                                    {
                                        [newView pinEdges:JRTViewPinLeftEdge toSameEdgesOfView:rowView inset:buttonsMargin];
                                    }
                                    lastCreatedView = newView;
                                    
                                    columnIndex += numberOfUnitWidthUsedByButtonsInBlock;
                                }
                            }
                        }
                    }
                }
                if( lastCreatedView != nil )
                {
                    [lastCreatedView pinEdges:JRTViewPinRightEdge toSameEdgesOfView:rowView inset:buttonsMargin];
                }
            }
        }
    }
    return viewsForLine;
}

#pragma mark - Config

-(GridOfSimpleButtons_Cell*)buttonForX:(NSUInteger)xPos y:(NSUInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = nil;
    if( [self buttons] != nil )
    {
        buttonToChange = [[self buttons] objectForKey:[GridOfSimpleButtons_Cell stringCodeForX:xPos y:yPos]];
    }
    return buttonToChange;
}

#if __has_include("FLAnimatedImageView.h")
-(void)setForButtonX:(NSInteger)xPos y:(NSInteger)yPos text:(NSString *)newText animatedIcon:(FLAnimatedImage*)newImage backgroundColor:(UIColor *)newBkgdColor
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setText:newText];
        [buttonToChange setAnimatedImage:newImage];
        [buttonToChange setBackgroundColor:newBkgdColor];
    }
}
#endif

-(void)setForButtonX:(NSInteger)xPos y:(NSInteger)yPos text:(NSString *)newText icon:(UIImage *)newImage backgroundColor:(UIColor *)newBkgdColor
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setText:newText];
        [buttonToChange setImage:newImage];
        [buttonToChange setBackgroundColor:newBkgdColor];
    }
}

-(void)setTextColor:(UIColor *)newTextColor
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setTextColor:newTextColor];
            }
        }
    }
}
-(void)setTextFont:(UIFont *)newFont
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setTextFont:newFont];
            }
        }
    }
}
-(void)setTextFontSize:(CGFloat)newFontSize
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setTextFontSize:newFontSize];
            }
        }
    }
}
-(void)setTextHidden:(BOOL)hidden
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setTextHidden:hidden];
            }
        }
    }
}
-(void)setSpaceBetweenIconAndText:(CGFloat)spaceBetweenIconAndText
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setSpaceBetweenIconAndText:spaceBetweenIconAndText];
            }
        }
    }
}
-(void)setImageSize:(CGSize)imageSize
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setImageSize:imageSize];
            }
        }
    }
}
-(void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setActivityIndicatorViewStyle:style];
            }
        }
    }
}
-(void)setActivityIndicatorColor:(UIColor*)color
{
    if( [self buttons] != nil )
    {
        NSUInteger numberOfButtons = [[self buttons] count];
        NSArray* buttonsList = [[self buttons] allValues];
        for( NSUInteger buttonIndexInRow = 0 ; buttonIndexInRow < numberOfButtons ; buttonIndexInRow++ )
        {
            GridOfSimpleButtons_Cell* buttonToChange = [buttonsList objectAtIndex:buttonIndexInRow];
            if( buttonToChange != nil )
            {
                [buttonToChange setActivityIndicatorViewColor:color];
            }
        }
    }
}

#pragma mark - Button specific

-(void)setText:(NSString*)newText forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setText:newText];
    }
}
-(void)setIcon:(UIImage*)newImage forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setImage:newImage];
    }
}
#if __has_include("FLAnimatedImageView.h")
-(void)setAnimatedIcon:(FLAnimatedImage*)newImage forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setAnimatedImage:newImage];
    }
}
#endif
-(void)setBackgroundColor:(UIColor*)newBkgdColor forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setBackgroundColor:newBkgdColor];
    }
}

-(void)setEnabled:(BOOL)enabled forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setEnabled:enabled];
    }
}
-(void)setAlpha:(CGFloat)alpha forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setAlpha:alpha];
    }
}

-(void)setTextColor:(UIColor*)newTextColor forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setTextColor:newTextColor];
    }
}
-(void)setTextFont:(UIFont*)newFont forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setTextFont:newFont];
    }
}
-(void)setTextFontSize:(CGFloat)newFontSize forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setTextFontSize:newFontSize];
    }
}
-(void)setTextHidden:(BOOL)hidden forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setTextHidden:hidden];
    }
}
-(void)setSpaceBetweenIconAndText:(CGFloat)spaceBetweenIconAndText forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setSpaceBetweenIconAndText:spaceBetweenIconAndText];
    }
}

-(void)setImageSize:(CGSize)imageSize forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setImageSize:imageSize];
    }
}

-(void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setActivityIndicatorViewStyle:style];
    }
}

-(void)setActivityIndicatorColor:(UIColor*)color forButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange setActivityIndicatorViewColor:color];
    }
}

-(void)activityIndicatorStartAnimatingForButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange activityIndicatorStartAnimating];
    }
}

-(void)activityIndicatorStopAnimatingForButtonX:(NSInteger)xPos y:(NSInteger)yPos
{
    GridOfSimpleButtons_Cell* buttonToChange = [self buttonForX:xPos y:yPos];
    
    if( buttonToChange == nil )
    {
        // NSLog( @"No button for coords X:%ld Y:%ld", (long)xPos, (long)yPos );
    }
    else
    {
        [buttonToChange activityIndicatorStopAnimating];
    }
}

@end
