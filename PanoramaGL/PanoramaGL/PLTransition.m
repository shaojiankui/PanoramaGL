/*
 * PanoramaGL library
 * Version 0.1
 * Copyright (c) 2010 Javier Baez <javbaezga@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PLTransitionProtected.h"
#import "PLView.h"

@implementation PLTransition

@synthesize interval;
@synthesize progressPercentage;
@synthesize type;
@synthesize delegate;

#pragma mark -
#pragma mark init methods

-(id)initWithInterval:(NSTimeInterval)intervalValue type:(PLTransitionType)typeValue
{
	if(self = [self init])
	{
		interval = intervalValue;
		type = typeValue;
	}
	return self;
}

-(void)initializeValues
{
	[super initializeValues];
	progressPercentage = 0;
	isRunning = NO;
}

#pragma mark -
#pragma mark property methods

-(NSTimer *)timer
{
	return timer;
}

-(void)setTimer:(NSTimer *)value 
{
	if(timer)
	{
		[timer invalidate];
		timer = nil;
	}
    timer = value;
}

-(UIView<PLIView> *)view
{
	return view;
}

-(NSObject<PLIScene> *)scene
{
	return scene;
}

-(void)setProgressPercentage:(NSUInteger)value
{
	progressPercentage = value;
}

-(void)setDelegate:(NSObject<PLTransitionDelegate> *)value
{
	if(!isRunning)
		delegate = value;
}

#pragma mark -
#pragma mark internal control methods

-(void)beginExecute
{
}

-(void)endExecute
{
}

-(void)process
{
	if(view)
	{
		BOOL isEnd = [self processInternally];
		[view drawView];
		
		if(delegate && [delegate respondsToSelector:@selector(transition:didProcessTransition:progressPercentage:)])
			[delegate transition:self didProcessTransition:type progressPercentage:progressPercentage];
		
		if(isEnd)
			[self stop];
	}
}

-(BOOL)processInternally
{
	return YES;
}

#pragma mark -
#pragma mark control methods

-(BOOL)executeWithView:(UIView<PLIView> *)plView scene:(NSObject<PLIScene> *)plScene
{	
	if(!plView || !plScene)
		return NO;
	
	isRunning = YES;
	
	view = plView;
	scene = plScene;
	progressPercentage = 0;
	self.timer = nil;
	
	[plView stopAnimation];
	
	[self beginExecute];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(process) userInfo:nil repeats:YES];
	
	if(delegate && [delegate respondsToSelector:@selector(transition:didBeginTransition:)])
		[delegate transition:self didBeginTransition:type];
	
	[self endExecute];
	
	return YES;
}

-(void)stop
{
	self.timer = nil;
	view = nil;
	scene = nil;
	if(delegate && [delegate respondsToSelector:@selector(transition:didEndTransition:)])
		[delegate transition:self didEndTransition:type];
	delegate = nil;
	isRunning = NO;
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc
{
	self.timer = nil;
	view = nil;
	scene = nil;
	delegate = nil;
	[super dealloc];
}

@end
