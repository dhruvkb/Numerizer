import Foundation

/**
 Holds constants pertaining to the English Indo-Arabic decimal number system.

 - Authors: Dhruv Bhanushali
 */
class EnglishProvider: Provider {
  required init() {}

  private let DIRECT_NUMS: [(pattern: String, num: Int)] = [
    (pattern: "zero",               num:  0),
    (pattern: "ten",                num: 10),
    (pattern: "eleven",             num: 11),
    (pattern: "twelve",             num: 12),
    (pattern: "thirteen",           num: 13),
    (pattern: "fourteen",           num: 14),
    (pattern: "fifteen",            num: 15),
    (pattern: "sixteen",            num: 16),
    (pattern: "seventeen",          num: 17),
    (pattern: "eighteen",           num: 18),
    (pattern: "nineteen",           num: 19),
  ]

  private let SINGLE_NUMS: [(pattern: String, num: Int)] = [
    (pattern: "one",                num: 1),
    (pattern: "two",                num: 2),
    (pattern: "three",              num: 3),
    (pattern: "four",               num: 4),
    (pattern: "five",               num: 5),
    (pattern: "six",                num: 6),
    (pattern: "seven",              num: 7),
    (pattern: "eight",              num: 8),
    (pattern: "nine",               num: 9),
  ]

  private let TENS_PREFIXES: [(pattern: String, num: Int)] = [
    (pattern: "twenty",             num: 2),
    (pattern: "thirty",             num: 3),
    (pattern: "forty",              num: 4),
    (pattern: "fifty",              num: 5),
    (pattern: "sixty",              num: 6),
    (pattern: "seventy",            num: 7),
    (pattern: "eighty",             num: 8),
    (pattern: "ninety",             num: 9),
  ]

  private let BIG_SUFFIXES: [(pattern: String, num: Int)] = [
    (pattern: "hundred",            num: Int(1e2)),
    (pattern: "thousand",           num: Int(1e3)),
    (pattern: "lakh",               num: Int(1e5)),
    (pattern: "million",            num: Int(1e6)),
    (pattern: "crore",              num: Int(1e7)),
    (pattern: "billion",            num: Int(1e9)),
    (pattern: "trillion",           num: Int(1e12)),
  ]

  private let DIRECT_NUM_FRACTIONS: [(pattern: String, num: Int)] = [
    (pattern: "tenths?",            num: 10),
    (pattern: "elevenths?",         num: 11),
    (pattern: "twelfths?",          num: 12),
    (pattern: "thirteenths?",       num: 13),
    (pattern: "fourteenths?",       num: 14),
    (pattern: "fifteenths?",        num: 15),
    (pattern: "sixteenths?",        num: 16),
    (pattern: "seventeenths?",      num: 17),
    (pattern: "eighteenths?",       num: 18),
    (pattern: "nineteenths?",       num: 19),
  ]

  private let SINGLE_NUM_FRACTIONS: [(pattern: String, num: Int)] = [
    (pattern: "hal(f|ves)",         num: 2),
    (pattern: "thirds?",            num: 3),
    (pattern: "(fourth|quarter)s?", num: 4),
    (pattern: "fifths?",            num: 5),
    (pattern: "sixths?",            num: 6),
    (pattern: "sevenths?",          num: 7),
    (pattern: "eighths?",           num: 8),
    (pattern: "ninths?",            num: 9),
  ]

  private let TENS_PREFIX_FRACTIONS: [(pattern: String, num: Int)] = [
    (pattern: "twentieths?",        num: 20),
    (pattern: "thirtieths?",        num: 30),
    (pattern: "fortieths?",         num: 40),
    (pattern: "fiftieths?",         num: 50),
    (pattern: "sixtieths?",         num: 60),
    (pattern: "seventieths?",       num: 70),
    (pattern: "eightieths?",        num: 80),
    (pattern: "ninetieths?",        num: 90),
  ]

