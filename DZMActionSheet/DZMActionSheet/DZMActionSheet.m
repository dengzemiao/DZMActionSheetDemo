//
//  DZMActionSheet.m
//  DZMActionSheet
//
//  Created by haspay on 15/11/9.
//  Copyright © 2015年 none. All rights reserved.
//

#define ASCustomBtnH [DZMActionSheet sizeWithCurrentSize:30]
#define ASSpace 5
#define ASScreenWidth [UIScreen mainScreen].bounds.size.width
#define ASScreenHeight [UIScreen mainScreen].bounds.size.height
#define ASCustomBtnSpaceH 1
#define ASAnimateShowDuration 0.2
#define ASAnimateHiddenDuration 0.2

#import <UIKit/UIKit.h>
#import "DZMActionSheet.h"

@interface DZMActionSheet()
@property (nonatomic,strong) UIWindow *myWindow;    // 创建window
@property (nonatomic,strong) UIButton *coverBtn;    // 背景按钮
@property (nonatomic,strong) UIView *topView;       // TopView
@property (nonatomic,strong) UIView *bottomView;    // bottomView
@end
@implementation DZMActionSheet
+ (DZMActionSheet *)actionSheet
{
    static DZMActionSheet *actionSheet = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        actionSheet = [[self alloc] init];
    });
    
    return actionSheet;
}

- (UIWindow *)myWindow{
    if (_myWindow == nil) {
        _myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _myWindow.backgroundColor = [UIColor clearColor];
        
        // 遮住状态栏的 假如不需要遮住去掉即可
        _myWindow.windowLevel = UIWindowLevelAlert;
        
        _myWindow.hidden = NO;
    }
    return _myWindow;
}

- (UIButton *)coverBtn
{
    if (_coverBtn == nil) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = [UIApplication sharedApplication].keyWindow.bounds;
        _coverBtn.backgroundColor = [UIColor clearColor];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchDown];
    }
    
    return _coverBtn;
}

/**
 *  显示一个类似系统的SPActionSheet (上下都可以放置多个按钮)
 *
 *  @param dict    字典 @{"title" : @(SPActionSheetTitleColorType),"title" : @(SPActionSheetTitleColorType)} 类似系统控件的 取消跟其他按钮是分开的 top为上面部分
 *  @param dict    字典 @{"title" : @(SPActionSheetTitleColorType),"title" : @(SPActionSheetTitleColorType)} 类似系统控件的 取消跟其他按钮是分开的 bottom为下面部分
 *  @param delegate delegate
 */
+ (void)actionSheetWithTopDicts:(NSArray *)topDicts bottomDicts:(NSArray *)bottomDicts delegate:(id<DZMActionSheetDelegate>)delegate
{
    DZMActionSheet *actionSheet = [DZMActionSheet actionSheet];
    
    [actionSheet showWindowWithTopDicts:topDicts bottomDicts:bottomDicts];
    
    actionSheet.delegate = delegate;
}

/**
 *  显示window
 */
- (void)showWindowWithTopDicts:(NSArray *)topDicts bottomDicts:(NSArray *)bottomDicts
{
    // 清理topView bottomView
    if (self.myWindow.subviews.count != 0) {
        for (UIView *view in self.myWindow.subviews) {
            [view removeFromSuperview];
        }
    }
    
    //创建一个遮盖的btn
    [self.myWindow addSubview:self.coverBtn];
    self.myWindow.hidden = NO;
    
    // 创建view
    int startTag = 0;
    self.topView = [self creatViewWithStartTag:0 dicts:topDicts];
    if (topDicts.count != 0) {startTag = (int)(topDicts.count);}
    self.bottomView = [self creatViewWithStartTag:startTag dicts:bottomDicts];
    
    // 最小Y
    CGFloat MinY = [UIScreen mainScreen].bounds.size.height;
    
    if (self.bottomView) {
        
        self.bottomView.userInteractionEnabled = NO;
        [self.myWindow addSubview:self.bottomView];
        CGFloat bottomViewH = ASCustomBtnH*bottomDicts.count + ASCustomBtnSpaceH * (bottomDicts.count - 1);
        CGFloat bottomViewY = MinY - bottomViewH - ASSpace;
        self.bottomView.frame = CGRectMake(ASSpace, ASScreenHeight, ASScreenWidth - 2*ASSpace, bottomViewH);
        [UIView animateWithDuration:ASAnimateShowDuration animations:^{
            self.bottomView.frame = CGRectMake(ASSpace, bottomViewY, ASScreenWidth - 2*ASSpace, bottomViewH);
        } completion:^(BOOL finished) {
            self.bottomView.userInteractionEnabled = YES;
        }];
        
        MinY = bottomViewY;
    }
    
    if (self.topView) {
        
        self.topView.userInteractionEnabled = NO;
        CGFloat topViewH = ASCustomBtnH*topDicts.count + ASCustomBtnSpaceH * (topDicts.count - 1);
        self.topView.frame = CGRectMake(ASSpace, ASScreenHeight, ASScreenWidth - 2*ASSpace, topViewH);
        [UIView animateWithDuration:ASAnimateShowDuration animations:^{
            self.topView.frame = CGRectMake(ASSpace, MinY - topViewH - ASSpace, ASScreenWidth - 2*ASSpace, topViewH);
        } completion:^(BOOL finished) {
            self.topView.userInteractionEnabled = YES;
        }];
        [self.myWindow addSubview:self.topView];
    }
}

