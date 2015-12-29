//
//  OSDDetailView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDDetailView.h"
#import "UIColor+Reader.h"
#import "LocalizationManager.h"

@interface OSDDetailView ()

@property (nonatomic, strong) UILabel *hostNameTitleLabel;
@property (nonatomic, strong) UILabel *publicTitleLabel;
@property (nonatomic, strong) UILabel *clusterTitleLabel;
@property (nonatomic, strong) UILabel *poolTitleLabel;
@property (nonatomic, strong) UILabel *reWeightTitleLabel;
@property (nonatomic, strong) UILabel *uuidTitleLabel;

@end

@implementation OSDDetailView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        self.hostNameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, height * 5 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25)];
        self.hostNameTitleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_host_name"];
        [self setTitleLabel:self.hostNameTitleLabel];
        
        self.hostNameValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.hostNameTitleLabel.frame), CGRectGetWidth(self.frame) - height * 10 / 255,  15)];
        [self setValueLabel:self.hostNameValueLabel];
        
        self.publicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.hostNameValueLabel.frame) + height * 10 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25)];
        self.publicTitleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_public_ip"];
        [self setTitleLabel:self.publicTitleLabel];
        
        self.publicValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.publicTitleLabel.frame), CGRectGetWidth(self.frame) - height * 10 / 255, 15)];
        [self setValueLabel:self.publicValueLabel];
        
        self.clusterTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.publicValueLabel.frame) + height * 10 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25)];
        self.clusterTitleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_cluster_ip"];
        [self setTitleLabel:self.clusterTitleLabel];
        
        self.clusterValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.clusterTitleLabel.frame), CGRectGetWidth(self.frame) - height * 10 / 255, 15)];
        [self setValueLabel:self.clusterValueLabel];
        
        self.poolTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.clusterValueLabel.frame) + height * 10 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25)];
        self.poolTitleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_pools"];
        [self setTitleLabel:self.poolTitleLabel];
        
        self.reWeightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.poolTitleLabel.frame) + height * 65 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25)];
        self.reWeightTitleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_re_weight"];
        [self setTitleLabel:self.reWeightTitleLabel];
        
        self.reWeightValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.reWeightTitleLabel.frame), CGRectGetWidth(self.frame) - height * 10 / 255, 15)];
        [self setValueLabel:self.reWeightValueLabel];
        
        self.uuidTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.reWeightValueLabel.frame) + height * 10 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25)];
        self.uuidTitleLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_detail_uuid"];
        [self setTitleLabel:self.uuidTitleLabel];
        
        self.uuidValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, CGRectGetMaxY(self.uuidTitleLabel.frame), CGRectGetWidth(self.frame) - height * 10 / 255, 15)];
        [self setValueLabel:self.uuidValueLabel];
        
        self.reweightHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.reWeightTitleLabel.frame) + 20, CGRectGetMinY(self.reWeightTitleLabel.frame), 20, 20)];
        [self.reweightHelpButton setBackgroundImage:[UIImage imageNamed:@"HelpImage"] forState:UIControlStateNormal];
        [self addSubview:self.reweightHelpButton];
    }
    return self;
}

- (void) setTitleLabel:(UILabel*)titleLabel {
//    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;

    titleLabel.textColor = [UIColor normalBlackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:titleLabel];
}

- (void) setValueLabel:(UILabel*)valueLabel {
//    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;

    valueLabel.textColor = [UIColor normalBlackColor];
    valueLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:valueLabel];
}

- (void) setPoolLabelsArray:(NSArray*)labelArray {
    BOOL firstTime = true;
    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    NSLog(@"%f", height);
    for (id object in labelArray) {

        UILabel *label;
        if (firstTime) {
            label = [[UILabel alloc] initWithFrame:CGRectMake( height * 5 / 255 + 10, CGRectGetMaxY(self.poolTitleLabel.frame) + 10, 0,  height * 15 / 255)];
        } else {
            if (!([NSString stringWithFormat:@"%@", object].length * height * 8.2 / 255 + height * 15 / 255 + CGRectGetMaxX([[self.subviews lastObject] frame]) + CGRectGetWidth(self.frame) * 0.06 < CGRectGetMaxX(self.frame))) {
                label = [[UILabel alloc] initWithFrame:CGRectMake( height * 5 / 255 + 10, CGRectGetMaxY([[self.subviews lastObject] frame]) + 25, 0, height * 15 / 255)];
            } else {
                float tempFixX = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 15.0 : 20.0;
                label = [[UILabel alloc] initWithFrame:CGRectMake( height * 5 / 255 + tempFixX + CGRectGetMaxX([[self.subviews lastObject] frame]), CGRectGetMinY([[self.subviews lastObject] frame]), 0, height * 15 / 255)];
            }
        }
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = ([object length] == 0) ? @"  " : [NSString stringWithFormat:@"%@", object];
        [label sizeToFit];
        label.textAlignment = NSTextAlignmentCenter;
        UIView *labelBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame) - 10, CGRectGetMinY(label.frame) - 5, CGRectGetWidth(label.frame) + 20, CGRectGetHeight(label.frame) + 10)];
        labelBackgroundView.layer.cornerRadius = 3;
        labelBackgroundView.layer.backgroundColor = [UIColor osdDetailButtonBackgroundColor].CGColor;
        [self addSubview:labelBackgroundView];
        [self addSubview:label];
        firstTime = false;
    }
    
    self.reWeightTitleLabel.frame = CGRectMake(height * 5 / 255, CGRectGetMaxY([[self.subviews lastObject] frame]) +  height * 10 / 255, 0,  25);
    [self.reWeightTitleLabel sizeToFit];
    self.reweightHelpButton.frame = CGRectMake(CGRectGetMaxX(self.reWeightTitleLabel.frame) + 15, CGRectGetMidY(self.reWeightTitleLabel.frame) - 7.5, 15, 15);
    
    self.reWeightValueLabel.frame = CGRectMake(height * 5 / 255, CGRectGetMaxY(self.reWeightTitleLabel.frame), CGRectGetWidth(self.frame) -  height * 10 / 255,  15);
    self.uuidTitleLabel.frame = CGRectMake(height * 5 / 255, CGRectGetMaxY(self.reWeightValueLabel.frame) + height * 10 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, 25);
    self.uuidValueLabel.frame = CGRectMake(height * 5 / 255, CGRectGetMaxY(self.uuidTitleLabel.frame), CGRectGetWidth(self.frame) - height * 10 / 255, 15);
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.uuidValueLabel.frame) + 64 + height * 5 / 255);
}

@end
