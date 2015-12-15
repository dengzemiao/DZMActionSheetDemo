//
//  ViewController.m
//  DZMActionSheet
//
//  Created by haspay on 15/11/9.
//  Copyright © 2015年 none. All rights reserved.
//

#import "ViewController.h"
#import "DZMActionSheet.h"
@interface ViewController ()<DZMActionSheetDelegate>
- (IBAction)click:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor redColor];
}

#pragma mark - DZMActionSheetDelegate
- (void)actionSheet:(DZMActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
}

- (IBAction)click:(id)sender {
    
    
    /**
     *  颜色可以随意改动的 我只是示范个例子 有这些使用 (上下都可以放置多个按钮)
     */
    [DZMActionSheet actionSheetWithTopDicts:@[@{@"提示语句":@(ASActionSheetTitleColorTypeGray)},@{@"确定":@(ASActionSheetTitleColorTypeRed)}] bottomDicts:@[@{@"取消":@(ASActionSheetTitleColorTypeBlue)}] delegate:self];
}
@end
