//
//  PGStatusController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/27.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PGStatusController.h"
#import "UIColor+Reader.h"
#import "PGStatusView.h"
#import "PGStatusViewCell.h"
#import "PGStatusFlowLayout.h"
#import "PGData.h"

@interface PGStatusController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PGStatusFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *pgDataArray;

@end

@implementation PGStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_pg_status"];
    
    self.layout = [[PGStatusFlowLayout alloc] init];
    self.pgStatusView = [[PGStatusView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
    [self.pgStatusView registerClass:[PGStatusViewCell class] forCellWithReuseIdentifier:@"PGStatusCellIdentifier"];
    self.pgStatusView.delegate = self;
    self.pgStatusView.dataSource = self;
    self.view = self.pgStatusView;
    
    self.pgDataArray = [NSMutableArray array];
    for (id criticalKey in [PGData shareInstance].criticalArray) {
        if ([PGData shareInstance].pgDic[criticalKey]) {
            [self.pgDataArray addObject:@[@"Critical", criticalKey, [NSString stringWithFormat:@"%@", [PGData shareInstance].pgDic[criticalKey]]]];
        }
    }
    
    for (id warnKey in [PGData shareInstance].warnArray) {
        if ([PGData shareInstance].pgDic[warnKey]) {
            [self.pgDataArray addObject:@[@"Warn", warnKey, [NSString stringWithFormat:@"%@", [PGData shareInstance].pgDic[warnKey]]]];
        }
    }
    
    for (id okKey in [PGData shareInstance].okArray) {
        if ([PGData shareInstance].pgDic[okKey]) {
            [self.pgDataArray addObject:@[@"Ok", okKey, [NSString stringWithFormat:@"%@", [PGData shareInstance].pgDic[okKey]]]];
        }
    }
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pgDataArray.count;
}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PGStatusViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PGStatusCellIdentifier" forIndexPath:indexPath];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@", [PGData shareInstance].pgKeyDic[self.pgDataArray[indexPath.row][1]]];
    cell.countLabel.text = [NSString stringWithFormat:@"%@", self.pgDataArray[indexPath.row][2]];
    
    if ([self.pgDataArray[indexPath.row][0] isEqualToString:@"Critical"]) {
        cell.colorView.fillColor = [UIColor errorColor].CGColor;
        cell.pgsLabel.text = [NSString stringWithFormat:@"%@ pgs", [self calculatePGCount:[PGData shareInstance].criticalCount]];
    } else if ([self.pgDataArray[indexPath.row][0] isEqualToString:@"Warn"]) {
        cell.colorView.fillColor = [UIColor warningColor].CGColor;
        cell.pgsLabel.text = [NSString stringWithFormat:@"%@ pgs", [self calculatePGCount:[PGData shareInstance].warnCount]];
    } else if ([self.pgDataArray[indexPath.row][0] isEqualToString:@"Ok"]) {
        cell.colorView.fillColor = [UIColor okGreenColor].CGColor;
        cell.pgsLabel.text = [NSString stringWithFormat:@"%@ pgs", [self calculatePGCount:[PGData shareInstance].okCount]];
    }
    return cell;
}

- (NSString*) calculatePGCount:(NSString*)pgCount {
    if (pgCount.intValue >= 100000) {
        return [NSString stringWithFormat:@"%.1fM", pgCount.floatValue / 100000.0];
    } else if (pgCount.intValue >= 1000) {
        return [NSString stringWithFormat:@"%.1fK", pgCount.floatValue / 1000.0];
    } else {
        return pgCount;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
