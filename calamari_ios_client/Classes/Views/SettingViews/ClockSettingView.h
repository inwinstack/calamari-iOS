//
//  ClockSettingView.h
//  calamari_ios_client
//
//  Created by Francis on 2015/10/13.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockSettingView : UIView

@property (nonatomic, strong) UILabel *clockNameLabel;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIView *selectedCircleView;
@property (nonatomic, strong) CAShapeLayer *selectedTriangleLayer;
@property (nonatomic, strong) UIButton *hourButton;
@property (nonatomic, strong) UIButton *minuteButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIButton *zeroButton;
@property (nonatomic, strong) UIButton *tenButton;
@property (nonatomic, strong) UIButton *twentyButton;
@property (nonatomic, strong) UIButton *thirtyButton;
@property (nonatomic, strong) UIButton *fortyButton;
@property (nonatomic, strong) UIButton *fiftyButton;


@end
