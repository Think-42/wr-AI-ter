//
//  DeepDivePastAI.swift
//  Thoughts
//
//  Created by Sam on 31.08.23.
//

import SwiftUI
import OpenAI

struct ImpulseAI: AI {
	typealias Input = StoryBeat
	typealias Output = [String]
	
	static let shared = ImpulseAI()
	static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4
	
	var functionName: String { "suggest_impulses" }
	
	var functions: [ChatFunctionDeclaration] {
		return [
			ChatFunctionDeclaration(
				name: self.functionName,
				description: "Use this function to present 3 impulses for idea generation to the user.",
				parameters:
					JSONSchema(
						type: .object,
						properties: [
							"impulse_1" : .init(type: .string),
							"impulse_2" : .init(type: .string),
							"impulse_3" : .init(type: .string)
						],
						required: ["impulse_1", "impulse_2", "impulse_3", "impulse_4", "impulse_5"]
					)
			)
		]
	}
	
	func systemMessage(for input: Input) -> String {
		return """
You are a creative assitant.

For the story beat provided, offer inventive sparks ranging from succinct quotes, evocative words, uncommon emotions, atmospheric moods, creative ideas. Each suggestion should be brief: 1-3 sentences at most.

Ignite fresh ideas with your creativity.
"""
	}
	
	func userMessage(for storybeat: Input) -> String {
		var outputString: String = ""
		
		outputString += "I am searching for inspiration / impulses for the storybeat: \(storybeat.index + 1)\n\n\n"
		
		outputString += storybeat.project!.orderedStoryBeatsDescription
		
		return outputString
	}
	
	func decodeResponse(from data: Data) throws -> Output {
		struct Response: Codable {
			let impulse_1: String
			let impulse_2: String
			let impulse_3: String
		}
		let response = try JSONDecoder().decode(Response.self, from: data)
		return [response.impulse_1, response.impulse_2, response.impulse_3]
	}
}
