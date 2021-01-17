import XCTest
@testable import Numerizer

final class LatinProviderTests: XCTestCase {
  var provider: LatinProvider = LatinProvider()

  /*
   preProcess
   */

  func testCaseNormalization() {
    let testCases: [String: String] = [
      "tWeNtY   One":  "twenty one",
    ]
    for (input, output): (String, String) in testCases {
      XCTAssertEqual(provider.preProcess(input), output)
    }
  }

  func testMultipleSpaces() {
    let testCases: [String: String] = [
      "twenty   one":  "twenty one",
    ]
    for (input, output): (String, String) in testCases {
      XCTAssertEqual(provider.preProcess(input), output)
    }
  }

  func testHyphens() {
    let testCases: [String: String] = [
      "twenty-one": "twenty one",
    ]
    for (input, output): (String, String) in testCases {
      XCTAssertEqual(provider.preProcess(input), output)
    }
  }

  func testTrailingArticles() {
    let testCases: [String: String] = [
      "twenty a":  "twenty",
      "twenty an": "twenty",
    ]
    for (input, output): (String, String) in testCases {
      XCTAssertEqual(provider.preProcess(input), output)
    }
  }

  /*
   postProcess
   */

  func testLeftoverNums() {
    let testCases: [String: String] = [
      "<num>20": "20",
    ]
    for (input, output): (String, String) in testCases {
      XCTAssertEqual(provider.postProcess(input), output)
    }
  }

  /*
   Test numerals
   */

