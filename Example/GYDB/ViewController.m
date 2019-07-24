//
//  ViewController.m
//  GYDB
//
//  Created by liuguoyan on 2019/7/17.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "QueryViewController.h"


@interface ViewController ()
{
    NSArray *titles ;
    NSArray *cons ;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GYDB";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    titles =[NSArray arrayWithObjects:@"添加" , @"查询", nil] ;
    cons = [NSArray arrayWithObjects:[AddViewController class],[QueryViewController class], nil];
    
    int top = 40 ;
    for (int i = 0 ; i<2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, top + i*50 + i*15, self.view.frame.size.width - 20, 50)] ;
        [button setTitle:titles[i] forState:UIControlStateNormal] ;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted] ;
        button.tag = i ;
        [button setBackgroundColor:[UIColor blueColor]] ;
        [self.view addSubview:button] ;
        
        [button addTarget:self action:@selector(startViewController:) forControlEvents:UIControlEventTouchUpInside] ;
        
    }
    
    
    NSLog(@"%%%@%%",@"liu");
    
}

-(void)startViewController:(UIControl *)sender
{
    NSInteger tag = sender.tag ;
    UIViewController *controller = [[cons[tag] alloc]init] ;
    controller.view.backgroundColor = [UIColor whiteColor];
    controller.navigationItem.title = titles[tag] ;
    [self.navigationController pushViewController:controller animated:YES] ;
}


@end
