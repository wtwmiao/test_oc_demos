//
//  GCDTest.h
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTest : NSObject

-(void)testConcurrentMainQueue;
-(void)testConcurrentUseDefQueue;


-(void) testRunBarrier;
-(void)testDispathGroup;
@end
