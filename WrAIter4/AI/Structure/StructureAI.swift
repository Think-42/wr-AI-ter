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
	static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4_1106_preview
	
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
# Role
You are a professional screenwriter. I am a professional screenwriter too.

# Task
Convert the unstructured brainstorming session into a story beat structure that roughly fits into a five-act structure to create a first draft and an initial overview of the story we have so far.

# Approach
1. Take a deep breath and relax.
2. Read through the brainstorming session and story beats.
3. Keep the wording of the already provided story beats the same. You can view them as established cornerstones of the story that we have internally agreed upon.
4. Now, consider the brainstorming session and the provided story beat to complete the story. Take creative liberties to fill in gaps that were not provided, making the story cohesive and rounded. Come up with captivating text for the story beats that are currently empty.
(5. If no story beats are provided, do your best to bring the brainstorming session into the correct chronological order for a five-act structure.)

# Guidelines
- Consider the "show, don't tell" principle, even if we are still in the plotting stage.
- Be creative, but first utilize all the creative material given to you. Closely stick to the ideas provided to you in the brainstorming session.
- Present your answer in the order from 1 to 5.
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
