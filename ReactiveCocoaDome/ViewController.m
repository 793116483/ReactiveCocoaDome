//
//  ViewController.m
//  ReactiveCocoaDome
//
//  Created by 瞿杰 on 2017/8/17.
//  Copyright © 2017年 yiniu. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>

@interface ViewController ()

@property (nonatomic , assign) NSInteger age ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    // 1.RACSignal 先订阅 再发送 (主线程中执行)
//    self.RACSignalDome();
    
//    // 2.RACSubject 先订阅 再发送 (主线程中执行)
//    self.RACSubjectDome();
    
//    // 3.价值所在：先发送，再订阅 (不管怎么延时，订阅的 block 都可以接收到发送过的信号) (主线程中执行)
//    self.RACReplaySubjectDome();
 
//    // 4.RACTuple 元组使用例子 (异步执行 block 内容，开启新的线程)
//    self.NSArrayAndNSDictionaryRACTupleDome();
   
//    // 5.RACMulticastConnectionDome 广播连接 (主线程中执行)
//    self.RACMulticastConnectionDome();
    
//    // 6. RACCommand：处理事件的操作.(主线程中执行)
//    self.RACCommandDome();
    
//    // 7. RAC NSObject 分类中 rac_liftSelector... 方法的使用（主线程中执行）
//    //    功能：等待一个或多个 RACSingal 发出信号完成后 ，就会调用指定的对象方法，把信号值传给指定的方法
//    self.rac_liftSelectorDome();
    
//    // 8. RAC 通知 的使用
//    self.RAC_Notification_Dome();
    
//    // 9. RAC UITextField 监听 text 变化(主线程)
//    self.RAC_UITextField_Dome();
    
//    // 10、RAC KVO 监听属性内容变化
//    self.RAC_KVO_Dome();
    
//    // 11、RACSignal 的 bind 绑定方法
//    self.RACSignalBind();
    
//    /** 
//     12、RACReplaySubject 的 then: 方法用法。
//         then 功能：可以使 RACSignal 及其子类的 对象有序接收信号
//    */
//    self.RACReplaySubjectThenUseDome();
    
    
//    // 13、合并两个及以上 RACSignal 或 RACSignal 的子类对象，用新创建的 RACSignal 对象接收多个 RACSignal 或 RACSignal 的子类对象 发出的信号
//    self.RACSignalMergeDome();
    
//    // 14、使用 zipWith: 对象方法 压缩两个及以上 RACSignal 或 RACSignal 的子类对象。注意：( 1.所有 的被压缩对象 一起发送信号 才能收到; 2.解析时需要一层一层的解析 )
//    self.RACSignalZipWithDome();
    
//    // 15、合并两个及以上 RACSignal 或 RACSignal 的子类对象，用新创建的 RACSignal 对象 同时接收多个 RACSignal 或 RACSignal 的子类对象 发出的信号 (任意一个 被合并的对象 发送的信号 都能收到)（注意：解析时需要一层一层的解析）
//    self.RACSignalCombineLatestWithDome();
    
//    // 16、RACSignal 的 map 拦截信号发出的信号和处理数据
//    self.RACSignalMapDome();
    
    // 17、信号中的信号，RACSignal 的 flattenMap 对象方法，用来接收信号对象value 和 信号对象value发出的信息
//    self.RACSignalFlattenMapDome();
    
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
        
//        // 解析元组
//        RACTupleUnpack(NSString * a , NSString * b , NSString * c) = tuple ;
        
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


/**
    6、RACCommand：处理事件的操作.(主线程中执行)
        (1) RACCommand : 内部必须返回 RACSignal
        (2) executionSignals : 信号外的信号
             (2.1) switchToLatest 最新发出来信号的 RACSignal 类型
             (2.2) 能过 (2.1)的诠释，那么只要用 switchToLatest subscribeNext: 订阅，就可以接收到发出来的信号
        (3) 下面是执行的顺序，用 (index)表示
        (4) execute:(id)input ; 该对象方法必须被调用(调用次数只有一次有效)才会执行一些相关操作，所有的 block 执行操作的 入口
 */
