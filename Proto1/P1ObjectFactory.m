//
//  P1ObjectFactory.m
//  Proto1
//
//  Created by Filipe Calegario on 03/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#import "P1ObjectFactory.h"
#import "P1InputObjectView.h"
#import "P1OutputObjectView.h"
#import "P1Touchable.h"

@implementation P1ObjectFactory

+(UIView *)createAfrobeatWithCanvas:(P1EditView *)canvas
{
    UIView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 350) relatedPatch:@"afro-beat.pd"];
    
    NSString * connectorTypeString = @"trigger";
    
    CGRect defaultIconRect = CGRectMake(50, 0, 100, 50);
    NSString* defaultIconImageSource = @"specialIconLong";
    
    NSArray *icons = [[NSArray alloc] initWithObjects:
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"music1" withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"music2"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"music3"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"music4"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"bpmUp"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"bpmDown" withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"trackSel" withImageSource:defaultIconImageSource],
                      nil];
    
    for (int i = 0; i < 7; i++)
    {
        P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) withType:connectorTypeString withImageSource:@"specialConnector"];
        
        P1IconView* icon = [icons objectAtIndex:i];
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:@"output" withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        noteObject.myTag = 128;
        
        [object addSubview:noteObject];
    }
    return object;
}

+(UIView *)createSamplePlayerWithCanvas:(P1EditView *)canvas
{
    UIView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 350) relatedPatch:@"mySimpleSamplePlayer.pd"];
    
    NSString * connectorTypeString = @"trigger";
    
    CGRect defaultIconRect = CGRectMake(50, 0, 100, 50);
    NSString* defaultIconImageSource = @"specialIconLong";
    
    NSArray *icons = [[NSArray alloc] initWithObjects:
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"sample1" withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"sample2"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"sample3"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"sample4"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"sample5"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"sample6" withImageSource:defaultIconImageSource],
                      nil];
    
    for (int i = 0; i < 6; i++)
    {
        P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) withType:connectorTypeString withImageSource:@"specialConnector"];
        
        P1IconView* icon = [icons objectAtIndex:i];
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:@"output" withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        noteObject.myTag = 128;
        
        [object addSubview:noteObject];
    }
    return object;
}

#warning Criar um createGenericPDTriggerDefaultOuputObject

+(UIView *)createNoteArrayWithCanvas:(P1EditView *)canvas withGestureHandler:(id)gestureHandler
{
    NSString* iconTypeString = @"playNote";
    NSString* connectorTypeString = @"trigger";
    UIView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 100, 400) relatedPatch:@"proto1.pd"];
    
    for (int i = 0; i < 8; i++)
    {
        P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) withType:connectorTypeString withImageSource:@"specialConnector"];
        P1IconView* icon = [[P1IconView alloc] initWithFrame:CGRectMake(50, 0, 50, 50) withType:iconTypeString withImageSource:@"specialIcon"];
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 100, 50) withObjectType:@"output" withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        noteObject.myTag = 60 + i;
        [object addSubview:noteObject];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:gestureHandler action:@selector(longTapHandle:)];
        [icon addGestureRecognizer:longPress];
    }
    return object;
}

+(UIView *)createNoteFlowWithCanvas:(P1EditView *)canvas
{
    NSLog(@"NoteFlow");
    UIView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 150) relatedPatch:@"proto1.pd"];
    
    NSString* defaultIconImageSource = @"specialIconLong";
    CGRect defaultIconRect = CGRectMake(50, 0, 100, 50);
    CGRect defaultConnectorRect = CGRectMake(0, 0, 50, 50);
    
    NSArray *icons = [[NSArray alloc] initWithObjects:
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"playNotes" withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"pitch"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"duration"  withImageSource:defaultIconImageSource],
                      nil];
    
    NSArray *connectors = [[NSArray alloc] initWithObjects:
                           [[P1IconView alloc] initWithFrame:defaultConnectorRect withType:@"trigger" withImageSource:@"specialConnector"],
                           [[P1IconView alloc] initWithFrame:defaultConnectorRect withType:@"track"  withImageSource:@"specialTrackConnector"],
                           [[P1IconView alloc] initWithFrame:defaultConnectorRect withType:@"track"  withImageSource:@"specialTrackConnector"],
                           nil];
    
    for (int i = 0; i < 3; i++)
    {
        
        P1IconView* icon = [icons objectAtIndex:i];
        P1IconView* connector = [connectors objectAtIndex:i];
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:@"output" withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        //noteObject.myTag = 128;
        
        [object addSubview:noteObject];
    }
    return object;
}

+(P1Touchable *)createTouchable:(P1EditView *)canvas
{
    CGRect defaultRect = CGRectMake(0, 0, 150, 100);
    
    P1Touchable * object = [[P1Touchable alloc] initWithFrame:defaultRect withCanvas:canvas];
    
    return object;
}

@end
