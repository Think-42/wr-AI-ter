//
//  QuestionView.swift
//  WrAIter4
//
//  Created by Sam on 12.09.23.
//

import SwiftUI
import SwiftData

struct QuestionList: View {
	let storybeat: StoryBeat
	
	@Query var questions: [Question]
	
	init(storybeat: StoryBeat) {
		self.storybeat = storybeat
		self._questions = Query(
			//filter: #Predicate<Question> { $0.storybeat?.id == storybeat.id },
			sort: [.init(\Question.id)],
			animation: .bouncy
		)
	}
	
	var relevantQuestions: [Question] {
		questions.filter({$0.storybeat?.id == storybeat.id})
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			ForEach(relevantQuestions, id: \.id) { question in
				QuestionView(question: question)
			}
		}
		.padding(.top, 16)
	}
}

struct QuestionView: View {
	let question: Question
	
    var body: some View {
		HStack(alignment: .center, spacing: 0) {
			HStack {
				Text(question.question)
					.padding()
				Spacer()
			}.frame(width: STORY_BEAT_WIDTH)
				.background(.red)
				.cornerRadius(8)
			
			
			if !question.answer.isEmpty {
				Rectangle()
					.frame(width: QuestionDistances.getQuestionLineWidth(questionIndex: question.question_storybeat, answerIndex: question.answer_storybeat), height: 3)
					.background(.black)
				
				HStack {
					Text(question.answer)
						.padding()
					Spacer()
				}.frame(width: STORY_BEAT_WIDTH)
					.background(.green)
					.cornerRadius(8)
			}
		}
		//.background(.purple)
		.offset(x: QuestionDistances.getQuestionXOffset(questionIndex: question.question_storybeat), y: 0)
		
    }
}


struct QuestionDistances {
	static func getQuestionXOffset(questionIndex: Int) -> CGFloat {
		let tmp1 = CGFloat(questionIndex) * STORY_BEAT_WIDTH
		let tmp2 = CGFloat(questionIndex) * STORY_BEAT_PADDING
		
		return tmp1 + tmp2
	}
	
	static func getQuestionLineWidth(questionIndex: Int, answerIndex: Int) -> CGFloat {
		let tmp1 = CGFloat(answerIndex - questionIndex - 1) * STORY_BEAT_WIDTH
		let tmp2 = CGFloat(answerIndex - questionIndex) * STORY_BEAT_PADDING
		
		return tmp1 + tmp2
	}
	
//	static func getXAbsolutPosition(index: Int) -> CGFloat {
//		let tmp1 = CGFloat(index) * STORY_BEAT_WIDTH
//		let tmp2 = CGFloat(index) * STORY_BEAT_PADDING
//		
//		return tmp1 + tmp2
//	}
}


