//
//  PoolListViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/2.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolListViewCell.h"
#import "UIColor+Reader.h"
#import "LocalizationManager.h"

@interface  PoolListViewCell()

@property (nonatomic, strong) UIView *districtView;

@end

@implementation PoolListViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, CGRectGetWidth([UIScreen mainScreen].bounds) - 15, 30)];
        self.nameLabel.textColor = [UIColor normalBlackColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:self.nameLabel];
        
        self.idLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) , CGRectGetWidth([UIScreen mainScreen].bounds) * 0.95, 20)];
        self.idLabel.textColor = [UIColor unitTextDefalutGrayColor];
        self.idLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.idLabel];
        
        self.replicasImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.idLabel.frame) + 10, 12, 12)];
        self.replicasImage.image = [UIImage imageNamed:@"replicasImage"];
        [self addSubview:self.replicasImage];
        
        self.replicasNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.replicasImage.frame) + 12, CGRectGetMidY(self.replicasImage.frame) - 10, 0, 30)];
        self.replicasNumberLabel.font = [UIFont boldSystemFontOfSize:16];
        self.replicasNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.replicasNumberLabel];
        
        self.pgImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.replicasImage.frame) + 10, 12, 12)];
        self.pgImage.image = [UIImage imageNamed:@"PGImage"];
        [self addSubview:self.pgImage];
        
        self.pgNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pgImage.frame) + 12, CGRectGetMidY(self.pgImage.frame) - 10, 0, 30)];
        self.pgNumberLabel.font = [UIFont boldSystemFontOfSize:16];
        self.pgNumberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.pgNumberLabel];
        
        self.replicasLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.replicasNumberLabel.frame) + 6, CGRectGetMidY(self.replicasImage.frame) - 15, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.replicasNumberLabel.frame), 30)];
        self.replicasLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"pool_list_id_replicas"];
        self.replicasLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.replicasLabel];
        
        self.pgLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pgNumberLabel.frame) + 6, CGRectGetMidY(self.pgImage.frame) - 15, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.pgNumberLabel.frame), 30)];
        self.pgLabel.text = @"PGs";
        self.pgLabel.font = [UIFont systemFontOfSize:16];

        [self addSubview:self.pgLabel];
    
        self.districtView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.pgImage.frame), CGRectGetMaxY(self.pgLabel.frame) + 15, CGRectGetWidth([UIScreen mainScreen].bounds) - (CGRectGetMinX(self.pgImage.frame) * 2), 1)];
        self.districtView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self addSubview:self.districtView];
    }
    return self;
}

- (void) reloadLayout {
    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;

    [self.pgNumberLabel sizeToFit];
    [self.replicasNumberLabel sizeToFit];
    self.replicasLabel.frame = CGRectMake(CGRectGetMaxX(self.replicasNumberLabel.frame) + CGRectGetWidth([UIScreen mainScreen].bounds) * 0.02, CGRectGetMidY(self.replicasImage.frame) - height * 15 / 255, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.replicasNumberLabel.frame), height * 30 / 255);
    self.pgLabel.frame = CGRectMake(CGRectGetMaxX(self.pgNumberLabel.frame) + CGRectGetWidth([UIScreen mainScreen].bounds) * 0.02, CGRectGetMidY(self.pgImage.frame) - height * 15 / 255, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.pgNumberLabel.frame), height * 30 / 255);
}

@end
