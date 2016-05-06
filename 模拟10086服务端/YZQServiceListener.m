//
//  YZQServiceListener.m
//  模拟10086服务端
//
//  Created by Apple on 16/4/16.
//  Copyright © 2016年 YZQ. All rights reserved.
//

//  telnet 172.21.62.9 5288

#import "YZQServiceListener.h"
#import "GCDAsyncSocket.h"

@interface YZQServiceListener ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *serverSocket;

/*客户端的所有Socket*/
@property (nonatomic, strong) NSMutableArray *clientSocket;

@end

@implementation YZQServiceListener

- (NSMutableArray *)clientSocket{

    if (!_clientSocket) {
        _clientSocket = [NSMutableArray array];
    }
    return _clientSocket;
}

- (void)start{

    //开启10086服务 端口：5288
    
    //1、创建一个socket对象
    //服务端的Socket只监听有没有客户端请求连接
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    //2、绑定端口并监听
    NSError *error = nil;
    [serverSocket acceptOnPort:5288 error:&error];
    if (!error) {
        NSLog(@"开启成功");
    } else {
        //失败原因：端口被占用
        NSLog(@"开启失败");
    }
    
    self.serverSocket = serverSocket;
    
}

#pragma mark - 有客户端的socket连接到服务器
- (void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket{

    //sock --> 服务端的socket  newSocket --> 客户端的socket
    NSLog(@"sock = %@",serverSocket);
    NSLog(@"newSocket = %@",clientSocket);
    
    //1、保存客户端的socket
    [self.clientSocket addObject:clientSocket];
    
    
    //提供服务
    NSMutableString *serviceStr = [NSMutableString string];
    [serviceStr appendString:@"欢迎来到10086在线服务，请输入下面的数字选择服务\n"];
    [serviceStr appendString:@"[0]在线充值\n"];
    [serviceStr appendString:@"[1]在线投诉\n"];
    [serviceStr appendString:@"[2]优惠信息\n"];
    [serviceStr appendString:@"[3]人工服务\n"];
    [serviceStr appendString:@"[4]退出\n"];
    [clientSocket writeData:[serviceStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
    //2、监听客户端有没有数据上传
    //timeout -1 代表不超时
    //tag 标示作用 现在不用 就写 0
    [clientSocket readDataWithTimeout:-1 tag:0];
    
    
}
#pragma mark - 读取客户端请求的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    //1.把NSData转成NSString
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //2、字符串转数字
    NSInteger code = [str integerValue];
    NSString *responseStr = nil;
    switch (code) {
        case 0:
            responseStr = @"充值服务暂停。。。\n";
            break;
        case 1:
            responseStr = @"投诉服务暂停。。。\n";

            break;
        case 2:
            responseStr = @"优惠信息没有。。。\n";

            break;
        case 3:
            responseStr = @"服务暂停。。。\n";

            break;
        case 4:
            responseStr = @"退出成功\n";

            break;
            
        default:
            break;
    }
    
    NSLog(@"接收到数据:%@", str);
    
    //3.处理请求，返回数据给客户端
    [sock writeData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
#warning 每次读完数据后，都要调用一次监听数据的方法
    [sock readDataWithTimeout:-1 tag:0];
    
    if (code == 4) {
        [self.clientSocket removeObject:sock];
    }

}

#pragma mark - 读取客户端请求的数据
//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//    
//    //1.把NSData转成NSString
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"接收到数据:%@", str);
//    
//    //2.处理请求，返回数据给客户端
//    [sock writeData:data withTimeout:-1 tag:0];
//    
//#warning 每次读完数据后，都要调用一次监听数据的方法
//    [sock readDataWithTimeout:-1 tag:0];
//    
//}
@end
