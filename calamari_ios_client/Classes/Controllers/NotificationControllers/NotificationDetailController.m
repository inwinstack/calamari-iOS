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
#import "DateMaker.h"

@interface NotificationDetailController ()

@end

@implementation NotificationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_notification_detail"];
    [self setBackButtonDisplay:YES];
    NSString *timeDataString = [[DateMaker shareDateMaker] getTodayWithNotificationFormatWithTimeStamp:[self.dataDic[@"Time"] doubleValue]];
    NSString *errorType = [NSString stringWithFormat:@"%@", self.dataDic[@"Type"]];
    NSString *errorCondtionType = [NSString stringWithFormat:@"%@", self.dataDic[@"Status"]];
    NSString *contentString = [NSString stringWithFormat:@"%@", [[LocalizationManager sharedLocalizationManager] getTextByKey:self.dataDic[@"Content"]]];
    NSString *errorTitleString = [NSString stringWithFormat:@"%@", [[LocalizationManager sharedLocalizationManager] getTextByKey:self.dataDic[@"ErrorTitle"]]];
    NSString *errorCountString = [NSString stringWithFormat:@"%@", self.dataDic[@"ErrorCount"]];
    NSString *errorTimeString = [NSString stringWithFormat:@"%@\n%@", [[LocalizationManager sharedLocalizationManager] getTextByKey:@"notification_detail_triggered_title"], timeDataString];
    
    
    ([errorType isEqualToString:@"Error"]) ? [self.navigationController.navigationBar setBarTintColor:[UIColor errorColor]] : [self.navigationController.navigationBar setBarTintColor:[UIColor warningColor]] ;
    self.notificationDetailView = [[NotificationDetailView alloc] initWithFrame:self.view.frame];
    self.view = self.notificationDetailView;
    
    if (self.dataDic[@"ResolveTime"]) {
        NSString *resolvedtimeDataString = [[DateMaker shareDateMaker] getTodayWithNotificationFormatWithTimeStamp:[self.dataDic[@"ResolveTime"] doubleValue]];
        NSString *resolvedTimeString = [NSString stringWithFormat:@"%@\n%@", [[LocalizationManager sharedLocalizationManager] getTextByKey:@"notification_detail_resolved_title"], resolvedtimeDataString];
        contentString = [NSString stringWithFormat:@"%@", [[LocalizationManager sharedLocalizationManager] getTextByKey:self.dataDic[@"ResolveContent"]]];
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
