//
//  assertThrowsAsyncError.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import XCTest


/// Asserts that an asynchronous expression throws an error. If the expression does not throw an error, the test fails. Optionally, you can provide a custom failure message and an error handler.
///
/// - Parameters:
///    - expression: An asynchronous expression that is expected to throw an error.
///    - message: A custom message to display if the expression does not throw an error. Defaults to an empty string.
///    - file: The file name to use in the error message. Defaults to the file where this function is called.
///    - line: The line number to use in the error message. Defaults to the line where this function is called.
///    - errorHandler: A closure that handles the error thrown by the expression. Defaults to a closure that does nothing.
///
/// - Usage:
///    ```swift
///    await assertThrowsAsyncError(try await someAsyncFunction()) { error in
///        // Handle the error
///    }
///    ```
func assertThrowsAsyncError<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    
    do {
        _ = try await expression()
        let customMessage = message()
        if customMessage.isEmpty {
            XCTFail("Async call did not throw an error.", file: file, line: line)
        } else {
            XCTFail(customMessage, file: file, line: line)
        }
    } catch {
        errorHandler(error)
    }
}
