//
//  HostDetailHeaderView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostDetailHeaderView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@implementation HostDetailHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.backgroundColor = [UIColor oceanHealthBarColor];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setScrollsToTop:NO];
        [self setScrollEnabled:NO];
        self.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 2, CGRectGetHeight(self.frame));
        self.summaryButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - height * 50 / 255, 0, height * 100 / 255, CGRectGetHeight(self.frame))];
        self.summaryButton.tag = 0;
        [self.summaryButton setTitleColor:[UIColor osdButtonHighlightColor] forState:UIControlStateNormal];
        [self.summaryButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_tab_summary"] forState:UIControlStateNormal];
        [self.summaryButton.titleLabel setFont:[UIFont systemFontOfSize:[UIView bodySize]]];
        [self addSubview:self.summaryButton];
        
        self.allCPUButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - height * 50 / 255, 0, height * 100 / 255, CGRectGetHeight(self.frame))];
        self.allCPUButton.tag = 1;
        [self.allCPUButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_tab_all_cpus"] forState:UIControlStateNormal];
        [self.allCPUButton.titleLabel setFont:[UIFont systemFontOfSize:[UIView bodySize]]];
        [self.allCPUButton setTitleColor:[UIColor osdButtonHighlightColor] forState:UIControlStateNormal];
        [self addSubview:self.allCPUButton];
        
        self.iopsButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) + CGRectGetMidX(self.frame) - height * 50 / 255, 0, height * 100 / 255, CGRectGetHeight(self.frame))];
        self.iopsButton.tag = 2;
        [self.iopsButton setTitleColor:[UIColor osdButtonHighlightColor] forState:UIControlStateNormal];
        [self.iopsButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_tab_iops"] forState:UIControlStateNormal];
        [self.iopsButton.titleLabel setFont:[UIFont systemFontOfSize:[UIView bodySize]]];
        [self addSubview:self.iopsButton];
    }
    return self;
}

- (void) setHeaderType:(HostDetailType)type {
    [self.allCPUButton setTitleColor:[UIColor osdButtonHighlightColor] forState:UIControlStateNormal];
    [self.summaryButton setTitleColor:[UIColor osdButtonHighlightColor] forState:UIControlStateNormal];
    [self.iopsButton setTitleColor:[UIColor osdButtonHighlightColor] forState:UIControlStateNormal];
    switch (type) {
        case HostDetailAllCpuType: {
            [self.allCPUButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        } case HostDetailSummaryType: {
            [self.summaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        } case HostDetailIOPSType: {
            [self.iopsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        }
    }
}

@end
