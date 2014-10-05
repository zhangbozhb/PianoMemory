//
//  PMStudentBrowseTableViewCell.m
//  PianoMemory
//
//  Created by 张 波 on 14-10-5.
//  Copyright (c) 2014年 yue. All rights reserved.
//

#import "PMStudentBrowseTableViewCell.h"

@interface PMStudentBrowseTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *decriptionLabel;
@end

@implementation PMStudentBrowseTableViewCell

- (void)refreshUI
{
    [self.nameLabel setText:self.student.name];
    [self.phoneLabel setText:self.student.phone];
}
@end
