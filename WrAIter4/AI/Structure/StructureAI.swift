//
//  DeepDivePastAI.swift
//  Thoughts
//
//  Created by Sam on 31.08.23.
//

import SwiftUI
import OpenAI

struct StructureAI: AI {
	
	typealias Input = String
	typealias Output = [String]
	
	static let shared = StructureAI()
	static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4
	
	var functionName: String { "suggest_story_beats" }
	
	var functions: [ChatFunctionDeclaration] {
		return [
			ChatFunctionDeclaration(
				name: self.functionName,
				description: "Use this function to present 5 story beats to the user.",
				parameters:
					JSONSchema(
						type: .object,
						properties: [
							"story_beat_1" : .init(type: .string),
							"story_beat_2" : .init(type: .string),
							"story_beat_3" : .init(type: .string),
							"story_beat_4" : .init(type: .string),
							"story_beat_5" : .init(type: .string),
						],
						required: ["story_beat_1", "story_beat_2", "story_beat_3", "story_beat_4", "story_beat_5"]
					)
			)
		]
	}
	
	func systemMessage(for input: Input) -> String {
		return """
You are a professional screenwriter.

Convert the brainstorming session into a story beat structure that roughly fits into 5 act structure.

If there are story beats provided:
- Fill in gaps of the already provided story beats with ideas to make the story work.
- Keep the words of the story beat the same when they are already provided.
- Build a captivating story around it.
If not, just focus on the brainstorm text and sort the ideas into a chronological order and into the stages of the 5 act structure.

Consider the "show, don't tell" principle, even if we are still in the plotting stage.

Give your answer in the order from 1 to 5.
"""
	}
	
	func userMessage(for input: Input) -> String {
		input
	}
	
	func decodeResponse(from data: Data) throws -> Output {
		struct Response: Codable {
			let story_beat_1: String
			let story_beat_2: String
			let story_beat_3: String
			let story_beat_4: String
			let story_beat_5: String
		}
		let response = try JSONDecoder().decode(Response.self, from: data)
		return [response.story_beat_1, response.story_beat_2, response.story_beat_3, response.story_beat_4, response.story_beat_5]
	}
}
