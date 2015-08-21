//
//  CephAPI.m
//  CephAPITest
//
//  Created by Francis on 2015/4/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "CephAPI.h"
#import "URLMaker.h"
#import "Cookies.h"
#import "UserData.h"
#import "ClusterData.h"
#import "APIRecord.h"
#import "PGData.h"
#import "DateMaker.h"
#import "HostHealthData.h"
#import "AFNetworking.h"
#import "AFURLResponseSerialization.h"

@interface CephAPI ()

@property (nonatomic, strong) NSArray *cpuSummaryKeyArray;

@end

@implementation CephAPI

+ (CephAPI*) shareInstance {
    static CephAPI *cephAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cephAPI = [[CephAPI alloc] init];
    });
    return cephAPI;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.cpuSummaryKeyArray = @[@"byte", @"average", @"percent"];
    }
    return self;
}

- (void) startGetSessionWithIP:(NSString*)ip Port:(NSString*)port Account:(NSString*)account Password:(NSString*)password completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getLoginURLWithIP:ip Port:port]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"POST"];
    NSDictionary *json = @{@"username": account, @"password": password};
    NSError *setError;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&setError]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            error(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                error(readError);
            } else {
                if ([receiveObject isEqual:@{}]) {
                    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
                        if ([cookie.name isEqualToString:@"XSRF-TOKEN"]) {
                            [Cookies shareInstance].sessionID = cookie.value;
                        }
                    }
                    completion(true);
                } else {
                    error(receiveObject);
                }
            }
        }
    }];
}

- (void) startGetClusterListWithIP:(NSString *)ip Port:(NSString *)port completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getClusterListURLWithIP:ip Port:port]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            error(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                error(readError);
            } else {
                [ClusterData shareInstance].clusterArray = (NSMutableArray*)receiveObject;
                completion(true);
            }
        }
    }];
}

- (void) startGetClusterDetailWithIP:(NSString *)ip Port:(NSString *)port ClusterID:(NSString*)clusterID completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getClusterDetailWithIP:ip Port:port ClusterID:clusterID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            error(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                error(readError);
            } else {
                [[ClusterData shareInstance].clusterDetailData setObject:receiveObject forKey:clusterID];
                completion(true);
            }
        }
    }];
}

- (void) startGetClusterDataWithIP:(NSString *)ip Port:(NSString *)port Version:(NSString*)version ClusterID:(NSString*)clusterID Kind:(NSString*)kind completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getClusterDataWithIP:ip Port:port Version:version ClusterID:clusterID Kind:kind]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            error(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                error(readError);
            } else {
                [[ClusterData shareInstance].clusterDetailData setObject:receiveObject forKey:[NSString stringWithFormat:@"%@_%@", clusterID, kind]];
                completion(true);
            }
        }
    }];
}

- (void) startGetOSDDataWithIP:(NSString *)ip Port:(NSString *)port ClusterID:(NSString*)clusterID OSDID:(NSString*)osdID completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getOSDDataWithIP:ip Port:port ClusterID:clusterID OSDID:osdID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            error(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                error(readError);
            } else {
                [[ClusterData shareInstance].clusterDetailData setObject:receiveObject forKey:[NSString stringWithFormat:@"%@_osd_detail", clusterID]];
                completion(true);
            }
        }
    }];
}

- (void) startGetClusterDetailAtBackgroundCompletion:(void (^)(BOOL finished))completion error:(void (^)(id error))backgroundError {
   [self startGetClusterDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString Version:[APIRecord shareInstance].APIDictionary[@"Health"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Health"][1] completion:^(BOOL finished) {
       if (finished) {
           [self startGetClusterDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString Version:[APIRecord shareInstance].APIDictionary[@"Space"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Space"][1] completion:^(BOOL finished) {
               if (finished) {
                   [self startGetClusterDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString Version:[APIRecord shareInstance].APIDictionary[@"Health_Counter"][0] ClusterID:[ClusterData shareInstance].clusterArray[0][@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Health_Counter"][1] completion:^(BOOL finished) {
                       if (finished) {
                           completion(true);
                       }
                   } error:^(id error) {
                       backgroundError(error);
                   }];
               }
           } error:^(id error) {
               backgroundError(error);
           }];
       }
   } error:^(id error) {
       backgroundError(error);
   }];
}

- (void) startGetIOPSDataWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getIOPSDataWithIp:ip Port:port ClusterID:clusterID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            getError(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                getError(readError);
            } else {
                [[ClusterData shareInstance].clusterDetailData setObject:receiveObject forKey:[NSString stringWithFormat:@"%@_iops", clusterID]];
                completion(true);
            }
        }
    }];
}

- (void) startGetIOPSIDWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getIOPSIDWithIp:ip port:port ClusterID:clusterID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            getError(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                getError(readError);
            } else {
                [[ClusterData shareInstance].clusterDetailData setObject:receiveObject forKey:[NSString stringWithFormat:@"%@_iops_ID", clusterID]];
                completion(true);
            }
        }
    }];
}

