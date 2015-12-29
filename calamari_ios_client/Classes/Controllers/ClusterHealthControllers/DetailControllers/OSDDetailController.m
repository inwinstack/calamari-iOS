//
//  OSDDetailController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDDetailController.h"
#import "UIColor+Reader.h"
#import "OSDDetailView.h"
#import "ClusterData.h"
#import "OSDHealthData.h"
#import "UIView+SizeMaker.h"
#import "HelpView.h"
#import "LocalizationManager.h"

@interface OSDDetailController ()

@property (nonatomic, strong) NSDictionary *currentOSDDictionary;

@end

@implementation OSDDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.osdDetailView = [[OSDDetailView alloc] initWithFrame:self.view.frame];
    
    for (id object in [OSDHealthData shareInstance].osdArray) {
        if ([object[@"id"] integerValue] == self.currentIndex) {
            self.currentOSDDictionary = (NSDictionary*)object;
        }
    }
    self.osdDetailView.hostNameValueLabel.text = [NSString stringWithFormat:@"%@", self.currentOSDDictionary[@"host"]];
    self.osdDetailView.clusterValueLabel.text = [NSString stringWithFormat:@"%@", self.currentOSDDictionary[@"cluster_addr"]];
    self.osdDetailView.publicValueLabel.text = [NSString stringWithFormat:@"%@", self.currentOSDDictionary[@"public_addr"]];
    self.osdDetailView.uuidValueLabel.text = [NSString stringWithFormat:@"%@", self.currentOSDDictionary[@"uuid"]];
    float reweight = [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_osd_detail", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"reweight"] floatValue] / 1.0;
    self.osdDetailView.reWeightValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)(reweight * 100.0)];
//    [self.osdDetailView setPoolLabelsArray:@[@"Teset", @"FrancisHu770410@gmail.com", @"nutc.imac", @"1234", @"I Love My Family and I want world peace", @"Franc", @"Teset", @"FrancisHu770410@gmail.com", @"nutc.imac", @"1234", @"I Love My Family and I want world peace", @"Franc"]];

    [self.osdDetailView setPoolLabelsArray:(NSArray*)self.currentOSDDictionary[@"pools"]];
    [self.view addSubview:self.osdDetailView];
    
    [self.osdDetailView.reweightHelpButton addTarget:self action:@selector(reweightHelpAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.title = [NSString stringWithFormat:@"%ld", (long)self.currentIndex];
    switch (self.OSDdetailType) {
        case OSDDetailOKType: {
            [self.navigationController.navigationBar setBarTintColor:[UIColor okGreenColor]];
            break;
        } case OSDDetailWarnType: {
            [self.navigationController.navigationBar setBarTintColor:[UIColor warningColor]];
            break;
        } case OSDDetailErrorType: {
            [self.navigationController.navigationBar setBarTintColor:[UIColor errorColor]];
            break;
        }
    }
    self.osdDetailView.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        self.osdDetailView.alpha = 1;
    } completion:^(BOOL finished) {
        self.osdDetailView.alpha = 1;
    }];
}

- (void) reweightHelpAction {
    HelpView *helpView = [[HelpView alloc] initWithTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_re_weight_help_title"] message:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_re_weight_help"]];
    [self.view.window addSubview:helpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
