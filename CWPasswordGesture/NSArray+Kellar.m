//
//  NSArray+Kellar.m
//  CWPasswordGesture
//
//  Created by Cory D. Wiles on 10/9/13.
//  Copyright (c) 2013 Cory D. Wiles. All rights reserved.
//

#import "NSArray+Kellar.h"

@implementation NSArray (Kellar)

- (NSArray *)shuffled {

	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
  
	for (id anObject in self) {
	
    NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		
    [tmpArray insertObject:anObject atIndex:randomPos];
  }
  
	return [NSArray arrayWithArray:tmpArray];
}

@end
