//
//  HelpView.m
//  calamari_ios_client
//
//  Created by 胡珀菖 on 2015/12/17.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "HelpView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface HelpView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIView *upView;
@property (nonatomic, strong) UIView *buttonLineView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HelpView

- (instancetype) initWithTitle:(NSString *)helpTitle message:(NSString *)helpMessage {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMidY(self.frame) - 75, CGRectGetWidth(self.frame) - 20, 150)];
        self.backgroundView.layer.cornerRadius = 5.0;
        self.backgroundView.backgroundColor = [UIColor oceanBackgroundThreeColor];
        [self addSubview:self.backgroundView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.backgroundView.frame), 30)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = helpTitle;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self.backgroundView addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame) + 5, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame) - 10, 90)];
        self.messageLabel.textColor = [UIColor normalBlackColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.messageLabel.text = [NSString stringWithFormat:@"%@", helpMessage];
        [self.backgroundView addSubview:self.messageLabel];
        
        self.okButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.messageLabel.frame), CGRectGetWidth(self.titleLabel.frame), 30)];
        [self.okButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_dialog_ok"] forState:UIControlStateNormal];
        [self.okButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        [self.okButton addTarget:self action:@selector(didSelect) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.okButton];
        
        self.okButton.layer.cornerRadius = 5.0;
        
        self.upView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame) + 2, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame) - 4, 1)];
        self.upView.backgroundColor = [UIColor oceanHorizonRuleTwoColor];
        [self.backgroundView addSubview:self.upView];
        
        self.buttonLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.messageLabel.frame), CGRectGetWidth(self.titleLabel.frame), 1)];
        self.buttonLineView.backgroundColor = [UIColor oceanHorizonRuleTwoColor];
        [self.backgroundView addSubview:self.buttonLineView];
        
    }
    return self;
}

- (void) didSelect {
    [self removeFromSuperview];
}

@end
