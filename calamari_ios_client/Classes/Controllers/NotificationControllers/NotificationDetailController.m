//
//  NotificationDetailController.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationDetailController.h"
#import "UIColor+Reader.h"
#import "NotificationDetailView.h"

@interface NotificationDetailController ()

@end

@implementation NotificationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notification Detail";
    [self setBackButtonDisplay:YES];
    NSString *timeDataString = [self.dataDic[@"Time"] stringByReplacingOccurrencesOfString:@" - " withString:@""];
    NSString *errorType = [NSString stringWithFormat:@"%@", self.dataDic[@"Type"]];
    NSString *errorCondtionType = [NSString stringWithFormat:@"%@", self.dataDic[@"Status"]];
    NSString *contentString = [NSString stringWithFormat:@"%@", self.dataDic[@"Content"]];
    NSString *errorTitleString = [NSString stringWithFormat:@"%@", self.dataDic[@"ErrorTitle"]];
    NSString *errorCountString = [NSString stringWithFormat:@"%@", self.dataDic[@"ErrorCount"]];
    NSString *errorTimeString = [NSString stringWithFormat:@"Triggered at\n%@", timeDataString];
    
    
    ([errorType isEqualToString:@"Error"]) ? [self.navigationController.navigationBar setBarTintColor:[UIColor errorColor]] : [self.navigationController.navigationBar setBarTintColor:[UIColor warningColor]] ;
    self.notificationDetailView = [[NotificationDetailView alloc] initWithFrame:self.view.frame];
    self.view = self.notificationDetailView;
    
    if (self.dataDic[@"ResolveTime"]) {
        NSString *resolvedtimeDataString = [self.dataDic[@"ResolveTime"] stringByReplacingOccurrencesOfString:@" - " withString:@""];
        NSString *resolvedTimeString = [NSString stringWithFormat:@"Resolved at\n%@", resolvedtimeDataString];
        contentString = [NSString stringWithFormat:@"%@", self.dataDic[@"ResolveContent"]];
        [self.notificationDetailView setContentWithContent:contentString status:errorCondtionType errorTitle:errorTitleString errorCount:errorCountString errorTimeString:errorTimeString resolveTimeString:resolvedTimeString];
    } else {
        [self.notificationDetailView setContentWithContent:contentString status:errorCondtionType errorTitle:errorTitleString errorCount:errorCountString errorTimeString:errorTimeString resolveTimeString:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
