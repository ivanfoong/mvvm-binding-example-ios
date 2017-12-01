//
//  ViewModelTests.swift
//  MVVMBinding ExampleTests
//
//  Created by Ivan Foong on 30/11/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import XCTest
@testable import MVVMBinding_Example

class ViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit() {
        let expectedInitialSeconds = 10
        let expectedTextFieldText = String(expectedInitialSeconds)
        let expectedButtonText = "Start"
        var actualTextFieldText: String?
        var actualButtonText: String?
        
        let viewModel = ViewModel(initialSecondsRemaining: expectedInitialSeconds)
        
        let textFieldTextUpdateClosureCalledExpectation = self.expectation(description: "textFieldTextUpdateClosureCalledExpectation")
        let buttonTextUpdateClosureCalledExpectation = self.expectation(description: "buttonTextUpdateClosureCalledExpectation")
        
        viewModel.textFieldText.bindAndFire { text in
            actualTextFieldText = text
            textFieldTextUpdateClosureCalledExpectation.fulfill()
        }
        
        viewModel.buttonText.bindAndFire { text in
            actualButtonText = text
            buttonTextUpdateClosureCalledExpectation.fulfill()
        }
        
        self.wait(for: [textFieldTextUpdateClosureCalledExpectation, buttonTextUpdateClosureCalledExpectation], timeout: 10)
        
