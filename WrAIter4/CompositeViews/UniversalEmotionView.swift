//
//  ImpulseView.swift
//  WrAIter4
//
//  Created by Sam on 10.09.23.
//

import SwiftUI

struct UniversalEmotionView: View {
	var storyBeat: StoryBeat
	@Binding var isLoading: Bool
	
	var body: some View {
		if storyBeat.universalEmotionStage == .loading || storyBeat.universalEmotionStage == .shown {
			HStack {
				MatrixTextWrapper(text: Bindable(storyBeat).universalEmotion, isLoading: self.$isLoading) { displayText in
					if isLoading {
						ProgressView()
					} else {
						VStack {
							Text("Universal Emotion\n")
								.fontWeight(.bold)
							Text(displayText.wrappedValue)
								
						}.font(.caption)
							.multilineTextAlignment(.leading)
						
					}
					
				}
				Spacer()
			}
			.padding()
			.background(Color(UIColor.orange))
			.cornerRadius(8)
			.frame(width: STORY_BEAT_WIDTH)
			.transition(.scale(0, anchor: .top).combined(with: .opacity))
			.padding(.top, 16)
		}
	}
}
