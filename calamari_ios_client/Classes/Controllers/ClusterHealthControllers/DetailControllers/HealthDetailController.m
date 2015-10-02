//
//  HealthDetailController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HealthDetailController.h"
#import "HealthDetailView.h"
#import "HealthDetailViewCell.h"
#import "HealthDetailData.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface HealthDetailController ()

@end

@implementation HealthDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_health_detail"];
    
    self.healthDetailView = [[HealthDetailView alloc] initWithFrame:self.view.frame];
    self.view = self.healthDetailView;
    self.healthDetailView.delegate = self;
    self.healthDetailView.dataSource = self;
    
    if ([HealthDetailData shareInstance].detailArray.count == 0) {
        self.healthDetailView.okView.alpha = 1;
        self.healthDetailView.okLabel.alpha = 1;
    } else {
        self.healthDetailView.okView.alpha = 0;
        self.healthDetailView.okLabel.alpha = 0;
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HealthDetailData shareInstance].detailArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HealthDetailIdentifier"];
    if (!cell) {
        cell = [[HealthDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HealthDetailIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.statusImage.image = ([[HealthDetailData shareInstance].detailArray[indexPath.row][@"severity"] isEqualToString:@"HEALTH_WARN"]) ? [UIImage imageNamed:@"HealthWarnImage"] : [UIImage imageNamed:@"HealthErrorImage"];
    cell.statusLabel.text = [NSString stringWithFormat:@"%@", [HealthDetailData shareInstance].detailArray[indexPath.row][@"summary"]];
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(HealthDetailViewCell*)cell reloadLayout];
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float widthMax = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9;
    float tempHeight = [NSString stringWithFormat:@"%@", [HealthDetailData shareInstance].detailArray[indexPath.row]].length * 5 / widthMax;
    int tempInt = ceil(tempHeight);
    return tempInt * CGRectGetWidth([UIScreen mainScreen].bounds) / 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
