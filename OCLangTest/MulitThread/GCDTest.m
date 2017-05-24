//
//  GCDTest.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import "GCDTest.h"

//http://www.jianshu.com/p/2d57c72016c6
//Grand Central Dispatch (GCD)
/*
 为什么要用GCD呢？
 
 因为GCD有很多好处啊，具体如下：
 
 GCD可用于多核的并行运算
 GCD会自动利用更多的CPU内核（比如双核、四核）
 GCD会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
 程序员只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码
 
*/

/*
 GCD中任务是放在 block中.(NSOperation -> selector 和 block)
 任务：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在GCD中是放在block中的
 队列: 特殊的线性表，采用FIFO（先进先出）的原则 ,串行队列和并发队列。
 并发功能只有在异步（dispatch_async）函数下才有效
 
 使用:
 创建一个队列（串行队列或并发队列）
 将任务添加到队列中，然后系统就会根据任务类型执行任务（同步执行或异步执行）
 */
@implementation GCDTest


/* 并发 交替执行.*/
-(void)testConcurrentUseDefQueue{
    dispatch_queue_t queue  = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"start async task thread = %@ main thread = %@",[NSThread currentThread],[NSThread mainThread]);
    });
    
    dispatch_sync(queue, ^{
           NSLog(@"start sync task thread = %@ main thread = %@",[NSThread currentThread],[NSThread mainThread]);
    });
}

-(void)testConcurrentMainQueue{
    //还可以使用全局并发 队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSLog(@"start async task thread = %@ main thread = %@",[NSThread currentThread],[NSThread mainThread]);
    });
    
    //是在主线程中运行主队列，当把主队列中得任务放到主线程时，会和dispatch_sync进行线程争夺。这时就会产生线程死锁
    //dispatch_sync(queue, ^{
    //    NSLog(@"start sync task thread = %@ main thread = %@",[NSThread currentThread],[NSThread mainThread]);
    //});
}


/* 非并发 顺序执行.*/
-(void)testSerialUseDefQueue{
    dispatch_queue_t queue  = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"start async task thread = %@ main thread = %@",[NSThread currentThread],[NSThread mainThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"start sync task thread = %@ main thread = %@",[NSThread currentThread],[NSThread mainThread]);
    });
}

/*
 我们有时需要异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏
 */
-(void) testRunBarrier{

    dispatch_queue_t queue = dispatch_queue_create("12312312", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"----1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----3-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
    
}
/*
 有时候我们会有这样的需求：分别异步执行2个耗时操作，然后当2个耗时操作都执行完毕后再回到主线程执行操作。这时候我们可以用到GCD的队列组
 */

-(void)testDispathGroup{
    dispatch_group_t group  = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
         NSLog(@"----task 1 finish-----%@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
         NSLog(@"----task 2 finish-----%@", [NSThread currentThread]);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
         NSLog(@"----all task finish-----%@", [NSThread currentThread]);
    });
    
}
@end
