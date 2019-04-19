//
//  TableViewCell.h
//  QNUpload
//
//  Created by Leon on 2019/4/18.
//  Copyright © 2019 leon. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHuFeedbackTableViewSectionFiveCellH (111)

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (nonatomic ,copy) void(^userPictureBlock)(NSArray *pictureArray);

+ (NSString *) cellIdentifier;

@end


@interface TableViewCellSave : UITableViewCell


+ (NSString *) cellIdentifier;

@end


NS_ASSUME_NONNULL_END
