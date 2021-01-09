import XCTest
@testable import Numerizer

final class EnglishProviderTests: XCTestCase {
  func testDirectNums() {
    let testCases: [String: Int] = [
      "zero":       0,
      "ten":       10,
      "eleven":    11,
      "twelve":    12,
      "thirteen":  13,
      "fourteen":  14,
      "fifteen":   15,
      "sixteen":   16,
      "seventeen": 17,
      "eighteen":  18,
      "nineteen":  19,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testSingleNums() {
    let testCases: [String: Int] = [
      "one":   1,
      "two":   2,
      "three": 3,
      "four":  4,
      "five":  5,
      "six":   6,
      "seven": 7,
      "eight": 8,
      "nine":  9,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testTenPrefixes() {
    let testCases: [String: Int] = [
      "twenty":  20,
      "thirty":  30,
      "forty":   40,
      "fifty":   50,
      "sixty":   60,
      "seventy": 70,
      "eighty":  80,
      "ninety":  90,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testDoubleDigitNums() {
    let testCases: [String: Int] = [
      "twenty two":  22,
      "thirty two":  32,
      "forty two":   42,
      "fifty two":   52,
      "sixty two":   62,
      "seventy two": 72,
      "eighty two":  82,
      "ninety two":  92,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testBigSuffixes() {
    let testCases: [String: Int] = [
      "hundred":  Int(1e2),
      "thousand": Int(1e3),
      "lakh":     Int(1e5),
      "million":  Int(1e6),
      "crore":    Int(1e7),
      "billion":  Int(1e9),
      "trillion": Int(1e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
      XCTAssertEqual(numerize("a \(words)"), String(num))
    }
  }

  func testBigSuffixesWithDirectNums() {
    let testCases: [String: Int] = [
      "eleven hundred":  Int(11e2), // Indian colloquial
      "eleven thousand": Int(11e3),
      "eleven lakh":     Int(11e5),
      "eleven million":  Int(11e6),
      "eleven crore":    Int(11e7),
      "eleven billion":  Int(11e9),
      "eleven trillion": Int(11e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testBigSuffixesWithSingleNums() {
    let testCases: [String: Int] = [
      "two hundred":  Int(2e2),
      "two thousand": Int(2e3),
      "two lakh":     Int(2e5),
      "two million":  Int(2e6),
      "two crore":    Int(2e7),
      "two billion":  Int(2e9),
      "two trillion": Int(2e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testBigSuffixesWithTenPrefixes() {
    let testCases: [String: Int] = [
      "twenty hundred":  Int(2e3), // Just call it a thousand!
      "twenty thousand": Int(2e4),
      "twenty lakh":     Int(2e6),
      "twenty million":  Int(2e7),
      "twenty crore":    Int(2e8),
      "twenty billion":  Int(2e10),
      "twenty trillion": Int(2e13),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testBigSuffixesWithDoubleDigitNums() {
    let testCases: [String: Int] = [
      "twenty two hundred":  Int(22e2), // Indian colloquial
      "twenty two thousand": Int(22e3),
      "twenty two lakh":     Int(22e5),
      "twenty two million":  Int(22e6),
      "twenty two crore":    Int(22e7),
      "twenty two billion":  Int(22e9),
      "twenty two trillion": Int(22e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testDirectNumFractions() {
    let testCases: [String: Int] = [
      "tenth":       10,
      "twelfth":     12,
      "eleventh":    11, // starts with a vowel
      "thirteenth":  13,
      "fourteenth":  14,
      "fifteenth":   15,
      "sixteenth":   16,
      "seventeenth": 17,
      "eighteenth":  18, // starts with a vowel
      "nineteenth":  19,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), "1/\(num)")
      if ["a", "e", "i", "o", "u"].contains(where: { item in
        words.starts(with: item)
      }) {
        XCTAssertEqual(numerize("an \(words)"), "1/\(num)")
      } else {
        XCTAssertEqual(numerize("a \(words)"), "1/\(num)")
      }
    }
  }

  func testDirectNumFractionsWithNumerator() {
    let testCases: [String: Int] = [
      "tenths":       10,
      "twelfths":     12,
      "elevenths":    11,
      "thirteenths":  13,
      "fourteenths":  14,
      "fifteenths":   15,
      "sixteenths":   16,
      "seventeenths": 17,
      "eighteenths":  18,
      "nineteenths":  19,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize("two \(words)"), "2/\(num)")
    }
  }

  func testDirectNumFractionsWithNumeratorAndInteger() {
    let testCases: [String: String] = [
      "one and two tenths":   "1.200",
      "one and two twelfths": "1.167",
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(numerize(words), num)
    }
  }

  func testSingleNumFractions() {
    let testCases: [String: Int] = [
      "half":    2,
      "third":   3,
      "fourth":  4,
      "quarter": 4,
      "fifth":   5,
      "sixth":   6,
      "seventh": 7,
      "eighth":  8,
      "ninth":   9,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize("a \(words)"), "1/\(num)")
    }
  }

  func testSingleNumFractionsWithNumerator() {
    let testCases: [String: Int] = [
      "halves":   2,
      "thirds":   3,
      "fourths":  4,
      "quarters": 4,
      "fifths":   5,
      "sixths":   6,
      "sevenths": 7,
      "eighths":  8,
      "ninths":   9,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize("two \(words)"), "2/\(num)")
    }
  }

  func testSingleNumFractionsWithNumeratorAndInteger() {
    let testCases: [String: String] = [
      "one and two halves":   "2.000",
      "one and two thirds":   "1.667",
      "one and two fourths":  "1.500",
      "one and two quarters": "1.500",
      "one and two fifths":   "1.400",
      "one and two sixths":   "1.333",
      "one and two sevenths": "1.286",
      "one and two eighths":  "1.250",
      "one and two ninths":   "1.222",
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(numerize(words), num)
    }
  }

  func testComplexIntCombinations() {
    let testCases: [String: Int] = [
      "nine hundred ninety nine": 999, // missing 'and'
      "twenty   one":              21, // multiple spaces
      "twentyone":                 21, // no spaces
      "100 thousand":        Int(1e5), // numbers and strings
      "a billion":           Int(1e9), // article instead of number
      "one fifty five":           155, // missing 'hundred'
      "two nineteen":             219, // missing 'hundred'
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(numerize(words), String(num))
    }
  }

  func testComplexFloatCombinations() {
    let testCases: [String: String] = [
      "two one fifth": "2.200", // missing 'and'
      "zero and a fifth": "0.200", // zero as the integer
      "two halves": "2/2" // not equal to 1
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(numerize(words), num)
    }
  }
}
