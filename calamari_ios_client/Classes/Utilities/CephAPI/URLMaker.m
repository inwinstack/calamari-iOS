//
//  URLMaker.m
//  CephAPITest
//
//  Created by Francis on 2015/4/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "URLMaker.h"

@implementation URLMaker

+ (NSString*) getLoginURLWithIP:(NSString*)ip Port:(NSString*)port {
    return [NSString stringWithFormat:@"http://%@:%@/api/v2/auth/login",ip, port];
}

+ (NSString*) getClusterListURLWithIP:(NSString*)ip Port:(NSString*)port {
    return [NSString stringWithFormat:@"http://%@:%@/api/v2/cluster",ip, port];
}

+ (NSString*) getClusterDetailWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID {
    return [NSString stringWithFormat:@"http://%@:%@/api/v2/cluster/%@", ip, port, clusterID];
}

+ (NSString*) getClusterDataWithIP:(NSString*)ip Port:(NSString*)port Version:(NSString*)version ClusterID:(NSString*)clusterID Kind:(NSString*)kind {
    return [NSString stringWithFormat:@"http://%@:%@/api/%@/cluster/%@/%@", ip, port, version, clusterID, kind];
}

+ (NSString*) getLogoutURLWithIP:(NSString*)ip Port:(NSString*)port {
    return [NSString stringWithFormat:@"http://%@:%@/api/v2/auth/logout",ip, port];
}

+ (NSString*) getOSDDataWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID OSDID:(NSString*)osdID {
    return [NSString stringWithFormat:@"http://%@:%@/api/v2/cluster/%@/osd/%@", ip, port, clusterID, osdID];
}

//Dashboard IOPS Card的圖表
+ (NSString*) getIOPSDataWithIp:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&from=-1d&target=sumSeries(ceph.cluster.%@.pool.all.num_read,ceph.cluster.%@.pool.all.num_write)", ip, port, clusterID, clusterID];
}

+ (NSString*) getIOPSIDWithIp:(NSString*)ip port:(NSString*)port ClusterID:(NSString*)clusterID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/metrics/find?query=ceph.cluster.%@.pool.*", ip, port, clusterID];
}

//Usage圖表
+ (NSString*) getUsageStatusDataWithIp:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=sumSeries(%%20scale(ceph.cluster.%@.df.total_avail,1024)%%20,%%20ceph.cluster.%@.df.total_avail_bytes%%20)&target=sumSeries(%%20scale(ceph.cluster.%@.df.total_used,1024)%%20,%%20ceph.cluster.%@.df.total_used_bytes%%20)", ip, port, clusterID, clusterID, clusterID, clusterID];
}

//Pool IOPS圖表
+ (NSString*) getPoolIOPSWithIp:(NSString*)ip Port:(NSString*)port PoolID:(NSString*)poolID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=%@.num_write&target=%@.num_read", ip, port, poolID, poolID];
}

+ (NSString*) getPoolListWithIp:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID {
    return [NSString stringWithFormat:@"http://%@:%@/api/v2/cluster/%@/pool", ip, port, clusterID];
}

//兩種type cpu跟iostat  cpu的是 all cpus的資料的加總   iostat是cpu iops的加總
+ (NSString*) getAllDataWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID whichAll:(NSString*)whichType {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/metrics/find?query=servers.%@.%@.*", ip, port, nodeID, whichType];
}

//cpu All cpus 每個cpu的資料
+ (NSString*) getAllCPUsWithIP:(NSString *)ip Port:(NSString *)port cpuID:(NSString*)cpuID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=%@.system&target=%@.user&target=%@.nice&target=%@.idle&target=%@.iowait&target=%@.irq&target=%@.softirq&target=%@.steal&from=-24hour", ip, port, cpuID, cpuID, cpuID, cpuID, cpuID, cpuID, cpuID, cpuID];
}

//cpu summary
+ (NSString*) getCPUPercentWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=servers.%@.cpu.total.system&target=servers.%@.cpu.total.user&target=servers.%@.cpu.total.idle", ip, port, nodeID, nodeID, nodeID];
}

//cpu load average
+ (NSString*) getCPULoadAverageWithIP:(NSString *)ip Port:(NSString *)port nodeID:(NSString *)nodeID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=servers.%@.loadavg.01&target=servers.%@.loadavg.05&target=servers.%@.loadavg.15", ip, port, nodeID, nodeID, nodeID];
}

//cpu memory
+ (NSString*) getCPUByteWithIP:(NSString *)ip Port:(NSString *)port nodeID:(NSString *)nodeID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=servers.%@.memory.Active&target=servers.%@.memory.Buffers&target=servers.%@.memory.Cached&target=servers.%@.memory.MemFree", ip, port, nodeID, nodeID, nodeID, nodeID];
}

//cpu iops
+ (NSString*) getCPUIOPSWithIP:(NSString*)ip Port:(NSString*)port iopsID:(NSString*)iopsID {
    return [NSString stringWithFormat:@"http://%@:%@/graphite/render/?format=json-array&target=%@.iops", ip, port, iopsID];
}

@end
