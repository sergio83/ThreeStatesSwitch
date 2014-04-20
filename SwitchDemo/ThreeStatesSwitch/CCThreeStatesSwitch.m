//
//  CCSwitchThreeStates.m
//  Slider
//
//  Created by Sergio Cirasa on 18/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import "CCThreeStatesSwitch.h"
#import "SKInnerShadowLayer.h"

#define kButtonMarginTopButton 1.0
#define kPaddingLeftRight 1.0
#define kOvalStyleWidth 98.0
#define kCircleStyleWidth 44.0

#define kFalseCenterPoint CGPointMake((buttonSwitch.frame.size.width)/2+kPaddingLeftRight, buttonSwitch.center.y)
#define kUndefineCenterPoint CGPointMake(self.frame.size.width/2, buttonSwitch.center.y)
#define kTrueCenterPoint CGPointMake(self.frame.size.width - (buttonSwitch.frame.size.width)/2-kPaddingLeftRight, buttonSwitch.center.y)
#define kBackgroundColor [UIColor colorWithRed:100.0/255.0 green:98.0/255.0 blue:88.0/255.0 alpha:1.0]
// #define kBackgroundColor [UIColor colorWithRed:69.0/255.0 green:68.0/255.0 blue:53.0/255.0 alpha:1.0]
static const CGFloat kAnimateDuration = 0.2f;

@interface CCThreeStatesSwitch ()
{
    UIView *buttonSwitch;
    SKInnerShadowLayer *innerShadowLayer;
}
@end

