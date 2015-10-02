//
//  SelectionViewCell.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "SelectionViewCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@implementation SelectionViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 40, 17)];
        self.mainLabel.textAlignment = NSTextAlignmentLeft;
        self.mainLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        self.mainLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.mainLabel];
        
        self.rightDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 40, 17)];
        self.rightDetailLabel.textAlignment = NSTextAlignmentRight;
        self.rightDetailLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.rightDetailLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.rightDetailLabel];
        
        self.districtLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 2)];
        self.districtLineView.backgroundColor = [UIColor osdButtonHighlightColor];
        [self addSubview:self.districtLineView];
    }
    return self;
}

@end
