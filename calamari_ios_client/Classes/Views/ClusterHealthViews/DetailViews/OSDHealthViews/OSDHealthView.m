//
//  OSDHealthView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDHealthView.h"
#import "UIColor+Reader.h"
#import "LocalizationManager.h"
#import "OSDViewFLowLayout.h"

@interface OSDHealthView ()

@property (nonatomic, strong) OSDViewFLowLayout *flowLayout;

@end

@implementation OSDHealthView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        self.okView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - ((CGRectGetWidth(self.frame) * 0.3) / 2), CGRectGetMidY(self.frame) - ((CGRectGetWidth(self.frame) * 0.3) / 2) - 60, (CGRectGetWidth(self.frame) * 0.3), (CGRectGetWidth(self.frame) * 0.3))];
        self.okView.image = [UIImage imageNamed:@"OSDHealthOKView"];
        self.okView.contentMode = UIViewContentModeScaleAspectFill;
        self.okView.alpha = 0;
        [self addSubview:self.okView];
        
        self.okLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 150, CGRectGetMaxY(self.okView.frame) + 25, 300, 50)];
        self.okLabel.alpha = 0;
        self.okLabel.numberOfLines = 0;
        self.okLabel.textColor = [UIColor unitTextDefalutGrayColor];
        self.okLabel.textAlignment = NSTextAlignmentCenter;
        self.okLabel.text = [NSString stringWithFormat:@"%@\n%@", [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_health_great"], [[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_health_work_fine"]];
        [self addSubview:self.okLabel];
        
        self.flowLayout = [[OSDViewFLowLayout alloc] init];
        self.contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)  - 64 - CGRectGetWidth(self.frame) * 0.1) collectionViewLayout:self.flowLayout];
        self.contentCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentCollectionView];
        
        self.osdHealthToolBar = [[OSDHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - CGRectGetWidth(self.frame) * 0.1 - 64, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame) * 0.1)];
        
        [self addSubview:self.osdHealthToolBar];
    }
    return self;
}

@end
