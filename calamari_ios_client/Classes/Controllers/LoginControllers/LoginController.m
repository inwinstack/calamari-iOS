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
#import "NotificationData.h"
#import "AlertSelectionView.h"
#import "AlertSelectionViewCell.h"
#import "SettingData.h"
#import "LocalizationManager.h"

@interface LoginController () <ErrorDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AlertSectionDelegate>

@property (nonatomic, strong) AlertSelectionView *alertSelectionView;
@property (nonatomic, strong) NSString *tempLanguageString;
@property (nonatomic, strong) NSString *tempImageString;
@property (nonatomic, strong) UITableView *tempTableView;
@property (nonatomic, strong) NSMutableArray *tempOptionArray;
@property (nonatomic, strong) UITextField *tempCurrentTextfield;

@end

@implementation LoginController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.loginView.hostIpField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]] : @"";
    self.loginView.portField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]] : @"";
    self.loginView.accountField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Account"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Account"]] : @"";
    self.loginView.passwordField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]] : @"";
    self.loginView.languageContentLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
    self.loginView.languageCountryImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageImage"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundAction) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[Cookies shareInstance] clearCookies];
    [[NSUserDefaults standardUserDefaults] setObject:@"didLogout" forKey:@"firstTime"];

}

- (void) backgroundAction {
    [self textFieldResign];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 2) {
        return self.tempOptionArray.count;
    } else {
        return [SettingData shareSettingData].languageOptionArray.count;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TempOptionCellIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TempOptionCellIdentifier"];
            
        }
        
        cell.textLabel.text = self.tempOptionArray[indexPath.row];
        return cell;
    } else {
        AlertSelectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LanguageSettingAlertViewCellIdentifier"];
        if (!cell) {
            cell = [[AlertSelectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LanguageSettingAlertViewCellIdentifier" imageName:[SettingData shareSettingData].languageImageOptionArray[indexPath.row]];
        }
        cell.districtLineView.alpha = (indexPath.row == 2) ? 0.0 : 1.0;
        cell.mainNameLabel.text = [SettingData shareSettingData].languageOptionArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedView.backgroundColor = ([self.tempLanguageString isEqualToString:cell.mainNameLabel.text]) ? [UIColor oceanNavigationBarColor] : [UIColor osdButtonHighlightColor];
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2) {
        self.tempCurrentTextfield.text = self.tempOptionArray[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.tempTableView.alpha = 0.0;
        }];
        
    } else {
        self.tempLanguageString = [SettingData shareSettingData].languageOptionArray[indexPath.row];
        self.tempImageString = [SettingData shareSettingData].languageImageOptionArray[indexPath.row];
        [tableView reloadData];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 37.0;
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
    [self.loginView.languageSettingButton addTarget:self action:@selector(languageSettingAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginView.hostIpField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]] : @"";
    self.loginView.portField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Port"]] : @"";
    self.loginView.accountField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Account"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Account"]] : @"";
    self.loginView.passwordField.text = ([[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]) ? [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"]] : @"";
    self.loginView.languageContentLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
    self.loginView.languageCountryImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageImage"]];
    
    self.tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tempTableView.delegate = self;
    self.tempTableView.dataSource = self;
    self.tempTableView.tag = 2;
    self.tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tempTableView];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] locationInView:self.view].y > CGRectGetMaxY(self.loginView.loginButton.frame) || [[touches anyObject] locationInView:self.view].y < CGRectGetMinY(self.loginView.accountField.frame)) {
        [self textFieldResign];
    }
}

