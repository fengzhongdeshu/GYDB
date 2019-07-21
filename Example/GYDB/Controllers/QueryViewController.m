//
//  QueryViewController.m
//  GYDB
//
//  Created by liuguoyan on 2019/7/17.
//  Copyright © 2019年 hebtu. All rights reserved.
//

#import "QueryViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UpdateViewController.h"
#import "MyLinearLayout.h"
#import "GYDBOprator.h"
#import "GYUser.h"

@interface ConditionPacker : NSObject

@property (nonatomic,strong) UITextField *nameFiled;
@property (nonatomic,strong) UITextField *compFiled;
@property (nonatomic,strong) UITextField *valueFiled;
@property (nonatomic,strong) UITextField *logicFiled;
@property (nonatomic,strong) UIView *container;

@end
@implementation ConditionPacker
@end

@interface QueryViewController ()

@property (nonatomic,strong) UIButton *searchButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *editButton;

@property (nonatomic,strong) UIButton *delButton;

@property (nonatomic,strong) MyLinearLayout *layout;

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,strong) NSMutableArray<ConditionPacker *> *conditionPackers;

@property (nonatomic,strong) NSMutableArray<GYUser*> *results;

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)] ;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.delButton] ;
    [self.delButton setTitle:@"清除条件" forState:UIControlStateNormal] ;
    [self.delButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal] ;
    [self.delButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted] ;
    [self.delButton addTarget:self action:@selector(onClearAllConditions) forControlEvents:UIControlEventTouchUpInside] ;
    self.navigationItem.rightBarButtonItem = barItem ;
    
    
    TPKeyboardAvoidingScrollView *scView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
    [self.view addSubview:scView] ;
    
    self.layout = [[MyLinearLayout alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
    [scView addSubview:self.layout] ;
    
    [self addConditionView];
    [self addConditionView];
    [self addConditionView];
    
    
    UIView *actionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 50)] ;
    [self.layout addSubview:actionView] ;
    actionView.topPos.equalTo(@5) ;
    
    //查询
    self.searchButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 100, 50)] ;
    self.searchButton.backgroundColor = [UIColor blueColor] ;
    [self.searchButton setTitle:@"查询" forState:UIControlStateNormal] ;
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted] ;
    [actionView addSubview:self.searchButton] ;
    [self.searchButton addTarget:self action:@selector(onSearchButton) forControlEvents:UIControlEventTouchUpInside] ;
    
    //删除
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(120, 0, 100, 50)] ;
    self.deleteButton.backgroundColor = [UIColor redColor] ;
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal] ;
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted] ;
    [actionView addSubview:self.deleteButton] ;
    [self.deleteButton addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside] ;
    
    //编辑
    self.editButton = [[UIButton alloc]initWithFrame:CGRectMake(230, 0, 100, 50)] ;
    self.editButton.backgroundColor = [UIColor grayColor] ;
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal] ;
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    [self.editButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted] ;
    [actionView addSubview:self.editButton] ;
    [self.editButton addTarget:self action:@selector(onEditButton) forControlEvents:UIControlEventTouchUpInside] ;
    
    //查询结果
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 600)] ;
    self.textView.topPos.equalTo(@3);
    self.textView.backgroundColor = [UIColor whiteColor] ;
    [self.textView setTextColor:[UIColor blackColor] ] ;
    [self.layout addSubview:self.textView] ;
    
}

-(void)onClearAllConditions
{
    for (int i = 0 ; i<self.conditionPackers.count; i++) {
        self.conditionPackers[i].nameFiled.text = @"" ;
        self.conditionPackers[i].compFiled.text = @"" ;
        self.conditionPackers[i].valueFiled.text = @"" ;
        self.conditionPackers[i].logicFiled.text = @"" ;
        
    }
}


-(void)onEditButton
{
    if (self.results.count==0) {
        self.textView.text  = @"请先查询出要编辑的数据";
    }else{
        UpdateViewController *update = [[UpdateViewController alloc]init] ;
        update.title = @"编辑";
        update.user = [self.results firstObject] ;
        [self.navigationController pushViewController:update animated:YES] ;
    }
}

