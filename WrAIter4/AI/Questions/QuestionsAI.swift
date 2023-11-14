//
//  DeepDivePastAI.swift
//  Thoughts
//
//  Created by Sam on 31.08.23.
//

import SwiftUI
import OpenAI

struct QuestionsAI: AI {
	typealias Input = StoryBeat
	typealias Output = QuestionResponse
	
	static let shared = QuestionsAI()
	static let defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4
	
	var functionName: String { "suggest_questions_and_answers" }
	
	var functions: [ChatFunctionDeclaration] {
		return [
			ChatFunctionDeclaration(
				name: self.functionName,
				description: "Use this function to present 3 impulses for idea generation to the user.",
				parameters:
					JSONSchema(
						type: .object,
						properties: [
							"questions_raised" : .init(
								type: .array,
								description: "Array of questions that are raised by the storybeat",
								items: .init(
									type: .object,
									properties: [
										"question" : .init(type: .string, description: "This is the litteral question that the storybeat raises"),
										"question_story_beat_number" : .init(type: .integer, description: "This has to be the number of the focused storybeat"),
										"answer" : .init(type: .string, description: "This is the answer that a later story beat gives to the question."),
										"answer_story_beat_number" : .init(type: .integer, description: "This is the storybeat number of the story beat that provides an answer for the question that the looked at storybeat raises."),
									]
								),
								required: ["question", "question_story_beat_number", "answer", "answer_story_beat_number"]
							),
							"questions_answered" : .init(
								type: .array,
								description: "Array of questions that are answered by the storybeat",
								items: .init(
									type: .object,
									properties: [
										"question" : .init(type: .string, description: ""),
										"question_story_beat_number" : .init(type: .integer, description: ""),
										"answer" : .init(type: .string, description: "This is the answer this very looked at story beat gives to a previously raised question."),
										"answer_story_beat_number" : .init(type: .integer, description: "This storybeat number has to match the focused storybeat."),
									]
								),
								required: ["question", "question_story_beat_number", "answer", "answer_story_beat_number"]
							)
						]
					)
			)
		]
		
//		return [
//			ChatFunctionDeclaration(
//				name: self.functionName,
//				description: "Generates a list of potential questions viewers might pose during a movie, based on a first draft screenplay's story beats. This function helps to identify areas of tension, engagement, or confusion that might arise from the viewer's perspective, enabling screenwriters to address these issues in later drafts.",
//				parameters:
//					JSONSchema(
//						type: .object,
//						properties: ["questions_and_answers" : .init(
//							type: .array,
//							description: "Array of key questions and their corresponding answers occurring within the story beats. These questions significantly contribute to the viewer's engagement and tension while watching the movie.",
//							items: .init(
//								type: .object,
//								properties: [
//									"question": .init(type: .string, description: "Questions are phrased as a viewer might ask them, without any foresight of the story's conclusion."),
//									"question_beat_number" : .init(type: .integer, description: "This represents the specific story beat when the question first surfaces in the viewer's mind."),
//									"answer": .init(type: .string, description: "If a question is unanswered, the value will be an empty string. If an answer is given, it represents the moment of revelation or understanding a viewer experiences at a specific story beat."),
//									"answer_beat_number": .init(type: .integer, description: "The answer_beat_number should always be greater than the question_beat_number, indicating a progression in the story. It creates a feeling of tension. If no answer is provided within the story beats, the answer_beat_number is -1.")
//								]
//								//required: ["question", "question_beat_number"]
//							),
//							required: ["question", "question_beat_number"]
//						)]
//					)
//			)
//		]
	}
	
	func systemMessage(for input: Input) -> String {
		return """
You are a skilled screenwriter. In the early stages of scriptwriting, it's beneficial to analyze the relationship between different story beats. Specifically, some story beats pose questions while others provide answers.

For this exercise, focus on a single story beat's questions and the answers it either provides or seeks.

Please ensure every entry includes:
- The question itself
- question_story_beat_number (the beat where the question is raised)
- The answer
- answer_story_beat_number (the beat where the answer is provided)

The provided questions should help me analyzse where there is tension / curiosity to continue watching or gaps in the story, where there are only a few questions. Or if the viewer has questions, that are not answered by the story (chekhov's gun).

The desired outcome consists of two arrays:

1. `questions_answered`: This array captures the answers given by this story beat in response to questions raised by previous beats.
2. `questions_raised`: This array highlights the questions that this story beat introduces, which will be answered in subsequent beats.

Note: The "answer_story_beat_number" and "question_story_beat_number" should never be identical. If they were, it would imply that the beat neither truly poses a question nor provides an answer, as both are presented simultaneously.
No json-field can be "null", "nil" or "" (empty), except the "answer"-attribute (if no answer is given) - in such a case provide a random integer as an "answer_story_beat_number" (NOT NULL!!!!).
"""
	}
	
	func userMessage(for storybeat: Input) -> String {
		var outputString: String = ""
		
		outputString += "I want to analyse the following storybeat in terms of which questions it answers and which question it raises: \(storybeat.index + 1)\n\n\n"
		
		outputString += storybeat.project!.orderedStoryBeatsDescription
		
		return outputString
	}
	
	func decodeResponse(from data: Data) throws -> Output {
		let response = try JSONDecoder().decode(QuestionResponse.self, from: data)
		return response
	}
}

struct QuestionResponse: Codable {
	struct QuestionsRaised: Codable {
		let question: String
		let question_story_beat_number: Int
		let answer: String
		let answer_story_beat_number: Int
	}
	
	struct QuestionsAnswered: Codable {
		let question: String
		let question_story_beat_number: Int
		let answer: String
		let answer_story_beat_number: Int
	}
	
	let questions_raised: [QuestionsRaised]
	let questions_answered: [QuestionsAnswered]
}

