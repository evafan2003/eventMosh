//
//  GlobalConfig.h
//  MoshActivity
//
//  Created by  evafan2003 on 12-12-20.
//  Copyright (c) 2012年 cn.mosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "MOSHDefine.h"
#import "URLDefine.h"

//自定义navbutton;
typedef enum {
    NavButtonTypeBack,
    NavButtonTypeRefresh,
    NavButtonTypeShare,
    NavButtonTypeBuy,
    NavButtonTypeList,
    NavButtonTypeUser
}NavButtonType;

@interface GlobalConfig : NSObject
@property (nonatomic, assign) NavButtonType navButtonType;

#pragma mark - 设备方法-
/**
 *  判断设备是否是 iPod Touch
 *
 *  @return yes or no
 */
+ (BOOL)isIPodTouch;

/**
 *  判断设备是否是 ipad
 *
 *  @return yes or no
 */

+ (BOOL) isIpad;
/**
 *  返回设备型号
 *
 *  @return e.g. @"iPhone", @"iPod touch"
 */

+ (NSString *)deviceType;

/**
 *  返回系统版本信息
 *
 *  @return e.g. @"4.0"
 */
+ (NSString *)systemVersion;
/**
 *  判断是否ios7
 *
 *  @return yes or no
 */
+ (BOOL) versionIsIOS7;

/**
 *  返回软件版本信息
 *
 *  @return e.g. 7.1000
 */
+(CGFloat)appVersion;

/**
 *  打电话
 *
 *  @param phoneNumber 电话号码
 */
+ (void)makeCall:(NSString *)phoneNumber;

/**
 *  发短信
 *
 *  @param phoneNumber 电话号码
 */
+ (void)sendSms:(NSString *)phoneNumber;

/**
 *  发邮件
 *
 *  @param emailAddress 邮箱
 *  @param cc      抄送
 *  @param subject 主题
 *  @param body    内容
 */
+ (void)sendEmail:(NSString *)emailAddress cc:(NSString*)cc subject:(NSString*)subject body:(NSString*)body;

/**
 *  访问网页
 *
 *  @param url 网址
 */
+(void)openUrl:(NSString *) url;

#pragma mark - 动画方法-
/**
 *  页面之间的推送动画
 *
 *  @param push    yes push  no pop
 *  @param ctl     需要显示的controller
 *  @param navCtl  navigationController
 *  @param number1 动画类型 e.g. push movein fade
 *  @param number2 动画类型 e.g. left top
 *  @param time    动画时间
 */
+ (void) push:(BOOL)push viewController:(UIViewController *)ctl withNavigationCotroller:(UINavigationController *)navCtl animationType:(NSInteger)number1 subType:(NSInteger)number2 Duration:(CGFloat)time;

#pragma mark - 自定义控件-
/**
 *  自定义分享页面 （从下推出）
 *
 *  @param title 标题
 *  @param type  类型
 *  @param vc    controller
 *
 *  @return actionsheet实例
 */
+(UIActionSheet *) initWithTitle:(NSString *)title type:(NSString *)type sender:(UIViewController *)vc;

////创建假的navigationbar
//+(UIView *) createNavigationbar:(CGRect)frame title:(NSString *)title withLeftButton:(BOOL)left rightButton:(BOOL)right vc:(UIViewController *)vc;

/**
 *  快速创建UIView实例
 *
 *  @param rect frame
 *
 *  @return view实例
 */
+ (UIView*)createViewWithFrame:(CGRect)rect;

/**
 *  创建UIImageView实例
 *
 *  @param rect      frame
 *  @param imageName 图片名称
 *
 *  @return imageview实例
 */
+ (UIImageView*)createImageViewWithFrame:(CGRect)rect ImageName:(NSString*)imageName;

/**
 *  快速创建UILable实例
 *
 *  @param rect     frame
 *  @param text     内容
 *  @param fontSize 字体大小
 *  @param color    字体颜色
 *
 *  @return UILabel实例
 */
+ (UILabel *)createLabelWithFrame:(CGRect)rect Text:(NSString *)text FontSize:(CGFloat)fontSize textColor:(UIColor *)color;

/**
 *  创建UITextField实例
 *
 *  @param rect        frame
 *  @param placeHolder 占位符
 *
 *  @return UITextField实例
 */
+ (UITextField*)createTextFieldWithFrame:(CGRect)rect Placeholder:(NSString*)placeHolder;
/**
 *  创建UIButton实例
 *
 *  @param rect      frame
 *  @param imageName button背景图
 *  @param title     标题
 *  @param target    target
 *  @param action    方法
 *
 *  @return UIButton实例
 */
