//
//  ViewController.m
//  OCLangTest
//
//  Created by huiti123 on 2017/5/23.
//  Copyright © 2017年 wtw. All rights reserved.
//

#import "ViewController.h"
#import "Pthread.h"
#import "NSThread_Test.h"
#import "BlockTest.h"
#import "UIButton+Hook.h"
#import "NSOperation_Test.h"
#import "GCDTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    Phtread *pth  =[[Phtread alloc]init];
//    [pth startThread];
//    [pth endThread];
    
   NSThread_Test *nstest = [NSThread_Test new];
//   [nstest startTest_block];
    
    BlockTest  *bTest = [[BlockTest alloc ]init];
   // [bTest startTest];
//    
//    UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 100, 200)];
//    btn.backgroundColor=[UIColor grayColor];
//    [btn setTitle:@"hook" forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:btn];
    
    //NSOperation_Test *opTest  = [[NSOperation_Test alloc]init];
 //   [opTest startWithNoNeedOperation];
    
    GCDTest  *gcdTest  = [[GCDTest alloc]init];
    [gcdTest testDispathGroup];
    
}

-(void)onClick{
    NSLog(@" clicked");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
