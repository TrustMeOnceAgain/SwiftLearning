//
//  Interpreter.swift
//  swift-learning
//
//  Created by Filip Cybuch on 11/07/2022.
//

import Foundation

protocol Interpreter {
    associatedtype T
    func interpret(data: Data, response: URLResponse) -> T?
}

class AnyInterpreter<T>: Interpreter {
    func interpret(data: Data, response: URLResponse) -> T? {
        fatalError("AnyInterpreter used!")
    }
}
