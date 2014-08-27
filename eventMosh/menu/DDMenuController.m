//
//  DDMenuController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 toaast. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "DDMenuController.h"
#import "GlobalConfig.h"
#import "LeftViewController.h"

#define kMenuFullWidth 320.0f
#define kMenuDisplayedWidth 250.0f
#define KMLeftLimit   120.0f
#define kMenuOverlayWidth (self.view.bounds.size.width - kMenuDisplayedWidth)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f


@interface DDMenuController (Internal)
- (void)showShadow:(BOOL)val;
@end

@implementation DDMenuController

@synthesize delegate, barButtonItemClass;

@synthesize leftViewController=_left;
@synthesize rightViewController=_right;
@synthesize rootViewController=_root;

@synthesize tap=_tap;
@synthesize pan=_pan;


- (id)initWithRootViewController:(UIViewController*)controller {
    if ((self = [self init])) {
        _root = controller;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.barButtonItemClass = [UIBarButtonItem class];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRootViewController:_root]; // reset root
    
//    初始化
    self.isShowRight = YES;
    self.isrotate = NO;
    [_tap setEnabled:NO];
    //注册横屏消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isrotate:) name:@"isrotate" object:nil];
    
}
//是否横屏
- (void) isrotate:(NSNotification *)noti
{
    NSNumber *num = noti.object;
    self.isrotate = [num boolValue];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    _tap = nil;
    _pan = nil;
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    
  
    if (![_pan isEnabled]) {
        return;
    }
    
    CGPoint offset = [gesture translationInView:self.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        beginPoint = _root.view.frame.origin.x;
        
        if (beginPoint == 0) {
            //判断左移还是右移
            self.ddMenuPanDirection = offset.x > 0 ? DDMenuPanDirectionLeft:DDMenuPanDirectionRight;

            [self showShadow:YES];
            
            if (self.ddMenuPanDirection == DDMenuPanDirectionLeft) {//向左滑动
                [self showLeftViewController];
            }
            else {//向右滑动
                [self showRightViewController];
            }
        }

    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
       
        if (beginPoint == 0) {
            if (self.ddMenuPanDirection == DDMenuPanDirectionLeft && offset.x < 0) { //先开始向左滑动后又转向右
                self.ddMenuPanDirection = DDMenuPanDirectionRight;
                [self showRightViewController];
            
            }
            else if (self.ddMenuPanDirection == DDMenuPanDirectionRight && offset.x > 0) { //先开始向右滑动后又转向左
                self.ddMenuPanDirection = DDMenuPanDirectionLeft;
                [self showLeftViewController];
            }
        }
        if ((self.ddMenuPanDirection == DDMenuPanDirectionLeft) || (self.ddMenuPanDirection == DDMenuPanDirectionRight && self.isShowRight))
            _root.view.frame = CGRectMake(offset.x + beginPoint, 0, SCREENWIDTH, SCREENHEIGHT - STATEHEIGHT);
            
            //控制左右view的透明度
            if (self.ddMenuPanDirection == DDMenuPanDirectionLeft) {
                self.leftViewController.alphaView.alpha = 1 -  _root.view.frame.origin.x/kMenuDisplayedWidth;
                self.leftViewController.alphaView.hidden = NO;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ) {

        if (_root.view.frame.origin.x > KMLeftLimit) {
            
            [GlobalConfig moveViewWithAnimations:_root.view cgrect:CGRectMake(kMenuDisplayedWidth, 0, SCREENWIDTH, SCREENHEIGHT - STATEHEIGHT)Duration:0.4 delegate:nil];
                [self allUserInteraction:NO insuperView:_root.view];
                [_tap setEnabled:YES];
                self.leftViewController.alphaView.alpha = 0;
                self.leftViewController.alphaView.hidden = YES;
        }
        else if (_root.view.frame.origin.x < - KMLeftLimit) {
            
            [GlobalConfig moveViewWithAnimations:_root.view cgrect:CGRectMake(- kMenuDisplayedWidth, 0, SCREENWIDTH, SCREENHEIGHT - STATEHEIGHT) Duration:0.4 delegate:nil];
                [self allUserInteraction:NO insuperView:_root.view];
                [_tap setEnabled:YES];
        }
        else {
            [GlobalConfig moveViewWithAnimations:_root.view cgrect:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT -STATEHEIGHT) Duration:0.4 delegate:nil];
                [self allUserInteraction:YES insuperView:_root.view];
                [_tap setEnabled:NO];
        }
    }
    

}

- (void) allUserInteraction:(BOOL)isOk insuperView:(UIView *)superView
{
    for (UIView *view in superView.subviews) {
        view.userInteractionEnabled = isOk;
    }
}


