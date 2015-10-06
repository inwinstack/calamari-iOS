//
//  AlertSelectionView.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "AlertSelectionView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface AlertSelectionView ()

@property (nonatomic, strong) UIView *selectionBackgroundView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *districtTopView;
@property (nonatomic, strong) UIView *districtMidView;
@property (nonatomic, strong) UIView *districtBottomView;
@property (nonatomic, strong) UILabel *alertContentLabel;

@end

@implementation AlertSelectionView

- (instancetype) initWithTitle:(NSString*)title content:(NSString*)content {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.7;
        [self addSubview:self.backgroundView];
        
        self.selectionBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 145, CGRectGetMidY(self.frame) - 100, 290, 207)];
        self.selectionBackgroundView.layer.cornerRadius = 5.0;
        self.selectionBackgroundView.backgroundColor = [UIColor oceanBackgroundThreeColor];
        [self addSubview:self.selectionBackgroundView];
        
        self.selectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.selectionBackgroundView.frame), 35)];
        self.selectionTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.selectionTitleLabel.text = title;
        self.selectionTitleLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self.selectionBackgroundView addSubview:self.selectionTitleLabel];
        
        self.districtTopView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectionTitleLabel.frame), CGRectGetWidth(self.selectionBackgroundView.frame), 2)];
        self.districtTopView.backgroundColor = [UIColor customAlertContentDistrictColor];
        [self.selectionBackgroundView addSubview:self.districtTopView];
        
        self.selectionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, CGRectGetWidth(self.selectionBackgroundView.frame), 111)];
        self.selectionTableView.tag = 3;
        self.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 56, CGRectGetWidth(self.selectionBackgroundView.frame) - 20, 91)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentLeft;
        
        
        self.districtBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectionTableView.frame), CGRectGetWidth(self.selectionBackgroundView.frame), 2)];
        self.districtBottomView.backgroundColor = [UIColor customAlertContentDistrictColor];
        [self.selectionBackgroundView addSubview:self.districtBottomView];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.districtBottomView.frame), CGRectGetWidth(self.selectionBackgroundView.frame) / 2 - 1, 48)];
        [self.cancelButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_dialog_cancel"] forState:UIControlStateNormal];
        [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        self.cancelButton.backgroundColor = [UIColor whiteColor];
        [self.selectionBackgroundView addSubview:self.cancelButton];
        
        self.districtMidView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.districtBottomView.frame), 2, 48)];
        self.districtMidView.backgroundColor = [UIColor customAlertContentDistrictColor];
        [self.selectionBackgroundView addSubview:self.districtMidView];
        
        self.enterButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.districtMidView.frame), CGRectGetMaxY(self.districtBottomView.frame), CGRectGetWidth(self.selectionBackgroundView.frame) / 2 - 1, 48)];
        self.enterButton.backgroundColor = [UIColor whiteColor];
        [self.enterButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.enterButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
        [self.enterButton addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectionBackgroundView addSubview:self.enterButton];
        
        if (content.length > 0) {
            self.alertContentLabel.text = content;
            [self.selectionBackgroundView addSubview:self.alertContentLabel];
            [self.enterButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_dialog_ok"] forState:UIControlStateNormal];
        } else {
            [self.selectionBackgroundView addSubview:self.selectionTableView];
            [self.enterButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_dialog_save"] forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void) enterAction:(UIButton*)enterButton {
    if (self.alertSectionDelegate) {
        [self.alertSectionDelegate alertButtonDidSelect:enterButton];
    }
    [self removeFromSuperview];
}

- (void) cancelAction {
    [self removeFromSuperview];
}

@end
