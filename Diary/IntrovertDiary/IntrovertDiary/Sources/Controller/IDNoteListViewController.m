//
//  IDNoteListViewController.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDNoteListViewController.h"
#import "IDNoteTableViewCell.h"
#import "IDNoteStorage.h"
#import "IDNote.h"
#import "NSDateAdditions.h"

@interface IDNoteListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<IDNote *> *notes;

@end

@implementation IDNoteListViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	[self.tableView registerNib:[UINib nibWithNibName:@"IDNoteTableViewCell"
				bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"note"];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
	
	self.title = NSLocalizedString(@"cToday", @"Title");
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	infoButton.backgroundColor = [UIColor clearColor];
	[infoButton setImage:[UIImage imageNamed:@"info"]
				forState:UIControlStateNormal];
	[infoButton sizeToFit];
	[infoButton addTarget:self action:@selector(presentInfo)
				forControlEvents:UIControlEventTouchUpInside];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:infoButton];
	
	self.notes = [NSArray arrayWithArray:[[IDNoteStorage sharedStorage] notes]];
}

- (IBAction)addNewNote:(UIButton *)sender
{
}

- (void)presentInfo
{
	[self.navigationController pushViewController:
				[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
				instantiateViewControllerWithIdentifier:@"infoViewController"]
				animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	IDNoteTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"note"
				forIndexPath:indexPath];
	IDNote *note = self.notes[indexPath.row];
	
	cell.noteLabel.text = note.text;
	cell.dateLabel.text = [note.creationDate localizableDate];
	cell.imageView.image = nil != note.picture ? note.picture : [UIImage imageNamed:@"image"];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 92;
}

@end