-(void(^)(void))RACCommandDome
{
    return ^{
    
        RACCommand * command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           // input 即是执行 execute:(id)input; 传进来的值   (3)
            NSLog(@"init RACCommand block 被执行 initWithSignalBlock input = %@ , thread = %@",input,[NSThread currentThread]);
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               // (6)
                NSLog(@"内部创建的信号block 被执行 createSignal , thread = %@",[NSThread currentThread]);
                
                // 发送信号
                [subscriber sendNext:@"create Signal for somthing %@"];
                [subscriber sendCompleted];
                
                return [RACDisposable disposableWithBlock:^{
                    // 当 [subscriber sendCompleted] 调用时就会执行释放功能的 block (8)
                    NSLog(@"内部信号被释放 disposableWithBlock , thread = %@",[NSThread currentThread]);
                }];
                
            }];
        }];
    
        // 订阅最新发出来信号的 signal (7)
        [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"执行最近的 signal , x = %@ , thread = %@",x,[NSThread currentThread]);
        }];

        // executionSignals 这里传的 x 值类型为 RACDynamicSignal 类型对象 (5)
        [command.executionSignals subscribeNext:^(id  _Nullable x) {
            
            NSLog(@"executionSignals subscribeNext x = %@ , thread = %@",x,[NSThread currentThread]);
        }];
        
        // 查看将要执行，每执行完一个步聚 都会调用一次查看哪个 signal block（即 第 x 个 block  ） 将被使用 (2)(4)(9)
        // signal 的 skip: 方法功能是跳过 skipCount 个 使用 block 的查看
        [[[command executing] skip:0] subscribeNext:^(NSNumber * _Nullable x) {
            NSLog(@"executing signal subscribeNext x = %@ , thread = %@",x,[NSThread currentThread]);
        }];

        
        // 只执行一次 (1)
        [command execute:@"execute"];
      
//        [command execute:@"execute"];

    };
}


/**
    7、NSObject 分类中 rac_liftSelector... 方法的使用(即等待成所有的 RACSignal 对象发送完信号再执行方法) (主程中执行)
 */
-(void(^)(void))rac_liftSelectorDome
{
    return ^{
    
        RACSignal * signalOne = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
           
            // 现在想发出信号了
            [subscriber sendNext:@"网络请求数据 1"];
            
            // 不需要释放操作
            return nil ;
        }];
        
        RACSignal * signalTwo = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 现在想发出信号了
            [subscriber sendNext:@"网络请求数据 2"];
            
            // 不需要释放操作
            return nil ;
        }];
        
        [self rac_liftSelector:@selector(updateUIWithSignalOneMessage:signalTwoMessage:) withSignalsFromArray:@[signalOne , signalTwo]];
    };
}
// 当据有数据都拿到手后更新UI , 传的数据就是 signalOne 和 signalTwo 发出来的信号数据 ，(所以当前设计的接收方法 也必需要有两个参数，发出的信号按顺序 传参)
// 假如当前对象方法只设计 传一个参数，那么就会导致崩溃
-(void)updateUIWithSignalOneMessage:(id)signalOneMessage signalTwoMessage:(id)signalTwoMessage
{
    NSLog(@"signalOneMessage = %@ , signalTwoMessage = %@ , thread = %@",signalOneMessage,signalTwoMessage,[NSThread currentThread]);
}


/**
   NSNotificationCenter : 使用了 RAC 把监听通知的方法改成了 block 形势
 */
-(void(^)(void))RAC_Notification_Dome
{
    return ^{
        
        // 监听通知
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"NSNotification 1 x = %@",x.userInfo);
        }];
        
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"NSNotification 2 x = %@",x.userInfo);
        }];
        
        // 发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    
    };
}


/**
    9、RAC UITextField 监听 text 变化 和 绑定 lable.text 永远等于 textField.text
 */
-(void(^)(void))RAC_UITextField_Dome
{
    @weakify(self);
    return ^{
        
        @strongify(self);
        
        // UITextField RAC使用
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
        textField.backgroundColor = [UIColor redColor];
        [self.view addSubview:textField];
      
        [[textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
            NSLog(@"text = %@ , textField.text = %@ , thread = %@",x,textField.text,[NSThread currentThread]);
        }];
        
        
        // 绑定 lable.text
        UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
        lable.backgroundColor = [UIColor greenColor];
        [self.view addSubview:lable];

        // 绑定 lable.text 永远等于 textField.text
        RAC(lable,text) = textField.rac_textSignal ;
        
        
    };
}


/**
    10、RAC KVO 监听属性内容变化
 */
-(void(^)(void))RAC_KVO_Dome
{
    return ^{
    
        [RACObserve(self, age) subscribeNext:^(id  _Nullable x) {
           
            NSLog(@"KVO 监听到 age 内容发生变化 ，变为 %@ , thread = %@",x,[NSThread currentThread]);
        }];
    };
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.age++ ;
}


/**
    11、RACSignal 的 bind 绑定方法
 */
