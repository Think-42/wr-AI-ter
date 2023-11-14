//
//  AI.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import Foundation
import OpenAI
import OSLog

public struct AIError: Error {
	public let message: String
	
	init(message: String) {
		self.message = message
	}
}

public struct MetaData {
	public let model: Model
	public let inputToken: Int
	public let outputToken: Int
	public let timestamp: Date
	public let currentTryNumber: Int
	public let costsInDollar: Double
	
	public init(model: Model, inputToken: Int, outputToken: Int, timestamp: Date, currentTryNumber: Int) {
		self.model = model
		self.inputToken = inputToken
		self.outputToken = outputToken
		self.timestamp = timestamp
		self.currentTryNumber = currentTryNumber
		
		var costs: Double = 0.0
		
		if model == .gpt4 || model == .gpt4_0613 {
			costs += (Double(inputToken)/1000) * 0.03
			costs += (Double(outputToken)/1000) * 0.06
		} else if model == .gpt3_5Turbo || model == .gpt3_5Turbo0613 {
			costs += (Double(inputToken)/1000) * 0.0015
			costs += (Double(outputToken)/1000) * 0.002
		} else {
			costs = -1
		}
		
		self.costsInDollar = costs
	}
}

public protocol AI {
	associatedtype Input
	associatedtype Output
	
	static var defaultModel: Model { get }
	static var shared: Self { get }
	
	var functions: [ChatFunctionDeclaration] { get }
	func userMessage(for input: Input) -> String
	func systemMessage(for input: Input) -> String
	var functionName: String { get }
	var apiToken: String { get }
	
	func run(input: Input) async throws -> Output
	func _getResponse(for input: Input, from model: Model) async throws -> Output
	
	func decodeResponse(from data: Data) throws -> Output
	
	func handleMetaData(metadata: MetaData)
}

public struct magicVariables_AI {
	static let maxTries: Int = 2
}

public extension AI {
	func run(input: Input) async throws -> Output {
		return try await _getResponse(for: input)
	}
	
	func _getResponse(for input: Input) async throws -> Output {
		return try await _getResponse(for: input, from: Self.defaultModel)
	}
	
	func _getResponse(for input: Input, from model: Model) async throws -> Output {
		return try await _getResponse(for: input, from: model, maxTries: magicVariables_AI.maxTries)
	}
	
	func _getResponse(for input: Input, from model: Model, maxTries numTries: Int) async throws -> Output {
		let logger = Logger(subsystem: "Utility.AI", category: "AI")
		
		let openAI = OpenAI(configuration: .init(token: self.apiToken, timeoutInterval: 360))
		
		let query = ChatQuery(
			model: model,
			messages: [
				.init(role: .system, content: self.systemMessage(for: input)),
				.init(role: .user, content: self.userMessage(for: input))],
			functions: self.functions.isEmpty ? nil : self.functions,
			functionCall: self.functions.isEmpty ? nil : .function(self.functionName)
		)
		
		do {
			logger.info("OpenAI Request started")
			logger.info("System Message:\n\(self.systemMessage(for: input))")
			logger.info("User Message:\n\(self.userMessage(for: input))")
			
			let result = try await openAI.chats(query: query)
			
			handleMetaData(metadata: MetaData(
				model: model,
				inputToken: result.usage?.promptTokens ?? -1,
				outputToken: result.usage?.completionTokens ?? -1,
				timestamp: Date.now,
				currentTryNumber: (magicVariables_AI.maxTries - numTries) + 1
			))
			
			logger.info("OpenAIs return message received")
			
			if let returnedJSON = self.functions.isEmpty ? result.choices[0].message.content : result.choices[0].message.functionCall?.arguments {
				logger.info("The JSON extracted from response:\n\(returnedJSON)")
				
				return try decodeResponse(from: Data(returnedJSON.utf8))
			} else {
				logger.critical("The message was nil! Älabätsch! 🤙🏻")
				throw AIError(message: "The message was nil! Älabätsch! 🤙🏻")
			}
		} catch {
			logger.error("ERROR: Something went wrong - we are trying again to get results that we can parse, but this will cost more!!!\n\n❌\n\nThis went wrong:\n\(error)")
			if numTries > 1 {
				return try await _getResponse(for: input, from: model, maxTries: numTries - 1)
			} else {
				throw error
			}
		}
	}
}

public extension AI where Output: Decodable {
	func decodeResponse(from data: Data) throws -> Output {
		return try JSONDecoder().decode(Output.self, from: data)
	}
}


extension AI {
	var apiToken: String {
		return "sk-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
	}
	
	func handleMetaData(metadata: MetaData) {
		// NOTE: I think handling the meta data is not necessary in this context
	}
}