-(void)onSearchButton
{
    
    GYDBOprator *oprator = [GYDBOprator opratorWithModel:[GYUser class]] ;
    
    [self addWheres:oprator];
    
    NSArray *arr =  [oprator query] ;
    [self.results removeAllObjects] ;
    [self.results addObjectsFromArray:arr] ;
    
    NSMutableString *string = [NSMutableString string] ;
    
    if (arr && arr.count>0) {
        for (int i = 0 ; i<arr.count; i++) {
            [string appendString:[arr[i] description]] ;
            [string appendString:@"\n"] ;
        }
        [self.textView setText:string] ;
    }else{
        [self.textView setText:@"无内容"] ;
    }
    
}


-(void)addWheres:(GYDBOprator *)oprator
{
    for (int i = 0 ; i<self.conditionPackers.count; i++) {
        NSString *name = self.conditionPackers[i].nameFiled.text ;
        NSString *comp = self.conditionPackers[i].compFiled.text ;
        NSString *value = self.conditionPackers[i].valueFiled.text ;
        NSString *logic = self.conditionPackers[i].logicFiled.text ;
        
        if (i==0 && name && comp && value && name.length>0 && comp.length>0 && value.length>0) {
            [oprator whereColume:name compare:comp value:value] ;
        }
        
        if (i>0 && name && comp && value && name.length>0 && comp.length>0 && value.length>0&& logic && logic.length>0) {
            
            if ([logic isEqualToString:@"or"]) {
                [oprator orWhereColume:name compare:comp value:value];
            }
            if ([logic isEqualToString:@"and"]) {
                [oprator andWhereColume:name compare:comp value:value];
            }
        }
    }
}

-(void)addConditionView
{
    
    int wid = self.view.frame.size.width * 0.25;
    
    UIView *oneV =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)] ;
    [self.layout addSubview:oneV] ;
    oneV.topPos.equalTo(@5);
    
    UITextField *oneLogic = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, wid, 40)] ;
    oneLogic.placeholder = @"or,and";
    oneLogic.textAlignment = NSTextAlignmentCenter ;
    oneLogic.layer.borderColor = [UIColor blueColor].CGColor;
    oneLogic.layer.borderWidth = 0.5 ;
    [oneV addSubview:oneLogic] ;
    
    UITextField *oneFiled = [[UITextField alloc]initWithFrame:CGRectMake(wid, 0, wid, 40)] ;
    oneFiled.placeholder = @"colume";
    oneFiled.textAlignment = NSTextAlignmentCenter ;
    oneFiled.layer.borderColor = [UIColor blueColor].CGColor;
    oneFiled.layer.borderWidth = 0.5 ;
    [oneV addSubview:oneFiled] ;
    
    UITextField *oneComp = [[UITextField alloc]initWithFrame:CGRectMake(wid*2, 0, wid, 40)] ;
    oneComp.placeholder = @">,<,=,like";
    oneComp.textAlignment = NSTextAlignmentCenter ;
    oneComp.layer.borderColor = [UIColor blueColor].CGColor;
    oneComp.layer.borderWidth = 0.5 ;
    [oneV addSubview:oneComp] ;
    
    UITextField *oneValue = [[UITextField alloc]initWithFrame:CGRectMake(wid*3, 0, wid, 40)] ;
    oneValue.placeholder = @"value";
    oneValue.textAlignment = NSTextAlignmentCenter ;
    oneValue.layer.borderColor = [UIColor blueColor].CGColor;
    oneValue.layer.borderWidth = 0.5 ;
    [oneV addSubview:oneValue] ;
    
    
    ConditionPacker *packer = [[ConditionPacker alloc]init] ;
    packer.container = oneV ;
    packer.nameFiled = oneFiled ;
    packer.compFiled = oneComp ;
    packer.valueFiled = oneValue ;
    packer.logicFiled = oneLogic ;
    [self.conditionPackers addObject:packer] ;
    
}

-(NSMutableArray<GYUser *> *)results
{
    if (!_results) {
        _results = [NSMutableArray array] ;
    }
    return _results ;
}

- (NSMutableArray *)conditionPackers
{
    if (!_conditionPackers) {
        _conditionPackers = [NSMutableArray array] ;
    }
    return _conditionPackers ;
}

-(void)onDelete
{
    
    GYDBOprator *oprator = [GYDBOprator opratorWithModel:[GYUser class]] ;
    [self addWheres:oprator] ;
    BOOL bol =  [oprator remove] ;
    
    if (bol) {
        self.textView.text = @"删除成功";
    }else{
        self.textView.text = @"删除失败";
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
