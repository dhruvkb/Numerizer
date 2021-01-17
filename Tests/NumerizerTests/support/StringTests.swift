import XCTest

final class StringTests: XCTestCase {
  func testMatchesPatternPresent() {
    let isMatch = "Hello, World!".matches(pattern: "Hello")
    XCTAssertTrue(isMatch)
  }

  func testMatchesPatternAbsent() {
    let isMatch = "Hello, World!".matches(pattern: "Hi")
    XCTAssertFalse(isMatch)
  }

  func testMatchesPatternCaseInsensitive() {
    let isMatch = "Hello, World!".matches(pattern: "hELLO", options: [.caseInsensitive])
    XCTAssertTrue(isMatch)
  }

  func testReplaceDynamic() {
    let string = "Hello, World!".replace(pattern: #"(\w+),\s(\w+)"#) { (matches: [String]) -> String in
      let one: String = matches[1]
      let two: String = matches[2]
      return "\(two), \(one)"
    }
    XCTAssertEqual(string, "World, Hello!")
  }

  func testReplaceCaseInsensitive() {
    let string = "Hello, World!".replace(pattern: "hELLO", options: [.caseInsensitive]) { (matches: [String]) -> String in
      "Hi"
    }
    XCTAssertEqual(string, "Hi, World!")
  }

  func testReplaceMultipleOccurrences() {
    let string = "Hello, hello!".replace(pattern: "ello") { (matches: [String]) -> String in
      "ola"
    }
    XCTAssertEqual(string, "Hola, hola!")
  }

  func testReplaceNoOccurrences() {
    let string = "Hello, World!".replace(pattern: "x") { (matches: [String]) -> String in
      "y"
    }
    XCTAssertEqual(string, "Hello, World!")
  }

  func testReplaceStatic() {
    let string = "Hello, World!".replace(pattern: "World", with: "Dhruv")
    XCTAssertEqual(string, "Hello, Dhruv!")
  }
}
