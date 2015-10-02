//
//  SettingViewFlowLayout.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "SettingViewFlowLayout.h"
#import "UIView+SizeMaker.h"

@implementation SettingViewFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
    }
    return self;
}

@end
