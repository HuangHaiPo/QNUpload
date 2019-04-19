//
//  ViewController.m
//  QNUpload
//
//  Created by Leon on 2019/4/18.
//  Copyright © 2019 leon. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "ACSelectMediaView.h"
#import "HuUploadImgManage.h"

#define kToken @"QFpscwmNgsPFV1lW43vMjzgvWRRHJ9XFE7WlscXT:lOB6H97IXpJUkBkoKSJKcN7ocBc=:eyJzY29wZSI6InRlc3QiLCJkZWFkbGluZSI6MTU1NTY0NzM4Mn0="


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *pictureArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pictureArray = @[].mutableCopy;
    [self tableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(uploadImg)];
}
- (void) uploadImg {
   
}
#pragma mark - UITableViewDelegate && UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[TableViewCell cellIdentifier]];
        if (!cell) {
            cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TableViewCell cellIdentifier]];
        }
        __weak typeof(self)weakSelf = self;
        cell.userPictureBlock = ^(NSArray * _Nonnull pictureArray) {
            for ( ACMediaModel *model in pictureArray) {
                [weakSelf.pictureArray addObject:model.uploadType];
            }
            [weakSelf.tableView reloadData];
        };
        return cell;
    }else{
        TableViewCellSave * cell = [tableView dequeueReusableCellWithIdentifier:[TableViewCellSave cellIdentifier]];
        if (!cell) {
            cell = [[TableViewCellSave alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TableViewCellSave cellIdentifier]];
        }
        return cell;
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [HuUploadImgManage uploadMuchImage:_pictureArray view:self.view token:kToken success:^(NSArray * _Nonnull imgArrayUrl) {
            NSLog(@"图片上传成功:%@",imgArrayUrl);
        } failure:^(NSString * _Nonnull message) {
            NSLog(@"%@",message);
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 44;
    }
    NSInteger picInt = _pictureArray.count+1;
    NSInteger remainder = picInt%4;
    NSInteger tempRow = picInt/4;
    NSInteger row = 1;
    if (remainder > 0) {
        row = tempRow+1;
    }else{
        row = tempRow;
    }
    return row*kHuFeedbackTableViewSectionFiveCellH;
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
