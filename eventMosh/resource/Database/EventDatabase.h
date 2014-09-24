//
//  EventDatabase.h
//  eventMosh
//
//  Created by  evafan2003 on 14-9-24.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "PosModel.h"

@interface EventDatabase : NSObject {
    FMDatabase *db;
    FMDatabaseQueue *dbQueue;
}

+ (EventDatabase *)sharedInstance;

/**
 *  删除表
 *
 *  @param tableName 表名
 */
- (void) dropTable:(NSString *)tableName;

//添加一个活动到收藏
-(void) insertFavorite:(PosModel *)pos;


//查看收藏活动
-(NSArray *)getAllFavorite;

@end
