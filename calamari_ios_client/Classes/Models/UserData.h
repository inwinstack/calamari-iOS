//
//  UserData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString *ipString;
@property (nonatomic, strong) NSString *portString;
@property (nonatomic, strong) NSString *accountString;
@property (nonatomic, strong) NSString *passwordString;

+ (UserData*) shareInstance;

@end
