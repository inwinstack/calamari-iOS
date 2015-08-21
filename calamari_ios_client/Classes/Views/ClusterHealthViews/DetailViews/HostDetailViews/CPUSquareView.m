//
//  CPUSquareView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/7.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "CPUSquareView.h"
#import "UIColor+Reader.h"
#import "DateMaker.h"
#import "UIView+SizeMaker.h"

@interface CPUSquareView ()

@property (nonatomic, strong) UILabel *systemLabel;
@property (nonatomic, strong) UILabel *niceLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *idleLabel;
@property (nonatomic, strong) UILabel *ioWaitLabel;
@property (nonatomic, strong) UILabel *irqLabel;
@property (nonatomic, strong) UILabel *softIrqLabel;
@property (nonatomic, strong) UILabel *stealLabel;
@property (nonatomic, strong) CAShapeLayer *xLayer;
@property (nonatomic, strong) CAShapeLayer *yLayer;
@property (nonatomic, strong) CAShapeLayer *xTagLayer;
@property (nonatomic, strong) CAShapeLayer *firstTag;
@property (nonatomic, strong) CAShapeLayer *secondTag;
@property (nonatomic, strong) CAShapeLayer *thirdTag;
@property (nonatomic, strong) CAShapeLayer *fourthTag;
@property (nonatomic, strong) CAShapeLayer *fifthTag;
@property (nonatomic, strong) CAShapeLayer *sixthTag;
@property (nonatomic, strong) CAShapeLayer *systemLayer;
@property (nonatomic, strong) CAShapeLayer *userLayer;
@property (nonatomic, strong) CAShapeLayer *IdleLayer;
@property (nonatomic, strong) CAShapeLayer *niceLayer;
@property (nonatomic, strong) CAShapeLayer *ioWaitLayer;
@property (nonatomic, strong) CAShapeLayer *irqLayer;
@property (nonatomic, strong) CAShapeLayer *softIrqLayer;
@property (nonatomic, strong) CAShapeLayer *stealLayer;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UILabel *fifthLabel;
@property (nonatomic, strong) UILabel *sixthLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) NSMutableArray *tagLayerArray;
@property (nonatomic, strong) NSMutableArray *tagLabelStringArray;
@property (nonatomic, strong) UIView *backgroundWhiteView;

@end

