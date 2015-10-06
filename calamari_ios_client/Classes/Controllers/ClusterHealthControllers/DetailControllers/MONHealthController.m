//
//  MONHealthController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "MONHealthController.h"
#import "UIColor+Reader.h"
#import "MONHealthView.h"
#import "MONHealthCell.h"
#import "MONHealthFlowLayout.h"
#import "MONHealthData.h"
#import "ClusterData.h"

@interface MONHealthController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MONHealthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_mon_health"];
    
    self.flowLayout = [[MONHealthFlowLayout alloc] init];
    self.monHealthView = [[MONHealthView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    [self.monHealthView registerClass:[MONHealthCell class] forCellWithReuseIdentifier:@"MONHealthIdetntifer"];
    self.monHealthView.delegate = self;
    self.monHealthView.dataSource = self;
    self.view = self.monHealthView;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [MONHealthData shareInstance].monArray.count;
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
    MONHealthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MONHealthIdetntifer" forIndexPath:indexPath];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@", [MONHealthData shareInstance].monArray[indexPath.row][@"name"]];
    cell.ipLabel.text = [NSString stringWithFormat:@"%@", [MONHealthData shareInstance].monArray[indexPath.row][@"addr"]];
    if ([[[MONHealthData shareInstance] checkMonWithNodeName:cell.numberLabel.text] isEqualToString:@"HEALTH_ERROR"]) {
        cell.colorView.backgroundColor = [UIColor errorColor];
    } else if ([[[MONHealthData shareInstance] checkMonWithNodeName:cell.numberLabel.text] isEqualToString:@"HEALTH_WARN"]) {
        cell.colorView.backgroundColor = [UIColor warningColor];
    } else if ([[[MONHealthData shareInstance] checkMonWithNodeName:cell.numberLabel.text] isEqualToString:@"HEALTH_OK"]) {
        cell.colorView.backgroundColor = [UIColor okGreenColor];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
