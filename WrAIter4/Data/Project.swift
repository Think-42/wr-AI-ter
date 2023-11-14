//
//  Item.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import Foundation
import SwiftData



@Model
final class Project: Identifiable {
	var id: UUID
	var name: String
	var projectStage: ProjectStage
	
	var brainstorm: String = ""
	
	var export: String = ""
	
	@Relationship(inverse: \StoryBeat.project)
	var storyBeats: [StoryBeat] = []
	
	@Relationship
	var storyBeatOfWhichTheQuestionsShouldBeDisplayed: StoryBeat?
	
	init(id: UUID = UUID(),
		 name: String = "[Unnamed]",
		 projectStage: ProjectStage = ProjectStage.brainstorm,
		 brainstorm: String = "",
		 export: String = "",
		 questionToDisplay: StoryBeat? = nil
	) {
		self.id = id
		self.name = name
		self.projectStage = projectStage
		self.brainstorm = brainstorm
		self.export = export
		self.storyBeatOfWhichTheQuestionsShouldBeDisplayed = questionToDisplay
	}
}

extension Project {
	var orderedStoryBeats: [StoryBeat] {
		return self.storyBeats.sorted(by: {$0.index < $1.index})
	}
	
	var orderedStoryBeatsDescription: String {
		var outputString: String = ""
		
		outputString += "The whole story right now goes something like this:\n\(self.orderedStoryBeats.description)"
		
		return outputString
	}
}

extension Project {
	func hideEverythingOptional() {
		for storyBeat in self.storyBeats {
			if storyBeat.universalEmotionStage == .shown || storyBeat.universalEmotionStage == .loading {
				storyBeat.universalEmotionStage = .hidden
			}
			
			if storyBeat.impulseStage == .shown || storyBeat.impulseStage == .loading {
				storyBeat.impulseStage = .hidden
			}
			
			storyBeatOfWhichTheQuestionsShouldBeDisplayed = nil
			if storyBeat.questionStage == .shown || storyBeat.questionStage == .loading {
				storyBeat.questionStage = .hidden
			}
		}
	}
}

enum ProjectStage: Steppable {
	case brainstorm
	case structure
	case refinement
	case export
	
	var description: String {
		switch self {
		case .brainstorm:
			return "Brainstorm"
		case .structure:
			return "Structure"
		case .refinement:
			return "Refinement"
		case .export:
			return "Export"
		}
	}
}
