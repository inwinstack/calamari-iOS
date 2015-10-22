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
#import "LocalizationManager.h"

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
@property (nonatomic, strong) UIView *fifthLine;
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
        
        self.calculatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 145, CGRectGetMidY(self.frame) - 209, 290, 438)];
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
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLineView.frame) + 10, CGRectGetWidth(self.calculatorView.frame) - 40, 20)];
        self.numberLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        self.numberLabel.textColor = [UIColor titleGrayColor];
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
            UIButton *numberButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.calculatorView.frame) / 3 * (i % 3), CGRectGetMaxY(self.infoLabel.frame) + 150 - 70 * (i / 3), CGRectGetWidth(self.calculatorView.frame) / 3, 70)];
            numberButton.tag = i + 1;
        
            numberButton.titleLabel.font = [UIFont systemFontOfSize:[UIView largeButtonSize]];
            [numberButton setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            [numberButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
            numberButton.backgroundColor = [UIColor oceanBackgroundOneColor];
            [numberButton addTarget:self action:@selector(numberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.calculatorView addSubview:numberButton];
            numberButton.exclusiveTouch = YES;

        }
        self.zeroButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 220, CGRectGetWidth(self.calculatorView.frame) * 2 / 3, 70)];
        self.zeroButton.tag = 0;
        self.zeroButton.titleLabel.font = [UIFont systemFontOfSize:[UIView largeButtonSize]];
        [self.zeroButton setTitle:@"0" forState:UIControlStateNormal];
        [self.zeroButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
        self.zeroButton.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self.zeroButton addTarget:self action:@selector(numberButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.calculatorView addSubview:self.zeroButton];
        self.zeroButton.exclusiveTouch = YES;

        
        self.clearButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.zeroButton.frame), CGRectGetMinY(self.zeroButton.frame), CGRectGetWidth(self.calculatorView.frame) / 3, 70)];
        [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [self.clearButton setTitleColor:[UIColor titleGrayColor] forState:UIControlStateNormal];
        self.clearButton.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        [self.calculatorView addSubview:self.clearButton];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.clearButton.frame), CGRectGetWidth(self.calculatorView.frame) / 2, 50)];
        [self.cancelButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_dialog_cancel"] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.cancelButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        [self.calculatorView addSubview:self.cancelButton];
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.clearButton.frame), CGRectGetWidth(self.calculatorView.frame) / 2, 50)];
        [self.saveButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"settings_dialog_save"] forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
        self.saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.saveButton.exclusiveTouch = YES;
        [self.calculatorView addSubview:self.saveButton];

        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.saveButton.frame) - 1, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.bottomView.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.bottomView];
        
        self.middleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame) - 1, CGRectGetMaxY(self.bottomView.frame), 2, CGRectGetHeight(self.saveButton.frame) - 1)];
        self.middleView.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.middleView];
        
        self.firstLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.calculatorView.frame) / 3 - 1, CGRectGetMaxY(self.infoLabel.frame) + 10, 2, 210)];
        self.firstLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.firstLine];
        
        self.secondLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.calculatorView.frame) * 2 / 3 - 1, CGRectGetMaxY(self.infoLabel.frame) + 10, 2, 280)];
        self.secondLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.secondLine];
        
        self.fifthLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 79, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.fifthLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.fifthLine];
        
        self.thirdLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 149, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.thirdLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.thirdLine];
        
        self.forthLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 219, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.forthLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.forthLine];
        
        self.topNumberLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoLabel.frame) + 9, CGRectGetWidth(self.calculatorView.frame), 2)];
        self.topNumberLine.backgroundColor = [UIColor oceanHorizonRuleOneColor];
        [self.calculatorView addSubview:self.topNumberLine];
    }
    return self;
}

- (void) numberButtonClicked:(UIButton*)numberButton {
    if (self.numberLabel.text.length < 6) {
        
        NSString *tempString = ([self.numberLabel.text integerValue] > 0) ? [NSString stringWithFormat:@"%@%ld", self.numberLabel.text, numberButton.tag] : [NSString stringWithFormat:@"%ld", numberButton.tag];
        
        NSRange tempRange = [self.titleLabel.text rangeOfString:@" "];
        NSString *tempTitle = [self.titleLabel.text substringToIndex:tempRange.location];
        
        if ([tempTitle isEqualToString:@"PG"]) {
            if ([tempString intValue] > 100) {
                return;
            }
            NSRange tempSpaceRange = [self.infoLabel.text rangeOfString:@" "];
            NSString *tempLastString = [self.infoLabel.text substringFromIndex:tempSpaceRange.location + tempSpaceRange.length];
            long int newValue = self.currentCount * [tempString intValue] / 100;
            self.infoLabel.text = [NSString stringWithFormat:@"%ld %@", newValue, tempLastString];
        } else if ([tempTitle isEqualToString:@"Usage"]) {
            if ([tempString intValue] > 100) {
                return;
            }
            NSRange tempSpaceRange = [self.infoLabel.text rangeOfString:@" "];
            NSString *tempLastString = [self.infoLabel.text substringFromIndex:tempSpaceRange.location + tempSpaceRange.length + 2];
            double newValue = self.currentCount * [tempString doubleValue] / 100.0;
            self.infoLabel.text = [NSString stringWithFormat:@"%@%@", [self caculateByte:newValue], tempLastString];
        }
        
        if ([tempString intValue] > self.maxValue || [tempString intValue] < self.minValue) {
            self.numberLabel.textColor = [UIColor errorColor];
            [self.saveButton setTitleColor:[UIColor navigationSelectedColor] forState:UIControlStateNormal];
            self.saveButton.enabled = NO;
        } else {
            [self.saveButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
            self.numberLabel.textColor = [UIColor titleGrayColor];
            self.saveButton.enabled = YES;
        }
        
        self.numberLabel.text = tempString;
    }
}

- (NSString*) caculateByte:(double)value {
    int count = 0;
    while (value > 1024.0) {
        value = value / 1024.0;
        count++;
        if (count == 4) {
            break;
        }
    }
    NSString *unit;
    switch (count) {
        case 0: {
            return @"1 KB";
            break;
        } case 1: {
            unit = @"KB";
            break;
        } case 2: {
            unit = @"MB";
            break;
        } case 3: {
            unit = @"GB";
            break;
        } case 4: {
            unit = @"TB";
            break;
        }
            
    }
    if (value >= 100) {
        return [NSString stringWithFormat:@"%d %@", (int)value, unit];
    } else if (value >= 10) {
        return [NSString stringWithFormat:@"%.1f %@", value, unit];
    } else {
        return [NSString stringWithFormat:@"%.2f %@", value, unit];
    }
}

- (void) clearAction {
    [self.saveButton setTitleColor:[UIColor navigationSelectedColor] forState:UIControlStateNormal];
    self.saveButton.enabled = NO;
    self.numberLabel.text = @"";
    NSRange tempRange = [self.titleLabel.text rangeOfString:@" "];
    NSString *tempTitle = [self.titleLabel.text substringToIndex:tempRange.location];
    if ([tempTitle isEqualToString:@"PG"] || [tempTitle isEqualToString:@"Usage"]) {
        self.infoLabel.text = self.originalValue;
    }
}

@end
