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

@end
