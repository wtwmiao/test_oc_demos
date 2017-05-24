//
//  NSOperation_Test.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import "NSOperation_Test.h"

//http://www.jianshu.com/p/4b1d77054b35
//NSOperation是对GCD的封装.

@implementation NSOperation_Test

// 同步执行.
-(void)startTestInvocation{
    
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    [op start];
    NSLog(@" NSInvocationOperation after call [op start]" );
}


-(void) startTestBlock{
    
    NSBlockOperation  *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@" NSBlockOperation run thread = %@,main thread = %@",[NSThread currentThread], [NSThread mainThread] );
    }];
    
    [op start];
    NSLog(@" NSInvocationOperation after call [op start]" );
}

/*
 但是，NSBlockOperation还提供了一个方法addExecutionBlock:，通过addExecutionBlock:就可以为NSBlockOperation添加额外的操作，这些额外的操作就会在其他线程并发执行。
 */
-(void)startTestBlockWithAddExecute{
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        // 在主线程
        NSLog(@"1------%@", [NSThread currentThread]);
    }];
    
    // 添加额外的任务(在子线程执行)
    [op addExecutionBlock:^{
        NSLog(@"2------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"3------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"4------%@", [NSThread currentThread]);
    }];
    
    [op start];
}


/*
 和GCD中的并发队列、串行队列略有不同的是：NSOperationQueue一共有两种队列：主队列、其他队列。其中其他队列同时包含了串行、并发功能。下边是主队列、其他队列的基本创建方法和特点
 */

-(void)startWithOperationQueue{
    //凡是添加到主队列中的任务（NSOperation），都会放到主线程中执行
    ///NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1-----%@", [NSThread currentThread]);
        }
    }];
    
    //串行并行 控制.
    // 设置最大并发操作数
    //    queue.maxConcurrentOperationCount = 2;
    queue.maxConcurrentOperationCount = 1; // 就变成了串行队列
    
    
    
    [op2 addDependency:op];    // 让op2 依赖于 op，则先执行OP，在执行op2
    
    
    [queue addOperation:op];
    [queue addOperation:op2];
    
}
//无需先创建任务，在block中添加任务，直接将任务block加入到队列中。
-(void) startWithNoNeedOperation{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1-----curthread = %@ main = %@ ", [NSThread currentThread],[NSThread mainThread]);
        }
    }];
    
}

-(void)run{
    
    NSLog(@" NSInvocationOperation run thread = %@,main thread = %@",[NSThread currentThread], [NSThread mainThread] );
    
}


/*
 - (void)cancel; NSOperation提供的方法，可取消单个操作
 - (void)cancelAllOperations; NSOperationQueue提供的方法，可以取消队列的所有操作
 - (void)setSuspended:(BOOL)b; 可设置任务的暂停和恢复，YES代表暂停队列，NO代表恢复队列
 - (BOOL)isSuspended; 判断暂停状态
 */

@end


/*
  how to use :
 MyOperation *op = [[MyOperation alloc]init];
 [op start];
 */
@implementation MyOperation

// nsoperation 执行体. 重写.
-(void)main{
    
    for(int i =0;i<4;i++){
        
        NSLog(@"myOperaton runnable thraed = %@",[NSThread currentThread]);
    }
    
}

@end
