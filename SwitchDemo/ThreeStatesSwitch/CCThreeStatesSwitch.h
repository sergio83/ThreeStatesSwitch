//
//  CCSwitchThreeStates.h
//  Slider
//
//  Created by Sergio Cirasa on 18/04/14.
//  Copyright (c) 2014 Sergio Cirasa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
   kFalse  = -1,
  kUndefined = 0,
  kTrue  = 1,
} SwitchState;

typedef enum  {
    kOval = 0,
    kCircle = 1,
} SwitchStyle;


@interface CCThreeStatesSwitch : UIControl<UIGestureRecognizerDelegate>

@property (nonatomic, assign) SwitchState switchState;
@property (nonatomic,assign) SwitchStyle style;

@property (nonatomic,strong) UIColor *trueStateColor;
@property (nonatomic,strong) UIColor *undefineStateColor;
@property (nonatomic,strong) UIColor *falseStateColor;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UILabel *trueLabel;
@property (nonatomic,strong) UILabel *falseLabel;

- (id)initWithFrame:(CGRect)frame;
-(void)setSwitchState:(SwitchState)switchState animated:(BOOL)animated;

@end
