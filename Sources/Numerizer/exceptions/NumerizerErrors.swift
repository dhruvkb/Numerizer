/**
 Enumerates the various errors that can be thrown during the numerization
 process.

 - Authors: Dhruv Bhanushali
 */
enum NumerizerErrors: Error {
  /// Raised when the chosen locale does not have an associated provider
  case unsupportedLocale
}