        XCTAssertEqual(expectedTextFieldText, actualTextFieldText)
        XCTAssertEqual(expectedButtonText, actualButtonText)
    }
    
    func testInit_empty() {
        let expectedInitialSeconds = 10
        let expectedTextFieldText = String(expectedInitialSeconds)
        let expectedButtonText = "Start"
        var actualTextFieldText: String?
        var actualButtonText: String?
        
        let viewModel = ViewModel()
        
        let textFieldTextUpdateClosureCalledExpectation = self.expectation(description: "textFieldTextUpdateClosureCalledExpectation")
        let buttonTextUpdateClosureCalledExpectation = self.expectation(description: "buttonTextUpdateClosureCalledExpectation")
        
        viewModel.textFieldText.bindAndFire { text in
            actualTextFieldText = text
            textFieldTextUpdateClosureCalledExpectation.fulfill()
        }
        
        viewModel.buttonText.bindAndFire { text in
            actualButtonText = text
            buttonTextUpdateClosureCalledExpectation.fulfill()
        }
        
        self.wait(for: [textFieldTextUpdateClosureCalledExpectation, buttonTextUpdateClosureCalledExpectation], timeout: 10)
        
        XCTAssertEqual(expectedTextFieldText, actualTextFieldText)
        XCTAssertEqual(expectedButtonText, actualButtonText)
    }
    
    func testButtonTapped() {
        let expectedInitialSeconds = 2
        var expectedTextFieldTextSequence: [String?] {
            var sequence: [String] = []
            for seconds in 0...expectedInitialSeconds {
                sequence.insert(String(seconds), at: 0)
            }
            sequence.append(String(expectedInitialSeconds))
            return sequence
        }
        
        let expectedButtonTextSequence: [String?] = [
            "Start", "Pause", "Start"
        ]
        
        var actualTextFieldTextSequence: [String?] = []
        var actualButtonTextSequence: [String?] = []
        
        let viewModel = ViewModel(initialSecondsRemaining: expectedInitialSeconds)
        
        let textFieldTextUpdateClosureCalledWithCorrectValueExpectation = self.expectation(description: "textFieldTextUpdateClosureCalledWithExpectedResponse")
        let buttonTextUpdateClosureCalledWithCorrectValueExpectation = self.expectation(description: "buttonTextUpdateClosureCalledWithCorrectValueExpectation")
        
        viewModel.textFieldText.bindAndFire { text in
            if actualTextFieldTextSequence.count == 0 {
                actualTextFieldTextSequence.append(text)
            }
            else if let last = actualTextFieldTextSequence.last, last != text {
                actualTextFieldTextSequence.append(text)
            }
            if expectedTextFieldTextSequence == actualTextFieldTextSequence {
                textFieldTextUpdateClosureCalledWithCorrectValueExpectation.fulfill()
            }
        }
        
        viewModel.buttonText.bindAndFire { text in
            if actualButtonTextSequence.count == 0 {
                actualButtonTextSequence.append(text)
            }
            else if let last = actualButtonTextSequence.last, last != text {
                actualButtonTextSequence.append(text)
            }
            if expectedButtonTextSequence == actualButtonTextSequence {
                buttonTextUpdateClosureCalledWithCorrectValueExpectation.fulfill()
            }
        }
        
        viewModel.buttonTapped()
        
        self.wait(for: [textFieldTextUpdateClosureCalledWithCorrectValueExpectation, buttonTextUpdateClosureCalledWithCorrectValueExpectation], timeout: TimeInterval(expectedInitialSeconds+2))
    }
    
    func testStart() {
        let expectedInitialSeconds = 2
        var expectedTextFieldTextSequence: [String?] {
            var sequence: [String] = []
            for seconds in 0...expectedInitialSeconds {
                sequence.insert(String(seconds), at: 0)
            }
            sequence.append(String(expectedInitialSeconds))
            return sequence
        }
        
        let expectedButtonTextSequence: [String?] = [
            "Start", "Pause", "Start"
        ]
        
        var actualTextFieldTextSequence: [String?] = []
        var actualButtonTextSequence: [String?] = []
        
        let viewModel = ViewModel(initialSecondsRemaining: expectedInitialSeconds)
        
        let textFieldTextUpdateClosureCalledWithCorrectValueExpectation = self.expectation(description: "textFieldTextUpdateClosureCalledWithExpectedResponse")
        let buttonTextUpdateClosureCalledWithCorrectValueExpectation = self.expectation(description: "buttonTextUpdateClosureCalledWithCorrectValueExpectation")
        
        viewModel.textFieldText.bindAndFire { text in
            if actualTextFieldTextSequence.count == 0 {
                actualTextFieldTextSequence.append(text)
            }
            else if let last = actualTextFieldTextSequence.last, last != text {
                actualTextFieldTextSequence.append(text)
            }
            if expectedTextFieldTextSequence == actualTextFieldTextSequence {
                textFieldTextUpdateClosureCalledWithCorrectValueExpectation.fulfill()
            }
        }
        
        viewModel.buttonText.bindAndFire { text in
            if actualButtonTextSequence.count == 0 {
                actualButtonTextSequence.append(text)
            }
            else if let last = actualButtonTextSequence.last, last != text {
                actualButtonTextSequence.append(text)
            }
            if expectedButtonTextSequence == actualButtonTextSequence {
                buttonTextUpdateClosureCalledWithCorrectValueExpectation.fulfill()
            }
        }
        
        viewModel.start()
        
        self.wait(for: [textFieldTextUpdateClosureCalledWithCorrectValueExpectation, buttonTextUpdateClosureCalledWithCorrectValueExpectation], timeout: TimeInterval(expectedInitialSeconds+2))
    }
    
    func testStop() {
        let expectedInitialSeconds = 2
        let expectedTextFieldTextSequence: [String] = [String(2), String(1), String(2)]
        let expectedButtonTextSequence: [String] = [
            "Start", "Pause", "Start"
        ]
        
        var actualTextFieldTextSequence: [String] = []
        var actualButtonTextSequence: [String] = []
        
        let viewModel = ViewModel(initialSecondsRemaining: expectedInitialSeconds)
        
        let textFieldTextUpdateClosureCalledWithCorrectValueExpectation = self.expectation(description: "textFieldTextUpdateClosureCalledWithExpectedResponse")
        let buttonTextUpdateClosureCalledWithCorrectValueExpectation = self.expectation(description: "buttonTextUpdateClosureCalledWithCorrectValueExpectation")
        
        viewModel.textFieldText.bindAndFire { text in
//            guard let text = text else {
//                return
//            }
//            print(actualTextFieldTextSequence)
//            if actualTextFieldTextSequence.count == 0 {
//                actualTextFieldTextSequence.append(text)
//            }
//            else if let last = actualTextFieldTextSequence.last, last != text {
//                actualTextFieldTextSequence.append(text)
//            }
//            if text == String(1) {
//                viewModel.stop()
//            }
//            if expectedTextFieldTextSequence == actualTextFieldTextSequence {
//                viewModel.textFieldText.unbind()
//                textFieldTextUpdateClosureCalledWithCorrectValueExpectation.fulfill()
//            }
        }
        
        viewModel.buttonText.bindAndFire { text in
//            guard let text = text else {
//                return
//            }
//            if actualButtonTextSequence.count == 0 {
//                actualButtonTextSequence.append(text)
//            }
//            else if let last = actualButtonTextSequence.last, last != text {
//                actualButtonTextSequence.append(text)
//            }
//            if expectedButtonTextSequence == actualButtonTextSequence {
//                viewModel.buttonText.unbind()
//                buttonTextUpdateClosureCalledWithCorrectValueExpectation.fulfill()
//            }
        }
        
        viewModel.start()
        
        self.wait(for: [textFieldTextUpdateClosureCalledWithCorrectValueExpectation, buttonTextUpdateClosureCalledWithCorrectValueExpectation], timeout: 20)
    }
    
    func testPause() {
        XCTFail("Not implemented")
    }
    
    func testReset() {
        XCTFail("Not implemented")
    }
}

func ==<T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    if lhs.count != rhs.count { return false }
    for (l,r) in zip(lhs,rhs) {
        if l != r { return false }
    }
    return true
}
