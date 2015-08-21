//
//  ImageData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/14.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageData : NSObject

@property (nonatomic, strong) NSDictionary *imageNameDictionary;

+ (ImageData*) shareInstance;

@end