- (void) startGetPoolIOPSWithIP:(NSString*)ip Port:(NSString*)port PoolID:(NSString*)poolID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getPoolIOPSWithIp:ip Port:port PoolID:poolID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            getError(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                getError(readError);
            } else {
                [self setAverageDataWithDataArray:receiveObject[@"datapoints"] target:[ClusterData shareInstance].clusterDetailData key:poolID kind:@"pool_iops"];
            
                completion(true);
            }
        }
    }];
}

- (void) startGetPoolListWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getPoolListWithIp:ip Port:port ClusterID:clusterID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            getError(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                getError(readError);
            } else {
                [[ClusterData shareInstance].clusterDetailData setObject:receiveObject forKey:[NSString stringWithFormat:@"%@_pool_list", clusterID]];
                completion(true);
            }
        }
    }];
}

- (void) startGetUsageStatusWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getUsageStatusDataWithIp:ip Port:port ClusterID:clusterID]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            getError(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                getError(readError);
            } else {
                [self setDataWithDataArray:receiveObject[@"datapoints"] target:[ClusterData shareInstance].clusterDetailData key:clusterID kind:@"usage"];
                completion(true);
            }
        }
    }];
}

- (void) startGetAllDataWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID whichType:(NSString*)whichType Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getAllDataWithIP:ip Port:port nodeID:nodeID whichAll:whichType]] cachePolicy:0 timeoutInterval:6];
    [request setHTTPMethod:@"GET"];
    [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            getError(connectionError);
        } else {
            NSError *readError;
            id receiveObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&readError];
            if (readError) {
                getError(readError);
            } else {
                if ([whichType isEqualToString:@"iostat"]) {
                    NSMutableArray *iopsArray = [NSMutableArray array];
                    for (id object in receiveObject) {
                        if (!([[[NSString stringWithFormat:@"%@", object[@"text"]] substringFromIndex:[NSString stringWithFormat:@"%@", object[@"text"]].length - 1] intValue] > 0)) {
                            [iopsArray addObject:object];
                        }
                    }
                    [[HostHealthData shareInstance].hostDic setObject:iopsArray forKey:[NSString stringWithFormat:@"%@_%@", nodeID, whichType]];
                } else if ([whichType isEqualToString:@"cpu"]) {
                    NSMutableArray *tempArray = [NSMutableArray array];
                    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                    for (int i = 0; i < [receiveObject count] - 1; i ++) {
                        [tempArray addObject:receiveObject[i]];
                        [tempDic setObject:receiveObject[i] forKey:receiveObject[i][@"id"]];
                    }

                    for (int j = 0; j < tempArray.count; j++) {
                        for (int k = 0; k < (tempArray.count - 1); k++) {
                            NSRange findFirstRange = [[NSString stringWithFormat:@"%@", tempArray[k][@"id"]] rangeOfString:@"cpu.cpu"];
                            NSRange findNextRange = [[NSString stringWithFormat:@"%@", tempArray[k + 1][@"id"]] rangeOfString:@"cpu.cpu"];
                            NSString *findFirstValue = [[NSString stringWithFormat:@"%@", tempArray[k][@"id"]] substringFromIndex:findFirstRange.length + findFirstRange.location];
                            NSString *findNextValue = [[NSString stringWithFormat:@"%@", tempArray[k + 1][@"id"]] substringFromIndex:findNextRange.length + findNextRange.location];
                            if ([findFirstValue integerValue] > [findNextValue integerValue]) {
                                id tempObj = tempArray[k];
                                tempArray[k] = tempArray[k + 1];
                                tempArray[k + 1] = tempObj;
                            }
                        }
                    }
                    
                    NSMutableArray *resultArray = [NSMutableArray array];
                    for (id objectValue in tempArray) {
                        [resultArray addObject:objectValue[@"id"]];
                    }
                    
                    [tempDic setObject:[receiveObject lastObject] forKey:[receiveObject lastObject][@"id"]];
                    [resultArray insertObject:[receiveObject lastObject][@"id"] atIndex:0];
                    [HostHealthData shareInstance].hostAllCPUKeyArray = resultArray;
                    
                    [[HostHealthData shareInstance].hostDic setObject:tempDic forKey:[NSString stringWithFormat:@"%@_%@", nodeID, whichType]];
                } else {
                    [[HostHealthData shareInstance].hostDic setObject:receiveObject forKey:[NSString stringWithFormat:@"%@_%@", nodeID, whichType]];
                }
                completion(true);
            }
        }
    }];
}

