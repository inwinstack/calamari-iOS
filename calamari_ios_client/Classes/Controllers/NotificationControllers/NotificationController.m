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
#import "NotificationData.h"

@interface NotificationController ()

@end

@implementation NotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notifications";
    [self setBackButtonDisplay:YES];
    
    self.notificationView = [[NotificationView alloc] initWithFrame:self.view.frame];
    self.notificationView.delegate = self;
    self.notificationView.dataSource = self;
    [self noNotficationAction];
    self.view = self.notificationView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@",[NotificationData shareInstance].notificationArray);
    [self noNotficationAction];
    return [NotificationData shareInstance].notificationArray.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCellIdentifier"];
    if (!cell) {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationCellIdentifier"];
    }
    cell.cancelButton.tag = indexPath.row;
    cell.statusImage.image = ([[NotificationData shareInstance].notificationArray[indexPath.row][0] isEqualToString:@"Warn"]) ? [UIImage imageNamed:@"HealthWarnImage"] : [UIImage imageNamed:@"HealthErrorImage"];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [NotificationData shareInstance].notificationArray[indexPath.row][1]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", [NotificationData shareInstance].notificationArray[indexPath.row][2]];
    [cell.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) noNotficationAction {
    if ([NotificationData shareInstance].notificationArray.count == 0) {
        self.notificationView.okLabel.alpha = 1;
        self.notificationView.okView.alpha = 1;
    } else {
        self.notificationView.okLabel.alpha = 0;
        self.notificationView.okView.alpha = 0;
    }
}

- (void) cancelAction:(UIButton*)button {
    [[NotificationData shareInstance].notificationArray removeObjectAtIndex:button.tag];
    [self.notificationView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
