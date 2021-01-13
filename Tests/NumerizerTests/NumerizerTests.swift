import XCTest
@testable import Numerizer

final class NumerizerTests: XCTestCase {
  func testWithDefaultProvider() {
    let numerizer: Numerizer = try! Numerizer()
    XCTAssertEqual(numerizer.numerize("forty two"), "42")
  }

  func testWithEnglishProvider() {
    let numerizer: Numerizer = try! Numerizer(localeChoice: LocaleChoice.en)
    XCTAssertEqual(numerizer.numerize("forty two"), "42")
  }
}