+ (UIButton*)createButtonWithFrame:(CGRect)rect ImageName:(NSString*)imageName Title:(NSString*)title Target:(id)target Action:(SEL)action;

/**
 *  解决textfield输入靠边问题
 *
 *  @param view textfield对象
 */
+ (void) textFieldAddLeftView:(UITextField *)view;

/**
 *  创建并返回一个带菊花的view
 *
 *  @param frame frame
 *  @param style activity style
 *
 *  @return Uiview实例
 */
+(UIView *) flowerWithFrame:(CGRect)frame style:(UIActivityIndicatorViewStyle)style;

#pragma mark - 时间方法-

//时间格式
#define DATEFORMAT_01              @"yyyy.MM.dd HH:mm:ss"
#define DATEFORMAT_02              @"yyyy.MM.dd HH:mm"
#define DATEFORMAT_03              @"yyyy.MM.dd"
#define DATEFORMAT_04              @"yyyy.MM"
#define DATEFORMAT_05              @"M月dd日 hh:mm"
#define DATEFORMAT_06              @"yyyy-MM-dd HH:mm:ss"
#define DATEFORMAT_07              @"yyyy-MM-dd HH:mm"
#define DATEFORMAT_08              @"yyyy-MM-dd"
#define DATEFORMAT_09              @"HH:mm"


/**
 *  格式化日期
 *
 *  @param timeStamp 时间戳 e.g. @“423233124234”
 *  @param format    格式 e.g. @“YYYY-MM-dd HH:mm:ss” 或使用 DATEFORMAT_01
 *
 *  @return 按格式返回的日期 e.g. @“2014-11-12 12：15”
 */
+(NSString *) dateFormater:(NSString *)timeStamp format:(NSString *)format;

/**
 *  格式化日期
 *
 *  @param date   NSDate对象
 *  @param format 格式 e.g. @“YYYY-MM-dd HH:mm:ss” 或使用 DATEFORMAT_01
 *
 *  @return 按格式返回的日期 e.g. @“2014-11-12 12：15”
 */
+(NSString *) date:(NSDate *)date format:(NSString *)format;

/**
 *  将YYYY-MM-dd HH:mm:ss的时间转化为时间戳
 *
 *  @param date   时间字符串 e.g. @“2014-11-13 11：13：05”
 *  @param format 与date对应的格式 e.g. @“YYYY-MM-dd HH:mm:ss” 或使用 DATEFORMAT_01
 *
 *  @return 返回时间戳 （自1970算起）
 */
+(NSTimeInterval) datetoTimeStamp:(NSString *) date format:(NSString *)format;

/**
 *  与现在时间比较
 *
 *  @param timeStamp 时间戳
 *
 *  @return NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
 */
+ (NSComparisonResult) dateCompareWithCurrentDate:(NSString *)timeStamp;

#pragma mark - 常用类处理 -
/**
 *  转化为字符串 （处理json NULL情况）
 *
 *  @param str object
 *
 *  @return 传入NULL ->@“” 或原字符串
 */
+ (NSString *) convertToString:(id)str;

+ (NSString *) convertToString:(NSString *)str withObject:(id)obj;

/**
 *  转化为数组 （处理json NULL情况）
 *
 *  @param array object
 *
 *  @return 传入NULL ->@【】或原数组
 */
+ (NSArray *) convertToArray:(id)array;

/**
 *  转化为字典 （处理json NULL情况）
 *
 *  @param dic object
 *
 *  @return 传入NULL->@{} 或原字典
 */
+ (NSDictionary *) convertToDictionary:(id)dic;

/**
 *  转化为Number（处理json NULL情况）
 *
 *  @param num object
 *
 *  @return 传入NULL ->@NO 或传入的原值
 */
+ (NSNumber *) convertToNumber:(id)num;

/**
 *  判断是否是字符串并且长度大于零
 *
 *  @param string
 *
 *  @return yes or no
 */
+ (BOOL) isKindOfNSStringClassAndLenthGreaterThanZero:(NSString *)string;
/**
 *  判断是否是数组并且数量大于零
 *
 *  @param array
 *
 *  @return yes or no
 */
+ (BOOL) isKindOfNSArrayClassAndCountGreaterThanZero:(NSArray *)array;
/**
 *  判断是否是字典并且数量大于零
 *
 *  @param dic
 *
 *  @return yes or no
 */
+ (BOOL) isKindOfNSDictionaryClassAndCountGreaterThanZero:(NSDictionary *)dic;
/**
 *  判断是否是字符串并且长度大于零,如果为no则弹出警告
 *
 *  @param string
 *  @param alert  弹窗信息
 *
 *  @return yes or no
 */
