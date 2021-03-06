//
//  NSDateExtension.m
//  tandr
//
//  Created by Katsuyoshi Ito on 10/02/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

/* 

  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import "NSDateExtension.h"


@implementation NSDate(ISExtension)

+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second
{
    return [self dateWithYear:year month:month day:day hour:hour minute:minute second:second timeZone:[NSTimeZone localTimeZone]];
}

+ (NSDate *)dateWithYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute second:(int)second timeZone:(NSTimeZone *)timeZone
{
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    
    NSCalendar *gregorian = [self gregorianCalendar];
    [gregorian setTimeZone:timeZone];
    return [gregorian dateFromComponents:components];
}

+ (NSCalendar *)gregorianCalendar
{
    return [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
}

- (NSCalendar *)gregorianCalendar
{
    return [[self class] gregorianCalendar];
}

- (int)year
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

- (int)month
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:self];
    return [components month];
}

- (int)day
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

- (int)hour
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDateComponents *components = [gregorian components:NSHourCalendarUnit fromDate:self];
    return [components hour];
}

- (int)minute
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMinuteCalendarUnit fromDate:self];
    return [components minute];
}

- (int)second
{
    NSCalendar *gregorian = [self gregorianCalendar];
    NSDateComponents *components = [gregorian components:NSSecondCalendarUnit fromDate:self];
    return [components second];
}



- (NSDate *)beginningOfDay
{
    return [NSDate dateWithYear:[self year] month:[self month] day:[self day] hour:0 minute:0 second:0];
}


+ (NSDate *)dateFromISO8601String:(NSString *)string
{
    int length = [string length];
    if (length) {
        unichar lastLatter = [string characterAtIndex:length - 1];
        NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
        if (lastLatter == 'Z') {
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            if ([formatter respondsToSelector:@selector(setTimeZone:)]) {
                [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                return [formatter dateFromString:string];
            } else {
                // -[NSDateFormatter timeZone] available iOS4 and later
                // first, parse data as localtime zone
                NSDate *date = [formatter dateFromString:string];
                // get back to UTC
                NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                date = [date dateByAddingTimeInterval:[timeZone secondsFromGMT]];
                return date;
            }
        } else {
            if (length >= 6) {
                unichar sign = [string characterAtIndex:length - 6];
                unichar colon = [string characterAtIndex:length - 3];
                if ((sign == '+' || sign == '-') && colon == ':') {
                    string = [[string mutableCopy] autorelease];
                    [(NSMutableString *)string replaceCharactersInRange:NSMakeRange(length - 3, 1) withString:@""];
                }
            }
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            return [formatter dateFromString:string];
        }
    }
    return nil;
}

@end
