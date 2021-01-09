/**
 A provider is the implementation of a a step-by-step process to parse numeric
 text to numbers. This protocol must be implemented by all locale-specific
 providers to ensure conformity.

 - Authors: Dhruv Bhanushali
 */
protocol Provider {
  /**
   Prepares the given string for processing.

   - Parameters:
     - text: the string to prepare for processing
   */
  static func preProcess(_ text: String) -> String

  /**
   Parses straight-forward numerals from the given string.

   - Parameters:
     - text: the string from which to parse numerals
   */
  static func numerizeNumerals(_ text: String) -> String

  /**
   Parses fractions from the given string.

   - Parameters:
     - text: the string from which to parse fractions
   */
  static func numerizeFractions(_ text: String) -> String

  /**
   Parses numerals with big suffixes from the given string.

   - Parameters:
     - text: the string from which to parse numerals
   */
  static func numerizeBigSuffixes(_ text: String) -> String

  /**
   Cleans up the given string after processing.

   - Parameters:
     - text: the string to clean up after processing
   */
  static func postProcess(_ text: String) -> String
}

extension Provider {
  /**
   Performs a numerization of the given string.

   The function performs the following operations on the given string:
   * pre-processing
   * numerization of numerals
   * numerization of fractions
   * numerization of big suffixes
   * post-processing

   - Parameters:
     - text: the text in which to replace numeric words with numbers
   */
  static func process(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    string = preProcess(string)
    string = numerizeNumerals(string)
    string = numerizeFractions(string)
    string = numerizeBigSuffixes(string)
    string = postProcess(string)

    return string
  }
}
