//
//  HostHealthController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostHealthController.h"
#import "HostHealthViewCell.h"
#import "HostHealthView.h"
#import "UIColor+Reader.h"
#import "HostHealthFlowLayout.h"
#import "HostHealthData.h"
#import "HostDetailController.h"
#import "CephAPI.h"
#import "UserData.h"
#import "ErrorView.h"
#import "SVProgressHUD.h"

@interface HostHealthController () <ErrorDelegate>

@property (nonatomic, strong) ErrorView *errorView;

@end

@implementation HostHealthController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = @"Host List";
    
    self.hostHealthFlowLayout = [[HostHealthFlowLayout alloc] init];
    self.hostHealthView = [[HostHealthView alloc] initWithFrame:self.view.frame collectionViewLayout:self.hostHealthFlowLayout];
    self.view = self.hostHealthView;
    
    [self.hostHealthView registerClass:[HostHealthViewCell class] forCellWithReuseIdentifier:@"HostHealthCellIdentifier"];
    self.hostHealthView.delegate = self;
    self.hostHealthView.dataSource = self;
    
    self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:@"系統訊息" message:@"連線錯誤"];
    self.errorView.delegate = self;
    
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
    HostHealthViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HostHealthCellIdentifier" forIndexPath:indexPath];
    NSString *key = [HostHealthData shareInstance].hostArray[indexPath.row];
    NSDictionary *object = [HostHealthData shareInstance].hostAllData[key];
    int count = 0;
    for (id services in object[@"services"]) {
        if ([[NSString stringWithFormat:@"%@", services[@"type"]] isEqualToString:@"osd"]) {
            count++;
        }
    }
    cell.countLabel.text = [NSString stringWithFormat:@"%d", count];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", object[@"hostname"]];
    return cell;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [HostHealthData shareInstance].hostArray.count;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempName = [(HostHealthViewCell*)[collectionView cellForItemAtIndexPath:indexPath] nameLabel].text;
    [HostHealthData shareInstance].hostDic = [NSMutableDictionary dictionary];
    self.hostHealthView.userInteractionEnabled = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[CephAPI shareInstance] startGetCPUSummaryDataWithIP:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] Port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] nodeID:tempName Completion:^(BOOL finished) {
        if (finished) {
            [SVProgressHUD dismiss];
            self.hostHealthView.userInteractionEnabled = YES;
            self.hostDetailController = [[HostDetailController alloc] init];
            self.hostDetailController.navigationTitle = tempName;
            [self.navigationController pushViewController:self.hostDetailController animated:YES];
        }
    } error:^(id error) {
        [SVProgressHUD dismiss];
        self.hostHealthView.userInteractionEnabled = YES;
        [self.view addSubview:self.errorView];
        NSLog(@"%@",error);
    }];

}

- (void) didConfirm {
    [self.errorView removeFromSuperview];
}

@end
