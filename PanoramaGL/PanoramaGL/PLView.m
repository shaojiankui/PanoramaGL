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

#import "PLView.h"
#import "PLViewBaseProtected.h"

@implementation PLView

#pragma mark -
#pragma mark progressbar methods

-(BOOL)showProgressBar
{
	if(!progressBar)
	{
		progressBar = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		CGSize size = self.bounds.size;
		progressBar.frame = CGRectMake(0, 0, 50, 50);
		progressBar.center = CGPointMake(size.width / 2.0f, size.height / 2.0f);
		[self addSubview:progressBar];
		[progressBar startAnimating];
		[progressBar release];
		return YES;
	}
	return NO;
}

-(void)resetProgressBar
{
	if(progressBar)
	{
		[self hideProgressBar];
		[self showProgressBar];
	}
}

-(BOOL)hideProgressBar
{
	if(progressBar)
	{
		[progressBar stopAnimating];
		[progressBar removeFromSuperview];
		progressBar = nil;
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark layout methods 

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(progressBar)
    {
        [self hideProgressBar];
        [self showProgressBar];
    }
}

#pragma mark -
#pragma mark clear methods

-(void)clear
{
    NSObject<PLIPanorama> *panorama = [self panorama];
    if(panorama)
    {
        @synchronized(self)
        {
            [panorama clearPanorama];
        }
    }
}

#pragma mark -
#pragma mark load methods

-(void)load:(NSObject<PLILoader> *)loader
{
    if(loader)
    {
        @synchronized(self)
        {
            [self stopOnlyAnimation];
            [loader load:self];
        }
    }
    else
        [NSException raise:@"PanoramaGL" format:@"loader param is NULL"];
}

#pragma mark -
#pragma mark dealloc methods

-(void)dealloc 
{
	[self hideProgressBar];
	[super dealloc];
}
				
@end
