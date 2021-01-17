/**
 Provides functionality to parse any numeric words in a string with actual
 numbers in their place.

 A locale needs to be chosen upon instantiantion, from the `LocaleChoice` enum,
 which determines the provider that will be used to parse the string.

 ```swift
 let numerizer: Numerizer = try! Numerizer(numberingSystem: NumberingSystem.latn)
 numerizer.numerize("forty two")
 // "42"
 ```

 - Authors: Dhruv Bhanushali
 */
public class Numerizer {
  /// The provider to use to parse any given string
  let provider: Provider

  /// Mapping of locale choices to the provider for that particular locale
  private let providers: [NumberingSystem: Provider.Type] = [
    NumberingSystem.latn: EnglishProvider.self
  ]

  /**
   Constructor

   - Parameters:
     - localeChoice: one of the values of the enum `LocaleChoice`
   - Throws: `NumerizerErrors.unsupportedLocale` if locale choice does not have
             an associated provider
   */
  public init(
    numberingSystem: NumberingSystem = NumberingSystem.latn
  ) throws {
    guard let Provider: Provider.Type = providers[numberingSystem] else {
      throw NumerizerError.unsupportedNumberingSystem
    }
    self.provider = Provider.init()
  }

  /**
   Changes all numeric words in the string to numbers.

   - Parameters:
     - text: the text in which to replace numeric words with numbers
   - Returns: A new string with the numeric words replaced with numbers
   */
  public func parse(_ text: String) -> String {
    provider.process(text)
  }

  @available(*, deprecated, renamed: "parse")
  public func numerize(_ text: String) -> String {
    parse(text)
  }
}
