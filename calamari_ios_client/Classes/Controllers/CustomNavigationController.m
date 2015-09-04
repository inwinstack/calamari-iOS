//
//  CustomNavigationController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/20.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "CustomNavigationController.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "UINavigationBar+HeightMaker.h"
#import "ClusterHealthController.h"
#import "ChartController.h"
#import "MutualController.h"
#import "HealthDetailController.h"
#import "OSDHealthController.h"
#import "MONHealthController.h"
#import "HostHealthController.h"
#import "PGStatusController.h"
#import "UsageController.h"
#import "PoolIOPSController.h"
#import "PoolListController.h"
#import "Cookies.h"
#import "NotificationController.h"
#import "CephAPI.h"
#import "ClusterData.h"
#import "UserData.h"
#import "ErrorView.h"
#import "SVProgressHUD.h"
#import "NavigationView.h"
#import "NavigationViewCell.h"
#import "NotificationData.h"
#import "APIRecord.h"

@interface CustomNavigationController ()<DidReceiveCollectionIndexDelegate, ErrorDelegate, UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    int count;
    NSInteger tempSelectedIndex;
    BOOL isTouchFromZero;
    float tempX;
}

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIBarButtonItem *menuBarButton;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) NotificationController *notificationController;
@property (nonatomic, strong) NavigationView *navigationView;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIWindow *navigationWindow;
@property (nonatomic, strong) UITapGestureRecognizer *removeTapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *navigationPanGesture;

@end

@implementation CustomNavigationController

- (instancetype) initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.panGesture.enabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self.navigationBar setHeight:45];
    [self.navigationBar setBarTintColor:[UIColor oceanNavigationBarColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIView titleSize]]}];
    self.navigationItem.hidesBackButton = YES;
    self.navigationView = [[NavigationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.navigationView.navigationTableView.delegate = self;
    self.navigationView.navigationTableView.dataSource = self;
    [self.navigationView.navigationTableView setShowsVerticalScrollIndicator:NO];
    self.removeTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavigation)];
    [self.removeTapGesture setNumberOfTapsRequired:1];
    [self.removeTapGesture setNumberOfTouchesRequired:1];
    [self.navigationView.backgroundView addGestureRecognizer:self.removeTapGesture];
    
    self.navigationPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(removePan:)];
    [self.navigationPanGesture setMaximumNumberOfTouches:1];
    [self.navigationView addGestureRecognizer:self.navigationPanGesture];
    
    self.navigationWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.navigationWindow.backgroundColor = [UIColor clearColor];
    self.navigationWindow.windowLevel = UIWindowLevelStatusBar + 1;
    [self.navigationWindow addSubview:self.navigationView];
    isTouchFromZero = false;
    
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIView titleIconSize], [UIView titleIconSize])];
    [self.menuButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setBackgroundImage:[UIImage imageNamed:@"NavigationImage"] forState:UIControlStateNormal];
    self.menuButton.exclusiveTouch = YES;
    
    self.menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    
    
    self.itemArray = @[@"Dashboard", @"Health Detail", @"OSD Health", @"Monitor Health", @"Pool List", @"Host List", @"PG Status", @"Usage Status", @"Pool IOPS", @"Notifications", @"Logs", @"Settings", @"Logout"];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:self.panGesture];

}

