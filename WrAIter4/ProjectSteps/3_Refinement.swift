//
//  3_Refinement.swift
//  WrAIter4
//
//  Created by Sam on 09.09.23.
//

import SwiftUI
import SwiftData

struct Refinement: View {
	let project: Project
	
	var body: some View {
		StoryBeatTimeline(project: project, refinement: true, buttonText: "", buttonAction: {})
	}
}

struct StoryBeatTimeline: View {
	let project: Project
	let refinement: Bool
	
	var buttonText: String
	var buttonAction: () -> ()
	
	var onAppearAction: () -> () = {}
	
	@Query
	private var storyBeats: [StoryBeat]
	
	init(project: Project, refinement: Bool, buttonText: String, buttonAction: @escaping () -> Void = {}, onAppearAction: @escaping () -> Void = {}) {
		self.project = project
		self.refinement = refinement
		self.buttonText = buttonText
		self.buttonAction = buttonAction
		self.onAppearAction = onAppearAction
		
		//let pred: Predicate<StoryBeat> = #Predicate<StoryBeat> { beat in beat.project?.id == project.id }
		
		self._storyBeats = Query(
			//filter: #Predicate<StoryBeat> {$0.project?.id == project.id},
			//filter: pred,
			sort: \StoryBeat.index,
			order: .forward,
			animation: .bouncy
		)
	}
	
	@State var isRunning: Bool = false
	
	var relevantStoryBeats: [StoryBeat] {
		storyBeats.filter({$0.project == project})
	}
	
	var body: some View {
		ScrollView([.horizontal, .vertical], showsIndicators: false) {
			VStack(alignment: .leading) {
				HStack(alignment: .top, spacing: 0) {
					ForEach(relevantStoryBeats, id: \.id) { storyBeat in
						VStack(alignment: .leading) {
							StoryBeatView(storyBeat: storyBeat, isLoading: storyBeat.locked ? .constant(false) : $isRunning)
							
							ImpulseStack(storyBeat: storyBeat)
							
							UniversalEmotionView(storyBeat: storyBeat, isLoading: .constant(false))
						}
					}
				}
				
				if let storybeat = project.storyBeatOfWhichTheQuestionsShouldBeDisplayed {
					QuestionList(storybeat: storybeat)
				}
				
				if !buttonText.isEmpty {
					Button {
						buttonAction()
					} label: {
						Text(buttonText)
							.addBackgroundFillToButton()
					}
				}
			}
			.padding(.horizontal, 128)
		}
		.onAppear {
			onAppearAction()
		}
	}
}
