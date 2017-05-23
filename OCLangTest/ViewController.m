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
    [nstest startTest_2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
