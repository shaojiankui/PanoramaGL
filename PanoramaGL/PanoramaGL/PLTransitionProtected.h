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

#import "PLObjectBaseProtected.h"
#import "PLTransition.h"

@interface PLTransition(Protected)

#pragma mark -
#pragma mark properties

@property(nonatomic, assign, getter=timer, setter=setTimer:) NSTimer *timer;
@property(nonatomic, readonly, getter=view) UIView<PLIView> *view;
@property(nonatomic, readonly, getter=scene) PLScene *scene;

#pragma mark -
#pragma mark property methods

-(NSTimer *)timer;
-(void)setTimer:(NSTimer *)timer;

-(UIView<PLIView> *)view;
-(PLScene *)scene;

-(void)setProgressPercentage:(NSUInteger)value;

#pragma mark -
#pragma mark internal control methods

-(void)beginExecute;
-(void)endExecute;

-(void)process;
-(BOOL)processInternally;

@end

