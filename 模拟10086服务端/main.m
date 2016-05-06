//
//  main.m
//  模拟10086服务端
//
//  Created by Apple on 16/4/16.
//  Copyright © 2016年 YZQ. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YZQServiceListener.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        //创建一个服务监听对象
        YZQServiceListener *listener = [[YZQServiceListener alloc] init];
        
        //开启监听
        [listener start];
        
        //开启户运行循环，让服务不能停
        [[NSRunLoop mainRunLoop] run];
        
    }
    return 0;
}
