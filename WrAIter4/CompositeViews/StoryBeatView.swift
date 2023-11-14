//
//  StoryBeat.swift
//  WrAIter4
//
//  Created by Sam on 06.09.23.
//

import SwiftUI

let STORY_BEAT_WIDTH: CGFloat = 300
let STORY_BEAT_PADDING: CGFloat = 64
let LINE_WIDTH: CGFloat = 3

struct StoryBeatView: View {
	var storyBeat: StoryBeat
	@Binding var isLoading: Bool
	@Environment(\.modelContext) private var modelContext
	
    var body: some View {
		HStack(alignment: .top, spacing: 0) {
			VStack(alignment: .leading, spacing: 8) {
				StoryBeatControls(storyBeat: storyBeat)
				//MatrixTextWrapper(text: Bindable(storyBeat).text, isLoading: self.$isLoading) { displayText in
				TextFieldBasicStyled(placeholder: "Story...", text: Bindable(storyBeat).text, lineWidth: LINE_WIDTH)
						.foregroundStyle(storyBeat.locked ? Color.gray : Color.black)
						.frame(width: STORY_BEAT_WIDTH)
				//}
			}.onChange(of: storyBeat.text) { oldValue, newValue in
				print("Text changed")
			}
			
			ZStack(alignment: .top) {
				Rectangle()
					.frame(width: STORY_BEAT_PADDING, height: LINE_WIDTH)
					.foregroundColor({
						if storyBeat.project!.projectStage == .structure {
							if storyBeat.index == 4 {
								return .black.opacity(0)
							} else {
								return .black
							}
						} else if storyBeat.project!.projectStage == .refinement {
							return .black
						}
						return .black
					}())
				
				if storyBeat.project!.projectStage == .refinement {
					Button {
						// increase the storybeats coming after
						
						for storybeat in storyBeat.project!.storyBeats {
							if storybeat.index > storyBeat.index {
								storybeat.index += 1
							}
						}
						
						let newStoryBeat = StoryBeat(text: "", index: storyBeat.index + 1)
						modelContext.insert(newStoryBeat)
						newStoryBeat.project = storyBeat.project!
						newStoryBeat.impulseStage = .wantsToBeInitialized
						
					} label: {
						Image(systemName: "plus")
							.iconButton()
					}.offset(CGSize(width: 0, height: -30/2)) // TODO: hardcoded?!
				}
			}.offset(CGSize(width: 0, height: 80)) //TODO: this offset is hard coded
			
		}
		
    }
}

import OSLog
import TipKit

struct StoryBeatControls: View {
	let logger = Logger(subsystem: "StoryBeatControls", category: "AI")
	
	var storyBeat: StoryBeat
	
	let tip: LockStoryBeat = LockStoryBeat()
	
	@Environment(\.modelContext) private var modelContext
	
	let questionAI: QuestionsAI = .init()
	let universalAI: UniversalEmotionAI = .init()
	
	var body: some View {
		HStack (alignment: .center, spacing: 8) {
			Image(systemName: "\(storyBeat.index + 1).square")
				.font(.system(size: 46))
				.fontWeight(.light)
				.transition(.scale.animation(.easeInOut(duration: 0.5).delay(0.5)))
			HStack (alignment: .center, spacing: 8) {
				if storyBeat.project?.projectStage ?? .brainstorm == .structure {
					Button {
						withAnimation {
							storyBeat.locked.toggle()
						}
						//tip.invalidate(reason: .actionPerformed)
					} label: {
						Image(systemName: storyBeat.locked ? "lock.square.fill" : "lock.square")
							.iconButton()
					}
					
				} else if storyBeat.project?.projectStage ?? .brainstorm == .refinement {
					Button {
						withAnimation {
							move(storyBeat: storyBeat, left: true)
							//storyBeat.move(storyBeat: storyBeat, left: true)
						}
					} label: {
						Image(systemName: "arrow.left")
							.iconButton()
					}
					Button {
						withAnimation {
							move(storyBeat: storyBeat, left: false)
							//storyBeat.move(storyBeat: storyBeat, left: false)
						}
					} label: {
						Image(systemName: "arrow.right")
							.iconButton()
					}
					
					Button {
						runAI()
					} label: {
						Image(systemName: "questionmark.bubble")
							.iconButton()
					}
					
					Button {
						runUniversalEmotionAI()
					} label: {
						Image(systemName: "star.bubble")
							.iconButton()
					}
					
					Button {
						storyBeat.project?.hideEverythingOptional()
						
						let storyBeatsWhichNeedAReducedIndex = storyBeat.project!.orderedStoryBeats.filter({$0.index > storyBeat.index})
						
						withAnimation {
							for storybeat in storyBeatsWhichNeedAReducedIndex {
								storybeat.index -= 1
							}
						}
						
						withAnimation {
							modelContext.delete(storyBeat)
						}
						
					} label: {
						Image(systemName: "trash")
							.iconButton()
					}
				}
			}
		}
	}
	
