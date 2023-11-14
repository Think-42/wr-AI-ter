//
//  ProjectSteps.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import Foundation
import SwiftUI

struct ProjectSteps: View {
	var project: Project
	
	var body: some View {
		VStack(alignment: .center) {
			StepView(activeStep: Bindable(project).projectStage)
				.padding(.bottom, 16)
			.padding(.horizontal, 128)
			
			Group {
				switch project.projectStage {
				case .brainstorm:
					Brainstorm(project: project)
				case .structure:
					StructureView(project: project)
				case .refinement:
					Refinement(project: project)
				case .export:
					Export(project: project)
				}
			}
				.onChange(of: self.project.projectStage) { _, _ in
					switch self.project.projectStage {
					case .brainstorm:
						Task {
							
						}
						break
					case .structure:
						//TODO: Add 5 Story Beats
						break
					case .refinement:
						//TODO: remove all locked values
						for storyBeat in project.storyBeats {
							storyBeat.locked = false
						}
						
						break
					case .export:
						break
					}
				}
			
			Spacer()
		}
		
	}
}
