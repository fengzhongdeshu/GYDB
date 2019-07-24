# GYDB

[![CI Status](https://img.shields.io/travis/liuguoyan/GYDB.svg?style=flat)](https://travis-ci.org/liuguoyan/GYDB)
[![Version](https://img.shields.io/cocoapods/v/GYDB.svg?style=flat)](https://cocoapods.org/pods/GYDB)
[![License](https://img.shields.io/cocoapods/l/GYDB.svg?style=flat)](https://cocoapods.org/pods/GYDB)
[![Platform](https://img.shields.io/cocoapods/p/GYDB.svg?style=flat)](https://cocoapods.org/pods/GYDB)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Document
**框架特点:**  
1:使用sqlite3为数据存储媒介，以键值形式存储数据。  
2:app升级或者数据字段升级，无需关心数据迁移问题，不需要维护版本，数据存储字段可以任意添加或者删除。  
3:完全面向对象操作，且不需要继承特定的类，只需要把Model存储即可。  
4:操作简单，简单调用即可实现CRUD操作。  
 

##Usage
**#保存**：
GYUser *user = [[GYUser alloc]init] ;
BOOL bol = [[[GYDBOprator opratorWithModel:[GYUser class]]addSaveModel:user] save] ;

**#查询**：  
GYDBOprator *oprator = [GYDBOprator opratorWithModel:[GYUser class]] ;  
[oprator whereColume:@"name" compare:@"=" value:@"张三"] ;  
[oprator andWhereColume:@"age" compare:@"=" value:@"12"];  
NSArray *arr =  [oprator query] ;  

**#删除**  
GYDBOprator *oprator = [GYDBOprator opratorWithModel:[GYUser class]] ;  
[oprator whereColume:@"name" compare:@"=" value:@"张三"] ;  
[oprator andWhereColume:@"age" compare:@"=" value:@"12"];  
NSArray *arr =  [oprator remove] ;  

**#更新**  
GYDBOprator *oprator = [GYDBOprator opratorWithModel:[GYUser class]] ;  
//设置要更新的字段和值  
[oprator updateColume:@"age" toValue:@"18"] ;  
//添加过滤条件  
[oprator whereColume:@"name" compare:@"=" value:@"张三"] ;  
[oprator andWhereColume:@"age" compare:@"=" value:@"12"];  
BOOL bol =  [oprator update];  


## Requirements

## Installation

GYDB is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GYDB', :git=>'https://github.com/fengzhongdeshu/GYDB.git'
```

## Author

liuguoyan, liuguoyan21@126.com

## License

GYDB is available under the MIT license. See the LICENSE file for more info.
