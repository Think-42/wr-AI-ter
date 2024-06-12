//
//  StructureView.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import SwiftUI
import SwiftData
import TipKit

struct LockStoryBeat: Tip {
    
    var image: Image {
        Image(systemName: "lock.square")
    }
    
    var title: Text {
        Text("Lock story beat")
    }
    
    var message: Text {
        Text("Befor 're-folling' the story beats, you can lock selected one to not get changed in the next iteration.")
    }
}

struct StructureView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var isRunning: Bool = false
    let structureAI = StructureAI()
    
    let project: Project
    
    @Query(sort: \StoryBeat.index, order: .forward)
    private var storyBeats: [StoryBeat]
    
    var relevantStoryBeats: [StoryBeat] {
        storyBeats.filter({$0.project == project})
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(relevantStoryBeats, id: \.id) { storyBeat in
                    StoryBeatView(storyBeat: storyBeat, isLoading: storyBeat.locked ? .constant(false) : $isRunning)
                }
            }.padding(.horizontal, 128)
            
            Button {
                runAI()
            } label: {
                if isRunning {
                    ProgressView()
                        .tint(.white)
                        .addBackgroundFillToButton()
                        .tint(.white)
                } else {
                    Text("Regenerate not-locked storybeats")
                        .addBackgroundFillToButton()
                }
            }
            
            Button(action: {
                self.project.projectStage = .refinement
            }, label: {
                Text("Next")
                    .addBackgroundFillToButton()
            })

        }.onAppear {
            if shouldAIRunOnAppear() {
                runAI()
            }
        }
    }
    
    func shouldAIRunOnAppear() -> Bool {
        if self.relevantStoryBeats.count >= 5 {
            print("[AI:] will not run")
            return false
        } else {
            return true
        }
    }
    
    func runAI() {
        DispatchQueue.main.async {
            Task {
                self.isRunning = true
                defer {
                    self.isRunning = false
                }
                
                do {
                    var inputString = "My brainstorm for this story is:\n\(project.brainstorm)\n"
                    
                    if relevantStoryBeats.isEmpty {
                        inputString += ""
                    } else {
                        inputString += "My story structure so far is:\n \(relevantStoryBeats.description_locked)"
                    }
                    
                    let output = try await structureAI.run(input: inputString)
                    
                    // replace only the non-locked story beats with the suggestions
                    
                    for (index, storyBeatString) in output.enumerated() {
                        if let storyBeat = relevantStoryBeats[safe: index] {
                            if storyBeat.locked {
                                // if the storybeat is locked nothing should happen
                            } else {
                                storyBeat.text = storyBeatString
                            }
                        } else {
                            // the storybeat does not exists... meaning that we have to create one (this always happens when there are no storyBeats to begin with)
                            
                            let newStoryBeat = StoryBeat(text: storyBeatString, index: index)
                            modelContext.insert(newStoryBeat)
                            newStoryBeat.project = project
                        }
                    }
                } catch {
                    print(String(repeating: "❌", count: 12))
                }
            }
        }
    }
}
