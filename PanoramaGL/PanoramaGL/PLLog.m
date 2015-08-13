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

#import "PLLog.h"

@implementation PLLog

#pragma mark -
#pragma mark log methods
	
+(void)debug:(NSString *)tag format:(NSString *)format, ...
{
	va_list args;
    va_start(args, format);
	NSLog([[[NSString alloc] initWithFormat:format arguments:args] autorelease], nil);
    va_end(args);
}
	
+(void)error:(NSString *)tag format:(NSString *)format, ...
{
	va_list args;
    va_start(args, format);
	NSLog([[[NSString alloc] initWithFormat:format arguments:args] autorelease], nil);
    va_end(args);
}

@end