- (void) alertButtonDidSelect:(UIButton *)alertButton {
    [[NSUserDefaults standardUserDefaults] setObject:self.tempLanguageString forKey:@"CurrentLanguage"];
    [[NSUserDefaults standardUserDefaults] setObject:self.tempImageString forKey:@"CurrentLanguageImage"];
    [[LocalizationManager sharedLocalizationManager] setLanguege];
    self.loginView.languageContentLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
    self.loginView.languageCountryImageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageImage"]];

    self.loginView.hostIpField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_host"];
    self.loginView.portField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_port"];
    self.loginView.accountField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_name"];
    self.loginView.passwordField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_password"];
    [self.loginView.loginButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_sign_in"] forState:UIControlStateNormal];
    self.loginView.versionLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_version"];
    [self.loginView setBottomInfo];
}

- (void) languageSettingAction {
    self.alertSelectionView = [[AlertSelectionView alloc] initWithTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_profile_language"] content:@""];
    self.alertSelectionView.selectionTableView.delegate = self;
    self.alertSelectionView.selectionTableView.dataSource = self;
    self.alertSelectionView.alertSectionDelegate = self;
    [self.view.window addSubview:self.alertSelectionView];
    self.tempLanguageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"];
    self.tempImageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageImage"];
    [self textFieldResign];
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
        self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_title"] message:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_sing_in"]];
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
                                                                                                        [[NotificationData shareInstance] setRecordWithHostIp:self.loginView.hostIpField.text];
                                                                                                        
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:@"did" forKey:@"refresh"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:@"did" forKey:@"firstTime"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.hostIpField.text forKey:@"HostIP"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.portField.text forKey:@"Port"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.accountField.text forKey:@"Account"];
                                                                                                        [[NSUserDefaults standardUserDefaults] setObject:self.loginView.passwordField.text forKey:@"Password"];
                                                                                                        [[NotificationData shareInstance] resetRecord];
                                                                                                        [UserData shareInstance].ipString = self.loginView.hostIpField.text;
                                                                                                        [UserData shareInstance].portString = self.loginView.portField.text;
                                                                                                        [UserData shareInstance].accountString = self.loginView.accountField.text;
                                                                                                        [UserData shareInstance].passwordString = self.loginView.passwordField.text;
                                                                                                        [SVProgressHUD dismiss];
                                                                                                        [self addHistory];
                                                                                                        if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_Notifications", self.loginView.hostIpField.text]]) {
                                                                                                            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"%@_Notifications", self.loginView.hostIpField.text]];
                                                                                                            [self setDefaultTrigger];
                                                                                                            
                                                                                                        }
                                                                                                        weakself.loginView.userInteractionEnabled = YES;
                                                                                                        weakself.navigationController.navigationBarHidden = NO;
                                                                                                        weakself.clusterHealthController = [[ClusterHealthController alloc] init];
                                                                                                        [weakself.navigationController pushViewController:weakself.clusterHealthController animated:YES];
                                                                                                        [[NotificationData shareInstance] restartTimerWithTimeInterval:30];
                                                                                                        [[NotificationData shareInstance] startDashBoardTimer];
                                                                                                        
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
            for (NSString *errorKey in [[[(NSError*)error userInfo][NSUnderlyingErrorKey] userInfo] allKeys]) {
                if ([errorKey isEqualToString:@"_kCFURLErrorAuthFailedResponseKey"]) {
                    weakself.errorView = [[ErrorView alloc] initWithFrame:weakself.view.frame title:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_title"] message:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_account_error"]];
                    [weakself.view addSubview:weakself.errorView];
                    break;
                } else if ([errorKey isEqualToString:NSLocalizedDescriptionKey]) {
                    if ([[[(NSError*)error userInfo][NSUnderlyingErrorKey] userInfo][errorKey] isEqualToString:@"A server with the specified hostname could not be found."]) {
                        weakself.errorView = [[ErrorView alloc] initWithFrame:weakself.view.frame title:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_title"] message:@"hostname could not be found."];
                        [weakself.view addSubview:weakself.errorView];
                    } else if ([[[(NSError*)error userInfo][NSUnderlyingErrorKey] userInfo][errorKey] isEqualToString:@"The Internet connection appears to be offline."]) {
                        weakself.errorView = [[ErrorView alloc] initWithFrame:weakself.view.frame title:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_title"] message:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_server_error"]];
                        [weakself.view addSubview:weakself.errorView];
                    } else {
                        [weakself.view addSubview:weakself.errorView];
                    }
                    break;
                }
            }
