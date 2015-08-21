//
//  LoginController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "CephAPI.h"
#import "ClusterHealthController.h"
#import "APIRecord.h"
#import "ClusterData.h"
#import "ErrorView.h"
#import "TextFieldChecker.h"
#import "UIColor+Reader.h"
#import "UserData.h"
#import "SVProgressHUD.h"
#import "UIView+SizeMaker.h"
#import "Cookies.h"

@interface LoginController () <ErrorDelegate, UITextFieldDelegate>

@end

@implementation LoginController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.loginView.hostIpField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]] : @"";
    self.loginView.portField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]] : @"";
    self.loginView.accountField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Account"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Account"]] : @"";
    self.loginView.passwordField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]] : @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundAction) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[Cookies shareInstance] clearCookies];
    [[NSUserDefaults standardUserDefaults] setObject:@"didLogout" forKey:@"firstTime"];
}

- (void) backgroundAction {
    [self textFieldResign];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.loginView = [[LoginView alloc] initWithFrame:self.view.frame];
    self.view = self.loginView;
    self.loginView.hostIpField.delegate = self;
    self.loginView.portField.delegate = self;
    self.loginView.accountField.delegate = self;
    self.loginView.passwordField.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
    [self.loginView.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) loginAction {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    self.loginView.userInteractionEnabled = NO;
    [self textFieldResign];
    self.loginView.hostIpField.text = [self.loginView.hostIpField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.loginView.portField.text = [self.loginView.portField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.loginView.accountField.text = [self.loginView.accountField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.loginView.passwordField.text = [self.loginView.passwordField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if ([[TextFieldChecker shareInstance] startCheck]) {
        [[TextFieldChecker shareInstance].checkArray removeAllObjects];
        self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:@"Login Failed" message:@"連線錯誤"];
        self.errorView.delegate = self;
        __weak typeof(self) weakself = self;
        [[CephAPI shareInstance] startGetSessionWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Account:self.loginView.accountField.text Password:self.loginView.passwordField.text completion:^(BOOL finished) {
            if (finished) {
                [[CephAPI shareInstance] startGetClusterListWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text completion:^(BOOL finished) {
                    if (finished) {
                        [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"Health"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Health"][1] completion:^(BOOL finished) {
                            if (finished) {
                                [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"Health_Counter"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Health_Counter"][1] completion:^(BOOL finished) {
                                    if (finished) {
                                        [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"Pools"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Pools"][1] completion:^(BOOL finished) {
                                            if (finished) {
                                                [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"Hosts"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Hosts"][1] completion:^(BOOL finished) {
                                                    if (finished) {
                                                        [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"OSD"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"OSD"][1] completion:^(BOOL finished) {
                                                            if (finished) {
                                                                [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"MON"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"MON"][1] completion:^(BOOL finished) {
                                                                    if (finished) {
                                                                        [[CephAPI shareInstance] startGetClusterDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text Version:[APIRecord shareInstance].APIDictionary[@"Space"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Space"][1] completion:^(BOOL finished) {
                                                                            if (finished) {
                                                                                [[CephAPI shareInstance] startGetIOPSDataWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Completion:^(BOOL finished) {
                                                                                    if (finished) {
                                                                                        [[CephAPI shareInstance] startGetIOPSIDWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Completion:^(BOOL finished) {
                                                                                            if (finished) {
                                                                                                [[CephAPI shareInstance] startGetPoolListWithIP:self.loginView.hostIpField.text Port:self.loginView.portField.text ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Completion:^(BOOL finished) {
                                                                                                    if (finished) {
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:@"did" forKey:@"firstTime"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.hostIpField.text forKey:@"HostIP"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.portField.text forKey:@"Port"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.accountField.text forKey:@"Account"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.passwordField.text forKey:@"Password"];
                                                                                                        [UserData shareInstance].ipString = self.loginView.hostIpField.text;
                                                                                                        [UserData shareInstance].portString = self.loginView.portField.text;
                                                                                                        [UserData shareInstance].accountString = self.loginView.accountField.text;
                                                                                                        [UserData shareInstance].passwordString = self.loginView.passwordField.text;
                                                                                                        weakself.loginView.userInteractionEnabled = YES;
                                                                                                        weakself.navigationController.navigationBarHidden = NO;
                                                                                                        weakself.clusterHealthController = [[ClusterHealthController alloc] init];
                                                                                                        [weakself.navigationController pushViewController:weakself.clusterHealthController animated:YES];
                                                                                                        [SVProgressHUD dismiss];
                                                                                                    }
                                                                                                } error:^(id error) {
                                                                                                    [SVProgressHUD dismiss];
                                                                                                    weakself.loginView.userInteractionEnabled = YES;
                                                                                                    [weakself.view addSubview:weakself.errorView];
                                                                                                    NSLog(@"%@", error);
                                                                                                }];

                                                                                            }
                                                                                        } error:^(id error) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            weakself.loginView.userInteractionEnabled = YES;
                                                                                            [weakself.view addSubview:weakself.errorView];
                                                                                            NSLog(@"%@", error);
                                                                                        }];
                                                                                    }
                                                                                } error:^(id error) {
                                                                                    [SVProgressHUD dismiss];
                                                                                    weakself.loginView.userInteractionEnabled = YES;
                                                                                    [weakself.view addSubview:weakself.errorView];
                                                                                    NSLog(@"%@", error);
                                                                                }];

                                                                            }
                                                                        } error:^(id error) {
                                                                            [SVProgressHUD dismiss];
                                                                            weakself.loginView.userInteractionEnabled = YES;
                                                                            [weakself.view addSubview:weakself.errorView];
                                                                            NSLog(@"%@", error);
                                                                        }];

                                                                    }
                                                                } error:^(id error) {
                                                                    [SVProgressHUD dismiss];
                                                                    weakself.loginView.userInteractionEnabled = YES;
                                                                    [weakself.view addSubview:weakself.errorView];
                                                                    NSLog(@"%@", error);
                                                                }];
                                                            }
                                                        } error:^(id error) {
                                                            [SVProgressHUD dismiss];
                                                            weakself.loginView.userInteractionEnabled = YES;
                                                            [weakself.view addSubview:weakself.errorView];
                                                            NSLog(@"%@", error);
                                                        }];
                                                    }
                                                } error:^(id error) {
                                                    [SVProgressHUD dismiss];
                                                    weakself.loginView.userInteractionEnabled = YES;
                                                    [weakself.view addSubview:weakself.errorView];
                                                    NSLog(@"%@", error);
                                                }];
                                            }
                                        } error:^(id error) {
                                            [SVProgressHUD dismiss];
                                            weakself.loginView.userInteractionEnabled = YES;
                                            [weakself.view addSubview:weakself.errorView];
                                            NSLog(@"%@", error);
                                        }];
                                    }
                                } error:^(id error) {
                                    [SVProgressHUD dismiss];
                                    weakself.loginView.userInteractionEnabled = YES;
                                    [weakself.view addSubview:weakself.errorView];
                                    NSLog(@"%@", error);
                                }];
                            }
                        } error:^(id error) {
                            [SVProgressHUD dismiss];
                            weakself.loginView.userInteractionEnabled = YES;
                            [weakself.view addSubview:weakself.errorView];
                            NSLog(@"%@", error);
                        }];
                    }
                } error:^(id error) {
                    [SVProgressHUD dismiss];
                    weakself.loginView.userInteractionEnabled = YES;
                    [weakself.view addSubview:weakself.errorView];
                    NSLog(@"%@", error);
                }];
            }
        } error:^(id error) {
            [SVProgressHUD dismiss];
            weakself.loginView.userInteractionEnabled = YES;
            [weakself.view addSubview:weakself.errorView];
            NSLog(@"%@", error);
        }];
    } else {
        [SVProgressHUD dismiss];
        self.loginView.userInteractionEnabled = YES;
        self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:@"Login Failed" message:@"欄位未填"];
        self.errorView.delegate = self;
        [self.view addSubview:self.errorView];
    }
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [[TextFieldChecker shareInstance].checkArray addObjectsFromArray:@[self.loginView.hostIpField, self.loginView.portField, self.loginView.accountField, self.loginView.passwordField]];
    [self.loginView setRedField:textField];
    if (textField.frame.origin.y > 150) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 150, self.view.frame.size.width, self.view.frame.size.height);
            textField.tag = 1;
        }];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.loginView setRedField:nil];
    if (textField.tag) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 150, self.view.frame.size.width, self.view.frame.size.height);
            textField.tag = 0;
        }];
    }
}

- (void) textFieldResign {
    [self.loginView setRedField:nil];
    [self.loginView.passwordField resignFirstResponder];
    [self.loginView.accountField resignFirstResponder];
    [self.loginView.hostIpField resignFirstResponder];
    [self.loginView.portField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self.loginView setRedField:nil];
    [textField resignFirstResponder];
    return YES;
}

- (void) didConfirm {
    [self.errorView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