+ (BOOL) isKindOfNSStringClassAndLenthGreaterThanZero:(NSString *)string Alert:(NSString *)alert;



#pragma mark - 其他方法-
/**
 *  弹出警告框(只有确定按钮)
 *
 *  @param msg 警告框信息
 */
+ (void)alert:(NSString *)msg;
/**
 *  获得Document目录
 *
 *  @param string 文件名称 e.g. @“xxx.txt”
 *
 *  @return 文件地址    e.g. @“Application/24554233-2423423/Document/xxx.txt”
 */
+ (NSString *)getDocumentPath:(NSString *)string;
/**
 *  MOSH图片服务器缩略图
 *
 *  @param imageStr 图片Url
 *  @param width    改后的图片宽
 *  @param height   改后的图片高
 *
 *  @return 改后的图片的url
 */
+ (NSString *)thumbnailImageUrl:(NSString *)imageStr
                          width:(NSInteger)width
                         height:(NSInteger)height;

/**
 *  压缩图片(分享用，重绘思路)
 *
 *  @param image   需要压缩的图片
 *  @param newSize 新的大小
 *
 *  @return 压缩后的图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  获取文字高度
 *
 *  @param text     文字内容
 *  @param width    文本框宽度
 *  @param fontSize 字体大小
 *
 *  @return 适应的size
 */
+ (CGSize) getAdjustHeightOfContent:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;

#pragma mark - userInfo -

/**
 *  手机号码验证 MODIFIED BY HELENSONG
 *
 *  @param mobile 手机号
 *
 *  @return yes or no
 */
+(BOOL) isValidateMobile:(NSString *)mobile;
/**
 *  邮箱验证 MODIFIED BY HELENSONG
 *
 *  @param email 邮箱
 *
 *  @return yes or no
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 *  设置textField的return键
 *
 *  @param array
 */
+ (void) textFieldReturnKeyWithArray:(NSArray *)array;

/**
 *  保存用户信息
 *
 *  @param uid
 *  @param userName
 *  @param passWord
 *  @param phone
 *  @param email
 *  @param city
 *  @param gender
 *  @param image
 *  @param array
 */
+ (void) saveUserInfoWithUid:(NSString *)uid
                    userName:(NSString *)userName
                    passWord:(NSString *)passWord
                       phone:(NSString *)phone
                       email:(NSString *)email
                        city:(NSString *)city
                      gender:(NSString *)gender
                       image:(NSString *)image
                       group:(NSString *)group
                     binding:(NSArray *)array
                  permission:(NSArray *)pArray;

/**
 *  删除用户信息
 */
+ (void) deleteUserInfo;


/**
 *  从userDefault中取值
 *
 *  @param key
 *
 *  @return value
 */
+(NSString *) getObjectWithKey:(NSString *)key;
+ (void)saveObject:(id)obj withKey:(NSString *)key;

+ (void) saveUserDefaultWithDictionary:(NSDictionary *)dic;

/**
 *   连接失败读取缓存显示提示信息....提醒显示2秒后消失
 *
 *  @param message   显示的信息 只能显示简短的信息
 *  @param superView 显示信息的视图 如果为空则在window上显示
 */
+ (void) showAlertViewWithMessage:(NSString *)message superView:(UIView *)superView;

//加密用(DES方式)
//+ (NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

//新浪微博
//+ (SinaWeibo *)sinaweibo;

#pragma mark - UIKeyBoardNotification -
/**
 *  键盘显示 textfield升高
 *
 *  @param noti       通知 UIKeyboardDidShowNotification
 *  @param scrollView
 */
+ (void) keyBoardDidShow:(NSNotification *)noti scrollView:(UIScrollView *)scrollView;
/**
 *  键盘消失 textfield返回原位置
 *
 *  @param noti       通知 UIKeyboardWillHideNotification
 *  @param scrollView
 */
+ (void) keyBoardDidDisapper:(NSNotification *)noti scrollView:(UIScrollView *)scrollView;

#pragma mark - 动画方法-
/**
 *  动画消失
 *
 *  @param view
 *  @param hide
 */
+(void)HideViewWithAnimations:(UIView *)view Hide:(BOOL)hide;
/**
 *  动画移动
 *
 *  @param view
 *  @param rect
 *  @param duration
 *  @param sender
 */
+ (void)moveViewWithAnimations:(UIView *)view cgrect:(CGRect)rect Duration:(CGFloat)duration delegate:(id)sender;
/**
 *  动画添加controller
 *
 *  @param superViewCtl
 *  @param viewCtl
 *  @param time
 */
+ (void) add:(BOOL)add superViewController:(UIViewController *)superViewCtl viewController:(UIViewController *)viewCtl Duration:(CGFloat)time;



@end
