//
//  EventDatabase.m
//  eventMosh
//
//  Created by  evafan2003 on 14-9-24.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "EventDatabase.h"
#import "GlobalConfig.h"


#define DB_NAME @"eventMosh.db"
#define TABLE_FAVORITE @"Favorite"



static EventDatabase *eventDatabase = nil;

@implementation EventDatabase


+(EventDatabase *) sharedInstance {
    
    if (!eventDatabase) {
        
        eventDatabase = [[EventDatabase alloc] init];
    }
    return eventDatabase;
}

-(id) init {
    
    if (self = [super init]) {
        db = [FMDatabase databaseWithPath:[self getFilePath]];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self getFilePath]];
        
        if (![db open]) {
			NSLog(@"Could not open db.");
			return nil;
		}
        
        [self createTable];
        
		if ([db hadError]) {
			NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
			return nil;
		}
    }
    
    return self;
}

//创建数据表
-(void) createTable {
    
    [db setShouldCacheStatements:YES];
    
    //票表
    [self createFavoriteTable];

    
}

//获取数据库地址

- (NSString *) getFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    
    MOSHLog(@"databaseAddress:%@",filePath);
    return filePath;
}

//删除表
- (void) dropTable:(NSString *)tableName
{
    [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",tableName]];
}

//创建收藏表
- (void) createFavoriteTable
{
    //    t_state 票状态 对应1未使用，2已使用，3已过期，4已退票,5删除票
    //    ispost 是否同步服务器 0未同步 1已同步
    NSString *createFavorite = [NSString stringWithFormat:@"create table  if not exists %@ (id  INTEGER PRIMARY KEY ASC, eid text, imageUrl text, title text, start_date text, end_date text, status text, is_allpay text, address text, sell_status text, sell_order_num text, sell_ticket_num text, sell_ticket_money text, issue_name text, bz text, uid text, currency text, c text, o_money text, t_count text, succ text, orgname text, a text)",TABLE_FAVORITE];
    [db executeUpdate:createFavorite];
}


//添加一个活动到收藏
-(void) addFavorite:(Activity *)act {

    NSMutableString *value = [[NSMutableString alloc] init];
    [value appendString:[NSString stringWithFormat:@"('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", act.eid, act.imageUrl, act.title, act.start_date, act.end_date, act.status, act.is_allpay, act.address, act.sell_status, act.sell_order_num, act.sell_ticket_num, act.sell_ticket_money, act.issue_name, act.bz, act.uid, act.currency, act.c, act.o_money, act.t_count, act.succ, act.orgname, act.a]];
    NSString *sql = [NSString stringWithFormat:@"replace into %@(`eid`,`imageUrl`, `title`, `start_date`, `end_date`, `status`, `is_allpay`, `address`, `sell_status`, `sell_order_num`, `sell_ticket_num`, `sell_ticket_money`,`issue_name`,`bz`,`uid`,`currency`,`c`,`o_money`,`t_count`,`succ`,`orgname`,`a`) values%@",TABLE_FAVORITE,value];
    
    MOSHLog(@"%@",sql);
    
    BOOL success = [db executeUpdate:sql];
    if (success) {
        MOSHLog(@"插入成功");
    }
    else {
        MOSHLog(@"插入失败");
    }
}

//判断一个活动是否收藏过
-(BOOL) isFavorite:(NSString *)eid {
    
    FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"select id from %@ where eid = '%@'",TABLE_FAVORITE,eid]];
    while ([resultSet next]) {
        return YES;
    }
    return NO;
}


//删除一个活动收藏
-(void) removeFavorite:(NSString *)eid {

    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where eid = '%@'",TABLE_FAVORITE,eid]];
    if (success) {
        MOSHLog(@"插入成功");
    }
    else {
        MOSHLog(@"插入失败");
    }
}

//查看收藏活动
-(NSMutableArray *)getAllFavorite {
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@",TABLE_FAVORITE];
    
    FMResultSet *resultSet = [db executeQuery:sql];
    
    while ([resultSet next]) {
        Activity *info = [self activityOfResultSet:resultSet];
        [resultArray addObject:info];
    }
    [resultSet close];
    return resultArray;
    
}

//删除所有活动
-(void) removeAllFavorite {
    
    [dbQueue inDatabase:^(FMDatabase *database) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@ ", TABLE_FAVORITE];
        [db executeUpdate:sql];
    }];
}

- (Activity *) activityOfResultSet:(FMResultSet *)resultSet
{
    Activity *info = [[Activity alloc] init];
    info.eid = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"eid"]];
    info.imageUrl = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"imageUrl"]];
    info.title = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"title"]];
    info.start_date = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"start_date"]];
    info.end_date = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"end_date"]];
    info.status = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"status"]];
    info.is_allpay = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"is_allpay"]];
    info.address = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"address"]];
    info.sell_status = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"sell_status"]];
    info.sell_order_num = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"sell_order_num"]];
    info.sell_ticket_num = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"sell_ticket_num"]];
    info.sell_ticket_money = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"sell_ticket_money"]];
    info.issue_name = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"issue_name"]];
    info.bz = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"bz"]];
    info.uid = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"uid"]];
    info.currency = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"currency"]];
    info.c = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"c"]];
    info.o_money = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"o_money"]];
    info.t_count = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"t_count"]];
    info.succ = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"succ"]];
    info.orgname = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"orgname"]];
    info.a = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"a"]];
    
    return info;
}
@end
