//
//  HTTPClient+PartTask.m
//  moshTickets
//
//  Created by 魔时网 on 14-7-4.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "HTTPClient+PartTask.h"
#import "GlobalConfig.h"

@implementation HTTPClient (PartTask)

- (void) addNewTaskWithTaskName:(NSString *)name
                            eid:(NSString *)eid
                            uid:(NSString *)uid
                        success:(void (^)(id json))success
{
    [self.request beginRequest:[NSString stringWithFormat:URL_ADDNEWPRATTASK,eid,name,uid]
                  isAppendHost:YES
                     isEncrypt:Encrypt
                       success:^(id json) {
                              success(json);
                              
                          } fail:^{
//                              [GlobalConfig showAlertViewWithMessage:ERROR_LOADINGFAIL superView:nil];
                              success(nil);
                          }];
}


@end
