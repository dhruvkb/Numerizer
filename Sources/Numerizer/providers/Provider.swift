/**
 A provider is the implementation of a a step-by-step process to parse numeric
 text to numbers. This protocol must be implemented by all locale-specific
 providers to ensure conformity.

 - Authors: Dhruv Bhanushali
 */
protocol Provider {
  init()

  /**
   Prepares the given string for processing.

   - Parameters:
     - text: the string to prepare for processing
   - Returns: the text prepared for processing
   */
  func preProcess(_ text: String) -> String

  /**
   Performs the actual processing on the string.

   - Parameters:
     - text: the string to process
   - Returns: the processed text
   */
  func process(_ text: String) -> String

  /**
   Cleans up the given string after processing.

   - Parameters:
     - text: the string to clean up after processing
   - Returns: the text cleaned-up after processing
   */
  func postProcess(_ text: String) -> String
}

extension Provider {
  /**
   Performs a numerization of the given string.

   The function performs the following operations on the given string:
   * pre-processes
   * processes
   * post-processes

   - Parameters:
     - text: the text in which to replace numeric words with numbers
   - Returns: parsed text
   */
  func parse(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    string = preProcess(string)
    string = process(string)
    string = postProcess(string)

    return string
  }
}
