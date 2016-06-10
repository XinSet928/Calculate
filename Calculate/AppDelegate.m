//
//  AppDelegate.m
//  Calculate
//
//  Created by ZhouRX on 16/4/14.
//  Copyright © 2016年 ZhouRX. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (){
    NSMutableString *_mutString;
    //保存输入的字符串
    NSString *_strNum;
    //保存符号
    NSString *_strSign;
}

@property(nonatomic,strong)UILabel *label;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor blackColor];
    [_window makeKeyAndVisible];
    _window.rootViewController = [[UIViewController alloc] init];
    //创建label
    [self createLabel];
    //创建计算器的按钮
    [self createButton];
    //初始化当前的字符串对象
    _mutString = [NSMutableString stringWithCapacity:20];
    //实例化
    _strNum = [[NSString alloc] init];
    //同上
    _strSign = [[NSString alloc] init];
  
    return YES;
}

-(void)createLabel{
    //创建label
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 267)];
    _label.backgroundColor = [UIColor blackColor];
    _label.text = @"0";
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:68];
    _label.textAlignment = NSTextAlignmentRight;
    [_window addSubview:_label];
}

-(void)createButton{
    //将titel放入数组，以便循环实现
    NSArray *titles = [NSArray arrayWithObjects:@"C",@"+/-",@"%",@"÷",
                                                @"7",@"8",@"9",@"x",
                                                @"4",@"5",@"6",@"-",
                                                @"1",@"2",@"3",@"+",
                                                @"0",@" ",@".",@"=",nil];
    //点击实现
    SEL click[20] = {@selector(clear),@selector(siging),@selector(mod),@selector(sign:),
        @selector(number:),@selector(number:),@selector(number:),@selector(sign:),
        @selector(number:),@selector(number:),@selector(number:),@selector(sign:),
        @selector(number:),@selector(number:),@selector(number:),@selector(sign:),
                     @selector(zero),@selector(number:),@selector(point),@selector(equal)};
    
  
    for (int i=0; i<5; i++) { //行
        for (int j=0; j<4; j++) { //列
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0+94.75*j, 267+80*i, 93.75, 79)];
            if (i*4+j==16) {
                [button setFrame:CGRectMake(0+94.75*j, 267+80*i, 188, 79)];
            }if (i*4+j==17) {
                [button setFrame:CGRectMake(0+94.75*j, 267+80*i, 0, 0)];
            }
            
            //设置不同的背景颜色
            if (i==0) {
                button.backgroundColor = [UIColor lightGrayColor];
            }else{
                button.backgroundColor = [UIColor grayColor];
            }
            if ((i*4+j+1)%4==0) {
                button.backgroundColor = [UIColor purpleColor];
            }
            [button setTitle:titles[i*4+j]  forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:36];
            
            [button addTarget:self action:click[i*4+j] forControlEvents:UIControlEventTouchUpInside];
            
            [_window addSubview:button];
        }
    }
}


#pragma mark -clear(清除键)的实现
-(void)clear{
    //把label内容字符串的变量清除
    NSRange range = {0,_mutString.length};
    [_mutString deleteCharactersInRange:range];
    //让label显示0
    _label.text = @"0";
}

#pragma mark -siging(正负号)的实现
-(void)siging{
    
    //判断第一个字符是什么
    if ( [_mutString characterAtIndex:0]=='-') { //是负数
        NSRange range = {0,1};
        [_mutString replaceCharactersInRange:range withString:@""];
        _label.text = _mutString;
    }else{ //不是负数
        NSString *string = [NSString stringWithFormat:@"-%@",_mutString];
        [_mutString setString:string];
        _label.text = _mutString;
    }
}

#pragma mark -mod(百分号)的实现
-(void)mod{
    double dou = [_mutString doubleValue];
    dou = dou/100.0;
    [_mutString setString:[NSString stringWithFormat:@"%g",dou]];
    //显示
    _label.text = _mutString;
}

#pragma mark -number(数字键)的实现
-(void)number:(UIButton *)sender{
    //链接字符串,实现连续输入
    [_mutString appendString:sender.titleLabel.text];
    //在label中显示字符串
    _label.text = _mutString;
}

#pragma mark -sign(符号键)的实现
-(void)sign:(UIButton *)sender{
   //按符号时，保存之前的字符串
    _strNum = [_mutString copy];//拷贝前面的值,千万不要使用引用
    //清空
    [_mutString setString:@""];
    //符号
    _strSign = sender.titleLabel.text;
}

#pragma mark -sign(符号键)的实现
-(void)zero{
    //判断是不是第一次就单机“0”
    if (_mutString.length == 0) {
        return;
    }else{
        //链接字符串,实现连续输入
        [_mutString appendString:@"0"];
        //在label中显示字符串
        _label.text = _mutString;
    }
}

#pragma mark -point(小数点键)的实现
-(void)point{
    //是不是第一次点击小数点
    if (_mutString.length == 0) {
        [_mutString setString:@"0."];
        //显示
        _label.text = _mutString;
    }else {//可变字符串是不是已经含有“.”
        //判断
        NSRange range = [_mutString rangeOfString:@"."];
        
        if (range.location == NSNotFound) {
            [_mutString appendString:@"."];
            //显示
            _label.text = _mutString;
        }
    }
}

#pragma mark -equal(等号键)的实现
-(void)equal{
    //每个都有，所以提取出来
    double first = [_strNum doubleValue];
    double last = [_mutString doubleValue];
    double sum = 0.0;
    
    if ([_strSign isEqualToString:@"+"]) {
        sum = first + last;
    }
    else if ([_strSign isEqualToString:@"-"]){
        sum = first - last;
    }
    else if ([_strSign isEqualToString:@"x"]){
        sum = first * last;
    }
    else if([_strSign isEqualToString:@"÷"]){
        sum = first / last;
    }
    
    NSString *s = [NSString stringWithFormat:@"%g",sum];
    _label.text = s;
    [_mutString setString:@""];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