@implementation CCThreeStatesSwitch
//----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - View
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _style = kOval;
        [self setupUI];
    }
    return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void) awakeFromNib
{
    [super awakeFromNib];
    _style = kOval;
    [self setupUI];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)setupUI
{
    self.trueStateColor = [UIColor colorWithRed:196.0/255.0 green:209.0/255.0 blue:45.0/255.0 alpha:1.0];
    self.undefineStateColor = [UIColor colorWithRed:144.0/255.0 green:141.0/255.0 blue:129.0/255.0 alpha:1.0];
    self.falseStateColor = [UIColor colorWithRed:242.0/255.0 green:107.0/255.0 blue:54.0/255.0 alpha:1.0];
    self.backgroundColor = kBackgroundColor;
    self.textColor = [UIColor whiteColor];
    
    [self setupButton];
    [self setupLabels];
    
    // Default to Undefine position
    self.switchState = kUndefined;
    
    // Handle Thumb Pan Gesture
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	[panGestureRecognizer setDelegate:self];
    [buttonSwitch addGestureRecognizer:panGestureRecognizer];
    
    // Handle Thumb Tap Gesture
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwitchTap:)];
	[tapGestureRecognizer setDelegate:self];
	[buttonSwitch addGestureRecognizer:tapGestureRecognizer];
    
    // Handle Background Tap Gesture
    UITapGestureRecognizer *tapBgGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBgTap:)];
	[tapBgGestureRecognizer setDelegate:self];
	[self addGestureRecognizer:tapBgGestureRecognizer];
    
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setupButton
{
    buttonSwitch = [[UIView alloc] initWithFrame:CGRectMake(0, kButtonMarginTopButton, (self.style==kOval)?kOvalStyleWidth:kCircleStyleWidth, self.frame.size.height-kButtonMarginTopButton*2)];
    buttonSwitch.layer.borderColor = [UIColor colorWithRed:87.0/255.0 green:85.0/255.0 blue:67.0/255.0 alpha:1.0].CGColor;
    buttonSwitch.layer.borderWidth = 1.0;
    buttonSwitch.clipsToBounds = YES;
    buttonSwitch.layer.cornerRadius = self.frame.size.height/2;
    [self addSubview:buttonSwitch];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setupLabels
{
    float width = (self.style==kOval)?kOvalStyleWidth:kCircleStyleWidth;
    self.trueLabel = [self createLabelWithText:@"YES" origin:CGPointMake(self.frame.size.width-width-kPaddingLeftRight, 0)];
    [self addSubview:self.trueLabel];
    self.falseLabel = [self createLabelWithText:@"NO" origin:CGPointMake(kPaddingLeftRight, 0)];
    [self addSubview:self.falseLabel];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(UILabel*)createLabelWithText:(NSString*)text origin:(CGPoint)origin
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, (self.style==kOval)?kOvalStyleWidth:kCircleStyleWidth, self.frame.size.height)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.textColor;
    label.text = text;
    return label;
}
//----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Gesture Recognizers
- (void)handleSwitchTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded){
        [self updateButtonFrameToState:kUndefined animated:YES];
    }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)handleBgTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded){
        CGPoint point = [recognizer locationInView:self];
        float third = (self.frame.size.width/3);
        
        if(point.x < third){
            [self updateButtonFrameToState:kFalse animated:YES];
        }else if(point.x < third*2){
            [self updateButtonFrameToState:kUndefined animated:YES];
        }else{
            [self updateButtonFrameToState:kTrue animated:YES];
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:buttonSwitch];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);

    if (newCenter.x < (recognizer.view.frame.size.width)/2 || newCenter.x > self.frame.size.width-(recognizer.view.frame.size.width)/2)
    {
        // New center is Out of bound. Animate to left or right position
        if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged)
        {
            CGPoint velocity = [recognizer velocityInView:buttonSwitch];
            if (velocity.x >= 0){
                // Animate move to right
                [self updateButtonFrameToState:kTrue animated:YES];
            }else{
                // Animate move to left
                [self updateButtonFrameToState:kFalse animated:YES];
            }
        }
        return;
    }
    
    // Only allow vertical pan
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:buttonSwitch];
    
    CGPoint velocity = [recognizer velocityInView:buttonSwitch];    
    if(recognizer.state == UIGestureRecognizerStateEnded){

        if (velocity.x >= 0){
            if (recognizer.view.center.x < kTrueCenterPoint.x){
                
                CGPoint point = kTrueCenterPoint;
                SwitchState nextState = kTrue;
                
                if (recognizer.view.center.x < kUndefineCenterPoint.x){
                    point = kUndefineCenterPoint;
                    nextState = kUndefined;
                }
                
                // Animate move to right
                [self updateButtonFrameToState:nextState animated:YES];
            }
        }
        else
        {
            CGPoint point = kFalseCenterPoint;
            SwitchState nextState = kFalse;
            
            if (recognizer.view.center.x > kUndefineCenterPoint.x){
                point = kUndefineCenterPoint;
                nextState = kUndefined;
            }
            
            // Animate move to left
            [self updateButtonFrameToState:nextState animated:YES];
        }
    }
}
//----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Animation
- (void)animateToDestination:(CGPoint)centerPoint animated:(BOOL)animated state:(SwitchState)state
{
    if(animated){
        [UIView animateWithDuration:kAnimateDuration
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             buttonSwitch.center = centerPoint;
                            buttonSwitch.backgroundColor = [self colorForState:state];
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                                 [self updateSwitch:state];
                         }];
    }else{
        buttonSwitch.center = centerPoint;
        buttonSwitch.backgroundColor = [self colorForState:state];
        [self updateSwitch:state];
    }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)updateSwitch:(SwitchState)state
{
    _switchState = state;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
//----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Private Methods
-(void)updateButtonFrameToState:(SwitchState) state animated:(BOOL)animated
{
    switch (state) {
        case kFalse:{
            [self animateToDestination:kFalseCenterPoint animated:animated state:state];
        }
            break;
        case kUndefined:{
            [self animateToDestination:kUndefineCenterPoint animated:animated state:state];
        }
            break;
        case kTrue:{
            [self animateToDestination:kTrueCenterPoint animated:animated state:state];
        }
            break;
    }
}
//----------------------------------------------------------------------------------------------------------------------------------
-(UIColor*)colorForState:(SwitchState) state
{
    switch (state) {
        case kFalse:
            return self.falseStateColor;
        case kUndefined:
            return self.undefineStateColor;
        case kTrue:
            return self.trueStateColor;
    }
}
//----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Property Methods
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [innerShadowLayer removeFromSuperlayer];
	innerShadowLayer = [[SKInnerShadowLayer alloc] init];
	innerShadowLayer.backgroundColor = backgroundColor.CGColor;
	innerShadowLayer.frame = self.bounds;
	innerShadowLayer.cornerRadius = self.frame.size.height/2;
	innerShadowLayer.innerShadowOpacity = 0.6f;
	innerShadowLayer.innerShadowColor = [UIColor blackColor].CGColor;
	[self.layer addSublayer:innerShadowLayer];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setStyle:(SwitchStyle)style
{
    _style = style;
    
    if(_style==kOval){
        buttonSwitch.frame = CGRectMake(0, kButtonMarginTopButton, kOvalStyleWidth, self.frame.size.height-kButtonMarginTopButton*2);
        buttonSwitch.layer.cornerRadius = self.frame.size.height/2;
        self.trueLabel.frame = CGRectMake(self.frame.size.width-kOvalStyleWidth-kPaddingLeftRight, 0,kOvalStyleWidth,self.frame.size.height);
        self.falseLabel.frame = CGRectMake(kPaddingLeftRight, 0,kOvalStyleWidth,self.frame.size.height);
    }else{
        buttonSwitch.frame = CGRectMake(0, kButtonMarginTopButton, kCircleStyleWidth, self.frame.size.height-kButtonMarginTopButton*2);
        self.trueLabel.frame = CGRectMake(self.frame.size.width-kCircleStyleWidth-kPaddingLeftRight, 0,kCircleStyleWidth,self.frame.size.height);
        self.falseLabel.frame = CGRectMake(kPaddingLeftRight, 0,kCircleStyleWidth,self.frame.size.height);
    }
    
    [self updateButtonFrameToState:self.state animated:NO];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setSwitchState:(SwitchState)switchState
{
    _switchState = switchState;
    [self updateButtonFrameToState:_switchState animated:NO];
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setSwitchState:(SwitchState)switchState animated:(BOOL)animated
{
    _switchState = switchState;
    [self updateButtonFrameToState:_switchState animated:animated];
}
//----------------------------------------------------------------------------------------------------------------------------------

@end