//            NSLog(@"ff:%@", [[[(NSError*)error userInfo][NSUnderlyingErrorKey] userInfo] allKeys]);
        }];
    } else {
        [SVProgressHUD dismiss];
        self.loginView.userInteractionEnabled = YES;
        self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_title"] message:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_field"]];
        self.errorView.delegate = self;
        [self.view addSubview:self.errorView];
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableArray *tempSortArray = [NSMutableArray array];
    if (textField == self.loginView.hostIpField) {
        self.tempOptionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginHostArray"]];
    } else if (textField == self.loginView.portField) {
        self.tempOptionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginPortArray"]];
    } else if (textField == self.loginView.accountField) {
        self.tempOptionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginAccountArray"]];
    }
    
    for (NSString *optionString in self.tempOptionArray) {
        if ([optionString rangeOfString:textField.text].location == 0) {
            [tempSortArray addObject:optionString];
        }
    }
    
    self.tempOptionArray = tempSortArray;

    if (textField != self.loginView.passwordField) {
        [self.tempTableView reloadData];
        self.tempTableView.frame = (self.tempOptionArray.count > 3) ? CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), textField.frame.size.width, 100) : CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), textField.frame.size.width, 37 * self.tempOptionArray.count);
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.tempCurrentTextfield = textField;
    [TextFieldChecker shareInstance].checkArray = [NSMutableArray arrayWithArray:@[self.loginView.hostIpField, self.loginView.portField, self.loginView.accountField, self.loginView.passwordField]];
    [self.loginView setRedField:textField];
    
    if (textField == self.loginView.hostIpField) {
        self.tempOptionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginHostArray"]];
    } else if (textField == self.loginView.portField) {
        self.tempOptionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginPortArray"]];
    } else if (textField == self.loginView.accountField) {
        self.tempOptionArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginAccountArray"]];
    }
    
    NSLog(@"%@", self.tempOptionArray);
    if (textField != self.loginView.passwordField) {
        [self.tempTableView reloadData];
        __weak typeof(self) weakSelf = self;
        self.tempTableView.frame = CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), textField.frame.size.width, 0);
        self.tempTableView.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.tempTableView.frame = CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), textField.frame.size.width, 37 * weakSelf.tempOptionArray.count);
        }];
    }
    
    if (textField.frame.origin.y > 150 && ![[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
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
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.tempTableView.alpha = 0.0;
    }];
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
    if (textField == self.loginView.passwordField) {
        [self.loginView.hostIpField becomeFirstResponder];
    } else {
        for (UIView *subView in self.loginView.subviews) {
            if ([subView class] == [UITextField class] && subView.frame.origin.y > textField.frame.origin.y) {
                [subView becomeFirstResponder];
                break;
            }
        }
    }
    
    return YES;
}

- (void) didConfirm {
    [self.errorView removeFromSuperview];
}

- (void) addHistory {
    NSMutableSet *tempLoginHostArray = [NSMutableSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginHostArray"]];
    NSMutableSet *tempLoginPortArray = [NSMutableSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginPortArray"]];
    NSMutableSet *tempLoginAccountArray = [NSMutableSet setWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginAccountArray"]];
    
    [tempLoginHostArray addObject:self.loginView.hostIpField.text];
    [tempLoginPortArray addObject:self.loginView.portField.text];
    [tempLoginAccountArray addObject:self.loginView.accountField.text];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempLoginHostArray.allObjects forKey:@"TempLoginHostArray"];
    [[NSUserDefaults standardUserDefaults] setObject:tempLoginPortArray.allObjects forKey:@"TempLoginPortArray"];
    [[NSUserDefaults standardUserDefaults] setObject:tempLoginAccountArray.allObjects forKey:@"TempLoginAccountArray"];
    NSLog(@"%@" ,[[NSUserDefaults standardUserDefaults] objectForKey:@"TempLoginAccountArray"]);
}

- (void) setDefaultTrigger {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@_OSDTriggerWarn", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@_OSDTriggerError", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@_MONTriggerWarn", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"%@_MONTriggerError", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"20" forKey:[NSString stringWithFormat:@"%@_PGTriggerWarn", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"20" forKey:[NSString stringWithFormat:@"%@_PGTriggerError", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"70" forKey:[NSString stringWithFormat:@"%@_UsageTriggerWarn", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"85" forKey:[NSString stringWithFormat:@"%@_UsageTriggerError", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"000030" forKey:[NSString stringWithFormat:@"%@_normalTimePeriod", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"000200" forKey:[NSString stringWithFormat:@"%@_abnormalTimePeriod", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@"010000" forKey:[NSString stringWithFormat:@"%@_serverAbnormalTimePeriod", self.loginView.hostIpField.text]];
    
    [[NSUserDefaults standardUserDefaults] setObject:@[@"145,135.5", @"145,135.5", @"145,314.5"] forKey:[NSString stringWithFormat:@"%@_normalPeriodPoint", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"145,135.5", @"164.65,137.68", @"145,135.5"] forKey:[NSString stringWithFormat:@"%@_abnormalPeriodPoint", self.loginView.hostIpField.text]];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"168.919373,138.755501", @"145,135.5", @"145,135.5"] forKey:[NSString stringWithFormat:@"%@_serverAbnormalPeriodPoint", self.loginView.hostIpField.text]];
    
    [[SettingData shareSettingData] setTriggerArray];
}


- (BOOL) shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
