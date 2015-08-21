//
//  HostDetailHeaderView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HostDetailType) {
    HostDetailSummaryType = 0,
    HostDetailAllCpuType,
    HostDetailIOPSType,
};

@interface HostDetailHeaderView : UIScrollView

@property (nonatomic, strong) UIButton *allCPUButton;
@property (nonatomic, strong) UIButton *summaryButton;
@property (nonatomic, strong) UIButton *iopsButton;

- (void) setHeaderType:(HostDetailType)type;

@end
