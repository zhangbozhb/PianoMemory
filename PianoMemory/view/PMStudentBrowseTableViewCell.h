//
//  PMStudentBrowseTableViewCell.h
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMStudent.h"

@interface PMStudentBrowseTableViewCell : UITableViewCell
@property (nonatomic) PMStudent *student;

- (void)refreshUI;
@end
