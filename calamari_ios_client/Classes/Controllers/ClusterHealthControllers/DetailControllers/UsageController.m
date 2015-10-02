//
//  UsageController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "UsageController.h"
#import "UIColor+Reader.h"
#import "UsageStatusView.h"
#import "ClusterData.h"

@interface UsageController ()

@end

@implementation UsageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_usage_status"];
        
    self.usageStatusView = [[UsageStatusView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.usageStatusView];
    self.usageStatusView.maxLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_usage_max", [ClusterData shareInstance].clusterArray[0][@"id"]]]] doubleValue]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
    self.usageStatusView.midYLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_usage_max", [ClusterData shareInstance].clusterArray[0][@"id"]]]] doubleValue] / 2.0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
    self.usageStatusView.tempMidString = [NSString stringWithFormat:@"%f", [[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_usage_max", [ClusterData shareInstance].clusterArray[0][@"id"]]]] doubleValue] / 2.0];
    [self.usageStatusView setDataWithDataArray:[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_usage", [ClusterData shareInstance].clusterArray[0][@"id"]]]];
    self.usageStatusView.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        self.usageStatusView.alpha = 1;
    } completion:^(BOOL finished) {
        self.usageStatusView.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
