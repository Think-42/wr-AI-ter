//
//  Item.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import Foundation
import SwiftData

enum ImpulseStage: Codable {
	case uninitialized
	case wantsToBeInitialized
	case loading
	case shown
	case hidden
}

enum QuestionStage: Codable {
	case uninitialized
	case wantsToBeInitialized
	case loading
	case shown
	case hidden
}

enum UniversalEmotionStage: Codable {
	case uninitialized
	case wantsToBeInitialized
	case loading
	case shown
	case hidden
}

@Model
final class StoryBeat: Identifiable {
	@Attribute(.unique)
	var id: UUID
	var text: String
	var locked: Bool
	var index: Int
	
	var impulses: [String]
	var impulseStage: ImpulseStage
	
	var project: Project?
	
	@Relationship(inverse: \Question.storybeat)
	var questions: [Question] = []
	var questionStage: QuestionStage
	
	var universalEmotion: String
	var universalEmotionStage: UniversalEmotionStage
	
	init(id: UUID = UUID(),
		 text: String,
		 locked: Bool = false,
		 index: Int,
		 impulses: [String] = [],
		 impulseStage: ImpulseStage = .uninitialized,
		 questionStage: QuestionStage = .uninitialized,
		 universalEmotion: String = "",
		 universalEmotionStage: UniversalEmotionStage = .uninitialized
		 //project: Project
	) {
		self.id = id
		self.text = text
		self.locked = locked
		self.index = index
		self.impulses = impulses
		self.impulseStage = impulseStage
		self.questionStage = questionStage
		self.universalEmotion = universalEmotion
		self.universalEmotionStage = universalEmotionStage
		//self.project = project
	}
}

extension Array where Element == StoryBeat {
	var description: String {
		return self.map { "\($0.index + 1).: \($0.text)" }.joined(separator: "\n")
	}
	
	var description_locked: String {
		return self.map { "\($0.index + 1).: \($0.locked ? $0.text : "")" }.joined(separator: "\n")
	}
}
