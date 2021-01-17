/**
 Enumerates the various choices of numbering systems that determine the provider
 that will be used to parse the given string.

 - Authors: Dhruv Bhanushali
 - SeeAlso: [Unicode Common Locale Data Repository](https://github.com/unicode-org/cldr/blob/master/common/supplemental/numberingSystems.xml)
 */
public enum NumberingSystem {
  /// Latin numerials, the default
  case latn
  /// Roman numerals
  case roman
}
