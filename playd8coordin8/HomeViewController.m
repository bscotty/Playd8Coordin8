//
//  HomeViewController.m
//  playd8coordin8
//
//  Created by Haley Brown on 12/2/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

#import "HomeViewController.h"
#import "RootController.h"
#import "Event.h"
@import Firebase;

@interface HomeViewController ()


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //load an array with 3> upcoming events and "your" events from database into array
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView: (UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView: (UITableView *)tableView
        cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SimpleTableIdentifier];
    }
    
    if(tableView == self.upcomingTableView){
        cell.textLabel.text = self.pendingInvites[indexPath.row];
    }else {
        cell.textLabel.text = self.committedEvents[indexPath.row];
    }
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
