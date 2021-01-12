/**
 Provides functionality to parse any numeric words in a string with actual
 numbers in their place.

 A locale needs to be chosen upon instantiantion, from the `LocaleChoice` enum,
 which determines the provider that will be used to parse the string.

 ```swift
 let numerizer: Numerizer = try! Numerizer(localeChoice: LocaleChoice.en)
 numerizer.numerize("forty two")
 // "42"
 ```

 - Authors: Dhruv Bhanushali
 */
public class Numerizer {
  /// The provider to use to parse any given string
  let provider: Provider

  /// Mapping of locale choices to the provider for that particular locale
  private let providers: [LocaleChoice: Provider.Type] = [
    LocaleChoice.en: EnglishProvider.self
  ]

  /**
   Constructor

   - Parameters:
     - localeChoice: one of the values of the enum `LocaleChoice`
   - Throws: `NumerizerErrors.unsupportedLocale` if locale choice does not have
             an associated provider.
   */
  init(localeChoice: LocaleChoice) throws {
    guard let Provider: Provider.Type = providers[localeChoice] else {
      throw NumerizerErrors.unsupportedLocale
    }
    self.provider = Provider.init()
  }

  /**
   Changes all numeric words in the string to numbers.

   - Parameters:
     - text: the text in which to replace numeric words with numbers
   - Returns: A new string with the numeric words replaced with numbers
   */
  public func numerize(_ text: String) -> String {
    /// Mutable copy of the text passed as argument
    var string: String = text.copy() as! String

    string = provider.process(string)
    return string
  }
}
