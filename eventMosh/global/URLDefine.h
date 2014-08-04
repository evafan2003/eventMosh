//
//  URLDefine.h
//  modelTest
//
//  Created by mosh on 13-10-29.
//  Copyright (c) 2013年 mosh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JSONKEY     @"res"
#define JSONFEEDBACK    @"feedback"
#define Encrypt      YES
#define JSONLIST    @"list"

#define JSONKEY_DATA    @"data"
#define JSONKEY_SUCCESS    @"success"
#define JSONKEY_ERROR    @"errCode"
#define JSONKEY_TOKEN    @"token"

#define JSONSUCCESS     @"1"
#define JSONFAIL        @"0"
/*
 网址
 */

#define MOSHHOST        @"http://ly.lootai.com/api/" //host


#define URL_REG         @"user/register?user=%@&password=%@"  //注册
#define URL_LOGIN       @"user/login?user=%@&password=%@"  //登录
#define URL_USERINFO    @"user/userInfo?token=%@" //用户信息
#define URL_CARLIST     @"car/carlist?token=%@" //车辆列表
#define URL_CARDEL      @"car/del?cid=%@&token=%@" //车辆删除
#define URL_ADDCAR      @"car/registcar?code=%@&c_type=%@&c_length=%@&phone=%@&c_number=%@token=%@" //添加车辆 code 车牌号 c_type 类型  c_length 长度  c_number gps号
#define URL_UPDATECAR      @"car/updatecarinfo?code=%@&c_type=%@&c_length=%@&phone=%@&c_number=%@token=%@" //修改车辆信息 code 车牌号 c_type 类型  c_length 长度  c_number gps号


@interface URLDefine : NSObject

@end
