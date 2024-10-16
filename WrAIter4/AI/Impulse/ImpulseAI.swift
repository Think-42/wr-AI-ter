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
	static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4_1106_preview
	
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
						required: ["impulse_1", "impulse_2", "impulse_3"]
					)
			)
		]
	}
	
	func systemMessage(for input: Input) -> String {
		return """
# Role
You are an expert screenwriter. I am an expert screenwriter, too. We are both sitting in a writers room.

# Task
Provide inventive sparks ranging from succinct quotes, evocative words, uncommon emotions, atmospheric moods, creative ideas for the story beat provided. We are searching for ideas how to connect the story and make it really enganging for the audience.

# Approach
1. Take a deep breath and relax.
2. Read through the whole story and truly understand it.
3. Provide 3 impulses how the story could be completed in for the provided story beat. Also consider what story follows the story beat and really make it connecting.

# Guidelines
- Each suggestion should be brief: 1-3 sentences at most.
- Make the impulses really creative and suprisingly honest.
- Ignite fresh ideas with your creativity.
"""
	}
	
	func userMessage(for storybeat: Input) -> String {
		var outputString: String = ""
		
        outputString += storybeat.project!.orderedStoryBeatsDescription
        
		outputString += "\n\nI am searching for inspiration / impulses only for the storybeat: \(storybeat.index + 1)\n\n\n"
		
		
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