/**
 *  通过SPActionSheetTitleColorType 获取颜色
 *
 *  @param titleColorType SPActionSheetTitleColorType
 *
 *  @return 对应的颜色
 */
- (UIColor *)colorWithTitleColorType:(ASActionSheetTitleColorType)titleColorType
{
    UIColor *titleColor;
    
    switch (titleColorType) {
        case ASActionSheetTitleColorTypeBlue:
            titleColor = [UIColor blueColor];
            break;
        case ASActionSheetTitleColorTypeRed:
            titleColor = [UIColor redColor];
            break;
        case ASActionSheetTitleColorTypeGray:
            titleColor = [UIColor grayColor];
            break;
        default:
            titleColor = [UIColor blueColor];
            break;
    }
    return titleColor;
}

/**
 *  返回一个显示着button的view
 *
 *  @param startTag 开始tag
 *  @dict  字典数组 @[@{"title" : @(SPActionSheetTitleColorType)}]
 *
 *  @return UIView
 */
- (UIView *)creatViewWithStartTag:(int)startTag dicts:(NSArray *)dicts
{
    // 没值则不要创建
    if (dicts.count == 0) return nil;
    
    // 创建View
    UIView *customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor clearColor];
    customView.layer.cornerRadius = 4;
    customView.layer.masksToBounds = YES;
    
    // 创建点击按钮
    for (int i = 0; i < dicts.count; i++) {
        
        NSDictionary *dict = dicts[i];
        UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        customBtn.backgroundColor = [UIColor whiteColor];
        customBtn.tag = i + startTag;
        customBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        customBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [customBtn setTitle:[dict allKeys][0] forState:UIControlStateNormal];
        NSNumber *titleColorType = [dict allValues][0];
        [customBtn setTitleColor:[self colorWithTitleColorType:[titleColorType intValue]] forState:UIControlStateNormal];
        // 灰色不能进行点击
        if ([titleColorType intValue] == ASActionSheetTitleColorTypeGray) {
            customBtn.enabled = NO;
        }
        [customView addSubview:customBtn];
        customBtn.frame = CGRectMake(0, i *(ASCustomBtnSpaceH+ASCustomBtnH), ASScreenWidth - 2*ASSpace, ASCustomBtnH);
        [customBtn addTarget:self action:@selector(clickCustomBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return customView;
}

- (void)clickCustomBtn:(UIButton *)customBtn
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:customBtn.tag];
    }
    
    [self coverBtnClick];
}

/**
 *  隐藏
 */
- (void)coverBtnClick
{
    if (self.bottomView) {
        
        self.bottomView.frame = CGRectMake(ASSpace, self.bottomView.frame.origin.y, ASScreenWidth - 2*ASSpace, self.bottomView.frame.size.height);
        [UIView animateWithDuration:ASAnimateShowDuration animations:^{
            self.bottomView.frame = CGRectMake(ASSpace, ASScreenHeight, ASScreenWidth - 2*ASSpace, self.bottomView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
    
    if (self.topView) {
        
        self.topView.frame = CGRectMake(ASSpace, self.topView.frame.origin.y, ASScreenWidth - 2*ASSpace, self.topView.frame.size.height);
        [UIView animateWithDuration:ASAnimateShowDuration animations:^{
            self.topView.frame = CGRectMake(ASSpace,ASScreenHeight, ASScreenWidth - 2*ASSpace, self.topView.frame.size.height);
        } completion:^(BOOL finished) {
        }];
    }
    
    [self performSelector:@selector(hiddenWindow) withObject:self afterDelay:ASAnimateShowDuration];
}

/**
 *  隐藏window
 */
- (void)hiddenWindow
{
    
    self.myWindow.hidden = YES;
}

/**
 *  返回适配好的size 只计算高度 (设计是iPhone5sd的尺寸设计)
 *
 *  @param currentSize 当前UI设计的size
 *
 *  @return 通过比例结算好的size
 */
+ (CGFloat)sizeWithCurrentSize:(CGFloat)currentSize
{
    return ASScreenHeight * (currentSize/568);
}

@end
