//
//  CPUSquareView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/7.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "CPULineBrokenView.h"
#import "UIColor+Reader.h"
#import "DateMaker.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface CPULineBrokenView () {
    BOOL currentIsFilled;
}

@property (nonatomic, strong) UILabel *systemLabel;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UILabel *idleLabel;
@property (nonatomic, strong) UILabel *freeLabel;
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
@property (nonatomic, strong) CAShapeLayer *idleLayer;
@property (nonatomic, strong) CAShapeLayer *freeLayer;
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

@implementation CPULineBrokenView

- (instancetype) initWithFrame:(CGRect)frame isFilled:(BOOL)isFilled {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        currentIsFilled = isFilled;
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        
        self.systemLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 0, height * 25 / 255)];
        self.systemLabel.textColor = [UIColor okGreenColor];
        self.systemLabel.text = (isFilled) ? [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_system"] : [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_one_min"];
        [self setLabel:self.systemLabel];
        
        self.userLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.systemLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.userLabel.textColor = [UIColor UserLinePurpleColor];
        self.userLabel.text = (isFilled) ? [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_user"] : [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_five_min"];
        [self setLabel:self.userLabel];

        self.idleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.idleLabel.textColor = [UIColor warningColor];
        self.idleLabel.text = (isFilled) ? [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_Idle"] : [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_fifteen_min"];
        [self setLabel:self.idleLabel];
        
        self.freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.idleLabel.frame) + height * 5 / 255, CGRectGetMinY(self.systemLabel.frame), 0, height * 25 / 255)];
        self.freeLabel.textColor = [UIColor IdleLineBlueColor];
        
        self.freeLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"host_detail_summary_free"];
        [self setLabel:self.freeLabel];
        
        self.backgroundWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.freeLabel.frame) + 10 * height / 255, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.freeLabel.frame) - height * 15 / 255)];
        self.backgroundWhiteView.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self addSubview:self.backgroundWhiteView];
        
        self.xLayer = [CAShapeLayer layer];
        self.xLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.xLayer.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.04, CGRectGetMidY(self.frame) + height * 25 / 255 + 10 * height / 255, CGRectGetWidth(self.frame) - CGRectGetWidth([UIScreen mainScreen].bounds) * 0.08, 1);
        [self.layer addSublayer:self.xLayer];
        
        self.yLayer = [CAShapeLayer layer];
        self.yLayer.backgroundColor = [UIColor normalBlackColor].CGColor;
        self.yLayer.frame = CGRectMake(CGRectGetMinX(self.xLayer.frame), CGRectGetMaxY(self.systemLabel.frame) + 10 * height / 255, 1, CGRectGetMinY(self.xLayer.frame) - CGRectGetMaxY(self.systemLabel.frame) - 10 * height / 255);
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
        [self.layer addSublayer:self.systemLayer];
        
        self.userLayer = [CAShapeLayer layer];
        self.userLayer.strokeColor = [UIColor UserLinePurpleColor].CGColor;
        self.userLayer.lineWidth = 0.5;
        self.userLayer.zPosition = 1;
        [self.layer addSublayer:self.userLayer];
        
        self.idleLayer = [CAShapeLayer layer];
        self.idleLayer.strokeColor = [UIColor warningColor].CGColor;
        self.idleLayer.lineWidth = 0.5;
        self.idleLayer.zPosition = 2;
        [self.layer addSublayer:self.idleLayer];
        
        self.freeLayer = [CAShapeLayer layer];
        self.freeLayer.strokeColor = [UIColor IdleLineBlueColor].CGColor;
        self.freeLayer.fillColor = [UIColor IdleLineBlueFillColor].CGColor;
        self.freeLayer.lineWidth = 0.5;
        self.freeLayer.zPosition = 3;
        [self.layer addSublayer:self.freeLayer];
        
        if (isFilled) {
            self.systemLayer.fillColor = [UIColor okGreenShapelayerColor].CGColor;
            self.userLayer.fillColor = [UIColor UserLinePurpleFillColor].CGColor;
            self.idleLayer.fillColor = [UIColor warningShapelayerColor].CGColor;
        } else {
            self.systemLayer.fillColor = [UIColor clearColor].CGColor;
            self.userLayer.fillColor = [UIColor clearColor].CGColor;
            self.idleLayer.fillColor = [UIColor clearColor].CGColor;
        }
        
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
        CGMutablePathRef idlePath = CGPathCreateMutable();
        CGMutablePathRef freePath = CGPathCreateMutable();
        
        float startX = CGRectGetMaxX(self.yLayer.frame);
        float startY = CGRectGetMinY(self.xLayer.frame);
        float height = CGRectGetMinY(self.xLayer.frame) - CGRectGetMidY(self.maxLabel.frame);
        int tempX = 0;
        int count = 0;
        
        CGPathMoveToPoint(systemPath, nil, startX, startY);
        CGPathMoveToPoint(userPath, nil, startX, startY);
        CGPathMoveToPoint(idlePath, nil, startX, startY);
        CGPathMoveToPoint(freePath, nil, startX, startY);
        
        float systemY = startY;
        float userY = startY;
        float idleY = startY;
        float freeY = startY;
        if ([dataArray[0] count] > 4) {
            self.freeLabel.alpha = 1;
            self.freeLayer.opacity = 1;
            for (id object in dataArray) {
                float x = startX + (tempX * tempheight * 0.7 / 255);
                float addX = startX + ((tempX + 1) * tempheight * 0.7 / 255);
                if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                    [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                    ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                    count++;
                }
          
                freeY = (([object[4] isEqualToString:@"<null>"])) ? freeY : [self calculateValue:object[4] startY:startY addValue:height * (1 - [object[4] floatValue] / ([self.tempMidString floatValue] * 2))];
                [self addLineWithPath:freePath xLocation:x addXLocation:addX yLocation:freeY];
                
                idleY = (([object[3] isEqualToString:@"<null>"])) ? idleY : [self calculateValue:object[3] startY:freeY addValue:height * (1 - ([object[3] floatValue] + [object[4] floatValue]) / ([self.tempMidString floatValue] * 2))];
                [self addLineWithPath:idlePath xLocation:x addXLocation:addX yLocation:idleY];
                
                userY = (([object[2] isEqualToString:@"<null>"])) ? userY : [self calculateValue:object[2] startY:idleY addValue:height * (1 - ([object[2] floatValue] + [object[3] floatValue] + [object[4] floatValue]) / ([self.tempMidString floatValue] * 2))];
                [self addLineWithPath:userPath xLocation:x addXLocation:addX yLocation:userY];

                
                systemY = (([object[1] isEqualToString:@"<null>"])) ? systemY : [self calculateValue:object[1] startY:idleY addValue:height * (1 - ([object[1] floatValue] + [object[2] floatValue] + [object[3] floatValue] + [object[4] floatValue]) / ([self.tempMidString floatValue] * 2))];
                [self addLineWithPath:systemPath xLocation:x addXLocation:addX yLocation:systemY];

                tempX++;
            }
        } else {
            self.freeLabel.alpha = 0;
            self.freeLayer.opacity = 0;
            if (currentIsFilled) {
                
                for (id object in dataArray) {
                    float x = startX + (tempX * tempheight * 0.7 / 255);
                    float addX = startX + ((tempX + 1) * tempheight * 0.7 / 255);
                    if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                        [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                        ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                        count++;
                    }
                    
                    idleY = (([object[3] isEqualToString:@"<null>"])) ? idleY : [self calculateValue:object[3] startY:startY addValue:height * (1 - [object[3] floatValue] / ([self.tempMidString floatValue] * 2))];
                    [self addLineWithPath:idlePath xLocation:x addXLocation:addX yLocation:idleY];
                    
                    userY = (([object[2] isEqualToString:@"<null>"])) ? userY : [self calculateValue:object[2] startY:idleY addValue:height * (1 - ([object[2] floatValue] + [object[3] floatValue]) / ([self.tempMidString floatValue] * 2))];
                    [self addLineWithPath:userPath xLocation:x addXLocation:addX yLocation:userY];
                    
                    
                    systemY = (([object[1] isEqualToString:@"<null>"])) ? systemY : [self calculateValue:object[1] startY:idleY addValue:height * (1 - ([object[1] floatValue] + [object[2] floatValue] + [object[3] floatValue]) / ([self.tempMidString floatValue] * 2))];
                    [self addLineWithPath:systemPath xLocation:x addXLocation:addX yLocation:systemY];
                    
                    tempX++;
                }
            } else {
                CGPathMoveToPoint(systemPath, nil, startX + (tempX * tempheight * 0.7 / 255), [self calculateValue:dataArray[0][1] startY:startY addValue:height * (1 - [dataArray[0][1] floatValue] / ([self.tempMidString floatValue] * 2))]);
                CGPathMoveToPoint(userPath, nil, startX + (tempX * tempheight * 0.7 / 255), [self calculateValue:dataArray[0][2] startY:startY addValue:height * (1 - [dataArray[0][2] floatValue] / ([self.tempMidString floatValue] * 2))]);
                CGPathMoveToPoint(idlePath, nil, startX + (tempX * tempheight * 0.7 / 255), [self calculateValue:dataArray[0][3] startY:startY addValue:height * (1 - [dataArray[0][3] floatValue] / ([self.tempMidString floatValue] * 2))]);
                for (id object in dataArray) {
                    float x = startX + (tempX * tempheight * 0.7 / 255);
                    if ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@":"].location] isEqualToString:@":00"]) {
                        [self.tagLayerArray[count] setFrame:CGRectMake(x, CGRectGetMinY(self.yLayer.frame), tempheight * 0.5 / 255, height + CGRectGetMidY(self.maxLabel.frame) - CGRectGetMinY(self.yLayer.frame))];
                        ([[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1] isEqualToString:@"00:00"]) ? [self.tagLabelStringArray addObject:[[DateMaker shareDateMaker] getDateWithDate:object[0]]] : [self.tagLabelStringArray addObject:[[NSString stringWithFormat:@"%@", object[0]] substringFromIndex:[object[0] rangeOfString:@" "].location + 1]];
                        count++;
                    }
                    
                    idleY = (([object[3] isEqualToString:@"<null>"])) ? idleY : [self calculateValue:object[3] startY:startY addValue:height * (1 - [object[3] floatValue] / ([self.tempMidString floatValue] * 2))];
                    CGPathAddLineToPoint(idlePath, nil, x, idleY);
                    
                    userY = (([object[2] isEqualToString:@"<null>"])) ? userY : [self calculateValue:object[2] startY:idleY addValue:height * (1 - [object[2] floatValue] / ([self.tempMidString floatValue] * 2))];
                    CGPathAddLineToPoint(userPath, nil, x, userY);
                    
                    
                    systemY = (([object[1] isEqualToString:@"<null>"])) ? systemY : [self calculateValue:object[1] startY:idleY addValue:height * (1 - [object[1] floatValue] / ([self.tempMidString floatValue] * 2))];
                    CGPathAddLineToPoint(systemPath, nil, x, systemY);
                    
                    tempX++;
                }
            }
        }
        
        if (currentIsFilled) {
            CGPathAddLineToPoint(systemPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
            CGPathAddLineToPoint(userPath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
            CGPathAddLineToPoint(idlePath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
            CGPathAddLineToPoint(freePath, nil, startX + (dataArray.count * tempheight * 0.7 / 255), startY);
            
            CGPathCloseSubpath(systemPath);
            CGPathCloseSubpath(userPath);
            CGPathCloseSubpath(idlePath);
            CGPathCloseSubpath(freePath);
        }
        
        self.systemLayer.path = systemPath;
        self.idleLayer.path = idlePath;
        self.userLayer.path = userPath;
        self.freeLayer.path = freePath;
        CGPathRelease(systemPath);
        CGPathRelease(userPath);
        CGPathRelease(idlePath);
        CGPathRelease(freePath);
        [self setTagLabel];
    }
}

- (void) setLabel:(UILabel*)unitLabel {
    unitLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
    [unitLabel sizeToFit];
    [self addSubview:unitLabel];
}

- (void) addLineWithPath:(CGMutablePathRef)linePath xLocation:(float)x addXLocation:(float)addX yLocation:(float)y {
    CGPathAddLineToPoint(linePath, nil, x, y);
    CGPathAddLineToPoint(linePath, nil, addX, y);
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
