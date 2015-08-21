//
//  BaseController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"
#import "UIColor+Reader.h"
#import "NotificationData.h"
#import "UIView+SizeMaker.h"

@interface BaseController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIBarButtonItem *customBarItem;

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor oceanHealthBarColor]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.hidesBackButton = YES;
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView titleIconSize], [UIView titleIconSize])];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"BackImage"] forState:UIControlStateNormal];
    self.customBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
}

- (void) setBackButtonDisplay:(BOOL)display {
    if (display) {
        [self.navigationItem setLeftBarButtonItem:self.customBarItem];
        
    } else {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}

- (void) backAction {
    [[NotificationData shareInstance].notificationArray removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