- (void)tap:(UITapGestureRecognizer*)gesture {
    
    [gesture setEnabled:NO];
    [self showRootController:YES];
    
}

- (void) showLeftViewController
{
    _menuFlags.showingLeftView = YES;
    self.rightViewController.view.hidden = YES;
    self.leftViewController.view.hidden = NO;
    [self.view insertSubview:self.leftViewController.view atIndex:0];
    self.leftViewController.alphaView.alpha = 0;
    self.leftViewController.alphaView.hidden = NO;
    [_tap setEnabled:YES];
}

- (void) showRightViewController
{
    _menuFlags.showingRightView = YES;
    self.rightViewController.view.hidden = NO;
    self.leftViewController.view.hidden = YES;
     [self.view insertSubview:self.rightViewController.view atIndex:0];
     [_tap setEnabled:YES];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // Check for horizontal pan gesture
    if (gestureRecognizer == _pan) {

        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];

        if ([panGesture velocityInView:self.view].x < 600 && sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1) {
            return YES;
        } 
        
        return NO;
    }
    
    if (gestureRecognizer == _tap) {
        
        if (_root && (_menuFlags.showingRightView || _menuFlags.showingLeftView)) {
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        
        return NO;
        
    }

    return YES;
   
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer==_tap) {
        return YES;
    }     
    return NO;
}


#pragma Internal Nav Handling 

- (void)showShadow:(BOOL)val {
    if (!_root) return;
    
    _root.view.layer.shadowOpacity = val ? 0.8f : 0.0f;
    if (val) {
        _root.view.layer.cornerRadius = 4.0f;
        _root.view.layer.shadowOffset = CGSizeZero;
        _root.view.layer.shadowRadius = 4.0f;
        _root.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    
}

- (void)showRootController:(BOOL)animated {
    
    _root.view.userInteractionEnabled = YES;

    CGRect frame = _root.view.frame;
    frame.origin.x = 0.0f;

    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        
        _root.view.frame = frame;
        
    } completion:^(BOOL finished) {
        
        if (_left && _left.view.superview) {
            [_left.view removeFromSuperview];
        }
        
        if (_right && _right.view.superview) {
            [_right.view removeFromSuperview];
        }
        
        _menuFlags.showingLeftView = NO;
        _menuFlags.showingRightView = NO;

        [self showShadow:NO];
        
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
     [self allUserInteraction:YES insuperView:_root.view];
    [_tap setEnabled:NO];
}

- (void)showLeftController:(BOOL)animated {
    if (!_menuFlags.canShowLeft) return;
    
    if (_right && _right.view.superview) {
        [_right.view removeFromSuperview];
        _menuFlags.showingRightView = NO;
    }
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.leftViewController];
    }
    _menuFlags.showingLeftView = YES;
    [self showShadow:YES];

    UIView *view = self.leftViewController.view;
	CGRect frame = self.view.bounds;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    [self.leftViewController viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kMenuFullWidth - kMenuDisplayedWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
    self.leftViewController.view.hidden = NO;
    self.leftViewController.alphaView.hidden = YES;
    self.rightViewController.view.hidden = YES;
     [self allUserInteraction:NO insuperView:_root.view];
    [_tap setEnabled:YES];
    
}

- (void)showRightController:(BOOL)animated {
    if (!_menuFlags.canShowRight) return;
    
    if (_left && _left.view.superview) {
        [_left.view removeFromSuperview];
        _menuFlags.showingLeftView = NO;
    }
    
    if (_menuFlags.respondsToWillShowViewController) {
        [self.delegate menuController:self willShowViewController:self.rightViewController];
    }
    _menuFlags.showingRightView = YES;
    [self showShadow:YES];

    UIView *view = self.rightViewController.view;
    CGRect frame = self.view.bounds;
	frame.origin.x += frame.size.width - kMenuFullWidth;
	frame.size.width = kMenuFullWidth;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    frame = _root.view.frame;
    frame.origin.x = -(frame.size.width - kMenuOverlayWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = YES;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
    self.leftViewController.view.hidden = YES;
    self.rightViewController.view.hidden = NO;
    [self allUserInteraction:NO insuperView:_root.view];
    [_tap setEnabled:YES];

}


#pragma mark Setters

- (void)setDelegate:(id<DDMenuControllerDelegate>)val {
    delegate = val;
    _menuFlags.respondsToWillShowViewController = [(id)self.delegate respondsToSelector:@selector(menuController:willShowViewController:)];    
}

- (void)setRightViewController:(UIViewController *)rightController {
    _right = rightController;
    _menuFlags.canShowRight = (_right!=nil);
}

- (void)setLeftViewController:(LeftViewController *)leftController {
    _left = leftController;
    _menuFlags.canShowLeft = (_left!=nil);
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    UIViewController *tempRoot = _root;
    for (UIGestureRecognizer *ges in [_root.view gestureRecognizers]) {
        if ([ges isKindOfClass:[UITapGestureRecognizer class]])
            [_root.view removeGestureRecognizer:ges];

    }
    _root = rootViewController;
    
    if (_root) {
        
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
       
        
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];

        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = (id<UIGestureRecognizerDelegate>)self;
        [view addGestureRecognizer:pan];
        _pan = pan;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [view addGestureRecognizer:tap];
        [tap setEnabled:YES];
        _tap = tap;

        
    } else {
        
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        
    }
    
    [self allUserInteraction:YES insuperView:_root.view];
    [_tap setEnabled:NO];
}

