//
//  1_Brainstorm.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import SwiftUI

struct Brainstorm: View {
	let project: Project
	
    var body: some View {
		HStack(alignment: .center) {
			VStack(alignment: .center) {
				Spacer()
				VStack {
					Text("What should the story be about?")
						.font(.title)
						.fontWeight(.bold)
					
					Text("This is a brainstorming session. Please jot down all your thoughts related to the story. It's okay to capture your notes in an informal and unstructured manner.")
						.font(.caption)
						.foregroundStyle(Color.fontSecondaryLightMode)
						.multilineTextAlignment(.center)
					
						.frame(width: 600)
						.padding(.top, -15)
				}
				
				TextFieldBasicStyled(placeholder: "Put your ideas here...", text: Bindable(wrappedValue: project).brainstorm)
					.padding(.vertical, 16)
				
				Button {
					withAnimation {
						project.projectStage.next()
					}
				} label: {
					Text("I am happy with the ideas so far")
						.addBackgroundFillToButton()
				}
				.padding(.bottom, 64)
				
				VStack(spacing: 16) {
					
					Text("Questions that could help you come up with ideas")
						.fontWeight(.bold)
					
					QuestionMaster()
						
				}.padding(32).background(Color(white:0.8))
					.clipShape(RoundedRectangle(cornerRadius: 8))
					.opacity(0.7)
				
				
				
				
				Spacer()
			}
			.padding(.horizontal, 128)
		}
		
    }
}

struct QuestionMaster: View {
	let questions: [String] = ["Have you come across any cinematic elements recently that captivated your attention?", "What message or insight do you hope to convey to your audience?", "What's a personal experience you've had that still lingers in your mind?", "What's a moral dilemma you've always wrestled with?", "What genre do you feel most compelled to write in right now?", "Is there a particular emotion or sensation you want your audience to feel while watching your film?", "What's a societal issue or trend you've observed that you think needs more exploration?", "Think of a twist or unexpected revelation that would shock your audience. Now, what story could lead to that moment?", "Are there any themes or topics you're hesitant to delve into?", "Which settings or landscapes do you envision as the backdrop for your narrative?"]
	@State var currentQuestion: String
	@State var index: Int = 0
	
	init() {
		self.currentQuestion = questions[0]
	}
	
	func assignRandomQuestion() {
		index = ((index + 1) % questions.count)
		self.currentQuestion = questions[index]
	}
	
	var body: some View {
		VStack(spacing: 8) {
			Text(currentQuestion)
				.italic()
				.frame(width: 400)
				.multilineTextAlignment(.center)
				//.fontWeight(.bold)
			
			Button {
				assignRandomQuestion()
			} label: {
				Label("Next Question", systemImage: "arrow.2.squarepath")
					.font(.body)
					.foregroundStyle(.gray)
			}
		}
	}
}
