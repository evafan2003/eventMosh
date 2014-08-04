//
//  WSScrollViewController.h
//  moshTickets
//
//  Created by 魔时网 on 14-5-28.
//  Copyright (c) 2014年 mosh. All rights reserved.
//

#import "BaseViewController.h"
@class ScrollModel;
typedef enum {
    ScrollOrientation_vertical,//垂直
    ScrollOrientation_horizontal,//水平
} ScrollOrientation;
@interface WSScrollViewController : BaseViewController
{
    ScrollModel *_model;
}
- (id) initWithScrollModel:(ScrollModel *)model;

@end


@interface ScrollModel : NSObject

@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *imageUrl;
@property (nonatomic ,strong) UIImage *image;
@property (nonatomic ,assign) ScrollOrientation orientation;

- (id) initWithDictionary:(NSDictionary *)dic scrollOrientation:(ScrollOrientation)orientation;
@end