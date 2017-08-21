//
//  ViewController.m
//  ReactiveCocoaDome
//
//  Created by 瞿杰 on 2017/8/17.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"信号 block");

        return [RACDisposable disposableWithBlock:^{
            NSLog(@"disposableWithBlock");
        }];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"订阅 block = %@",x);
        
    } error:^(NSError * _Nullable error) {
        
        NSLog(@"订阅错误 = %@",error);
        
    } completed:^{
        
        NSLog(@"完成订阅");
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
