//
//  TimePeriodController.m
//  calamari_ios_client
//
//  Created by Francis on 2015/10/13.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "TimePeriodController.h"
#import "TimePeriodView.h"
#import "SettingViewCell.h"
#import "SelectionViewCell.h"
#import "SettingViewFlowLayout.h"
#import "ClockSettingView.h"

@interface TimePeriodController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TimePeriodView *timePeriodView;
@property (nonatomic, strong) SettingViewFlowLayout *flowLayout;
@property (nonatomic, strong) ClockSettingView *clockSettingView;
@property (nonatomic, strong) UIPanGestureRecognizer *clockPanGesture;

@end

@implementation TimePeriodController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.title = @"Time Period";
    self.flowLayout = [[SettingViewFlowLayout alloc] init];
    self.timePeriodView = [[TimePeriodView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.view = self.timePeriodView;
    self.timePeriodView.delegate = self;
    self.timePeriodView.dataSource = self;
    
    [self.timePeriodView registerClass:[SettingViewCell class] forCellWithReuseIdentifier:@"TimePeriodViewCellIdentifier"];
    
    self.clockPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clockAction:)];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectionViewCell *alertTriggerSelectionCell  = [tableView dequeueReusableCellWithIdentifier:@"TimePeriodSelectionViewCellIdentifier"];
    if (!alertTriggerSelectionCell) {
        alertTriggerSelectionCell = [[SelectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimePeriodSelectionViewCellIdentifier"];
    }
    alertTriggerSelectionCell.checkBoxButton.hidden = YES;
    alertTriggerSelectionCell.districtLineView.frame = CGRectMake(alertTriggerSelectionCell.districtLineView.frame.origin.x, 73, alertTriggerSelectionCell.districtLineView.frame.size.width, alertTriggerSelectionCell.districtLineView.frame.size.height);

    return alertTriggerSelectionCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.view.window.subviews indexOfObject:self.clockSettingView] > self.view.window.subviews.count) {
        self.clockSettingView = [[ClockSettingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.clockSettingView.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [self.clockSettingView.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:self.clockSettingView];
        [self.clockSettingView addGestureRecognizer:self.clockPanGesture];
    }
}

- (void) cancelAction {
    [self.clockSettingView removeFromSuperview];
}

- (void) saveAction {
    [self.clockSettingView removeFromSuperview];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimePeriodViewCellIdentifier" forIndexPath:indexPath];
    cell.selectionView.delegate = self;
    cell.selectionView.dataSource = self;
    cell.settingNameLabel.frame = CGRectMake(0, 0, 0, 0);
    CGRect tempFrame = cell.selectionView.frame;
    
    cell.selectionView.frame = CGRectMake(tempFrame.origin.x, 0, tempFrame.size.width, 222);
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 222);
}

- (void) clockAction:(UIPanGestureRecognizer*)panGesture {

    float testA = fabs(([panGesture locationInView:self.clockSettingView].y - CGRectGetHeight(self.clockSettingView.frame) / 2.0) / ([panGesture locationInView:self.clockSettingView].x - CGRectGetWidth(self.clockSettingView.frame) / 2.0));
    
    if ([panGesture locationInView:self.clockSettingView].y > CGRectGetHeight(self.clockSettingView.frame) / 2.0) {
        if ([panGesture locationInView:self.clockSettingView].x > CGRectGetWidth(self.clockSettingView.frame) / 2.0) {
            self.clockSettingView.circleView.center = CGPointMake(145.0 + 89.5 * cos(atan(testA)), 225.0 + 89.5 * sin(atan(testA)));
        } else {
            self.clockSettingView.circleView.center = CGPointMake(145.0 - 89.5 * cos(atan(testA)), 225.0 + 89.5 * sin(atan(testA)));
        }
    } else {
        if ([panGesture locationInView:self.clockSettingView].x > CGRectGetWidth(self.clockSettingView.frame) / 2.0) {
            self.clockSettingView.circleView.center = CGPointMake(145.0 + 89.5 * cos(atan(testA)), 225.0 - 89.5 * sin(atan(testA)));
        } else {
            self.clockSettingView.circleView.center = CGPointMake(145.0 - 89.5 * cos(atan(testA)), 225.0 - 89.5 * sin(atan(testA)));
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