@implementation CPUSquareView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    
        self.systemLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 0, height * 25 / 255)];
        self.systemLabel.textColor = [UIColor okGreenColor];
        self.systemLabel.text = @"-System";
        [self setLabel:self.systemLabel];
        
        self.userLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.systemLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.userLabel.textColor = [UIColor UserLinePurpleColor];
        self.userLabel.text = @"-User";
        [self setLabel:self.userLabel];
        
        self.niceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.niceLabel.textColor = [UIColor warningColor];
        self.niceLabel.text = @"-Nice";
        [self setLabel:self.niceLabel];
        
        self.idleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.niceLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.idleLabel.textColor = [UIColor IdleLineBlueColor];
        self.idleLabel.text = @"-Idle";
        [self setLabel:self.idleLabel];
        
        self.ioWaitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.idleLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.ioWaitLabel.textColor = [UIColor IOWaitLinePinkColor];
        self.ioWaitLabel.text = @"-IOWait";
        [self setLabel:self.ioWaitLabel];
        
        self.irqLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ioWaitLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.irqLabel.textColor = [UIColor IRQLineBrownColor];
        self.irqLabel.text = @"-IRQ";
        [self setLabel:self.irqLabel];
        
        float tempSoftIrqY = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? CGRectGetMinY(self.systemLabel.frame) : CGRectGetMaxY(self.systemLabel.frame);
        float tempSoftIrqX = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? CGRectGetMaxX(self.irqLabel.frame) + height * 5 / 255 : CGRectGetMinX(self.systemLabel.frame);
        self.softIrqLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempSoftIrqX, tempSoftIrqY, 0, height * 25 / 255)];
        self.softIrqLabel.textColor = [UIColor SoftIRQLineGrayColor];
        self.softIrqLabel.text = @"-Soft IRQ";
        [self setLabel:self.softIrqLabel];
        
        self.stealLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.softIrqLabel.frame) + height * 5 / 255, CGRectGetMinY(self.softIrqLabel.frame), 0, height * 25 / 255)];
        self.stealLabel.textColor = [UIColor okGreenColor];
        self.stealLabel.text = @"-Steal";
        [self setLabel:self.stealLabel];
        
        self.backgroundWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.stealLabel.frame) + 10 * height / 255, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.stealLabel.frame) - height * 15 / 255)];
        self.backgroundWhiteView.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self addSubview:self.backgroundWhiteView];
        
        self.xLayer = [CAShapeLayer layer];
        self.xLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.xLayer.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetMidY(self.frame) + height * 35 / 255, CGRectGetWidth(self.frame) - CGRectGetWidth([UIScreen mainScreen].bounds) * 0.08, 1);
        [self.layer addSublayer:self.xLayer];
        
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.yLayer.frame = CGRectMake(CGRectGetMinX(self.xLayer.frame), CGRectGetMaxY(self.softIrqLabel.frame) + 10 * height / 255, 1, CGRectGetMinY(self.xLayer.frame) - CGRectGetMaxY(self.softIrqLabel.frame) - 10 * height / 255);
        [self.layer addSublayer:self.yLayer];
        
        self.xTagLayer = [CAShapeLayer layer];
        self.xTagLayer.strokeColor = [UIColor normalBlackColor].CGColor;
        self.xTagLayer.lineWidth = 0.5;
        
        float tempHeight = CGRectGetHeight(self.yLayer.frame) / 15.0;
        CGMutablePathRef tempXPath = CGPathCreateMutable();
        CGPathMoveToPoint(tempXPath, nil, CGRectGetMinX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 14);
        CGPathAddLineToPoint(tempXPath, nil, CGRectGetMaxX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 14);
        CGPathMoveToPoint(tempXPath, nil, CGRectGetMinX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 7);
        CGPathAddLineToPoint(tempXPath, nil, CGRectGetMaxX(self.xLayer.frame), CGRectGetMinY(self.xLayer.frame) - tempHeight * 7);
        CGPathCloseSubpath(tempXPath);
        self.xTagLayer.path = tempXPath;
        CGPathRelease(tempXPath);
        [self.layer addSublayer:self.xTagLayer];
        
        self.maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - tempHeight * 14 - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        [self setDefaultYLabel:self.maxLabel];
        
        self.minLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255, CGRectGetMinY(self.xLayer.frame) - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        [self setDefaultYLabel:self.minLabel];
        
        self.midYLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.yLayer.frame) - height * 30 / 255,  CGRectGetMinY(self.xLayer.frame) - tempHeight * 7 - height * 5 / 255, height * 30 / 255, height * 10 / 255)];
        [self setDefaultYLabel:self.midYLabel];
        
        self.tagLayerArray = [NSMutableArray array];
        self.firstTag = [CAShapeLayer layer];
        [self setTagLayer:self.firstTag];
        
        self.secondTag = [CAShapeLayer layer];
        [self setTagLayer:self.secondTag];
        
        self.thirdTag = [CAShapeLayer layer];
        [self setTagLayer:self.thirdTag];
        
        self.fourthTag = [CAShapeLayer layer];
        [self setTagLayer:self.fourthTag];
        
        self.fifthTag = [CAShapeLayer layer];
        [self setTagLayer:self.fifthTag];
        
        self.sixthTag = [CAShapeLayer layer];
        [self setTagLayer:self.sixthTag];
        
        self.systemLayer = [CAShapeLayer layer];
        self.systemLayer.strokeColor = [UIColor okGreenColor].CGColor;
        self.systemLayer.lineWidth = 0.5;
        self.systemLayer.zPosition = 0;
        self.systemLayer.fillColor = [UIColor okGreenShapelayerColor].CGColor;
        [self.layer addSublayer:self.systemLayer];
        
        self.userLayer = [CAShapeLayer layer];
        self.userLayer.strokeColor = [UIColor UserLinePurpleColor].CGColor;
        self.userLayer.lineWidth = 0.5;
        self.userLayer.zPosition = 1;
        self.userLayer.fillColor = [UIColor UserLinePurpleFillColor].CGColor;
        [self.layer addSublayer:self.userLayer];
        
        self.niceLayer = [CAShapeLayer layer];
        self.niceLayer.strokeColor = [UIColor warningColor].CGColor;
        self.niceLayer.lineWidth = 0.5;
        self.niceLayer.zPosition = 2;
        self.niceLayer.fillColor = [UIColor warningShapelayerColor].CGColor;
        [self.layer addSublayer:self.niceLayer];
        
        self.IdleLayer = [CAShapeLayer layer];
        self.IdleLayer.strokeColor = [UIColor IdleLineBlueColor].CGColor;
        self.IdleLayer.lineWidth = 0.5;
        self.IdleLayer.zPosition = 3;
        self.IdleLayer.fillColor = [UIColor IdleLineBlueFillColor].CGColor;
        [self.layer addSublayer:self.IdleLayer];
        
        self.ioWaitLayer = [CAShapeLayer layer];
        self.ioWaitLayer.strokeColor = [UIColor IOWaitLinePinkColor].CGColor;
        self.ioWaitLayer.lineWidth = 0.5;
        self.ioWaitLayer.zPosition = 4;
        self.ioWaitLayer.fillColor = [UIColor IOWaitLinePinkFillColor].CGColor;
        [self.layer addSublayer:self.ioWaitLayer];
        
        self.irqLayer = [CAShapeLayer layer];
        self.irqLayer.strokeColor = [UIColor IRQLineBrownColor].CGColor;
        self.irqLayer.lineWidth = 0.5;
        self.irqLayer.zPosition = 5;
        self.irqLayer.fillColor = [UIColor IRQLineBrownFillColor].CGColor;
        [self.layer addSublayer:self.irqLayer];
        
        self.softIrqLayer = [CAShapeLayer layer];
        self.softIrqLayer.strokeColor = [UIColor SoftIRQLineGrayColor].CGColor;
        self.softIrqLayer.lineWidth = 0.5;
        self.softIrqLayer.zPosition = 6;
        self.softIrqLayer.fillColor = [UIColor SoftIRQLineGrayFillColor].CGColor;
        [self.layer addSublayer:self.softIrqLayer];
        
        self.stealLayer = [CAShapeLayer layer];
        self.stealLayer.strokeColor = [UIColor okGreenColor].CGColor;
        self.stealLayer.lineWidth = 0.5;
        self.stealLayer.zPosition = 7;
        self.stealLayer.fillColor = [UIColor okGreenShapelayerColor].CGColor;
        [self.layer addSublayer:self.stealLayer];

    }
    return self;
}



