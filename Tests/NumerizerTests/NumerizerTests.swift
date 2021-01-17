import XCTest
@testable import Numerizer

final class NumerizerTests: XCTestCase {
  func testWithDefaultProvider() {
    let numerizer: Numerizer = try! Numerizer()
    XCTAssertEqual(numerizer.parse("forty two"), "42")
  }

  func testWithEnglishProvider() {
    let numerizer: Numerizer = try! Numerizer(numberingSystem: NumberingSystem.latn)
    XCTAssertEqual(numerizer.parse("forty two"), "42")
  }

  func testWithUnsupportedProvider() {
    var error: Error?
    XCTAssertThrowsError(try Numerizer(numberingSystem: NumberingSystem.roman)) { (err: Error) in
      error = err
    }
    XCTAssertTrue(error is NumerizerError)
    XCTAssertEqual(error as? NumerizerError, NumerizerError.unsupportedNumberingSystem)
  }
}
