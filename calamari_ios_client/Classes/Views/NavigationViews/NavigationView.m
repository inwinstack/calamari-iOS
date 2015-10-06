//
//  NavigationView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/8/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NavigationView.h"
#import "UIView+SizeMaker.h"
#import "UIColor+Reader.h"

@interface NavigationView ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UIView *layerRoundView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation NavigationView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0;
        [self addSubview:self.backgroundView];
        
        self.titleView = [[UIView alloc] initWithFrame:CGRectMake(- [UIView navigationSize], 0, [UIView navigationSize], 83.2)];
        self.titleView.backgroundColor = [UIColor oceanNavigationBarColor];
        [self addSubview:self.titleView];
        
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIView lrMarginOne], CGRectGetMidY(self.titleView.frame) - 18.72, 37.44, 37.44)];
        self.userImageView.image = [UIImage imageNamed:@"TitleUserImage"];
        [self.titleView addSubview:self.userImageView];
        
        self.layerRoundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.userImageView.frame) - 20.8, CGRectGetMidY(self.titleView.frame) - 20.8, 41.6, 41.6)];
        self.layerRoundView.layer.cornerRadius = 20.8;
        self.layerRoundView.layer.borderWidth = 1;
        self.layerRoundView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layerRoundView.backgroundColor = [UIColor clearColor];
        [self.titleView addSubview:self.layerRoundView];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.layerRoundView.frame) + [UIView tbMarginOne], CGRectGetMidY(self.userImageView.frame) - 20, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.layerRoundView.frame), 20)];
        self.userNameLabel.text = @"Test";
        self.userNameLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.userNameLabel.textColor = [UIColor whiteColor];
        [self.titleView addSubview:self.userNameLabel];
        
        self.userIPLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.layerRoundView.frame) + [UIView tbMarginOne], CGRectGetMidY(self.userImageView.frame), CGRectGetWidth(self.frame) - CGRectGetMaxX(self.layerRoundView.frame), 20)];
        self.userIPLabel.text = @"127.0.0.1";
        self.userIPLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.userIPLabel.textColor = [UIColor whiteColor];
        [self.titleView addSubview:self.userIPLabel];
        
        self.navigationTableView = [[UITableView alloc] initWithFrame:CGRectMake(- [UIView navigationSize], CGRectGetMaxY(self.titleView.frame), CGRectGetWidth(self.titleView.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleView.frame))];
        self.navigationTableView.rowHeight = 41.6;
        self.navigationTableView.backgroundColor = [UIColor oceanBackgroundOneColor];
        self.navigationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.navigationTableView];
    }
    return self;
}

- (void) displayAnimation {
    self.window.hidden = NO;
    self.backgroundView.alpha = 0;
    self.titleView.frame = CGRectMake(- [UIView navigationSize], self.titleView.frame.origin.y, self.titleView.frame.size.width, self.titleView.frame.size.height);
    self.navigationTableView.frame = CGRectMake(- [UIView navigationSize], self.navigationTableView.frame.origin.y, self.navigationTableView.frame.size.width, self.navigationTableView.frame.size.height);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundView.alpha = 0.5;
        self.titleView.frame = CGRectMake(0, 0, [UIView navigationSize], self.titleView.frame.size.height);
        self.navigationTableView.frame = CGRectMake(0, self.navigationTableView.frame.origin.y, [UIView navigationSize], self.navigationTableView.frame.size.height);
        
    } completion:nil];
}

- (void) removeAnimation {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundView.alpha = 0;
        self.titleView.frame = CGRectMake(- [UIView navigationSize], self.titleView.frame.origin.y, [UIView navigationSize], self.titleView.frame.size.height);
        self.navigationTableView.frame = CGRectMake(- [UIView navigationSize], self.navigationTableView.frame.origin.y, [UIView navigationSize], self.navigationTableView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.window.hidden = YES;
        }
    }];
}

- (void) userPanAnimateWithX:(float)animationX {
    self.backgroundView.alpha = (0.0025 * animationX >= 0.5) ? 0.5 : 0.0025 * animationX;
    self.titleView.frame = CGRectMake(- [UIView navigationSize] + animationX, self.titleView.frame.origin.y, self.titleView.frame.size.width, self.titleView.frame.size.height);
    self.navigationTableView.frame = CGRectMake(- [UIView navigationSize] + animationX, self.navigationTableView.frame.origin.y, self.navigationTableView.frame.size.width, self.navigationTableView.frame.size.height);
}

- (void) confirmPanAnimate {
    self.backgroundView.alpha = 0.5;
    self.titleView.frame = CGRectMake(0, 0, [UIView navigationSize], self.titleView.frame.size.height);
    self.navigationTableView.frame = CGRectMake(0, self.navigationTableView.frame.origin.y, [UIView navigationSize], self.navigationTableView.frame.size.height);
}

- (void) confirmPanAnimateWithFloatX:(float)currentX {
    self.backgroundView.alpha = (0.0025 * currentX > 0.5) ? 0.5 : 0.0025 * currentX;
    self.titleView.frame = CGRectMake(- [UIView navigationSize] + currentX, self.titleView.frame.origin.y, self.titleView.frame.size.width, self.titleView.frame.size.height);
    self.navigationTableView.frame = CGRectMake(- [UIView navigationSize] + currentX, self.navigationTableView.frame.origin.y, self.navigationTableView.frame.size.width, self.navigationTableView.frame.size.height);
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundView.alpha = 0.5;
        self.titleView.frame = CGRectMake(0, 0, [UIView navigationSize], self.titleView.frame.size.height);
        self.navigationTableView.frame = CGRectMake(0, self.navigationTableView.frame.origin.y, [UIView navigationSize], self.navigationTableView.frame.size.height);
    } completion:nil];
}

- (void) resetPanAnimate {
    self.backgroundView.alpha = 0;
    self.titleView.frame = CGRectMake(- [UIView navigationSize], self.titleView.frame.origin.y, self.titleView.frame.size.width, self.titleView.frame.size.height);
    self.navigationTableView.frame = CGRectMake(- [UIView navigationSize], self.navigationTableView.frame.origin.y, self.navigationTableView.frame.size.width, self.navigationTableView.frame.size.height);
}

@end
