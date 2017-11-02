//
//  JumpTests.m
//  JumpTests
//
//  Created by xueyognwei on 2017/7/20.
//  Copyright © 2017年 xueyognwei. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GameRuleManager.h"
@interface JumpTests : XCTestCase
@property (nonatomic,assign) NSInteger index;
@end

@implementation JumpTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
-(void)setIndex:(NSInteger)index
{
    _index = index;
    
}
- (void)testExample {
    self.index+1;
//    NSArray *ar = @[@(0.5),@(0.4),@(0.2)];
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
