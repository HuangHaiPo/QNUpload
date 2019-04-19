//
//  TableViewCell.m
//  QNUpload
//
//  Created by Leon on 2019/4/18.
//  Copyright © 2019 leon. All rights reserved.
//

#define SCREENW [UIScreen mainScreen].bounds.size.width

#import "TableViewCell.h"
#import "ACSelectMediaView.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0,SCREENW, 1)];
        mediaView.backgroundColor = [UIColor clearColor];
        mediaView.type = ACMediaTypePhotoAndCamera;
        mediaView.maxImageSelected = 9;
        mediaView.naviBarBgColor = [UIColor whiteColor];
        mediaView.barItemTextColor = [UIColor blackColor];
        mediaView.isStatusBarDefault = YES;
        mediaView.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        [mediaView observeViewHeight:^(CGFloat mediaHeight) {
            
        }];
        __weak typeof(self)weakSelf = self;
        [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
            if (weakSelf.userPictureBlock) {
                weakSelf.userPictureBlock(list);
            }
        }];
        [self.contentView addSubview:mediaView];
        
    }
    return self;
}

+ (NSString *) cellIdentifier{
    return NSStringFromClass([self class]);
}

@end

@implementation TableViewCellSave

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [UILabel new];
        label.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-20, 0, 40, 44);
        label.text = @"保存";
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor blueColor];
        [self.contentView addSubview:label];
    }
    return self;
}

+ (NSString *) cellIdentifier{
    return NSStringFromClass([self class]);
}

@end
