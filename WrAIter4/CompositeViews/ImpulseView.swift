//
//  ImpulseView.swift
//  WrAIter4
//
//  Created by Sam on 10.09.23.
//

import SwiftUI

struct ImpulseStack: View {
	var storyBeat: StoryBeat
	let impulseAI = ImpulseAI()
	
	var body: some View {
		VStack(alignment: .leading) {
			if storyBeat.impulseStage == .loading || storyBeat.impulseStage == .shown {
				ForEach(storyBeat.impulses.indices, id: \.self) { impulseIndex in
					ImpulseView(storyBeat: storyBeat, index: impulseIndex, isLoading: .constant(false))
						
				}
			}
		}
		.frame(width: STORY_BEAT_WIDTH)
		.onAppear {
			if storyBeat.impulseStage == .wantsToBeInitialized {
				storyBeat.impulseStage = .loading
				runAI()
			}
		}
		.onChange(of: storyBeat.impulseStage) { _, newValue in
			if newValue == .wantsToBeInitialized {
				storyBeat.impulseStage = .loading
				runAI()
			}
		}
		//.animation(.bouncy, value: storyBeat.impulses)
		.animation(.bouncy, value: storyBeat.impulseStage)
		//.background(.red)
	}
	
	func runAI() {
		DispatchQueue.main.async {
			Task {
				// before running the AI set all others to hidden
				
				for storybeat in storyBeat.project!.storyBeats {
					if storybeat.index == storyBeat.index {
						
					} else {
						if storybeat.impulseStage == .wantsToBeInitialized || storybeat.impulseStage == .loading ||
							storybeat.impulseStage == .shown {
							storybeat.impulseStage = .hidden
						}
					}
				}
				
				do {
					let output = try await impulseAI.run(input: storyBeat)
					storyBeat.impulses = output
					storyBeat.impulseStage = .shown
				} catch {
					print(String(repeating: "❌", count: 12))
				}
			}
		}
	}
}

struct ImpulseView: View {
	var storyBeat: StoryBeat
	let index: Int
	@Binding var isLoading: Bool
	
    var body: some View {
		HStack {
			MatrixTextWrapper(text: Bindable(storyBeat).impulses[index], isLoading: self.$isLoading) { displayText in
				Text(displayText.wrappedValue)
					.font(.caption)
			}
			Spacer()
		}
		.padding()
		.background(Color.cardBackgroundLightMode)
		.cornerRadius(8)
		.frame(width: STORY_BEAT_WIDTH)
		.transition(.scale(0, anchor: .top).combined(with: .opacity))
    }
}
