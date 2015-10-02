//
//  AlertSelectionViewCell.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/23.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "AlertSelectionViewCell.h"
#import "UIView+SizeMaker.h"
#import "UIColor+Reader.h"

@implementation AlertSelectionViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString*)imageName {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (imageName.length > 0) {
            self.countryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18.5 - ([UIView bodySize] / 2.0), [UIView bodySize], [UIView bodySize])];
            self.countryImageView.image = [UIImage imageNamed:imageName];
            [self addSubview:self.countryImageView];
        }
        
        self.mainNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryImageView.frame) + 10, 0, 290 - (CGRectGetMaxX(self.countryImageView.frame) + 50), 37)];
        self.mainNameLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.mainNameLabel];
        
        self.selectedBackgroundCircleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.mainNameLabel.frame), 8.5, 20, 20)];
        self.selectedBackgroundCircleView.layer.borderWidth = 2.0;
        self.selectedBackgroundCircleView.layer.cornerRadius = 10.0;
        self.selectedBackgroundCircleView.layer.borderColor = [UIColor osdButtonHighlightColor].CGColor;
        [self addSubview:self.selectedBackgroundCircleView];
        
        self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 10, 10)];
        self.selectedView.layer.cornerRadius = 5.0;
        self.selectedView.backgroundColor = [UIColor osdButtonHighlightColor];
        [self.selectedBackgroundCircleView addSubview:self.selectedView];
        
        self.districtLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 2)];
        self.districtLineView.backgroundColor = [UIColor osdButtonHighlightColor];
        [self addSubview:self.districtLineView];
    }
    return self;
}

@end
