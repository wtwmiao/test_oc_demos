//
//  UIButton+Hook.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import "UIButton+Hook.h"
#import <objc/runtime.h>

//http://www.jianshu.com/p/3efc3e94b14c
/*
 
 每个类都维护一个方法（Method）列表，Method则包含SEL和其对应IMP的信息，方法交换做的事情就是把SEL和IMP的对应关系断开，并和新的IMP生成对应关系。
 
 交换前：Asel－>AImp Bsel－>BImp
 交换后：Asel－>BImp Bsel－>AImp
 
 1、方法交换应该保证唯一性和原子性
 唯一性：应该尽可能在＋load方法中实现，这样可以保证方法一定会调用且不会出现异常。
 原子性：使用dispatch_once来执行方法交换，这样可以保证只运行一次。
 
 2、一定要调用原始实现
 由于iOS的内部实现对我们来说是不可见的，使用方法交换可能会导致其代码结构改变，而对系统产生其他影响，因此应该调用原始实现来保证内部操作的正常运行。
 
 3、方法名必须不能产生冲突
 这个是常识，避免跟其他库产生冲突。
 
 4、做好记录
 记录好被影响过的方法，不然时间长了或者其他人debug代码时候可能会对一些输出信息感到困惑。
 */
// afurlsessionManager.m

/*
 test code :
 UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 200)];
 btn.backgroundColor=[UIColor grayColor];
 [btn setTitle:@"hook" forState:UIControlStateNormal];
 [btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchDown]; // 先添加注册消息
 [self.view addSubview:btn];
 
 
 */

const char * clickCountKey = "clickCountKey";

static inline void af_swizzleSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@implementation UIButton (Hook)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_swizzleSelector([self class], @selector(sendAction:to:forEvent:), @selector(mySendAction:to:forEvent:));
     //   af_swizzleSelector([self class], @selector(suspend), @selector(af_suspend));
    });
}


-(void) mySendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event{
    NSLog(@"call sendAction");
    [self mySendAction:action to:target forEvent:event];
    [self addClickCount ];
}

-(void) addClickCount{
    
    NSInteger count = [self clickCount];
    count ++;
    [self setClickCount:count];
    
    NSLog(@"current click count = %ld",count);
}

- (void)setClickCount:(NSInteger)count {
    
    objc_setAssociatedObject(self, clickCountKey, @(count), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)clickCount {
    
    NSInteger count = (NSInteger)[objc_getAssociatedObject(self, clickCountKey) integerValue];
    
    return count;
}


@end