- (void) setTagLayer:(CAShapeLayer*)tagLayer {
    tagLayer.backgroundColor = [UIColor TagLineColor].CGColor;
    [self.layer addSublayer:tagLayer];
    [self.tagLayerArray addObject:tagLayer];
}

- (void) setTagLabel {
    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    
    [self.firstLabel removeFromSuperview];
    [self.secondLabel removeFromSuperview];
    [self.thirdLabel removeFromSuperview];
    [self.fourthLabel removeFromSuperview];
    [self.fifthLabel removeFromSuperview];
    [self.sixthLabel removeFromSuperview];
    
    self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[0] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[0] frame]), height * 60 / 255, height * 15 / 255)];
    self.firstLabel.text = self.tagLabelStringArray[0];
    [self setTagLabel:self.firstLabel];
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[1] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[1] frame]), height * 60 / 255, height * 15 / 255)];
    self.secondLabel.text = self.tagLabelStringArray[1];
    [self setTagLabel:self.secondLabel];
    
    self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[2] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[2] frame]), height * 60 / 255, height * 15 / 255)];
    self.thirdLabel.text = self.tagLabelStringArray[2];
    [self setTagLabel:self.thirdLabel];
    
    self.fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[3] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[3] frame]), height * 60 / 255, height * 15 / 255)];
    self.fourthLabel.text = self.tagLabelStringArray[3];
    [self setTagLabel:self.fourthLabel];
    
    self.fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[4] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[4] frame]), height * 60 / 255, height * 15 / 255)];
    self.fifthLabel.text = self.tagLabelStringArray[4];
    [self setTagLabel:self.fifthLabel];
    
    self.sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX([self.tagLayerArray[5] frame]) - height * 30 / 255, CGRectGetMaxY([self.tagLayerArray[5] frame]), height * 60 / 255, height * 15 / 255)];
    self.sixthLabel.text = self.tagLabelStringArray[5];
    [self setTagLabel:self.sixthLabel];
}

