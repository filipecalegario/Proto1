//
//  P1EditViewController.h
//  Proto1
//
//  Created by Filipe Calegario on 16/07/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "P1EditView.h"
#import "P1InputObjectView.h"
//#import "PdDispatcher.h"
//#import "PdFile.h"
 
@interface P1EditViewController : UIViewController <UIGestureRecognizerDelegate>
//{
//    PdDispatcher *dispatcher;
//    PdFile *patch;
//}

@property (weak, nonatomic) IBOutlet UIButton *botao;

@property (weak, nonatomic) IBOutlet UIButton *contextMenuButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet P1EditView *canvas;

- (void) addObject:(NSString *)identifier;
- (void) openMenuToAddObject:(UITapGestureRecognizer *)gesture;
- (void) longTapHandle:(UILongPressGestureRecognizer *)gesture;
- (void) configContextMenu:(P1InputObjectView *)objectView withTag:(int)tag;

@end
