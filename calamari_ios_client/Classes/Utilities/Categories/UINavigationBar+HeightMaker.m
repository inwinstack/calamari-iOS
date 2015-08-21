//
//  UINavigationBar+HeightMaker.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/20.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "UINavigationBar+HeightMaker.h"
#import "objc/runtime.h"

@implementation UINavigationBar (HeightMaker)

- (void) setHeight:(CGFloat)height {
    objc_setAssociatedObject(self, @"Height", @(height), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *) height {
    return objc_getAssociatedObject(self, @"Height");
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize newSize;
    
    if (self.height) {
        newSize = CGSizeMake(self.superview.bounds.size.width, [self.height floatValue]);
    } else {
        newSize = [super sizeThatFits:size];
    }
    
    return newSize;
}

@end
