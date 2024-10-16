//
//  EmotionAI.swift
//  Thoughts
//
//  Created by Sam on 13.08.23.
//

import SwiftUI
import OpenAI

struct ExportAI: AI {
	typealias Input = Project
	typealias Output = String
	
	static let shared = ExportAI()
    static var defaultModel: Model = USE_GPT_3_5 ? .gpt3_5Turbo : .gpt4_1106_preview
	
	var functionName: String { "export_screenwriting" }
	
	var functions: [ChatFunctionDeclaration] {
		return []
	}
	
	func systemMessage(for input: Input) -> String {
		return """
You're a seasoned screenwriter.
Using the provided storybeats, craft a screenplay. Stay true to the details and length given, but flesh it out sufficiently. Transform the beats into a first draft script, incorporating dialogue. Your objective is to smoothly transition the storybeats into a script.
Really apply the "show, dont tell" principle. Only describe what can be seen and what can be heard.

Only reply with a single code block:
```fountain

```
"""
	}
	
	func userMessage(for input: Input) -> String {
		var string: String = ""
		string += "My storybeats are:\n\(input.orderedStoryBeats.description)"
		return string
	}
	
	func decodeResponse(from data: Data) throws -> String {
		return String(data: data, encoding: .utf8)!
	}
}
