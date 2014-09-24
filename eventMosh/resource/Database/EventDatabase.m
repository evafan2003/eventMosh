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
    NSString *createFavorite = [NSString stringWithFormat:@"create table  if not exists %@ (id  INTEGER PRIMARY KEY ASC,eid integer, ticket_id integer, t_id integer, t_password text, t_state integer, tel text, use_date integer, ispost integer, ticket_name text,email text, name text,idcard text,t_price text)",TABLE_FAVORITE];
    [db executeUpdate:createFavorite];
    
    //用票密码和活动名称创建唯一索引
//    [db executeUpdate:[NSString stringWithFormat:@"create unique index if not exists t_status on %@ (eid,t_password)",TABLE_TICKET]];
    
//    [db executeUpdate:[NSString stringWithFormat:@"create index if not exists password on %@ (t_password)",TABLE_TICKET]];
    
//    [db executeUpdate:[NSString stringWithFormat:@"create index if not exists phone_number on %@ (tel)",TABLE_TICKET]];
    
}
@end
