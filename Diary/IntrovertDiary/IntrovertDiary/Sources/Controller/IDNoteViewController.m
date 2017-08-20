//
//  IDNoteViewController.m
//  IntrovertDiary
//
//  Created by Www Www on 8/20/17.
//  Copyright © 2017 Michael Tishchenko. All rights reserved.
//

#import "IDNoteViewController.h"
#import "IDNote.h"
#import "NSDateAdditions.h"

@interface IDNoteViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UIButton *changePictureButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;

@property (nonatomic) BOOL editMode;

@property (nonatomic, strong) IDNote *note;

@end

@implementation IDNoteViewController

+ (UINavigationController *)noteControllerWithNote:(IDNote *)note;
{
	UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main"
				bundle:[NSBundle mainBundle]]
				instantiateViewControllerWithIdentifier:@"noteEditNavigationController"];
	IDNoteViewController *controller = (IDNoteViewController *)
				navigationController.topViewController;
	controller.note = note;
	
	return navigationController;
}

+ (UINavigationController *)createNoteController
{
	UINavigationController *navigationController = [[UIStoryboard storyboardWithName:@"Main"
				bundle:[NSBundle mainBundle]]
				instantiateViewControllerWithIdentifier:@"noteEditNavigationController"];
	IDNoteViewController *controller = (IDNoteViewController *)
				navigationController.topViewController;
	controller.note = [IDNote new];
	controller.editMode = YES;
	
	return navigationController;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"cToday", @"");
	
	self.imageWidthConstraint.constant =
				CGRectGetWidth(self.navigationController.view.frame) - 32;
	
	self.imageView.image = self.note.picture;
	
	self.dateLabel.text = [self.note.creationDate localizableDate];
	
	self.noteTextView.text = nil != self.note.text ? self.note.text :
				NSLocalizedString(@"cTellAboutYourDay", @"");
	
	[self turnEditMode:self.editMode];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.backgroundColor = [UIColor clearColor];
	[cancelButton setImage:[UIImage imageNamed:@"close"]
				forState:UIControlStateNormal];
	[cancelButton sizeToFit];
	[cancelButton addTarget:self action:@selector(cancelEditing)
				forControlEvents:UIControlEventTouchUpInside];
	cancelButton.exclusiveTouch = YES;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:cancelButton];
	
	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.backgroundColor = [UIColor clearColor];
	[deleteButton setImage:[UIImage imageNamed:@"delete"]
				forState:UIControlStateNormal];
	[deleteButton sizeToFit];
	[deleteButton addTarget:self action:@selector(deleteNote)
				forControlEvents:UIControlEventTouchUpInside];
	deleteButton.exclusiveTouch = YES;
	
	UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
	shareButton.backgroundColor = [UIColor clearColor];
	[shareButton setImage:[UIImage imageNamed:@"share"]
				forState:UIControlStateNormal];
	[shareButton sizeToFit];
	[shareButton addTarget:self action:@selector(shareNote)
				forControlEvents:UIControlEventTouchUpInside];
	shareButton.exclusiveTouch = YES;
	
	self.toolbarItems = @[[[UIBarButtonItem alloc] initWithCustomView:deleteButton],
				[[UIBarButtonItem alloc] initWithBarButtonSystemItem:
				UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
				[[UIBarButtonItem alloc] initWithCustomView:shareButton]];
}

- (void)turnEditMode:(BOOL)enableEditMode
{
	self.editMode = enableEditMode;
	
	self.changePictureButton.userInteractionEnabled = enableEditMode;
	self.changePictureButton.hidden = !enableEditMode && nil != self.note.picture;
	self.noteTextView.userInteractionEnabled = enableEditMode;
	
	[self.navigationController setToolbarHidden:enableEditMode animated:YES];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setImage:[UIImage imageNamed:enableEditMode ? @"done" : @"edit"]
				forState:UIControlStateNormal];
	[button sizeToFit];
	[button addTarget:self action:enableEditMode ? @selector(doneEditing) :
				@selector(enableEditMode)
				forControlEvents:UIControlEventTouchUpInside];
	button.exclusiveTouch = YES;
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:button];
}

- (void)cancelEditing
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneEditing
{
	[self turnEditMode:NO];
}

- (void)enableEditMode
{
	[self turnEditMode:YES];
}

- (void)deleteNote
{

}

- (void)shareNote
{

}

- (IBAction)changePicture:(UIButton *)sender
{
}

@end
