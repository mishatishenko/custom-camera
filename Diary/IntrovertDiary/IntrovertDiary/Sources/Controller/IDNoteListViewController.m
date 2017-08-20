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
#import "IDNoteViewController.h"

@interface IDNoteListViewController () <UITableViewDelegate,
			UITableViewDataSource, IDNoteStorageObserver>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<IDNote *> *notes;

@end

@implementation IDNoteListViewController

- (void)dealloc
{
	[[IDNoteStorage sharedStorage] removeObserver:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[IDNoteStorage sharedStorage] addObserver:self];

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
	infoButton.exclusiveTouch = YES;
	
	self.notes = [NSArray arrayWithArray:[[IDNoteStorage sharedStorage] notes]];
}

- (IBAction)addNewNote:(UIButton *)sender
{
	[self presentViewController:[IDNoteViewController createNoteController]
				animated:YES completion:nil];
}

- (void)presentInfo
{
	[self.navigationController pushViewController:
				[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]
				instantiateViewControllerWithIdentifier:@"infoViewController"]
				animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
			didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[self presentViewController:[IDNoteViewController
				noteControllerWithNote:self.notes[indexPath.row]]
				animated:YES completion:nil];
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
	cell.noteImageView.contentMode =  nil != note.picture ?
				UIViewContentModeScaleAspectFill : UIViewContentModeCenter;
	cell.noteImageView.image = nil != note.picture ?
				note.picture : [UIImage imageNamed:@"image"];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 92;
}

#pragma mark - IDNoteStorageObserver

- (void)noteStorage:(IDNoteStorage *)sender didDeleteNote:(IDNote *)note
{
	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath
				indexPathForRow:[self.notes indexOfObject:note] inSection:0]]
				withRowAnimation:UITableViewRowAnimationLeft];
	self.notes = [NSArray arrayWithArray:[[IDNoteStorage sharedStorage] notes]];
	[self.tableView endUpdates];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)noteStorage:(IDNoteStorage *)sender didAddNote:(IDNote *)note
{
	self.notes = [NSArray arrayWithArray:[[IDNoteStorage sharedStorage] notes]];
	
	[self.tableView reloadData];
}

- (void)noteStorage:(IDNoteStorage *)sender didUpdateNote:(IDNote *)note
{
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath
				indexPathForRow:[self.notes indexOfObject:note] inSection:0]]
				withRowAnimation:UITableViewRowAnimationFade];
	self.notes = [NSArray arrayWithArray:[[IDNoteStorage sharedStorage] notes]];
	[self.tableView endUpdates];
}

@end
