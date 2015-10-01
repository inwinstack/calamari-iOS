//
//  NotificationController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationController.h"
#import "NotificationView.h"
#import "NotificationCell.h"
#import "NotificationViewFlowLayout.h"
#import "UIColor+Reader.h"
#import "NotificationDetailController.h"
#import "DateMaker.h"

@interface NotificationController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NotificationDetailController *notificationDetailController;

@end

@implementation NotificationController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor oceanHealthBarColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notifications";
    [self setBackButtonDisplay:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"didRefreshAction" object:nil];
    NotificationViewFlowLayout *layout = [[NotificationViewFlowLayout alloc] init];
    self.notificationView = [[NotificationView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    self.notificationView.delegate = self;
    self.notificationView.dataSource = self;
    [self noNotficationAction];
    self.view = self.notificationView;
    
    [self.notificationView registerClass:[NotificationCell class] forCellWithReuseIdentifier:@"notificationCell"];
}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(NotificationCell*)cell reloadLayout];
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            cell.alpha = 1;
        }
    }];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dataString = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationAlerts"][indexPath.row][@"Content"];

    NSInteger rowCount = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? (dataString.length / 102) + 1 : (dataString.length / 40) + 1 ;
    return CGSizeMake( CGRectGetWidth(self.view.frame) - 20, rowCount * 15 + 55);
}

- (void) refreshAction {
    [self.notificationView reloadData];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self noNotficationAction];
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationAlerts"] count];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *notificationCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"notificationCell" forIndexPath:indexPath];
    NSDictionary *cellDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationAlerts"][indexPath.row];
    NSString *statusString = cellDictionary[@"Status"];
    notificationCell.statusColorView.fillColor = ([cellDictionary[@"Type"] isEqualToString:@"Error"]) ? [UIColor errorColor].CGColor : [UIColor warningColor].CGColor;
    notificationCell.alertContentLabel.text = cellDictionary[@"Content"];
    notificationCell.statusLabel.text =  statusString;
    notificationCell.statusLabel.textColor = ([statusString isEqualToString:@"Pending"]) ? [UIColor errorColor] : [UIColor normalBlueColor];
    notificationCell.statusImageView.image = ([statusString isEqualToString:@"Pending"]) ? [UIImage imageNamed:@"NotificationPendingImage"] : [UIImage imageNamed:@"NotificationResolvedImage"];
    
    notificationCell.statusTimeLabel.text = ([statusString isEqualToString:@"Pending"]) ? [NSString stringWithFormat:@" - %@", [[DateMaker shareDateMaker] getTodayWithNotificationFormatWithTimeStamp:[cellDictionary[@"Time"] doubleValue]]] : [NSString stringWithFormat:@" - %@", [[DateMaker shareDateMaker] getTodayWithNotificationFormatWithTimeStamp:[cellDictionary[@"ResolveTime"] doubleValue]]] ;
    notificationCell.archiveButton.hidden = ([statusString isEqualToString:@"Pending"]);
    return notificationCell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.notificationDetailController = [[NotificationDetailController alloc] init];
    self.notificationDetailController.dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationAlerts"][indexPath.row];
    [self.navigationController pushViewController:self.notificationDetailController animated:YES];
}

- (void) noNotficationAction {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"NotificationAlerts"] count] == 0) {
        self.notificationView.okLabel.alpha = 1;
        self.notificationView.okView.alpha = 1;
    } else {
        self.notificationView.okLabel.alpha = 0;
        self.notificationView.okView.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