  func testImplicitHundredsWithTensPrefixes() {
    let testCases: [String: Int] = [
      "two twenty":  220,
      "two thirty":  230,
      "two forty":   240,
      "two fifty":   250,
      "two sixty":   260,
      "two seventy": 270,
      "two eighty":  280,
      "two ninety":  290,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testImplicitHundredsWithDirectNums() {
    let testCases: [String: Int] = [
      "two ten":       210,
      "two eleven":    211,
      "two twelve":    212,
      "two thirteen":  213,
      "two fourteen":  214,
      "two fifteen":   215,
      "two sixteen":   216,
      "two seventeen": 217,
      "two eighteen":  218,
      "two nineteen":  219,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

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
      XCTAssertEqual(provider.parse(words), String(num))
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
      XCTAssertEqual(provider.parse(words), String(num))
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
      XCTAssertEqual(provider.parse(words), String(num))
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
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  /*
   Test fractions
   */

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
      XCTAssertEqual(provider.parse("two \(words)"), "2/\(num)")
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
      XCTAssertEqual(provider.parse("two \(words)"), "2/\(num)")
    }
  }

  func testTensPrefixFractionsWithNumerator() {
    let testCases: [String: Int] = [
      "twentieths":  20,
      "thirtieths":  30,
      "fortieths":   40,
      "fiftieths":   50,
      "sixtieths":   60,
      "seventieths": 70,
      "eightieths":  80,
      "ninetieths":  90,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse("two \(words)"), "2/\(num)")
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
      XCTAssertEqual(provider.parse(words), "1/\(num)")
      if ["a", "e", "i", "o", "u"].contains(where: { item in
        words.starts(with: item)
      }) {
        XCTAssertEqual(provider.parse("an \(words)"), "1/\(num)")
      } else {
        XCTAssertEqual(provider.parse("a \(words)"), "1/\(num)")
      }
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
      XCTAssertEqual(provider.parse(words), "1/\(num)")
      if ["a", "e", "i", "o", "u"].contains(where: { item in
        words.starts(with: item)
      }) {
        XCTAssertEqual(provider.parse("an \(words)"), "1/\(num)")
      } else {
        XCTAssertEqual(provider.parse("a \(words)"), "1/\(num)")
      }
    }
  }

  func testTensPrefixFractions() {
    let testCases: [String: Int] = [
      "twentieths":  20,
      "thirtieths":  30,
      "fortieths":   40,
      "fiftieths":   50,
      "sixtieths":   60,
      "seventieths": 70,
      "eightieths":  80,
      "ninetieths":  90,
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), "1/\(num)")
      if ["a", "e", "i", "o", "u"].contains(where: { item in
        words.starts(with: item)
      }) {
        XCTAssertEqual(provider.parse("an \(words)"), "1/\(num)")
      } else {
        XCTAssertEqual(provider.parse("a \(words)"), "1/\(num)")
      }
    }
  }

  func testDirectNumFractionsWithNumeratorAndWhole() {
    let testCases: [String: String] = [
      "one and two tenths":       "1.200",
      "one and two elevenths":    "1.182",
      "one and two twelfths":     "1.167",
      "one and two thirteenths":  "1.154",
      "one and two fourteenths":  "1.143",
      "one and two fifteenths":   "1.133",
      "one and two sixteenths":   "1.125",
      "one and two seventeenths": "1.118",
      "one and two eighteenths":  "1.111",
      "one and two nineteenths":  "1.105",
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(provider.parse(words), num)
    }
  }

  func testSingleNumFractionsWithNumeratorAndWhole() {
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
      XCTAssertEqual(provider.parse(words), num)
    }
  }

  func testTensPrefixFractionsWithNumeratorAndWhole() {
    let testCases: [String: String] = [
      "one and two twentieths":    "1.100",
      "one and three thirtieths":  "1.100",
      "one and four fortieths":    "1.100",
      "one and five fiftieths":    "1.100",
      "one and six sixtieths":     "1.100",
      "one and seven seventieths": "1.100",
      "one and eight eightieths":  "1.100",
      "one and nine ninetieths":   "1.100",
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(provider.parse(words), num)
    }
  }

  /*
   Test big suffixes
   */

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
      XCTAssertEqual(provider.parse(words), String(num))
      XCTAssertEqual(provider.parse("a \(words)"), String(num))
    }
  }

  func testBigSuffixesOnImplicitHundredsWithTensPrefixes() {
    let testCases: [String: Int] = [
      "one twenty thousand": Int(120e3),
      "one twenty lakh":     Int(120e5),
      "one twenty million":  Int(120e6),
      "one twenty crore":    Int(120e7),
      "one twenty billion":  Int(120e9),
      "one twenty trillion": Int(120e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testBigSuffixesOnImplicitHundredsWithDirectNums() {
    let testCases: [String: Int] = [
      "two nineteen thousand": Int(219e3),
      "two nineteen lakh":     Int(219e5),
      "two nineteen million":  Int(219e6),
      "two nineteen crore":    Int(219e7),
      "two nineteen billion":  Int(219e9),
      "two nineteen trillion": Int(219e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testBigSuffixesOnDirectNums() {
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
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testBigSuffixesOnSingleNums() {
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
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testBigSuffixesOnDoubleDigitNums() {
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
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testBigSuffixesOnTenPrefixes() {
    let testCases: [String: Int] = [
      "twenty hundred":  Int(20e2), // Better to say 'two thousand'
      "twenty thousand": Int(20e3),
      "twenty lakh":     Int(20e5),
      "twenty million":  Int(20e6),
      "twenty crore":    Int(20e7),
      "twenty billion":  Int(20e9),
      "twenty trillion": Int(20e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testBigSuffixesOnSmallerBigSuffixes() {
    let testCases: [String: Int] = [
      "hundred thousand": Int(100e3),
      "hundred lakh":     Int(100e5), // Better to say 'crore'
      "hundred million":  Int(100e6),
      "hundred crore":    Int(100e7),
      "hundred billion":  Int(100e9),
      "hundred trillion": Int(100e12),
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
      XCTAssertEqual(provider.parse("a \(words)"), String(num))
    }
  }

  /**
   Test complex combinations
   */

  func testComplexIntCombinations() {
    let testCases: [String: Int] = [
      "a thousand and a hundred": 1100, // non-trailing 'a's
      "thousand and hundred":     1100, // no multipliers or articles
      "thousand hundred":         1100, // no conjunctions
      "lakh thousand hundred":  101100, // longer chain of suffixes
      "two and hundred":           102, // addition using 'and'
      "nine hundred ninety nine":  999, // missing 'and'
      "twentyone":                  21, // no spaces
      "100 thousand":         Int(1e5), // numbers and strings
      "million billion":     Int(1e15), // big suffix on smaller big suffix
    ]
    for (words, num): (String, Int) in testCases {
      XCTAssertEqual(provider.parse(words), String(num))
    }
  }

  func testComplexFloatCombinations() {
    let testCases: [String: String] = [
      "two one fifth":    "2.200", // missing 'and'
      "zero and a fifth": "0.200", // zero as the integer
      "two halves":         "2/2", // not equal to 1
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(provider.parse(words), num)
    }
  }

  func testTotalCombination() {
    let testCases: [String: String] = [
      "two nineteen billion a hundred and fifty five million eleven thousand and ninety one and two fifths": "219155011091.400"
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(provider.parse(words), num)
    }
  }

  func testExceptions() {
    let testCases: [String: String] = [
      "pennyweight": "pennyweight",
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(provider.parse(words), num)
    }
  }

  /**
   Tests time-related transformations for compatibility with
   [Duri](https://github.com/dhruvkb/Duri), a related library for parsing
   durations from natural language strings.

   - SeeAlso: [Duri](https://github.com/dhruvkb/Duri)
   */
  func testDuriCompatibility() {
    let testCases: [String: String] = [
      "three and a half hours": "3.500 hours",
      "21 Sep 2002 12:01am": "21 sep 2002 12:01am",
      "21/09/2002": "21/09/2002",
//      "half an hour": "1/2 an hour",
    ]
    for (words, num): (String, String) in testCases {
      XCTAssertEqual(provider.parse(words), num)
    }
  }
}