- (void) didReceiveIndex:(NSInteger)collectionIndex {
    tempSelectedIndex = collectionIndex + 1;
    [self.navigationView.navigationTableView reloadData];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[ClusterData shareInstance] setData:[ClusterData shareInstance].clusterArray[0][@"id"] completion:^(BOOL finished) {
        if (finished) {
            if (collectionIndex == -1) {
                [SVProgressHUD dismiss];
                [self popToViewController:self.viewControllers[1] animated:YES];
                tempSelectedIndex = 0;
            }
            switch (collectionIndex) {
                case 0: {
                    [SVProgressHUD dismiss];
                    self.healthDetailController = [[HealthDetailController alloc] init];
                    [self pushViewController:self.healthDetailController animated:YES];
                    self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.healthDetailController];
                    break;
                } case 1: {
                    self.errorView = [[ErrorView alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"系統訊息" message:@"連線錯誤"];
                    self.errorView.delegate = self;
                    [[CephAPI shareInstance] startGetClusterDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString Version:[APIRecord shareInstance].APIDictionary[@"OSD"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"OSD"][1] completion:^(BOOL finished) {
                        if (finished) {
                            [SVProgressHUD dismiss];
                            self.osdHealthController = [[OSDHealthController alloc] init];
                            [self pushViewController:self.osdHealthController animated:YES];
                            self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.osdHealthController];
                        }
                    } error:^(id error) {
                        if (error) {
                            [SVProgressHUD dismiss];
                            [self.view addSubview:self.errorView];
                            NSLog(@"%@", error);
                        }
                    }];
                    break;
                } case 2: {
                    [SVProgressHUD dismiss];
                    self.monHealthController = [[MONHealthController alloc] init];
                    [self pushViewController:self.monHealthController animated:YES];
                    self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.monHealthController];
                    break;
                } case 3: {
                    [SVProgressHUD dismiss];
                    self.poolListController = [[PoolListController alloc] init];
                    [self pushViewController:self.poolListController animated:YES];
                    self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.poolListController];
                    break;
                } case 4: {
                    [SVProgressHUD dismiss];
                    self.hostHealthController = [[HostHealthController alloc] init];
                    [self pushViewController:self.hostHealthController animated:YES];
                    self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.hostHealthController];
                    break;
                } case 5: {
                    [SVProgressHUD dismiss];
                    self.pgStatusController = [[PGStatusController alloc] init];
                    [self pushViewController:self.pgStatusController animated:YES];
                    self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.pgStatusController];
                    break;
                } case 6 : {
                    self.errorView = [[ErrorView alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"系統訊息" message:@"連線錯誤"];
                    self.errorView.delegate = self;
                    [[CephAPI shareInstance] startGetUsageStatusWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Completion:^(BOOL finished) {
                        if (finished) {
                            [SVProgressHUD dismiss];
                            self.usageController = [[UsageController alloc] init];
                            [self pushViewController:self.usageController animated:YES];
                            self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.usageController];
                        }
                    } error:^(id error) {
                        [SVProgressHUD dismiss];
                        [self.view addSubview:self.errorView];
                        NSLog(@"%@", error);
                    }];
                    break;
                } case 7: {
                    self.errorView = [[ErrorView alloc] initWithFrame:[UIScreen mainScreen].bounds title:@"系統訊息" message:@"連線錯誤"];
                    self.errorView.delegate = self;
                    count = 0;
                    for (id poolObject in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops_ID", [ClusterData shareInstance].clusterArray[0][@"id"]]]) {
                        [[CephAPI shareInstance] startGetPoolIOPSWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString PoolID:poolObject[@"id"] Completion:^(BOOL finished) {
                            if (finished) {
                                count++;
                                if (count == [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops_ID", [ClusterData shareInstance].clusterArray[0][@"id"]]] count]) {
                                    [self poolAction];
                                }
                                
                            }
                        } error:^(id error) {
                            [SVProgressHUD dismiss];
                            [self.view addSubview:self.errorView];
                            NSLog(@"%@", error);
                        }];
                    }
                    break;
                } case 8: {
                    [SVProgressHUD dismiss];
                    self.notificationController = [[NotificationController alloc] init];
                    [self pushViewController:self.notificationController animated:YES];
                    self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.notificationController];
                    break;
                } case 9: {
                    [SVProgressHUD dismiss];
                    break;
                } case 10: {
                    [SVProgressHUD dismiss];
                    break;
                } case 11: {
                    [SVProgressHUD dismiss];
                    [[NotificationData shareInstance] stopTimer];
                    [self popToRootViewControllerAnimated:YES];
                    break;
                }
            }
            
        }
    }];
}

- (void) poolAction {
    [[CephAPI shareInstance] startGetPoolIOPSWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString PoolID:[NSString stringWithFormat:@"ceph.cluster.%@.pool.all", [ClusterData shareInstance].clusterArray[0][@"id"]] Completion:^(BOOL finished) {
        if (finished) {
            [SVProgressHUD dismiss];
            self.poolIOPSController = [[PoolIOPSController alloc] init];
            [self pushViewController:self.poolIOPSController animated:YES];
            self.viewControllers = @[self.viewControllers[0], self.viewControllers[1], self.poolIOPSController];
            
        }
    } error:^(id error) {
        [SVProgressHUD dismiss];
        [self.view addSubview:self.errorView];
        NSLog(@"%@", error);
    }];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NavigationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NavigationCellIdentifier"];
    if (!cell) {
        cell = [[NavigationViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NavigationCellIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = (indexPath.row == tempSelectedIndex) ? [UIColor navigationSelectedColor] : [UIColor clearColor];
    cell.nameLabel.text = self.itemArray[indexPath.row];
    cell.lineView.hidden = (![cell.nameLabel.text isEqualToString:@"Settings"]);
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tempSelectedIndex == indexPath.row) {
        [self removeNavigation];
    } else {
        [self removeNavigation];
        [self didReceiveIndex:indexPath.row - 1];
    }
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIView navigationSize], 10)];
    footerView.backgroundColor = [UIColor oceanBackgroundOneColor];
    return footerView;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIView navigationSize], 10)];
    headerView.backgroundColor = [UIColor oceanBackgroundOneColor];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void) didConfirm {
    [self.errorView removeFromSuperview];
}

