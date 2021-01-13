import XCTest
@testable import Numerizer

final class StringTests: XCTestCase {
  func testMatchesPatternPresent() {
    let isMatch = "Hello, World!".matchesPattern("Hello")
    XCTAssertTrue(isMatch)
  }

  func testMatchesPatternAbsent() {
    let isMatch = "Hello, World!".matchesPattern("Hi")
    XCTAssertFalse(isMatch)
  }

  func testMatchesPatternCaseInsensitive() {
    let isMatch = "Hello, World!".matchesPattern("hELLO", options: [.caseInsensitive])
    XCTAssertTrue(isMatch)
  }

  func testReplaceDynamic() {
    let string = "Hello, World!".replacePattern(#"(\w+),\s(\w+)"#) { (matches: [String]) -> String in
      let one: String = matches[1]
      let two: String = matches[2]
      return "\(two), \(one)"
    }
    XCTAssertEqual(string, "World, Hello!")
  }

  func testReplaceCaseInsensitive() {
    let string = "Hello, World!".replacePattern("hELLO", options: [.caseInsensitive]) { (matches: [String]) -> String in
      "Hi"
    }
    XCTAssertEqual(string, "Hi, World!")
  }

  func testReplaceMultipleOccurrences() {
    let string = "Hello, hello!".replacePattern("ello") { (matches: [String]) -> String in
      "ola"
    }
    XCTAssertEqual(string, "Hola, hola!")
  }

  func testReplaceNoOccurrences() {
    let string = "Hello, World!".replacePattern("x") { (matches: [String]) -> String in
      "y"
    }
    XCTAssertEqual(string, "Hello, World!")
  }

  func testReplaceStatic() {
    let string = "Hello, World!".replacePattern("World", replacement: "Dhruv")
    XCTAssertEqual(string, "Hello, Dhruv!")
  }
}
