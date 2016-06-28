//
//  main.m
//  ObjcLearning
//
//  Created by Darren Leith on 16/05/2016.
//  Copyright © 2016 Darren Leith. All rights reserved.
//

#import <Foundation/Foundation.h> //this is a pre-processor directive. It literally takes the contents of Foundation.h and copies it in place of this line, prior to anything being built.

/*
 #import "MyClass.h" //when importing our own header files we use "" , not <>. This is an important distinction. <> means search in system libraries, "" means search in system libraries AND this project.
 */

int main(int argc, const char * argv[]) {
	@autoreleasepool { //autoreleasepool = I am assigning a chunk of memory, please free it up when complete.
		
		/*
		 //1. BASICS
		 //NO type inference with Obj-C
		 
		 //@ means this is Obj-C, NOT C. Remember Obj-C is just a subset of the 40 year old C language. @ is ABUSED EXTENSIVELY in Obj-C
		 
		 int i = 10; //this is a VAR ! not using let or var here like Swift. Practically everything is a var in Obj-C.
		 const int j = 10; //this is how we would assign it a constant. Few Obj-C developers bother with using constants
		 
		 NSString *str = @"Reject common sense to make the impossible possible!"; //str is NOT an NSString, its just a POINTER to where an NSString exists.
		 
		 NSArray *array = @[@"Hello", @"World"];
		 
		 
		 NSLog(@"Hello, World!");
		 */
		
		/*
		//2. SWITCHING
		int i = 20;
		
		switch (i) {
			case 20:
				NSLog(@"Its 20!");
				break;
			case 40:
				NSLog(@"Its 40!");
				break;
			case 60:
				NSLog(@"Its 60!");
				break;
			default:
				NSLog(@"Its something else");
				break;
		}
		 */
		
		/*
		//3. LOOPS
		
		//fast enumeration
		
		NSArray *names = @[@"Darren", @"Sarah", @"Isabelle", @"Isaac"];
		
		for (NSString *name in names) {
			NSLog(@"Hello, %@", name);  //%@ is a FORMAT SPECIFIER that means insert the contents of any OBJECT here. No string interpolation here.!
		}
		
		//C-style for loop
		for (int i = 0; i < 5; i++) {
			NSLog(@"%d * %d is %d", i, i, i * i); //%d is another format specifier that means INT
		}
		 */
		
		/*
		//4. NIL COALSECING
		NSString *name = nil;
		NSLog(@"Hello, %@", name ?: @"Anonymous"); // ?: is Obj-C way of doing nil coalesing (compare to ?? in Swift). ?: basically hijacks the ternary operator.
		*/
		
		/*
		//5. POINTERS
		//All objects in Obj-C are pointers
		
		//this is perfectly valid !
		NSString const *first = @"Hello";
		first = @"World";
		
		//to understand it: first is not the constant here, the string is. We are just updating the pointer to point to the new string. note: NSString is essentially immutable anyway, so here we are just creating a brand new NSString
		
		NSString *pointer = @"Hello";
		NSLog(@"%p", pointer);
		pointer = @"Goodbye";
		NSLog(@"%p", pointer); //the pointer has been moved
		
		//to actually create a constant string, we move the const to AFTER the *
		NSString *const pointerCantBeChanged = @"Hello";
		NSLog(@"%p", pointerCantBeChanged);
		*/
		
		/*
		//6. FORMAT SPECIFIERS
		NSLog(@"%.2f", M_PI); //M_PI is a predefined constant defined for you as a MACRO
		
		#define M_DARREN @"fuckyou"
		
		NSLog(@"%@", M_DARREN);
		
		//use of NSInteger to satisfy both 32bit and 64bit CPUs. Used along with CGFloat
		NSInteger i = 10;
		NSLog(@"%ld", (long)i); //ld is long integer. Cant use %d here, as 64bit devices cant use this. Solution is to use %ld, and then cast it to a long
		*/
		
		/*
		//7. NSString
		//NSString is a class, not a struct, which means its a reference type
		//Can bridge NSString and String by using the "as" typecast. Alot of the methods used in Swift are NSString methods
		//stringByReplacingOccurrencesofString, isEqualToString, stringByAppendingString, etc, etc, etc
		
		NSInteger number = 42;
		NSString *output = [NSString stringWithFormat:@"You picked %ld", (long)number];
		
		//note this is exactly the same as above line
		//NSString *outputTwo = [[NSString alloc] initWithFormat:@"You picked %ld", (long)number];
		
		NSLog(@"%@", output);
		
		NSString *outputTwo = [[NSString alloc] initWithContentsOfFile:@"hello.txt" encoding:nil error:nil]; //here, we dont deal with the error. To be able to deal with this (and not simply say nil) we need to be able to use pointer pointers....
		
		
		NSMutableString *mutable = @"Hello";  //this is an error since @"" creates an NSString i.e. an immutable string
		NSMutableString *mutable = [@"Hello" mutableCopy]; //this is the correct way to perform above. Make a mutable copy..OR...below:
		NSString *hello = [NSMutableString stringWithFormat:@"asshole"];

		
		
		//So, NSNumber is an object that stores a primitive. Why?? Because it turns out arrays and dictionaries in Obj-C cant hold primitives, they can only store objects..! Therefore, we wrap our primitives up in an NSNumber. How ridonkulous...
		NSNumber *integerTen = @10; //note the use of the @ symbole to create the NSNumber
		NSNumber *anotherIntegerTen = [NSNumber numberWithInteger:10];
		NSNumber *booleanTrue = @YES;
		 
		 */
		
		
		/*
		//8.ARRAYS
		
		//long way
		NSArray *villains = [NSArray arrayWithObjects:@"hitler", @"aceventura", @"johnny", nil]; //the nil at the end is there because NSArray needs to know where the list of items ends. More silliness from Obj-C
		
		//short way. This is called an ARRAY LITERAL
		//NSArray *villainsTwo = @[@"hello", @"you", @"shithead"];
		
		NSLog(@"There are %ld villains", (long)[villains count]);
		NSLog(@"Hitler is villain number %ld", (long) [villains indexOfObject:@"hitler"]);
		NSLog(@"The mystery villain is villain number %ld", (long) [villains indexOfObject:@"mystery"]); //this will return 9223372036854775807 which is just a magic number. It is an NSNotFound value which is just a verly large integer. It means the object was not found.
		NSLog(@"The second villain was %@", [villains objectAtIndex:1]);
		
		NSMutableArray *mutableVillains = [@[@"hello", @"there"] mutableCopy]; //use of mutableCopy to create a mutable version of the array
		[mutableVillains insertObject:@"fuckhead" atIndex:2];
		[mutableVillains removeAllObjects];
		
		NSArray *sorted = [villains sortedArrayUsingSelector:@selector(compare:)]; //selector is almost identical to #selector but dont forget the : if it takes a parameter
		NSLog(@"%@", sorted[0]);
		
		//and here we introduce BLOCKS. Bit like closures in Swift. Note the use of the ^ "carrot"
		[villains enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSLog(@"The villain is %@", obj);
		}];
		//id is equivalent of AnyObject in Swift. Ctrl + Space on an object of type id will give you every possible variation since XCode doesnt know of what type it is i.e. it could be any object ..!
		//idx is index
		//stop is a pointer to a boolean. We use a pointer to a boolean so the boolean is almost "global" and visible outside of the block
		
		[villains enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if ([obj isEqualToString: @"hitler"]) {
				NSLog(@"Game Over");
				*stop = true; *stop means change the value that stop is pointing to
			}
		}];
		 
		
		NSMutableString *name = [NSMutableString stringWithFormat:@"Darren"];
		[name setString:@"Something else"];
		NSLog(@"%@", name);
		 */
		
		/*
		//9. DICTIONARIES
		
		//literal syntax
		
		NSDictionary *footballerAndClubs = @{
									  @"Barnes": @"Liverpool",
									  @"Wright": @"Arsenal",
									  @"Keane": @"Manchester United"
									  };
		
		for (NSString *player in footballerAndClubs) {
			NSLog(@"The player %@ played for %@", player, footballerAndClubs[player]);
		}
		 */
		
		/*
		//10. SETS
		
		NSSet *odd = [NSSet setWithObjects:@1, @3, @5, @7, nil];
		NSMutableSet *mutableOdd = [odd mutableCopy];
		[mutableOdd addObject:@9];
		[mutableOdd removeAllObjects];
		
		//can also use things like setWithArray to create from an existing NSArray
		//Paul is a big fan of NSCountedSet see page 53, as they are fast for determining number of objects in a set
		*/
		
		/*
		//11. GENERICS
		
		//incredibly this code will build and compile no problem, despite the fact that we are looping over NSStrings yet the array consists of NSNumbers
		
		NSArray *numbers = @[@1, @2, @3, @4];
		
		for (NSString * number in numbers) {
			NSLog(@"%@ is %ld letters in length", number, [number length]);
		}
		
		//so generics were introduced to Obj-C after Swift, but they are not very good, and nowhere near as powerful as in swift
		
		//rewriting above
		NSArray<NSNumber *> *numbersTwo = @[@1, @2, @3, @4];
		
		for (NSString * number in numbersTwo) {
			NSLog(@"%@ is %ld letters in length", number, [number length]);
		}
		
		//and this still works(!) despite the fact that we were explicit in the type being NSNumber for our array...!!.
		//basically, generics in Obj-C are shit
		*/
		
		/*
		//12. NSVALUE
		
		//for storing things like CGRects, CGPoints, and CGSize. Again, Obj-C can only store collections of objects, so for structs (yep, a very rare instance of Obj-C using structs) we wrap the above up in NSNumbers.
		//as Paul correctly states, its a gigantic HACK...! But one we are all stuck with :-(
		
		NSValue *rect = [NSValue valueWithRect:CGRectMake(10, 10, 10, 10)];
		NSValue *point = [NSValue valueWithPoint:CGPointMake(20, 20)];
		*/
		
		//13. NSData - this is exactly the same as in Swift
		//14. NSObject - the universal base class of Obj-C
		
		//15. id - can think of it as "anyobject" or even "every object" (!) since you can run anything against it. This is the one of the main sources of safety issues in Obj-C. Its actually a bit insane. Can literally call any method against an object of type id
		
		/*
		//id is a POINTER to any Obj-C object, which means you dont need a * ...it is there already
		NSArray *foo = [NSArray new];
		id bar = foo; //at this point foo has effectively lost its type information. This is unsafe
//		[bar actionButtonTitle];
		NSArray *baz = bar;
		*/
		
		/*
		//16. NSError
		
		//these generally make use of pointer pointers. Its not as hard as it sounds. Basically, we use them in cases where there is actually NO error in which case it would be a waste to create an error object when not required. If there IS an error, we point the method error variable to an error pointer located outside the method, which can then be used to store the error
		
		//Note: Swift 2.0 onwards uses try/catch in place of the final error variable, so unlikely to see this anymore
		
		NSError *error; //no value
		
		NSString *contents = [NSString stringWithContentsOfFile:@"hello.txt" encoding:nil error:&error]; //& is the pointer to the *error pointer above.
		*/
		
		
		/*
		//17. BLOCKS
		
		//Obj-C equivalent of closures, but a much worse syntax
		
		void (^universalGreeting) (void) = ^{
			NSLog(@"Fuck you");
		};
		
		//void = block returns nothing
		//^universalGreeting = put the block into a universalGreeting variable
		//void = block accepts no parameters
		//^{}  = the actual block itself
		
		universalGreeting();
		
		//calling a block that takes parameters can be tricky
		
		NSString* (^universalGreetingTwo) (NSString*) = ^(NSString *name) {
			return [NSString stringWithFormat:@"Live long and prosper, %@", name];
		};
		
		//NSString* = returns a string
		//(^universalGreetingTwo) = the variable
		//(NSString*) = it accepts a string parameter
		//^(NSString *name) = this block accepts a string parameter
		
		
		NSLog(@"%@", universalGreetingTwo(@"Darren"));
		*/
		
		NSArray *myArray = [NSArray new];
		NSLog(@"%@", myArray.description);
	}
	return 0;
}
