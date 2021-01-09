import XCTest
@testable import Numerizer

final class StringTests: XCTestCase {
  func testReplaceDynamic() {
    let string = "Hello, World!".replace(#"(\w+),\s(\w+)"#) { (matches: [String]) -> String in
      let one: String = matches[1]
      let two: String = matches[2]
      return "\(two), \(one)"
    }
    XCTAssertEqual(string, "World, Hello!")
  }

  func testNoOccurrences() {
    let string = "Hello, World!".replace("x") { (matches: [String]) -> String in
      "y"
    }
    XCTAssertEqual(string, "Hello, World!")
  }

  func testMultipleOccurrences() {
    let string = "Hello, hello!".replace("ello") { (matches: [String]) -> String in
      "ola"
    }
    XCTAssertEqual(string, "Hola, hola!")
  }

  func testReplaceStatic() {
    let string = "Hello, World!".replace("World", replacement: "Dhruv")
    XCTAssertEqual(string, "Hello, Dhruv!")
  }
}