- (void) removeNavigation {
    [self.panGesture setEnabled:YES];
    isTouchFromZero = false;
    [self.navigationView removeAnimation];
}

- (void) menuAction {
    [self.navigationPanGesture setEnabled:YES];
    [self.navigationView displayAnimation];
}

- (void) panAction:(UIPanGestureRecognizer*)pan {
    if (isTouchFromZero) {
        self.navigationWindow.hidden = NO;
        if (pan.state == UIGestureRecognizerStateEnded && [pan locationInView:self.view].x < CGRectGetWidth([UIScreen mainScreen].bounds) / 2) {
            [self removeNavigation];
            isTouchFromZero = false;
        } else if (pan.state == UIGestureRecognizerStateEnded && [pan locationInView:self.view].x >= CGRectGetWidth([UIScreen mainScreen].bounds) / 2) {
            [self.navigationPanGesture setEnabled:YES];
            [pan setEnabled:NO];
            self.navigationWindow.hidden = NO;
            [self.navigationView confirmPanAnimateWithFloatX:[pan locationInView:self.view].x];
        } else if ([pan locationInView:self.view].x >= [UIView navigationSize]) {
            isTouchFromZero = false;
            [self.navigationPanGesture setEnabled:YES];
            [pan setEnabled:NO];
            self.navigationWindow.hidden = NO;
            [self.navigationView confirmPanAnimate];
        } else {
            float moveX = ([pan locationInView:self.view].x >= [UIView navigationSize]) ? [UIView navigationSize] : [pan locationInView:self.view].x;
            [self.navigationView userPanAnimateWithX:moveX];
        }
    } else {
        if (pan.state == UIGestureRecognizerStateBegan && [pan locationInView:self.view].x < 150) {
            isTouchFromZero = true;
        } else {
            [self.navigationView resetPanAnimate];
            self.navigationWindow.hidden = YES;
            isTouchFromZero = false;
        }
    }
}

- (void) removePan:(UIPanGestureRecognizer*)removePan {
    if (isTouchFromZero) {
        self.navigationWindow.hidden = NO;
        if (removePan.state == UIGestureRecognizerStateEnded && [removePan locationInView:self.view].x < CGRectGetWidth([UIScreen mainScreen].bounds) / 2) {
            [self removeNavigation];
            isTouchFromZero = false;
            [removePan setEnabled:NO];
        } else if (removePan.state == UIGestureRecognizerStateEnded && [removePan locationInView:self.view].x >= CGRectGetWidth([UIScreen mainScreen].bounds) / 2) {
            self.navigationWindow.hidden = NO;
            [self.navigationView confirmPanAnimateWithFloatX:[removePan locationInView:self.view].x];
        } else if ([removePan locationInView:self.view].x >= [UIView navigationSize]) {
            isTouchFromZero = false;
            self.navigationWindow.hidden = NO;
            [self.navigationView confirmPanAnimate];
        } else {
            float moveX = ([removePan locationInView:self.view].x >= [UIView navigationSize]) ? [UIView navigationSize] : [removePan locationInView:self.view].x;
            [self.navigationView userPanAnimateWithX:moveX];
        }
    } else {
        if (removePan.state == UIGestureRecognizerStateBegan) {
            tempX = [removePan locationInView:self.navigationView].x;
        } else if (removePan.state == UIGestureRecognizerStateChanged && [removePan locationInView:self.navigationView].x < tempX) {
            isTouchFromZero = true;
        }
    }
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    self.panGesture.enabled = YES;
    if ([viewController class] == [ClusterHealthController class]) {
        self.navigationView.userNameLabel.text = [UserData shareInstance].accountString;
        self.navigationView.userIPLabel.text = [UserData shareInstance].ipString;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [(ClusterHealthController*)viewController setDelegate:self];
        [viewController.navigationItem setLeftBarButtonItem:self.menuBarButton];
    }
}

- (NSArray*) popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *popArray = [super popToRootViewControllerAnimated:animated];
    self.panGesture.enabled = NO;
    return popArray;
}

- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController class] == [ClusterHealthController class]) {
        tempSelectedIndex = 0;
        [self.navigationView.navigationTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
