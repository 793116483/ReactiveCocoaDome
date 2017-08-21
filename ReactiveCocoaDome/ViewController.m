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
    
//    // 1.RACSignal 先订阅 再发送
//    self.RACSignalDome();
    
//    // 2.RACSubject 先订阅 再发送
//    self.RACSubjectDome();
    
//    // 价值所在：先发送，再订阅 (不管怎么延时，订阅的 block 都可以接收到发送过的信号)
//    self.RACReplaySubjectDome();
 
    
}




/**
    1、RACSignal : 先订阅 再发送
 */
-(void (^)(void))RACSignalDome
{
    return ^{
        /*
         RACSignal : 只能订阅且只有一个订阅者，不能发送信号；在创建的时候会自动创建一个 RACSubscriber 类的对象subscriber，subscriber 可以发送信号信息；
         
         */
        
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSLog(@"信号 block , thread = %@",[NSThread currentThread]);
            
            // 发送信号
            [subscriber sendNext:@"RACSignalDome"];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"disposableWithBlock , thread = %@",[NSThread currentThread]);
            }];
        }];
        
        
        // 订阅
        // 当创建 signal 时的 subscriber 发出信号改变 [subscriber sendNext:@"中国人民"] 就会调用 下面的 订阅block , 当前最新版本与以往的不同，现在都是在主线程中执行 block
        
        [signal subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"订阅 block = %@ , thread = %@",x,[NSThread currentThread]);
            
        } error:^(NSError * _Nullable error) {
            
            NSLog(@"订阅错误 = %@,thread = %@",error,[NSThread currentThread]);
            
        } completed:^{
            
            NSLog(@"完成订阅 thread = %@",[NSThread currentThread]);
            
        }];

    };
}


/**
    2、RACSubject：先订阅 再发送
             价值：可以用在代理上，参数就可以可区分调用哪一块的代码
 */
-(void (^)(void))RACSubjectDome
{
    return ^{
    
        RACSubject * subject = [RACSubject subject];
        
        // 其中所有的 block 都在 main 主线程中执行
        // 订阅
        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"subscribeNext:x = %@ , thread = %@",x,[NSThread currentThread]);
        }];
        
        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"subscribeNext:x = %@ error completed , thread  = %@",x,[NSThread currentThread]);
        } error:^(NSError * _Nullable error) {
            NSLog(@"error = %@ , thread = %@",error,[NSThread currentThread]);
        } completed:^{
            NSLog(@"completed ! , thread = %@",[NSThread currentThread]);
        }];
        
        // 发送
        [subject sendNext:@"RACSubjectDome"];
        [subject sendCompleted];
    };
}


/**
    3、先发送 再订阅 （这个比较 实用 ，可以在不知道什么时候发送信号的情况下准确的接收到信号）
 */
-(void(^)(void))RACReplaySubjectDome
{
    return ^{
        
        // Capacity 事先预指订阅的个数，里面是动太数组
        RACReplaySubject * replaySubject = [RACReplaySubject replaySubjectWithCapacity:2];
        
        // 发送
        [replaySubject sendNext:@"RACReplaySubjectDome 先发送 1"];
        [replaySubject sendNext:@"RACReplaySubjectDome 先发送 2"];
        
        // 订阅
        [replaySubject subscribeNext:^(id  _Nullable x) {
            NSLog(@"subscribeNext:x = %@ error completed , thread  = %@",x,[NSThread currentThread]);
        } error:^(NSError * _Nullable error) {
            NSLog(@"error = %@ , thread = %@",error,[NSThread currentThread]);
        } completed:^{
            NSLog(@"completed ! , thread = %@",[NSThread currentThread]);
        }];
        
        // 延时订阅，一样可以接收到信号
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [replaySubject subscribeNext:^(id  _Nullable x) {
               
                NSLog(@"subscribeNext: x = %@, thread = %@",x,[NSThread currentThread]);
            }];
        });
        
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
