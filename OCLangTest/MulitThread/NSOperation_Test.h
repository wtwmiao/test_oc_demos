//
//  NSOperation_Test.h
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperation_Test : NSObject


-(void)startTestInvocation;

-(void) startTestBlock;

-(void) startWithNoNeedOperation;


@end

/* 定义 继承自 NSOperation的子类*/
@interface MyOperation : NSOperation





@end
