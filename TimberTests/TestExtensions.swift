//
//  TestExtensions.swift
//  Timber
//
//  Created by Scott Petit on 9/16/14.
//  Copyright (c) 2014 Scott Petit. All rights reserved.
//

import Foundation
import XCTest

func wait() {
    waitForSeconds(1.0)
}

func waitForSeconds(seconds: NSTimeInterval) {
    NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: seconds))
}

extension String {
    func shouldEqual(string: String) {
        let description = "Expected \(self) to equal \(string)"
        XCTAssertEqual(self, string, description)
    }
    
    func shouldContain(string: String) {
        let description = "Expected \(self) to contain \(string)"
        XCTAssertTrue(self.rangeOfString(string) != nil, description)
    }
    
    func shouldHavePrefix(string: String) {
        let description = "Expected \(self) to have a prefix of \(string)"
        XCTAssertTrue(self.hasPrefix(string), description)
    }
    
    func shouldHaveSuffix(string: String) {
        let description = "Expected \(self) to have a suffic of \(string)"
        XCTAssertTrue(self.hasSuffix(string), description)
    }
}

extension Character {
    func shouldEqual(character: Character) {
        let description = "Expected \(self) to equal \(character)"
        XCTAssertEqual(self, character, description)
    }
}

extension Int {
    func shouldEqual(int: Int) {
        let description = "Expected \(self) to equal \(int)"
        XCTAssertEqual(self, int, description)
    }
    
    func shouldBeGreaterThan(int: Int) {
        let description = "Expected \(self) to be greater than \(int)"
        XCTAssertTrue(self > int, description)
    }
    
    func shouldBeLessThan(int: Int) {
        let description = "Expected \(self) to be less than \(int)"
        XCTAssertTrue(self < int, description)
    }
    
    func shouldBeGreaterThanOrEqualTo(int: Int) {
        let description = "Expected \(self) to be greater than or equal to \(int)"
        XCTAssertTrue(self >= int, description)
    }
    
    func shouldBeLessThanOrEqualTo(int: Int) {
        let description = "Expected \(self) to be less than or equal to \(int)"
        XCTAssertTrue(self <= int, description)
    }
}

extension Float {
    func shouldEqual(float: Float) {
        let description = "Expected \(self) to equal \(float)"
        XCTAssertEqual(self, float, description)
    }
    
    func shouldBeGreaterThan(float: Float) {
        let description = "Expected \(self) to be greater than \(float)"
        XCTAssertTrue(self > float, description)
    }
    
    func shouldBeLessThan(float: Float) {
        let description = "Expected \(self) to be less than \(float)"
        XCTAssertTrue(self < float, description)
    }
    
    func shouldBeGreaterThanOrEqualTo(float: Float) {
        let description = "Expected \(self) to be greater than or equal to \(float)"
        XCTAssertTrue(self >= float, description)
    }
    
    func shouldBeLessThanOrEqualTo(float: Float) {
        let description = "Expected \(self) to be less than or equal to \(float)"
        XCTAssertTrue(self <= float, description)
    }
    
    func shouldBeCloseTo(float: Float, withAccuracy accuracy: Float) {
        let description = "Expected \(self) to be within \(accuracy) of \(float)"
        XCTAssertEqualWithAccuracy(self, float, accuracy, description)
    }
}

extension Double {
    func shouldEqual(double: Double) {
        let description = "Expected \(self) to equal \(double)"
        XCTAssertEqual(self, double, description)
    }
    
    func shouldBeGreaterThan(double: Double) {
        let description = "Expected \(self) to be greater than \(double)"
        XCTAssertTrue(self > double, description)
    }
    
    func shouldBeLessThan(double: Double) {
        let description = "Expected \(self) to be less than \(double)"
        XCTAssertTrue(self < double, description)
    }
    
    func shouldBeGreaterThanOrEqualTo(double: Double) {
        let description = "Expected \(self) to be greater than or equal to \(double)"
        XCTAssertTrue(self >= double, description)
    }
    
    func shouldBeLessThanOrEqualTo(double: Double) {
        let description = "Expected \(self) to be less than or equal to \(double)"
        XCTAssertTrue(self <= double, description)
    }
    
    func shouldBeCloseTo(double: Double, withAccuracy accuracy: Double) {
        let description = "Expected \(self) to be within \(accuracy) of \(double)"
        XCTAssertEqualWithAccuracy(self, double, accuracy, description)
    }
}

extension Bool {
    func shouldBeTrue() {
        let description = "Expected \(self) to be true"
        XCTAssertTrue(self, description)
    }
    
    func shouldBeFalse() {
        let description = "Expected \(self) to be false"
        XCTAssertFalse(self, description)
    }
}

extension NSObject {
    func shouldEqual(object: NSObject) {
        let description = "Expected \(self) to equal \(object)"
        XCTAssertEqual(self, object, description)
    }
}