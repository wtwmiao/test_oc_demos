//
//  UIButton+Hook.h
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Hook)

/* 分类 不可直接 添加属性  这里通过runtime 关联对象 来实现 属性添加 */
@property (assign) NSInteger clickCount;

@end
