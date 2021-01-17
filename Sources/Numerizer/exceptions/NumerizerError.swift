/**
 Enumerates the various errors that can be thrown during the numerization
 process.

 - Authors: Dhruv Bhanushali
 */
enum NumerizerError: Error {
  /// Raised when the chosen numbering system does not have an associated provider
  case unsupportedNumberingSystem
}