	func move(storyBeat: StoryBeat, left: Bool) {
		guard let storyBeats = storyBeat.project?.orderedStoryBeats else {
			print("No story beats found in project.")
			return
		}
		
		guard let currentIndex = storyBeats.firstIndex(of: storyBeat) else {
			print("Failed to find the story beat in the array.")
			return
		}
		
		if left {
			if currentIndex > 0 {
				let previousIndex = currentIndex - 1
				swapIndices(storyBeats: storyBeats, index1: currentIndex, index2: previousIndex)
			}
		} else {
			if currentIndex < storyBeats.count - 1 {
				let nextIndex = currentIndex + 1
				swapIndices(storyBeats: storyBeats, index1: currentIndex, index2: nextIndex)
			}
		}
	}
	
	private func swapIndices(storyBeats: [StoryBeat], index1: Int, index2: Int) {
		self.storyBeat.project?.hideEverythingOptional()
		let tempIndex = storyBeats[index1].index
		storyBeats[index1].index = storyBeats[index2].index
		storyBeats[index2].index = tempIndex
	}
	
	
	func runUniversalEmotionAI() {
		DispatchQueue.main.async {
			Task {
				self.storyBeat.project?.hideEverythingOptional()
				
				do {
					storyBeat.universalEmotionStage = .loading
					let output = try await universalAI.run(input: storyBeat)
					
					storyBeat.universalEmotion = output
					
					storyBeat.project!.storyBeatOfWhichTheQuestionsShouldBeDisplayed = nil
					
					storyBeat.universalEmotionStage = .shown
				} catch {
					logger.critical("We encountered an error! \(error)")
				}
			}
		}
	}
	

	func runAI() {
		guard storyBeat.questions.isEmpty else {
			storyBeat.project!.storyBeatOfWhichTheQuestionsShouldBeDisplayed = storyBeat
			return
		}
		
		
		DispatchQueue.main.async {
			Task {
				// TODO: before running the AI set all others to hidden
				
//				for storybeat in storyBeat.project!.storyBeats {
//					if storybeat.index == storyBeat.index {
//						
//					} else {
//						if storybeat.impulseStage == .wantsToBeInitialized || storybeat.impulseStage == .loading ||
//							storybeat.impulseStage == .shown {
//							storybeat.impulseStage = .hidden
//						}
//					}
//				}
				
				self.storyBeat.project?.hideEverythingOptional()
				
				do {
					let output = try await questionAI.run(input: storyBeat)
					
					let questions_raised = output.questions_raised.map { questionsRaised in
						Question(question: questionsRaised.question, question_storybeat: questionsRaised.question_story_beat_number - 1, answer: questionsRaised.answer, answer_storybeat: questionsRaised.answer_story_beat_number - 1)
					}
					
					let questions_answered = output.questions_answered.map { questionsAnswered in
						Question(question: questionsAnswered.question, question_storybeat: questionsAnswered.question_story_beat_number - 1, answer: questionsAnswered.answer, answer_storybeat: questionsAnswered.answer_story_beat_number - 1)
					}
					
					var allQuestions: [Question] = questions_raised
					allQuestions.append(contentsOf: questions_answered)
					
					for question in allQuestions {
						modelContext.insert(question)
						question.storybeat = storyBeat
					}
					
					//question.storybeat?.questionStage
					storyBeat.project!.storyBeatOfWhichTheQuestionsShouldBeDisplayed = storyBeat

					print(storyBeat.questions)
				} catch {
					print(String(repeating: "❌", count: 12))
				}
			}
		}
	}
}
