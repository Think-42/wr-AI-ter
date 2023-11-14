//
//  Item.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import Foundation
import SwiftData

@Model
final class Question: Identifiable {
	var id: UUID
	
	var question: String
	var question_storybeat: Int
	var answer: String
	var answer_storybeat: Int
	
	var storybeat: StoryBeat?
	
	init(id: UUID = UUID(), question: String, question_storybeat: Int,  answer: String, answer_storybeat: Int) {
		self.id = id
		self.question = question
		self.question_storybeat = question_storybeat
		self.answer = answer
		self.answer_storybeat = answer_storybeat
	}
}