- (void) startGetAllCPUDataWithIP:(NSString*)ip Port:(NSString*)port cpuArray:(NSArray*)cpuArray Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableArray *mutableOperations = [NSMutableArray array];
    for (id object in cpuArray) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getAllCPUsWithIP:ip Port:port cpuID:object]] cachePolicy:0 timeoutInterval:6];
        [request setHTTPMethod:@"GET"];
        [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            id receiveData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];

            [self setDataWithDataArray:receiveData[@"datapoints"] target:[HostHealthData shareInstance].hostDic key:object kind:@"cpu"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            getError(error);
        }];
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        //        NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        completion(true);
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (void) startGetCPUSummaryDataWithIP:(NSString *)ip Port:(NSString *)port nodeID:(NSString *)nodeID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSDictionary *tempDic = @{self.cpuSummaryKeyArray[0] : [URLMaker getCPUByteWithIP:ip Port:port nodeID:nodeID], self.cpuSummaryKeyArray[1] : [URLMaker getCPULoadAverageWithIP:ip Port:port nodeID:nodeID], self.cpuSummaryKeyArray[2] : [URLMaker getCPUPercentWithIP:ip Port:port nodeID:nodeID]};
    NSMutableArray *mutableOperations = [NSMutableArray array];
    for (id object in self.cpuSummaryKeyArray) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tempDic[object]] cachePolicy:0 timeoutInterval:6];
        [request setHTTPMethod:@"GET"];
        [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            id recevieData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            ([object isEqualToString:self.cpuSummaryKeyArray[1]]) ? [self setAverageDataWithDataArray:recevieData[@"datapoints"] target:[HostHealthData shareInstance].hostDic key:nodeID kind:object] : [self setDataWithDataArray:recevieData[@"datapoints"] target:[HostHealthData shareInstance].hostDic key:nodeID kind:object];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            getError(error);
        }];
        [mutableOperations addObject:operation];
    }

    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        //        NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        completion(true);
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (void) startGetCPUIOPSDataWithIP:(NSString *)ip Port:(NSString *)port iopsArray:(NSArray*)iopsArray Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError {
    NSMutableArray *mutableOperations = [NSMutableArray array];
    for (id object in iopsArray) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLMaker getCPUIOPSWithIP:ip Port:port iopsID:object[@"id"]]] cachePolicy:0 timeoutInterval:6];
        [request setHTTPMethod:@"GET"];
        [request setValue:[Cookies shareInstance].sessionID forHTTPHeaderField:@"X-XSRF-TOKEN"];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            id receiveData = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            [self setDataWithDataArray:receiveData[@"datapoints"] target:[HostHealthData shareInstance].hostDic key:object[@"id"] kind:@"cpuiops"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            getError(error);
        }];
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//        NSLog(@"%lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        completion(true);
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (void) setDataWithDataArray:(id)dataArray target:(id)target key:(NSString*)key kind:(NSString*)kind {
    NSMutableArray *tempDataArray = [NSMutableArray array];
    double max = 0.0;
    for (int i = 1080; i < [dataArray count] ; i++) {
        NSMutableArray *tempElementArray = [NSMutableArray array];
        [tempElementArray addObject:[[DateMaker shareDateMaker] getTimeWithTimeStamp:[NSString stringWithFormat:@"%@", dataArray[i][0]]]];
        double tempCount = 0.0;
        for (int k = 1 ;k < [dataArray[i] count]; k++) {
            tempCount += [[NSString stringWithFormat:@"%@", dataArray[i][k]] floatValue];
            [tempElementArray addObject:[NSString stringWithFormat:@"%@", dataArray[i][k]]];
        }
        [tempDataArray addObject:tempElementArray];
        if (tempCount > max) {
            max = tempCount;
        }
    }
    max = ceil(max / 20.0) * 20.0;
    long int tempMax = (max == 0) ? 20 : max;
    [target setObject:tempDataArray forKey:[NSString stringWithFormat:@"%@_%@", key, kind]];
    [target setObject:[NSString stringWithFormat:@"%ld", tempMax] forKey:[NSString stringWithFormat:@"%@_%@_max", key, kind]];
}

- (void) setAverageDataWithDataArray:(id)dataArray target:(id)target key:(NSString*)key kind:(NSString*)kind {
    NSMutableArray *tempDataArray = [NSMutableArray array];
    double max = 0.0;
    for (int i = 1080; i < [dataArray count] ; i++) {
        NSMutableArray *tempElementArray = [NSMutableArray array];
        [tempElementArray addObject:[[DateMaker shareDateMaker] getTimeWithTimeStamp:[NSString stringWithFormat:@"%@", dataArray[i][0]]]];
        for (int k = 1 ;k < [dataArray[i] count]; k++) {
            if ([[NSString stringWithFormat:@"%@", dataArray[i][k]] doubleValue] > max) {
                max = [[NSString stringWithFormat:@"%@", dataArray[i][k]] doubleValue];
            }
            [tempElementArray addObject:[NSString stringWithFormat:@"%@", dataArray[i][k]]];
        }
        [tempDataArray addObject:tempElementArray];
    }
    
    max = (max < 20 && max > 0) ? max + 0.1 : ceil(max / 20.0) * 20.0;
    double tempMax = (max == 0) ? 20.0 : max;
    [target setObject:tempDataArray forKey:[NSString stringWithFormat:@"%@_%@", key, kind]];
    [target setObject:[NSString stringWithFormat:@"%.1f", tempMax] forKey:[NSString stringWithFormat:@"%@_%@_max", key, kind]];
}

@end
