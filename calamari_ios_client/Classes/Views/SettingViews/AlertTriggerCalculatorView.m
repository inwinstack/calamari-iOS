//
//  AlertTriggerCalculatorView.m
//  calamari_ios_client
//
//  Created by Francis on 2015/10/8.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "AlertTriggerCalculatorView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface AlertTriggerCalculatorView ()

@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *calculatorView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic, strong) UIButton *zeroButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIView *firstLine;
@property (nonatomic, strong) UIView *secondLine;
@property (nonatomic, strong) UIView *thirdLine;
@property (nonatomic, strong) UIView *forthLine;
@property (nonatomic, strong) UIView *topNumberLine;

@end

@implementation AlertTriggerCalculatorView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.blackBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.blackBackgroundView.backgroundColor = [UIColor blackColor];
        self.blackBackgroundView.alpha = 0.5;
        [self addSubview:self.blackBackgroundView];
        
        self.calculatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 145, CGRectGetMidY(self.frame) - 174, 290, 348)];
        self.calculatorView.layer.borderWidth = 2.0;
        self.calculatorView.layer.borderColor = [UIColor osdButtonHighlightColor].CGColor;
        self.calculatorView.backgroundColor = [UIColor oceanBackgroundThreeColor];
        [self addSubview:self.calculatorView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.calculatorView.frame), 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:[UIView subHeadSize]];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor titleGrayColor];
        [self.calculatorView addSubview:self.titleLabel];
        
        self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.topLineView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self.calculatorView addSubview:self.topLineView];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLineView.frame) + 10, CGRectGetWidth(self.calculatorView.frame) - 30, 20)];
        self.numberLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        self.numberLabel.textColor = [UIColor titleGrayColor];
        self.numberLabel.text = @"1";
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        [self.calculatorView addSubview:self.numberLabel];
        
        self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLabel.frame) + 5, CGRectGetMidY(self.numberLabel.frame) - 6, CGRectGetWidth(self.calculatorView.frame) - CGRectGetWidth(self.numberLabel.frame) - 5, 16)];
        self.unitLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        self.unitLabel.textColor = [UIColor titleGrayColor];
        [self.calculatorView addSubview:self.unitLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame) + 10, CGRectGetWidth(self.calculatorView.frame) - 5, 16)];
        self.infoLabel.text = @"Information";
        self.infoLabel.textAlignment = NSTextAlignmentRight;
        self.infoLabel.textColor = [UIColor customAlertContentDistrictColor];
        self.infoLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        [self.calculatorView addSubview:self.infoLabel];
        
        for (int i = 0; i < 9; i++) {
            UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.calculatorView.frame) / 3 * (i % 3), CGRectGetMaxY(self.infoLabel.frame) + 10 + 70 * (i / 3), CGRectGetWidth(self.calculatorView.frame) / 3, 70)];
            numberButton.tag = i + 1;
            [numberButton setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            [numberButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
            numberButton.backgroundColor = [UIColor oceanBackgroundOneColor];
            [numberButton addTarget:self action:@selector(numberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.calculatorView addSubview:numberButton];
        }
        self.zeroButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 150, CGRectGetWidth(self.calculatorView.frame) * 2 / 3, 70)];
        self.zeroButton.tag = 0;
        [self.zeroButton setTitle:@"0" forState:UIControlStateNormal];
        [self.zeroButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
        self.zeroButton.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self.zeroButton addTarget:self action:@selector(numberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.calculatorView addSubview:self.zeroButton];
        
        self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.zeroButton.frame), CGRectGetMinY(self.zeroButton.frame), CGRectGetWidth(self.calculatorView.frame) / 3, 70)];
        [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [self.clearButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
        self.clearButton.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        [self.calculatorView addSubview:self.clearButton];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.clearButton.frame), CGRectGetWidth(self.calculatorView.frame) / 2, 30)];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.cancelButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        [self.calculatorView addSubview:self.cancelButton];
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.clearButton.frame), CGRectGetWidth(self.calculatorView.frame) / 2, 30)];
        [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
        [self.calculatorView addSubview:self.saveButton];

        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.saveButton.frame) - 1, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.bottomView.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.bottomView];
        
        self.middleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame) - 1, CGRectGetMaxY(self.bottomView.frame), 2, CGRectGetHeight(self.saveButton.frame) - 1)];
        self.middleView.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.middleView];
        
        self.firstLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.calculatorView.frame) / 3 - 1, CGRectGetMaxY(self.infoLabel.frame) + 10, 2, 140)];
        self.firstLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.firstLine];
        
        self.secondLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.calculatorView.frame) * 2 / 3 - 1, CGRectGetMaxY(self.infoLabel.frame) + 10, 2, 210)];
        self.secondLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.secondLine];
        
        self.thirdLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 79, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.thirdLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.thirdLine];
        
        self.forthLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 149, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.forthLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.forthLine];
        
        self.topNumberLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 9, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.topNumberLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.topNumberLine];
    }
    return self;
}

- (void) numberButtonClicked:(UIButton*)numberButton {
    NSLog(@"%ld", numberButton.tag);
}

- (void) clearAction {
    NSLog(@"clear");
}

@end
