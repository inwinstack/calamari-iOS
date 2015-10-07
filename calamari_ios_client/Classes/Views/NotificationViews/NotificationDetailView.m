//
//  NotificationDetailView.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationDetailView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@implementation NotificationDetailView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, 0)];
        self.contentLabel.font = [UIFont systemFontOfSize:[UIView subHeadSize]];
        self.contentLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.contentLabel];
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, CGRectGetMaxY(self.contentLabel.frame) + 10, 20, 15)];
        [self addSubview:self.statusImageView];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImageView.frame) + 10, CGRectGetMinY(self.statusImageView.frame), 0, 20)];
        self.statusLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.statusLabel];
        
        self.errorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.statusLabel.frame) + 10, 0, 0)];
        self.errorTitleLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.errorTitleLabel];
        
        self.errorCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.errorTitleLabel.frame), 0, 0)];
        self.errorCountLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.errorCountLabel];
        
        self.errorTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.errorCountLabel.frame) + 10, 0, 0)];
        self.errorTimeLabel.textColor = [UIColor normalBlackColor];
        [self addSubview:self.errorTimeLabel];
        
        self.resolveTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.errorTimeLabel.frame) + 10, 0, 0)];
        self.resolveTimeLabel.textColor = [UIColor normalBlackColor];
        self.resolveTimeLabel.alpha = 0;
        [self addSubview:self.resolveTimeLabel];
        
    }
    return self;
}

- (void) setContentWithContent:(NSString*)content status:(NSString*)status errorTitle:(NSString*)errorTitle errorCount:(NSString*)errorCount errorTimeString:(NSString*)errorTimeString resolveTimeString:(NSString*)resolveTimeString {
    self.contentLabel.frame = CGRectMake(10, 10, CGRectGetWidth(self.frame) - 20, 0);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.text = content;
    [self.contentLabel sizeToFit];
    
    self.statusImageView.frame = CGRectMake(7, CGRectGetMaxY(self.contentLabel.frame) + 5, 20, 15);
    self.statusImageView.image = ([status isEqualToString:@"Pending"]) ? [UIImage imageNamed:@"NotificationPendingImage"] : [UIImage imageNamed:@"NotificationResolvedImage"];
    
    self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.statusImageView.frame) + 10, CGRectGetMinY(self.statusImageView.frame), 0, 20);
    self.statusLabel.textColor = ([status isEqualToString:@"Pending"]) ? [UIColor errorColor] : [UIColor normalBlueColor];
    self.statusLabel.text = status;
    [self.statusLabel sizeToFit];
    
    self.errorTitleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.statusImageView.frame) + 10, 0, 0);
    self.errorTitleLabel.text = errorTitle;
    [self.errorTitleLabel sizeToFit];
    
    self.errorCountLabel.frame = CGRectMake(10, CGRectGetMaxY(self.errorTitleLabel.frame), 0, 0);
    self.errorCountLabel.text = errorCount;
    [self.errorCountLabel sizeToFit];
    
    self.errorTimeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.errorCountLabel.frame) + 10, 0, 0);
    self.errorTimeLabel.numberOfLines = 0;
    self.errorTimeLabel.text = errorTimeString;
    [self.errorTimeLabel sizeToFit];
    
    if (resolveTimeString.length > 0) {
        self.resolveTimeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.errorTimeLabel.frame) + 10, 0, 0);
        self.resolveTimeLabel.alpha = 1;
        self.resolveTimeLabel.numberOfLines = 0;
        self.resolveTimeLabel.text = resolveTimeString;
        [self.resolveTimeLabel sizeToFit];
    }
}

@end
