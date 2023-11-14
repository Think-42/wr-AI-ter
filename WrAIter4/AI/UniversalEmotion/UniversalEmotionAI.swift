//
//  DeepDivePastAI.swift
//  Thoughts
//
//  Created by Sam on 31.08.23.
//

import SwiftUI
import OpenAI

struct UniversalEmotionAI: AI {
	typealias Input = StoryBeat
	typealias Output = String
	
	static let shared = UniversalEmotionAI()
	static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4
	
	var functionName: String { "suggest_universal_emotions" }
	
	var functions: [ChatFunctionDeclaration] {
		return [
			ChatFunctionDeclaration(
				name: self.functionName,
				description: "Use this function to present creative, emotional impulases for the provided story beat number.",
				parameters:
					JSONSchema(
						type: .object,
						properties: [
							"description_of_core_emotions" : .init(type: .string),
							"impulses_for_enhanced_emotion" : .init(type: .string)
						]
					)
			)
		]
	}
	
	func systemMessage(for input: Input) -> String {
		return """
You are an experienced screenwriter.

There's a specific story beat in my script that feels underwhelming in terms of its emotional impact.
First, I'd like to get your insight on the core, universal emotion this beat is really trying to convey. Name it and describe why you think that is the underlying emotion. Just focus on the provided storybeat number that i give you.

Afterwards, provide multiple suggestions / impulses to amplify the emotional intensity of this beat. Feel free to go overboard with your ideas and make it extremely intense and extreme. This is more like an impulse.

Keep your response short, but super dense.
"""
	}
	
	func userMessage(for storybeat: Input) -> String {
		var outputString: String = ""
		
		outputString += "I am searching for the core emotion / creative impulses for the storybeat: \(storybeat.index + 1)\n\n\n"
		
		outputString += storybeat.project!.orderedStoryBeatsDescription
		
		return outputString
	}
	
	func decodeResponse(from data: Data) throws -> Output {
		struct Response: Codable {
			let description_of_core_emotions: String
			let impulses_for_enhanced_emotion: String
		}
		let response = try JSONDecoder().decode(Response.self, from: data)
		return response.description_of_core_emotions + "\n\n\n" + response.impulses_for_enhanced_emotion
	}
}
