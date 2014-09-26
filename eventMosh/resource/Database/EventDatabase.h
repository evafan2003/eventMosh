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
#import "Activity.h"

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

//添加一个活动收藏
-(void) addFavorite:(Activity *)act;

//判断一个活动是否收藏过
-(BOOL) isFavorite:(NSString *)eid;


//删除一个活动收藏
-(void) removeFavorite:(NSString *)eid;

//查看收藏活动
-(NSMutableArray *)getAllFavorite;

//删除所有活动
-(void) removeAllFavorite;
@end
