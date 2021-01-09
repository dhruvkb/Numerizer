/// Mapping of locale choices to the provider for that particular locale
private let providers: [LocaleChoice: Provider.Type] = [
  LocaleChoice.en: EnglishProvider.self
]

/**
 Changes all numeric words in the string to numbers.

 - Authors: Dhruv Bhanushali
 - Parameters:
   - text: the text in which to replace numeric words with numbers
   - localeChoice: one of the values of the enum `LocaleChoice`
 */
public func numerize(
  _ text: String,
  localeChoice: LocaleChoice = LocaleChoice.en
) -> String {
  /// Mutable copy of the text passed as argument
  var string: String = text.copy() as! String

  guard let provider: Provider.Type = providers[localeChoice] else { return text }

  string = provider.process(string)
  return string
}