- (void)setRootController:(UIViewController *)controller animated:(BOOL)animated {
   
    if (!controller) {
        [self setRootViewController:controller];
        [_tap setEnabled:NO];
        return;
    }
    
    if (_menuFlags.showingLeftView) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        // slide out then come back with the new root
        __block DDMenuController *selfRef = self;
        __block UIViewController *rootRef = _root;
        CGRect frame = rootRef.view.frame;
//        frame.origin.x = SCREENWIDTH;
//        
//        [UIView animateWithDuration:.1 animations:^{
//            
//            rootRef.view.frame = frame;
//            
//        } completion:^(BOOL finished) {
//            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

            [selfRef setRootViewController:controller];
            _root.view.frame = frame;
            [selfRef showRootController:animated];
            [_tap setEnabled:NO];
        
//        }];
        
    } else {
        
        // just add the root and move to it if it's not center
        [self setRootViewController:controller];
        [self showRootController:animated];
        [_tap setEnabled:NO];
    }
}


#pragma mark - Root Controller Navigation

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    NSAssert((_root!=nil), @"no root controller set");
    
    UINavigationController *navController = nil;
    
    if ([_root isKindOfClass:[UINavigationController class]]) {
    
        navController = (UINavigationController*)_root;
    
    } else if ([_root isKindOfClass:[UITabBarController class]]) {
        
        UIViewController *topController = [(UITabBarController*)_root selectedViewController];
        if ([topController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*)topController;
        }
        
    } 
    
    if (navController == nil) {
       
        NSLog(@"root controller is not a navigation controller.");
        return;
    }
    
   
    if (_menuFlags.showingRightView) {
        
        // if we're showing the right it works a bit different, we'll make a screen shot of the menu overlay, then push, and move everything over
        __block CALayer *layer = [CALayer layer];
        CGRect layerFrame = self.view.bounds;
        layer.frame = layerFrame;
        
        UIGraphicsBeginImageContextWithOptions(layerFrame.size, YES, 0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        layer.contents = (id)image.CGImage;
        
        [self.view.layer addSublayer:layer];
        [navController pushViewController:viewController animated:NO];
        CGRect frame = _root.view.frame;
        frame.origin.x = frame.size.width;
        _root.view.frame = frame;
        frame.origin.x = 0.0f;
        
        CGAffineTransform currentTransform = self.view.transform;
        
        [UIView animateWithDuration:0.25f animations:^{
            
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
                
                  self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(0, -[[UIScreen mainScreen] applicationFrame].size.height));
                
            } else {
                
                  self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(-[[UIScreen mainScreen] applicationFrame].size.width, 0));
            }
          
            
        } completion:^(BOOL finished) {
            
            [self showRootController:NO];
            self.view.transform = CGAffineTransformConcat(currentTransform, CGAffineTransformMakeTranslation(0.0f, 0.0f));
            [layer removeFromSuperlayer];
            
        }];
        
    } else {
        
        [navController pushViewController:viewController animated:animated];
        
    }
    
}


#pragma mark - Actions 

- (void)showLeft:(id)sender {
    
    [self showLeftController:YES];
    
}

- (void)showRight:(id)sender {
    
    [self showRightController:YES];
    
}

- (void) gestureSetEnable:(BOOL) enable isShowRight:(BOOL)isShow
{
//    [_tap setEnabled:enable];
    [_pan setEnabled:enable];
    self.isShowRight = isShow;
}

//旋转
- (BOOL) shouldAutorotate
{
    return self.isrotate;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"willRotateToLandScape" object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"willRotateToPortrait" object:nil];
    }
}

@end