- (void) setTagLabel:(UILabel*)tagLabel {
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:tagLabel];
}

- (void) setDefaultYLabel:(UILabel*)yLabel {
    yLabel.textColor = [UIColor normalBlackColor];
    yLabel.font = [UIFont systemFontOfSize:10];
    yLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:yLabel];
}

- (void) setDataWithDataArray:(NSMutableArray*)dataArray {
    if (dataArray.count > 0) {
        float tempheight = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        
        self.tagLabelStringArray = [NSMutableArray array];
        CGMutablePathRef systemPath = CGPathCreateMutable();
        CGMutablePathRef userPath = CGPathCreateMutable();
        CGMutablePathRef nicePath = CGPathCreateMutable();
        CGMutablePathRef idlePath = CGPathCreateMutable();
        CGMutablePathRef ioWaitPath = CGPathCreateMutable();
        CGMutablePathRef irqPath = CGPathCreateMutable();
        CGMutablePathRef softIRQPath = CGPathCreateMutable();
        CGMutablePathRef stealPath = CGPathCreateMutable();
        
        float startX = CGRectGetMaxX(self.yLayer.frame);
        float startY = CGRectGetMinY(self.xLayer.frame);
        float height = CGRectGetMinY(self.xLayer.frame) - CGRectGetMidY(self.maxLabel.frame);
        int tempX = 0;
        int count = 0;
        
        CGPathMoveToPoint(systemPath, nil, startX, startY);
        CGPathMoveToPoint(userPath, nil, startX, startY);
        CGPathMoveToPoint(nicePath, nil, startX, startY);
        CGPathMoveToPoint(idlePath, nil, startX, startY);
        CGPathMoveToPoint(ioWaitPath, nil, startX, startY);
        CGPathMoveToPoint(irqPath, nil, startX, startY);
        CGPathMoveToPoint(softIRQPath, nil, startX, startY);
        CGPathMoveToPoint(stealPath, nil, startX, startY);
        
        float systemY = startY;
        float userY = startY;
        float niceY = startY;
        float idleY = startY;
        float ioWaitY = startY;
        float irqY = startY;
        float softIRQY = startY;
        float stealY = startY;
        for (id object in dataArray) {
            float x = startX + (tempX * tempheight * 0.7 / 255);
            float addX = startX + ((tempX + 1) * tempheight * 0.7 / 255);
            
            if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                count++;
            }

            stealY = (([object[8] isEqualToString:@"<null>"])) ? stealY : [self calculateValue:object[8] startY:startY addValue:height * (1 -  [object[8] floatValue] / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(stealPath, nil, x, stealY);
            CGPathAddLineToPoint(stealPath, nil, addX, stealY);
            
            softIRQY = (([object[7] isEqualToString:@"<null>"])) ? softIRQY : [self calculateValue:object[7] startY:stealY addValue:height * (1 - ([object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(softIRQPath, nil, x, softIRQY);
            CGPathAddLineToPoint(softIRQPath, nil, addX, softIRQY);
            
            irqY = (([object[6] isEqualToString:@"<null>"])) ? irqY : [self calculateValue:object[6] startY:softIRQY addValue:height * (1 - ([object[6] floatValue] + [object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(irqPath, nil, x, irqY);
            CGPathAddLineToPoint(irqPath, nil, addX, irqY);
            
            ioWaitY = (([object[5] isEqualToString:@"<null>"])) ? ioWaitY : [self calculateValue:object[5] startY:irqY addValue:height * (1 - ([object[5] floatValue] + [object[6] floatValue] + [object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(ioWaitPath, nil, x, ioWaitY);
            CGPathAddLineToPoint(ioWaitPath, nil, addX, ioWaitY);
            
            idleY = (([object[4] isEqualToString:@"<null>"])) ? idleY : [self calculateValue:object[4] startY:ioWaitY addValue:height * (1 - ([object[4] floatValue] + [object[5] floatValue] + [object[6] floatValue] + [object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(idlePath, nil, x, idleY);
            CGPathAddLineToPoint(idlePath, nil, addX, idleY);
            
            niceY = (([object[3] isEqualToString:@"<null>"])) ? niceY : [self calculateValue:object[3] startY:idleY addValue:height * (1 - ([object[3] floatValue] + [object[4] floatValue] + [object[5] floatValue] + [object[6] floatValue] + [object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(nicePath, nil, x, niceY);
            CGPathAddLineToPoint(nicePath, nil, addX, niceY);
            
            userY = (([object[2] isEqualToString:@"<null>"])) ? userY : [self calculateValue:object[2] startY:niceY addValue:height * (1 - ([object[2] floatValue] + [object[3] floatValue] + [object[4] floatValue] + [object[5] floatValue] + [object[6] floatValue] + [object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(userPath, nil, x, userY);
            CGPathAddLineToPoint(userPath, nil, addX, userY);
            
            systemY = (([object[1] isEqualToString:@"<null>"])) ? systemY : [self calculateValue:object[1] startY:userY addValue:height * (1 - ([object[1] floatValue] + [object[2] floatValue] + [object[3] floatValue] + [object[4] floatValue] + [object[5] floatValue] + [object[6] floatValue] + [object[7] floatValue] + [object[8] floatValue]) / ([self.tempMidString floatValue] * 2))];
            CGPathAddLineToPoint(systemPath, nil, x, systemY);
            CGPathAddLineToPoint(systemPath, nil, addX, systemY);
            tempX++;
        }
        
        CGPathAddLineToPoint(systemPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(userPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(nicePath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(idlePath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(ioWaitPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(irqPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(softIRQPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathAddLineToPoint(stealPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
        CGPathCloseSubpath(systemPath);
        CGPathCloseSubpath(userPath);
        CGPathCloseSubpath(nicePath);
        CGPathCloseSubpath(idlePath);
        CGPathCloseSubpath(ioWaitPath);
        CGPathCloseSubpath(irqPath);
        CGPathCloseSubpath(softIRQPath);
        CGPathCloseSubpath(stealPath);
        
        self.systemLayer.path = systemPath;
        self.userLayer.path = userPath;
        self.niceLayer.path = nicePath;
        self.IdleLayer.path = idlePath;
        self.ioWaitLayer.path = ioWaitPath;
        self.irqLayer.path = irqPath;
        self.softIrqLayer.path = softIRQPath;
        self.stealLayer.path = stealPath;
        CGPathRelease(systemPath);
        CGPathRelease(userPath);
        CGPathRelease(nicePath);
        CGPathRelease(idlePath);
        CGPathRelease(ioWaitPath);
        CGPathRelease(irqPath);
        CGPathRelease(softIRQPath);
        CGPathRelease(stealPath);
        
        [self setTagLabel];
    }
}

- (void) setLabel:(UILabel*)unitLabel {
//    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    unitLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
    [unitLabel sizeToFit];
    [self addSubview:unitLabel];
}

- (float) calculateValue:(NSString*)value startY:(float)startY addValue:(float)addValue {
    float result;
    if ([value isEqualToString:@"<null>"] || [value isEqualToString:@"0"]) {
        result = startY;
    } else {
        result = CGRectGetMidY(self.maxLabel.frame) + addValue;
    }
    if (isnan(result) || isinf(result)) {
        result = startY;
    }
    return result;
}

@end
