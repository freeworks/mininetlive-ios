//
//  WWRewardTableViewController.m
//  MicroNetwork
//
//  Created by Lucas on 2017/1/14.
//  Copyright © 2017年 Lucas. All rights reserved.
//

#import "WWRewardTableViewController.h"
#import "WWRewardTableViewCell.h"
#import "WWUserServices.h"
#import "WWListModel.h"
#import "WWEmptyDataView.h"
#import "UITableView+EmptyView.h"

@interface WWRewardTableViewController ()
@property (nonatomic, strong) NSArray *list;

@end

@implementation WWRewardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请有奖";
    self.tableView.emptyDataView = [WWEmptyDataView emptyDataViewWithDescription:@"暂无记录" type:WWEmptyDataViewTypeLive];
    __weak __block typeof(self) weakSelf = self;
    [WWUserServices getRewardListResultBlock:^(NSArray *list, NSError *error) {
        weakSelf.list = list;
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *rid= @"WWRewardTableViewCell";
    WWRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil) {
        cell = [[WWRewardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.listModel = self.list[indexPath.row];
    return cell;
        
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