-(void(^)(void))RACSignalBind
{
    return ^{
    
        UITextField * textField = [[UITextField alloc] init];
        
        // bind 里面的做法：
        // (1) 创建一个 RACSignal 对象做为 bind 方法的返值；
        // (2) 当我们拿到该返的 RACSignal 类对象 tempSignal 去进行订阅；
        // (3) 然后会执行创建 RACSignal 对象时的 block A ,并在里面执行 bindBlock 拿到 返回的 block (B返回值为 RACSignal 对象)；
        // (4) 再执行 block B 就拿到 RACReturnSignal 对象；
        // (5) RACReturnSignal 对象 进行订阅,然后在该订阅 block 里面拿到 value 值;
        // (6) tempSignal 的 subscriber 订阅者 发送信号值 value , 最后在外面 tempSignal 对象的订阅就接收到信息了。
        [[textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
           
            NSLog(@"bind block");
            
            return ^RACSignal * (id _Nullable value, BOOL *stop){
              
                NSLog(@"return block value = %@ can do somthing",value);
                
                return [RACReturnSignal return:value];
            };
            
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"signal subscribeNext x = %@",x);
        }];
    };
}


/**
    12、RACReplaySubject 的 then: 方法用法。
        then 功能：可以使 RACSignal 及其子类的 对象有序接收信号
 */
-(void(^)(void))RACReplaySubjectThenUseDome
{
    return ^{
    
        // 在这里尽量使用 RACReplaySubject 类 ，因为 RACReplaySubject 可以先发送信号，订阅代码可以放在之后写。
        // 如果 使用 RACSignal 或 RACSubject ，那么必须要等这些对象订阅完后，发送的信号才能接收的到
        RACReplaySubject * subjectA = [RACReplaySubject subject];

        // 这就是好处,先发送
        [subjectA sendNext:@"AA"];
        // 必须要调用这个方法才会来到 then 后的 block
        [subjectA sendCompleted];
        
        // 按指定的顺序接收到信号
        RACSignal * resultSiganl =
        
        [[[subjectA then:^RACSignal * _Nonnull{
            
            // 当 subjectA 发送信号完成后 才执行 当前的 block
            RACReplaySubject * subjectB = [RACReplaySubject subject];
            
            // 可以单独调用发送信号完成的方法就可以接着执行下一个 then 
            [subjectB sendCompleted];
            
            return subjectB ;
            
        }] then:^RACSignal * _Nonnull{
            
            // 当 subjectB 发送信号完成后 才执行 当前的 block
            RACReplaySubject * subjectC = [RACReplaySubject subject];
            
            // subjectC 发送信号
            [subjectC sendNext:@"CC"];
            
            return subjectC ;
            
        }] subscribeNext:^(id  _Nullable x) { // 这个就 "相当于" 订阅了 subjectC 对象(但真正的对象则不是 subjectC 对象) ，x = @"CC"
            NSLog(@"RACReplaySubject C x = %@",x);
        }];
        
    };
}


/**
    13、合并两个及以上 RACSignal 或 RACSignal 的子类对象，用新创建的 RACSignal 对象接收多个 RACSignal 或 RACSignal 的子类对象 发出的信号 (只要求其中任一的一个被合并对象发送信号就能收到)
 */
