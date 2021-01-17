import Foundation

/**
 Adds a cleaner interface for regex-based find-and-replace functionality built
 on top of `NSRegularExpression`.
 */
extension String {
  /**
   Check if the given pattern occurs in the string or not.

   The function accepts a pattern string and an optional instance of
   `NSRegularExpression.Options`.

   ```swift
   "Hello, World!".matches(pattern: "Hello")
   // true
   ```

   ```swift
   "Hello, World!".matches(pattern: "Hi")
   // false
   ```

   Options can be passed to modify the behaviour of the `NSRegularExpression`
   instance.

   ```swift
   "Hello, World!".matches(pattern: "hELLO", options: [.caseInsensitive])
   // true
   ```

   - Authors: Dhruv Bhanushali
   - Parameters:
     - pattern: the pattern to search for in the string
     - options: the options to use for the regex pattern
   - Returns: whether the string contains the pattern
   */
  public func matches(
    pattern: String,
    options: NSRegularExpression.Options = []
  ) -> Bool {
    guard let regex: NSRegularExpression = try? NSRegularExpression(
      pattern: pattern,
      options: options
    ) else { return false }

    let matchCount: Int = regex.numberOfMatches(
      in: self,
      options: NSRegularExpression.MatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.utf16.count)
    )

    return matchCount > 0
  }

  /**
   Replace the given pattern with a dynamically-generated replacement string.
   
   The function accepts a pattern string, an optional instance of
   `NSRegularExpression.Options` and a closure that accepts the matches as an
   argument and returns a replacement.

   ```swift
   "Hello, World!".replace(pattern: #"(\w+),\s(\w+)"#) { (matches: [String]) -> String in
     let one: String = matches[1]
     let two: String = matches[2]
     return "\(two), \(one)"
   }
   // "World, Hello!"
   ```

   Options can be passed to modify the behaviour of the `NSRegularExpression`
   instance.

   ```swift
   "Hello, World!".replace(pattern: "hELLO", options: [.caseInsensitive]) { (matches: [String]) -> String in
     "Hi"
   }
   // "Hi, World!"
   ```

   This function replaces all occurrences of the pattern.

   ```swift
   "Hello, hello!".replace(pattern: "ello") { (matches: [String]) -> String in
     "ola"
   }
   // "Hola, hola!"
   ```

   - Authors: Brian Floersch, Dhruv Bhanushali
   - SeeAlso: [Brian Floersch's blog post](https://blog.sb1.io/a-better-find-replace-swift-interface/)
   - Note: This function replaces all occurrences of the pattern.
   - Parameters:
     - pattern: the pattern to replace in the string
     - options: the options to use for the regex pattern
     - replacer: a function that generates a replacement string
     - matches: an array containing:
       - 0: the entire matching substring
       - 1...n: capturing groups 1 through n
   - Returns: A new string with the occurrences replaced
   */
  public func replace(
    pattern: String,
    options: NSRegularExpression.Options = [],
    through replacer: (_ matches: [String]) -> String
  ) -> String {
    guard let regex: NSRegularExpression = try? NSRegularExpression(
      pattern: pattern,
      options: options
    ) else { return self }

    let matches: [NSTextCheckingResult] = regex.matches(
      in: self,
      options: NSRegularExpression.MatchingOptions(rawValue: 0),
      range: NSMakeRange(0, self.utf16.count)
    )

    guard matches.count > 0 else { return self }

    var splitStart: String.Index = startIndex
    var matchesMap = matches.map { (match: NSTextCheckingResult) -> (prefix: String, matches: [String]?) in
      /// The portion of the string matched by the regex pattern
      let range: Range<String.Index> = Range(match.range, in: self)!
      /// The portion of the string that precedes a match
      let prefix: String = String(self[splitStart ..< range.lowerBound])

      splitStart = range.upperBound

      return (
        prefix: prefix,
        matches: (0 ..< match.numberOfRanges).compactMap { (pos: Int) -> Range<String.Index>? in
          Range(match.range(at: pos), in: self)
        }.map { (range: Range<String.Index>) -> String in
          String(self[range])
        }
      )
    }
    /// Add the remaining string to the matches map
    matchesMap.append(
      (
        prefix: String(self[splitStart ..< endIndex]),
        matches: nil
      )
    )

    let replacedString: String = matchesMap.reduce("") { (result: String, elem: (prefix: String, matches: [String]?)) -> String in
      let prefix: String = elem.prefix
      let matches: [String]? = elem.matches
      var replaced: String = ""
      if let _matches: [String] = matches {
        replaced = replacer(_matches)
      }
      return "\(result)\(prefix)\(replaced)"
    }

    return replacedString
  }

  /**
   Replace the given pattern with a static replacement string.

   This is a convenience method that accepts a pattern string, an optional
   instance of `NSRegularExpression.Options` and a replacement string. This is
   equivalent to `replace(pattern, options, replacer)` where the closure
   `replacer` returns a constant string `replacement`.

   ```swift
   "Hello, World!".replace(pattern: "World", with: "Dhruv")
   // "Hello, Dhruv!"
   ```

   - Authors: Brian Floersch, Dhruv Bhanushali
   - SeeAlso: [Brian Floersch's blog post](https://blog.sb1.io/a-better-find-replace-swift-interface/)
   - Note: This function replaces all occurrences of the pattern.
   - Parameters:
     - pattern: the pattern to replace in the string
     - options: the options to use for the regex pattern
     - replacement: the string with which to replace the matching pattern
   - Returns: A new string with the occurrences replaced
   */
  public func replace(
    pattern: String,
    options: NSRegularExpression.Options = [],
    with replacement: String
  ) -> String {
    replace(pattern: pattern, options: options) { _ -> String in
      replacement
    }
  }
}
