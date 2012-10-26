//
//  P1ObjectFactory.m
//  Proto1
//
//  Created by Filipe Calegario on 03/08/12.
//  Copyright (c) 2012 FCAC. All rights reserved.
//

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#import "P1ObjectFactory.h"
#import "P1InputObjectView.h"
#import "P1OutputObjectView.h"
#import "P1Touchable.h"

@implementation P1ObjectFactory

+(UIView *)createAfrobeatWithCanvas:(P1EditView *)canvas
{
    P1OutputObjectView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 350) relatedPatch:@"afro-beat.pd"];
    
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
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:OUTPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        //noteObject.myTag = 128;
        
        noteObject.action.description = icon.type;
        noteObject.action.value = -1;
        noteObject.action.patch = object.relatedPatch;
        
        [object addSubview:noteObject];
    }
    return object;
}

+(UIView *)createSamplePlayerWithCanvas:(P1EditView *)canvas
{
    P1OutputObjectView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 350) relatedPatch:@"mySimpleSamplePlayer.pd"];
    
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
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:OUTPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        
        noteObject.action.description = icon.type;
        noteObject.action.value = -1;
        noteObject.action.patch = object.relatedPatch;
        
        [object addSubview:noteObject];
    }
    return object;
}

#warning Criar um createGenericPDTriggerDefaultOuputObject

+(UIView *)createNoteArrayWithCanvas:(P1EditView *)canvas withGestureHandler:(id)gestureHandler
{
    NSString* iconTypeString = @"playNote";
    NSString* connectorTypeString = @"trigger";
    P1OutputObjectView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 100, 500) relatedPatch:@"noteArray.pd"];
    
    NSArray * initialNotes = [NSArray arrayWithObjects: 
                              [NSNumber numberWithInt:60],
                              [NSNumber numberWithInt:62],
                              [NSNumber numberWithInt:64],
                              [NSNumber numberWithInt:67],
                              [NSNumber numberWithInt:69],
                              [NSNumber numberWithInt:60+12],
                              [NSNumber numberWithInt:62+12],
                              [NSNumber numberWithInt:64+12],
                              [NSNumber numberWithInt:67+12],
                              [NSNumber numberWithInt:69+12],
                              nil];
    
    for (int i = 0; i < 10; i++)
    {
        P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) withType:connectorTypeString withImageSource:@"specialConnector"];
        P1IconView* icon = [[P1IconView alloc] initWithFrame:CGRectMake(50, 0, 50, 50) withType:iconTypeString withImageSource:@"specialIcon"];
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 100, 50) withObjectType:OUTPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        
        noteObject.action.description = [NSString stringWithFormat:@"note%i",i];
        noteObject.action.value = [[initialNotes objectAtIndex:i] intValue];
        noteObject.action.patch = object.relatedPatch;
        
        //NSLog([NSString stringWithFormat:@"Nota %@ com valor %i adicionada na iteração %i", noteObject.name, noteObject.myTag, i]);
        
        [object addSubview:noteObject];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:gestureHandler action:@selector(longTapHandle:)];
        [icon addGestureRecognizer:longPress];
        
        [canvas.tapGesture requireGestureRecognizerToFail:longPress];
        
    }
    return object;
}

+(UIView *)createOSCNoteArrayWithCanvas:(P1EditView *)canvas withGestureHandler:(id)gestureHandler
{
    P1OutputObjectView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 350) relatedPatch:@"NotPD"];
    
    NSString * connectorTypeString = @"trigger";
    
    CGRect defaultIconRect = CGRectMake(50, 0, 100, 50);
    NSString* defaultIconImageSource = @"specialIconLong";
    
    NSArray *icons = [[NSArray alloc] initWithObjects:
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"note1" withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"note2"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"note3"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"note4"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"note5"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"note6" withImageSource:defaultIconImageSource],
                      nil];
    
    for (int i = 0; i < 6; i++)
    {
        P1IconView* connector = [[P1IconView alloc] initWithFrame:CGRectMake(0, 0, 50, 50) withType:connectorTypeString withImageSource:@"specialConnector"];
        
        P1IconView* icon = [icons objectAtIndex:i];
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:OUTPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        
        noteObject.action.description = icon.type;
        noteObject.action.value = -1;
        noteObject.action.patch = object.relatedPatch;
        
        [object addSubview:noteObject];
    }
    return object;
}