  /**
   Prepares the given string for processing.

   The function performs the following operations on the given string:
   * lowercases the string
   * combines multiple spaces
   * mutilates hyphenated words
   * removes trailing articles

   - Parameters:
     - text: the string to prepare for processing
   */
  func preProcess(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    // Lowercases the string
    string = string.lowercased()

    // Combines multiple spaces
    string = string.replace(pattern: #"\s+"#, with: " ")

    // Mutilates hyphenated words
    string = string.replace(pattern: #"([^\d])-([^\d])"#) { (matches: [String]) -> String in
      "\(matches[1]) \(matches[2])"
    }

    // Removes trailing articles
    string = string
      .replace(pattern: #"\ban?$"#, with: "")
      .trimmingCharacters(in: .whitespacesAndNewlines)

    return string
  }

  /**
   Parses straight-forward numerals from the given string.

   This function performs the following operations on the given string:
   * handles implicit hundreds
   * performs simple replacements
   * replaces indefinite articles with 1
   * replaces two digit numbers that have tens' prefixes

   - Parameters:
     - text: the string from which to parse numerals
   */
  func numerizeNumerals(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    // Handles implicit hundreds
    let single_nums: String = SINGLE_NUMS.map { (pattern: String, _) -> String in
      pattern
    }.joined(separator: "|")
    let direct_nums: String = DIRECT_NUMS.map { (pattern: String, _) -> String in
      pattern
    }.joined(separator: "|")
    let tens_prefixes: String = TENS_PREFIXES.map { (pattern: String, _) -> String in
      pattern
    }.joined(separator: "|")
    string = string.replace(pattern: #"(?<=^|\W)(\#(single_nums))\s(\#(tens_prefixes)|\#(direct_nums))(?=$|\W)"#) { (matches: [String]) -> String in
      let multiplier: String = matches[1]
      let addendum: String = matches[2]
      return "\(multiplier) hundred \(addendum)"
    }

    // Performs simple replacements
    for (pattern, num) in DIRECT_NUMS + SINGLE_NUMS {
      string = string.replace(pattern: #"(?<=^|\W)\#(pattern)(?=$|\W)"#) { (matches: [String]) -> String in
        "<num>\(num)"
      }
    }

    // Replaces indefinite articles with 1
    string = string.replace(pattern: #"(?<=^|\W)\ban?\b(?=$|\W)"#, with: "<num>1")

    // Replaces two digit numbers that have tens' prefixes
    for (tp_pattern, tp_num) in TENS_PREFIXES {
      let tp_val: Int = tp_num * 10
      for (sn_pattern, sn_num) in SINGLE_NUMS {
        string = string.replace(pattern: #"(?<=^|\W)\#(tp_pattern)\#(sn_pattern)(?=$|\W)"#) { (matches: [String]) -> String in
          "<num>\(tp_val + sn_num)"
        }
      }
      string = string.replace(pattern: #"(?<=^|\W)\#(tp_pattern)(?=$|\W)"#) { (matches: [String]) -> String in
        "<num>\(tp_val)"
      }
    }

    return string
  }

  /**
   Parses fractions from the given string.

   This function performs the following operations on the given string:
   * performs simple replacements
   * calculates fractions as decmimals when preceeded by number
   * processes unpreceeded fractions

   - Parameters:
     - text: the string from which to parse fractions
   */
  func numerizeFractions(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    // Performs simple replacements
    for (pattern, num) in DIRECT_NUM_FRACTIONS + SINGLE_NUM_FRACTIONS + TENS_PREFIX_FRACTIONS {
      string = string
        .replace(pattern: #"an?\s\#(pattern)(?=$|\W)"#, with: "<num>1/\(num)")
        .replace(pattern: #"(^|\W)\#(pattern)(?=$|\W)"#, with: "/\(num)")
    }

    // Calculates fractions as decmimals when preceeded by number
    string = string.replace(pattern: #"(\d+)(?:\s|\sand\s|-)+(?:<num>|\s)*(\d+)\s*\/\s*(\d+)"#) { (matches: [String]) -> String in
      let whole: Float = Float(matches[1])!
      let numerator: Float = Float(matches[2])!
      let denominator: Float = Float(matches[3])!
      let total: Float = whole + (numerator / denominator)
      return String(format: "%.3f", total)
    }

    // Processes unpreceeded fractions
    string = string
      .replace(pattern: #"(?:^|\W)\/(\d+)"#) { (matches: [String]) -> String in
        "1/\(matches[1])"
      }.replace(pattern: #"(?<=\w+)\/(\d+)"#) { (matches: [String]) -> String in
        "1/\(matches[1])"
      }

    return string
  }

  /**
   Parses numerals with big suffixes from the given string.

   This function performs the following operations on the given string:
   * processes the suffixes for magnitudes

   - Parameters:
     - text: the string from which to parse numerals
   */
  func numerizeBigSuffixes(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    // Processes the suffixes for magnitudes
    string = andition(string) // first andition, for the tens before the hundreds
    for (pattern, num) in BIG_SUFFIXES {
      string = string.replace(pattern: #"(?:<num>)?(\d*)\s?\#(pattern)"#) { (matches: [String]) -> String in
        let base: Int = Int(matches[1]) ?? 1
        let total: Int = num * base
        return "<num>\(String(total))"
      }
      string = andition(string)
    }
    string = andition(string) // final andition, for any 'and's that may remain

    return string
  }

  /**
   Cleans up the given string after processing.

   The function performs the following operations on the given string:
   * perform a final andition
   * remove leftover `<num>`s in the string

   - Parameters:
     - text: the string to clean up after processing
   */
  func postProcess(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    // Remove leftover `<num>`s in the string
    string = string.replace(pattern: "<num>", with: "")

    return string
  }

  /**
   Joins numbers separated by spaces or the word 'and' by adding them up if they
   match the addition criteria.

   - Parameters:
     - text: the string in which to add qualifying numbers
   */
  private func andition(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    let pattern: String = #"<num>(\d+)(\s|\sand\s)<num>(\d+)(?=$|\W)"#
    while string.matches(pattern: pattern) {
      string = string.replace(pattern: pattern) { (matches: [String]) -> String in
        let one: String = matches[1]
        let two: String = matches[3]
        let conjunction: String = matches[2]

        if conjunction.contains("and") || one.count > two.count {
          let numOne: Int = Int(one)!
          let numTwo: Int = Int(two)!
          return "<num>\(numOne + numTwo)"
        } else {
          return matches[0] // the string, as it was
        }
      }
    }

    return string
  }
}
