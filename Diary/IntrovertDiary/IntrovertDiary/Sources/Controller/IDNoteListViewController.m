//
//  IDNoteListViewController.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDNoteListViewController.h"

@interface IDNoteListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IDNoteListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

- (IBAction)addNewNote:(UIButton *)sender
{
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end
