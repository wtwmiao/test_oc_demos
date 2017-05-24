//
//  Pthread.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/23.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>
#import "Pthread.h"



@implementation Phtread{
       pthread_t _thread;
       sigset_t set;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        sigemptyset(&set);
        sigaddset(&set, SIGUSR1);
        sigaddset(&set, SIGUSR2);
        sigprocmask(SIG_SETMASK, &set, NULL);
    }
    return self;
}

-(void) startThread{
 
    pthread_create(&_thread, NULL, thread_fun, NULL);

}

-(void) endThread
{
    
    pthread_kill(_thread, 0);
    void *status;
   int ret  =  pthread_join(_thread, &status);
    
    NSLog(@"end return = %d",ret);
}

void * thread_fun(void *param){
    

    NSLog(@"enter thread  %@",[NSThread currentThread]);
    
    return NULL;
}

@end
