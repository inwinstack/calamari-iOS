//
//  ErrorView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ErrorView.h"
#import "UIColor+Reader.h"

@interface ErrorView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation ErrorView

- (instancetype) initWithFrame:(CGRect)frame title:(NSString*)title message:(NSString*)message {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMidY(self.frame) - 75, CGRectGetWidth(self.frame) - 20, 30)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = [NSString stringWithFormat:@"  %@", title];
        self.titleLabel.backgroundColor = [UIColor errorColor];
        [self addSubview:self.titleLabel];
    
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 90)];
        self.messageLabel.text = [NSString stringWithFormat:@"  %@", message];
        self.messageLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.messageLabel];
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.messageLabel.frame), CGRectGetWidth(self.titleLabel.frame), 30)];
        self.confirmButton.backgroundColor = [UIColor osdButtonDefaultColor];
        [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(didSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
    }
    return self;
}

- (void) didSelect {
    if (self.delegate) {
        [self.delegate didConfirm];
    } else {
        [self removeFromSuperview];
    }
}

@end