-(void(^)(void))RACSignalMergeDome
{
    return ^{
    
        RACReplaySubject * subjectA = [RACReplaySubject subject];
        RACReplaySubject * subjectB = [RACReplaySubject subject];
        RACReplaySubject * subjectC = [RACReplaySubject subject];

        // 三个对象发送信号（只需其中一个或多个发送信号时，合并的 信号对象 都可以在订阅的 block 接收到信息）
        [subjectB sendNext:@"BB"];
        [subjectA sendNext:@"AA"];
        [subjectC sendNext:@"CC"];
        
        // 合并两个信号对象变成一个接收信号对象 subjectD , subjectD 订阅 接收 subjectB 和 subjectA 发送的信号
        [[[subjectA merge:subjectB] merge:subjectC] subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
        
    };
}


/**
    14、压缩两个及以上 RACSignal 或 RACSignal 的子类对象，用新创建的 RACSignal 对象同时接收多个 RACSignal 或 RACSignal 的子类对象 发出的信号 (必须所有 的被压缩对象 一起发送信号 才能收到)（注意：解析时需要一层一层的解析）
 */
-(void(^)(void))RACSignalZipWithDome
{
    return ^{
        
        RACReplaySubject * subjectA = [RACReplaySubject subject];
        RACReplaySubject * subjectB = [RACReplaySubject subject];
        RACReplaySubject * subjectC = [RACReplaySubject subject];
        
        // 三个对象同时发送信号，缺一不可
        [subjectA sendNext:@"AA"];
        [subjectB sendNext:@"BB"];
        [subjectC sendNext:@"CC"];
        
        // 合并两个信号对象变成一个接收信号对象 subjectD , subjectD 订阅 接收 subjectB 和 subjectA 发送的信号
        // x 类型为 元组 RACTwoTuple 类型：解析使用
        [[[subjectA zipWith:subjectB] zipWith:subjectC] subscribeNext:^(id  _Nullable x) {
            
            // 注意：元组需要 一层一层 地解析
            RACTupleUnpack(RACTuple * AB , NSString * C) = x ;
            
            RACTupleUnpack(NSString * A , NSString * B) = AB ;
            
            NSLog(@"A = %@ , B = %@ , C = %@",A , B , C);
        }];
        
    };
}


/**
    15、合并两个及以上 RACSignal 或 RACSignal 的子类对象，用新创建的 RACSignal 对象 同时接收多个 RACSignal 或 RACSignal 的子类对象 发出的信号 (任意一个 被合并的对象 发送的信号 都能收到)（注意：解析时需要一层一层的解析）
 */
-(void(^)(void))RACSignalCombineLatestWithDome
{
    return ^{
        
        RACReplaySubject * subjectA = [RACReplaySubject subject];
        RACReplaySubject * subjectB = [RACReplaySubject subject];
        RACReplaySubject * subjectC = [RACReplaySubject subject];
        
        // 三个对象同时发送信号，缺一不可
        [subjectA sendNext:@"AA"];
        [subjectB sendNext:@"BB"];
        [subjectC sendNext:@"CC"];
        
        // 1.合并三个信号对象变成一个接收信号对象 subjectD , subjectD 订阅 接收 subjectB 和 subjectA 发送的信号
        // x 类型为 元组 RACTwoTuple 类型：解析使用
        [[[subjectA combineLatestWith:subjectB] combineLatestWith:subjectC] subscribeNext:^(id  _Nullable x) {
            
            // 注意：元组需要 一层一层 地解析
            RACTupleUnpack(RACTuple * AB , NSString * C) = x ;
            
            RACTupleUnpack(NSString * A , NSString * B) = AB ;
            
            NSLog(@"A = %@ , B = %@ , C = %@",A , B , C);
        }];
        
        
        // 2.也可以把那些信号传的参数聚合成一个值
        //   遵守 NSFastEnumeration 协议的类都可成为数组
        //   reduce block 参数可以自己根据信号设置
        [[RACSignal combineLatest:@[subjectB,subjectA,subjectC] reduce:^id (NSString * signalA,NSString * signalB,NSString * signalC){
            
            // 把这 三个中任意 一个发出的信号值 聚合成一个值 NSString 类型
            
            return [NSString stringWithFormat:@"A = %@ , B = %@ , C = %@",signalA , signalB , signalC];
            
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"聚合后三个值变成一个 NSString 类型的值： %@",x);
        }];
        
        
        // 3.也可以用聚合绑定做法
        UILabel * lable = [[UILabel alloc] init];
        
        RAC(lable , text) = [RACSignal combineLatest:@[subjectB,subjectA,subjectC] reduce:^id (NSString * signalA,NSString * signalB,NSString * signalC){
            
            // 把这 三个中任意 一个发出的信号值 聚合成一个值 NSString 类型
            
            return [NSString stringWithFormat:@"A = %@ , B = %@ , C = %@",signalA , signalB , signalC];
            
        }];
        
        NSLog(@"lable.text = %@",lable.text);
    };
}


/**
    16、RACSignal 的 map 拦截信号发出的信号和处理数据
 */
-(void(^)(void))RACSignalMapDome
{
    return ^{
    
        RACReplaySubject * signal = [RACReplaySubject subject];
        
        [[signal map:^id _Nullable(id  _Nullable value) {
            return [NSString stringWithFormat:@"%@ (拦截发出的信号，拼接个想要的东西)",value];
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"接收到处理后的信息 = %@",x);
        }];
        
        [signal sendNext:@"@(当前信号的信息)"];

    };
}


/**
    17、信号中的信号，RACSignal 的 flattenMap 对象方法，用来接收信号对象value 和 信号对象value发出的信息
 */
-(void(^)(void))RACSignalFlattenMapDome
{
    return ^{
    
        RACReplaySubject * signal = [RACReplaySubject subject];
        RACSubject * subject = [RACSubject subject];
        
        [[signal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
            
            // value 是信号对象 == subject
            
            return [value map:^id _Nullable(id  _Nullable value) {
                
                return [NSString stringWithFormat:@"(添加拦截信号处理信号) (%@)",value];
            }];
        }] subscribeNext:^(id  _Nullable x) {
            NSLog(@"接收到处理后的信息 = %@",x);
        }];
        
        [signal sendNext:subject];
        
        [subject sendNext:@" subject 发出信号了"];
    };
}

@end
