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
    
//    // 1.RACSignal 先订阅 再发送 (主线程中执行)
//    self.RACSignalDome();
    
//    // 2.RACSubject 先订阅 再发送 (主线程中执行)
//    self.RACSubjectDome();
    
//    // 3.价值所在：先发送，再订阅 (不管怎么延时，订阅的 block 都可以接收到发送过的信号) (主线程中执行)
//    self.RACReplaySubjectDome();
 
//    // 4.RACTuple 元组使用例子 (异步执行 block 内容，开启新的线程)
//    self.NSArrayAndNSDictionaryRACTupleDome();
   
    // 5.RACMulticastConnectionDome 广播连接
    self.RACMulticastConnectionDome();
}




/**
    1、RACSignal : 先订阅 再发送（主线程中执行）
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
        
        NSLog(@"确定先后顺序");
        // 订阅
        // 当创建 signal 时的 subscriber 发出信号改变 [subscriber sendNext:@"中国人民"] 就会调用 下面的 订阅block , 当前最新版本与以往的不同，现在都是在主线程中执行 block
        
        [signal subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"订阅 block = %@ , thread = %@",x,[NSThread currentThread]);
            
        } error:^(NSError * _Nullable error) {
            
            NSLog(@"订阅错误 = %@,thread = %@",error,[NSThread currentThread]);
            
        } completed:^{
            
            NSLog(@"完成订阅 thread = %@",[NSThread currentThread]);
            
        }];

        
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"subscribeNext x = %@",x);
        }];
    };
}


/**
    2、RACSubject：先订阅 再发送 （主线程中执行）
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
    3、先发送 再订阅 （这个比较 实用 ，可以在不知道什么时候发送信号的情况下准确的接收到信号）（主线程中执行）
 */
-(void(^)(void))RACReplaySubjectDome
{
    return ^{
        
        // Capacity 事先预指订阅的个数，里面是动太数组
        RACReplaySubject * replaySubject = [RACReplaySubject replaySubjectWithCapacity:2];
        
        // 发送
        [replaySubject sendNext:@"RACReplaySubjectDome 先发送 1"];
        [replaySubject sendNext:@"RACReplaySubjectDome 先发送 2"];
        [replaySubject sendCompleted];
        
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


/**
    4、RACTuple ：将数组 或 字典等所有的内容可以用 元组 来列出（异步执行，开了新的线程）
 */
-(void(^)(void))NSArrayAndNSDictionaryRACTupleDome
{
    return ^{
        
        // 1.把值包装成 元组
        RACTuple * tuple = RACTuplePack(@"abc",@"def",@"ghj");
    
        NSLog(@"RACTuple 元组包装: pack = %@ ",tuple);
        
        
        // 2.NSDictionary 元组 , 将字典里面的每一对 keyValue 列举出来(开了一个新的线程，异步列举)
        NSDictionary * dicTuple = @{@"name":@"Jakey" , @"age":@18 , @"student":@(YES)};
        
        [dicTuple.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
           
            NSString * key = [(RACTuple *)x objectAtIndex:0];
            id         value = [(RACTuple *)x objectAtIndex:1];
            NSLog(@"NSDictionary 元组使用 = %@ , key = %@ , value = %@ , thread = %@",x,key,value,[NSThread currentThread]);
        }completed:^{
            NSLog(@"NSDictionary 元组使用 completed , thread = %@",[NSThread currentThread]);
        } ];
        
        
        // 3.NSArray 元组 ，将数组内的所有数据列举出来 （异步列举）
        NSArray * array = @[@"klr",@"nop",@"rst"];
        [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"NSArray 元组 x = %@ , thread = %@",x,[NSThread currentThread]);
        }error:^(NSError * _Nullable error) {
            NSLog(@"NSArray 元组 error = %@",error);
        } completed:^{
            NSLog(@"NSArray 元组 completed ,thread = %@",[NSThread currentThread]);
        }];
        
        
        // 4.异步列出 数组 或 字典 内容
        NSArray * mapArray = [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
            
            NSLog(@"value = %@ , thread = %@",value,[NSThread currentThread]);
            
            return [value stringByAppendingString:@" temp"];
        }] array] ;
        NSLog(@"===== %@", mapArray);
    };
}


/**
    5、RACMulticastConnection ：广播连接(将 RACSignal 转成 RACMulticastConnection , block 在 main 主线程执行)
 */
-(void(^)(void))RACMulticastConnectionDome
{
    return ^{
    
        // 不能解决 _view ( === self->_view , 这样就无法解决强引用的问题)
        // __weak typeof(self) weakSelf = self ;
        
        // 无论哪种用法都可以解决强引用问题
        @weakify(self);
        
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // @weakify(self) 配套使用
            @strongify(self);
            
            NSLog(@"connection createSignal , thread = %@",[NSThread currentThread]);
            
            [self loadDataFromNetwork:^(NSArray *dataArr) {
               
                NSLog(@"loadDataFromNetwork block dataArr = %@ , thread = %@",dataArr , [NSThread currentThread]);
                
                // 发送信号
                [subscriber sendNext:dataArr];
                [subscriber sendCompleted];
            }];
            
            return [RACDisposable disposableWithBlock:^{
               
                NSLog(@"connection disposableWithBlock ，thread = %@",[NSThread currentThread]);
            }];
        }];
        
//        // 直接订阅
//        [signal subscribeNext:^(id  _Nullable x) {
//           
//            NSLog(@"subscribeNext x = %@ , thread = %@",x,[NSThread currentThread]);
//            
//        }];
        
        
        // 将 signal 转化成 connection
        RACMulticastConnection * connection = [signal publish];
        
        // 订阅信号
        // RACSubject:RACSubscriber
        [connection.signal subscribeNext:^(id  _Nullable x) {
           
            NSLog(@"commection x = %@ , thread = %@",x,[NSThread currentThread]);
        }];
        [connection.signal subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"commection2 x = %@ , thread = %@",x,[NSThread currentThread]);
        }];
        
        // 连接
        // RACSubject 订阅 RACSignal
        [connection connect];
        
    };
}
// 网络数据加载方法
-(void)loadDataFromNetwork:(void(^)(NSArray * dataArr))resultBlock
{
    NSLog(@"loadDataFromNetwork selector thread = %@",[NSThread currentThread]);
    
    resultBlock(@[@"temp = 1" , @"temp = 2" , @"temp = 3"]);
}



@end
