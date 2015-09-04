//
//  NotificationDetailView.h
//  calamari_ios_client
//
//  Created by Francis on 2015/9/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationDetailView : UIView

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *errorTitleLabel;
@property (nonatomic, strong) UILabel *errorCountLabel;
@property (nonatomic, strong) UILabel *errorTimeLabel;
@property (nonatomic, strong) UILabel *resolveTimeLabel;

- (void) setContentWithContent:(NSString*)content status:(NSString*)status errorTitle:(NSString*)errorTitle errorCount:(NSString*)errorCount errorTimeString:(NSString*)errorTimeString resolveTimeString:(NSString*)resolveTimeString;

@end
