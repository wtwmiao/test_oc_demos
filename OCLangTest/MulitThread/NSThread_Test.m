//
//  NSThread_Test.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/23.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import "NSThread_Test.h"

//http://www.jianshu.com/p/334bde6790be

/*
 
 线程通信
 // 指定在当前线程中操作;
 [self performSelector:@selector(threadRun)];
 [self performSelector:@selector(threadRun) withObject:nil];
 [self performSelector:@selector(threadRun) withObject:nil afterDelay:2.0];
 
 
 
 //指定到主线程
 [self performSelectorOnMainThread:@selector(threadRun) withObject:nil waitUntilDone:YES];
 
 //指定到子线程执行
 [self performSelector:@selector(threadRun) onThread:newThread withObject:nil waitUntilDone:YES]; //这里指定为某个线程
 [self performSelectorInBackground:@selector(threadRun) withObject:nil];//这里指定为后台线程
 
 线程同步:
 iOS实现线程加锁有NSLock和@synchronized两种方式
 */

@implementation NSThread_Test{
    
    NSThread  *_thread;
     NSThread  *_thread2;
    
    NSInteger _totalCount ;
}



//创建线程方式1
-(void) startTest{
    
    _totalCount = 20;
    _thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread_fun)  object:nil];
    [_thread start];
    
      _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread_fun) object:nil];
    [_thread2 start];
}

// 第二种方式创建线程,并且配置线程.
-(void)startTest_2{
    _totalCount = 20;
    _thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread_1)  object:nil];
    [_thread start];
    
    _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread_2) object:nil];
    [_thread2 start];
    
    [self performSelector:@selector(thread_fun) onThread:_thread withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(thread_fun) onThread:_thread2 withObject:nil waitUntilDone:NO];
    
}



-(void) thread_1{
    
    [NSThread currentThread].name = @"thread1";
    NSRunLoop  *runLoop = [NSRunLoop currentRunLoop];
    [runLoop runUntilDate:[NSDate date]];////一直运行

}
-(void) thread_2{
    [NSThread currentThread].name = @"thread2";
    NSRunLoop  *runLoop = [NSRunLoop currentRunLoop];
    [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]]; //自定义运行时间

}


-(void) endTest{
    
}




-(void) thread_fun{
    NSLog(@"enter thread  %@ class  = %@",[NSThread currentThread],NSStringFromClass([self class]));
    
    while (YES) {
        @synchronized (self) {
            if(_totalCount >0){
                _totalCount --;
                NSLog(@"cur cout = %ld",_totalCount);
                [NSThread sleepForTimeInterval:0.3];
            }else {
                
                if ([NSThread currentThread].isCancelled) {
                    break;
                }else {
                    [[NSThread currentThread] cancel];
                    CFRunLoopStop(CFRunLoopGetCurrent());
                }
                
                
                NSLog(@"exit thread = %@ name = %@",[NSThread currentThread] ,[[NSThread currentThread] name]);
            }
        }
    }

}


@end
