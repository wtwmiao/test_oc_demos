//
//  BlockTest.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/24.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import "BlockTest.h"

typedef int (^MultiBlock)(int ,int );

@implementation BlockTest{
    NSDictionary *_maxYDict;
    
    MultiBlock  _multiBlcok;
    
}


- (instancetype)init{
    self = [super init];
    if (self) {
        //_maxYDict = [[NSDictionary alloc]init];
        _maxYDict = @{@"a": @"1", @"b": @"2",@"o": @"0"};
        
        _multiBlcok = ^(int a,int b){
            return a *b *a *b;
        };
    }
    return self;
}

-(void) startTest
{
    MultiBlock block = ^(int a,int b ){
        return a *b;
    };
    
    int ret = block(3,4);
    
    
    NSLog(@"get return block = %d",ret);
    
    ret = _multiBlcok(3,4);
    NSLog(@"get return _multiBlcok = %d",ret);
    
}



-(void) startTestReturn{
    /*
     enumerateKeysAndObjectsUsingBlock 同步操作. 可以分步到多个核心并发执行.
     */
    __block NSString *maxColumn = @"0";
    
    [_maxYDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key: %@, value: %@", key, obj);
        
        if ([obj floatValue] > [_maxYDict[maxColumn] floatValue]) {
            maxColumn = key;
        }
    }];
    
    int ret = [_maxYDict[maxColumn] floatValue];
    NSLog(@"get startTestReturn block = %d",ret);
}
@end
