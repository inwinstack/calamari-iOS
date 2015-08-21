//
//  NavigationView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/8/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationView : UIView

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userIPLabel;
@property (nonatomic, strong) UITableView *navigationTableView;
@property (nonatomic, strong) UIView *backgroundView;

- (void) displayAnimation;
- (void) removeAnimation;
- (void) userPanAnimateWithX:(float)animationX;
- (void) resetPanAnimate;
- (void) confirmPanAnimate;
- (void) confirmPanAnimateWithFloatX:(float)currentX;

@end
