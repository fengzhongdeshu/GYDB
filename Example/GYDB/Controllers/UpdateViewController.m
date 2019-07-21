//
//  UpdateViewController.m
//  GYDB
//
//  Created by liuguoyan on 2019/7/17.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "UpdateViewController.h"
#import "GYUser.h"
#import "GYDBOprator.h"
@interface UpdateViewController ()

@property (nonatomic,strong) UITextField *idInuter;
@property (nonatomic,strong) UITextField *nameInuter;
@property (nonatomic,strong) UITextField *hobbyInuter;
@property (nonatomic,strong) UITextField *ageInuter;
@property (nonatomic,strong) UITextField *scoreInuter;

@property (nonatomic,strong) UIButton *button;

@end

@implementation UpdateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    int width = self.view.frame.size.width-20 ;
    self.idInuter = [self filedPlaceHolder:@"输入id" frame:CGRectMake(10, 40, width, 50)] ;
    self.idInuter.enabled = NO  ;
    self.nameInuter = [self filedPlaceHolder:@"输入姓名" frame:CGRectMake(10, 100, width, 50)] ;
    self.nameInuter.enabled = NO ;
    self.hobbyInuter = [self filedPlaceHolder:@"输入爱好" frame:CGRectMake(10, 160, width, 50)] ;
    self.ageInuter = [self filedPlaceHolder:@"输入年龄" frame:CGRectMake(10, 220, width, 50)] ;
    self.scoreInuter = [self filedPlaceHolder:@"输入分数" frame:CGRectMake(10, 280, width, 50)] ;
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(10, 360, width, 50)] ;
    [self.button setTitle:@"更新" forState:UIControlStateNormal] ;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted] ;
    [self.button setBackgroundColor:[UIColor blueColor]] ;
    [self.button addTarget:self action:@selector(onSaveButton) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:self.button] ;
    
    
    self.idInuter.text = [NSString stringWithFormat:@"%d",self.user._id] ;
    self.nameInuter.text = self.user.name ;
    self.hobbyInuter.text = self.user.hoppy ;
    self.ageInuter.text = [NSString stringWithFormat:@"%d",self.user.age] ;
    self.scoreInuter.text = [NSString stringWithFormat:@"%d",self.user.score] ;
    
}

-(void)onSaveButton
{
    
    GYDBOprator *oprator = [GYDBOprator opratorWithModel:[GYUser class]] ;
    [oprator updateColume:@"age" toValue:self.ageInuter.text] ;
    [oprator updateColume:@"score" toValue:self.scoreInuter.text] ;
    [oprator updateColume:@"hoppy" toValue:self.hobbyInuter.text] ;
    
    [oprator whereColume:@"_id" compare:@"=" value:[NSString stringWithFormat:@"%d",self.user._id]] ;
    BOOL bol =  [oprator update];
    
    if (bol) {
        [self.button setTitle:@"更新成功" forState:UIControlStateNormal] ;
    }else{
        [self.button setTitle:@"更新失败" forState:UIControlStateNormal] ;
    }
    
}


-(UITextField *)filedPlaceHolder:(NSString *)placeHolder frame:(CGRect)rect
{
    UITextField *f = [[UITextField alloc]initWithFrame:rect] ;
    f.textAlignment = NSTextAlignmentCenter ;
    f.layer.borderColor = [UIColor grayColor].CGColor ;
    f.layer.borderWidth = 0.5 ;
    f.placeholder = placeHolder ;
    [self.view addSubview:f] ;
    return f ;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
