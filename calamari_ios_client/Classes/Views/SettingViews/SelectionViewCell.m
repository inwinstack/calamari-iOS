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

@interface SelectionViewCell ()

@property (nonatomic, strong) CAShapeLayer *checkBoxLayer;

@end

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
        self.rightDetailLabel.numberOfLines = 0;
        [self addSubview:self.rightDetailLabel];
        
        self.districtLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 2)];
        self.districtLineView.backgroundColor = [UIColor osdButtonHighlightColor];
        [self addSubview:self.districtLineView];
        
        self.checkBoxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.checkBoxButton.layer.borderWidth = 2.0;
        self.checkBoxButton.layer.borderColor = [UIColor osdButtonHighlightColor].CGColor;
        [self addSubview:self.checkBoxButton];
        
        CGMutablePathRef tempPath = CGPathCreateMutable();
        CGPathMoveToPoint(tempPath, nil, 1.5, 11);
        CGPathAddLineToPoint(tempPath, nil, 7, 17);
        CGPathAddLineToPoint(tempPath, nil, 18.5, 1.5);
        
        self.checkBoxLayer = [CAShapeLayer layer];
        self.checkBoxLayer.lineWidth = 2.0;
        self.checkBoxLayer.path = tempPath;
        self.checkBoxLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.checkBoxLayer.fillColor = [UIColor clearColor].CGColor;
        [self.checkBoxButton.layer addSublayer:self.checkBoxLayer];
        
        CGPathRelease(tempPath);
        
    }
    return self;
}

@end
