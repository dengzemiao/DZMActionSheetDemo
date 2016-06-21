//
//  DZMActionSheet.h
//  DZMActionSheet
//
//  Created by haspay on 15/11/9.
//  Copyright © 2015年 none. All rights reserved.
//  邓泽淼


/**
 *  注意 ： 出现的速度可以在.M文件的宏定义里面修改 也可以去代码里面修改 如果需要添加新的颜色 只需要添加一个枚举即可 进入枚举判断下就好了 不需要别的操作。  如果需要修改文件名称(不需要修改文件名后面的就不用看了) 直接修改关于DZM 的就好了 其他的我都是使用AS  也就是ActionSheet 缩写使用 DZM我只有在delegate 跟文件名上使用了 还有就是.m 文件上面的一个类方法 是类名调用 也记得修改
 */

typedef void(^ASOperation)(NSInteger buttonIndex);

typedef enum{
    
    ASActionSheetTitleColorTypeBlue = 0,                // 蓝色
    ASActionSheetTitleColorTypeRed,                     // 红色
    ASActionSheetTitleColorTypeGray                     // 灰色(提示语句不能点击)
}ASActionSheetTitleColorType;

#import <Foundation/Foundation.h>

@class DZMActionSheet;

@protocol DZMActionSheetDelegate <NSObject>

- (void)actionSheet:(DZMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface DZMActionSheet : NSObject

/**
 *  代理回调
 */
@property (nonatomic,weak) id<DZMActionSheetDelegate> delegate;

/**
 *  回调block
 */
@property (nonatomic,copy) ASOperation operation;

/**
 *  返回 DZMActionSheet
 */
+ (DZMActionSheet *)actionSheet;

/**
 *  显示一个类似系统的ActionSheet (上下都可以放置多个按钮)
 *
 *  @param dicts    字典数组 @[@{"title" : @(SPActionSheetTitleColorType)}] 类似系统控件的 取消跟其他按钮是分开的 top为上面部分
 *  @param dicts    字典数组 @[@{"title" : @(SPActionSheetTitleColorType)}] 类似系统控件的 取消跟其他按钮是分开的 bottom为下面部分
 *  @param delegate delegate
 */
+ (void)actionSheetWithTopDicts:(NSArray *)topDicts bottomDicts:(NSArray *)bottomDicts delegate:(id<DZMActionSheetDelegate>)delegate;

/**
 *  显示一个类似系统的ActionSheet (上下都可以放置多个按钮)
 *
 *  @param dicts    字典数组 @[@{"title" : @(SPActionSheetTitleColorType)}] 类似系统控件的 取消跟其他按钮是分开的 top为上面部分
 *  @param dicts    字典数组 @[@{"title" : @(SPActionSheetTitleColorType)}] 类似系统控件的 取消跟其他按钮是分开的 bottom为下面部分
 *  @param operation 操作
 */
+ (void)actionSheetWithTopDicts:(NSArray *)topDicts bottomDicts:(NSArray *)bottomDicts operation:(ASOperation)operation;
@end
