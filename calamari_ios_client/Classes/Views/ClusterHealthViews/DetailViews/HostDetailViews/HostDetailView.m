//
//  HostDetailView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostDetailView.h"
#import "HostDetailHeaderView.h"
#import "HostDetailViewFlowLayout.h"
#import "UIColor+Reader.h"

@interface HostDetailView ()

@property (nonatomic, strong) HostDetailViewFlowLayout *hostDetailFlowLayout;

@end

@implementation HostDetailView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        
        self.headerView = [[HostDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 45)];
        [self addSubview:self.headerView];
        
        self.hostDetailFlowLayout = [[HostDetailViewFlowLayout alloc] init];
        self.hostDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.headerView.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.headerView.frame)) collectionViewLayout:self.hostDetailFlowLayout];
        self.hostDetailCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.hostDetailCollectionView];
    }
    return self;
}

@end