+(UIView *)createNoteFlowWithCanvas:(P1EditView *)canvas
{
    //NSLog(@"NoteFlow");
    P1OutputObjectView* object = [[P1OutputObjectView alloc] initWithFrame:CGRectMake(0, 0, 150, 150) relatedPatch:@"proto1.pd"];
    
    NSString* defaultIconImageSource = @"specialIconLong";
    CGRect defaultIconRect = CGRectMake(50, 0, 100, 50);
    CGRect defaultConnectorRect = CGRectMake(0, 0, 50, 50);
    
    NSArray *icons = [[NSArray alloc] initWithObjects:
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"playNotes" withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"pitch"  withImageSource:defaultIconImageSource],
                      [[P1IconView alloc] initWithFrame:defaultIconRect withType:@"duration"  withImageSource:defaultIconImageSource],
                      nil];
    
    NSArray *connectors = [[NSArray alloc] initWithObjects:
                           [[P1IconView alloc] initWithFrame:defaultConnectorRect withType:@"track" withImageSource:@"specialTrackConnector"],
                           [[P1IconView alloc] initWithFrame:defaultConnectorRect withType:@"track"  withImageSource:@"specialTrackConnector"],
                           [[P1IconView alloc] initWithFrame:defaultConnectorRect withType:@"track"  withImageSource:@"specialTrackConnector"],
                           nil];
    
    for (int i = 0; i < 3; i++)
    {
        
        P1IconView* icon = [icons objectAtIndex:i];
        P1IconView* connector = [connectors objectAtIndex:i];
        
        P1InputObjectView* noteObject = [[P1InputObjectView alloc] initWithFrame:CGRectMake(0, i * 50, 150, 50) withObjectType:OUTPUT withIcon:icon withConnector:connector withCanvas:canvas groupedGestures:YES];
        //noteObject.myTag = 128;
        noteObject.action.patch = object.relatedPatch;
        
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

+(P1CircleTouchable *)createCircleTouchable:(P1EditView *)canvas
{
    CGRect defaultRect = CGRectMake(0, 0, 125, 125);
    
    return [[P1CircleTouchable alloc] initWithFrame:defaultRect];
}

+(P1MultipleInputObject *)createMultipleTouchable:(P1EditView *)canvas
{
    P1MultipleInputObject * multipleObject = [[P1MultipleInputObject alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    
    CGRect rect = CGRectMake(0, 0, 100, 50);
    
    P1Touchable * west = [[P1Touchable alloc] initWithFrame:rect withCanvas:canvas withGroupedFlag:YES];
    P1Touchable * north = [[P1Touchable alloc] initWithFrame:rect withCanvas:canvas withGroupedFlag:YES];
    P1Touchable * east = [[P1Touchable alloc] initWithFrame:rect withCanvas:canvas withGroupedFlag:YES];
    P1Touchable * south = [[P1Touchable alloc] initWithFrame:rect withCanvas:canvas withGroupedFlag:YES];
    
    west.transform = CGAffineTransformMakeRotation(M_PI);
    west.frame = CGRectMake(100, 150, 100, 50);
    
    north.transform = CGAffineTransformMakeRotation(-M_PI/2);
    north.frame = CGRectMake(100, 100, 50, 100);
    
    //east.transform = CGAffineTransformMakeRotation(0);
    east.frame = CGRectMake(150, 100, 100, 50);
    
    south.transform = CGAffineTransformMakeRotation(M_PI/2);
    south.frame = CGRectMake(150, 150, 50, 100);
    
    //multipleObject.backgroundColor = [UIColor redColor];
    
    [multipleObject addSubview:west];
    [multipleObject addSubview:north];
    [multipleObject addSubview:east];
    [multipleObject addSubview:south];
    
    return multipleObject;
}

+(P1InputObjectView *)createInputObject:(NSString *)iconType withCanvas:(P1EditView *)canvas
{
    CGRect defaultRect = CGRectMake(0, 0, 150, 100);
    P1InputObjectView * object;
    
    if([iconType isEqualToString:@"touch"]){
        NSLog(@"Add touch input object");
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"track" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"horizontalSlide"]) {
        NSLog(@"Add horizontal slide input object");     
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"track" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"verticalSlide"]) {
        NSLog(@"Add vertical slide input object");       
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"track" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeUp"]) {
        NSLog(@"Add swipeUp input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeDown"]) {
        NSLog(@"Add swipeDown input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeLeft"]) {
        NSLog(@"Add swipeLeft input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeRight"]) {
        NSLog(@"Add swipeRight input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeDoubleUp"]) {
        NSLog(@"Add swipeDoubleUp input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeDoubleDown"]) {
        NSLog(@"Add swipeDoubleDown input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeDoubleLeft"]) {
        NSLog(@"Add swipeDoubleLeft input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
        
    } else if ([iconType isEqualToString:@"swipeDoubleRight"]) {
        NSLog(@"Add swipeDoubleRight input object");  
        object = [[P1InputObjectView alloc] initWithFrame:defaultRect withObjectType:INPUT withIconType:iconType withConnectorType:@"trigger" withCanvas:canvas];
    }
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Added %@", iconType]];
    
    return object;
}

@end
