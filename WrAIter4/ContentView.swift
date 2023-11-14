//
//  ContentView.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [Project]
	
	@State var showProjectCreationAlert: Bool = false
	@State var newProjectName: String = ""

    var body: some View {
        NavigationSplitView {
            List {
				ForEach(projects) { project in
                    NavigationLink {
						ProjectSteps(project: project)
							.colorSchemeAwareBackgroundColor(light: .overallBackgroundLightMode, dark: .overallBackgroundDarkMode)
							.navigationTitle(project.name)
							.navigationBarTitleDisplayMode(.inline)
                    } label: {
						Text(project.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
			.navigationTitle("Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
					Button(action: {
						showProjectCreationAlert = true
					}) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
			.alert("Enter the project name", isPresented: $showProjectCreationAlert) {
				TextField("Project name...", text: self.$newProjectName)
				Button("Cancel", role: .cancel) {
					showProjectCreationAlert = false
				}
				Button("OK") {
					withAnimation {
						modelContext.insert(Project(name: newProjectName))
					}
					
					showProjectCreationAlert = false
				}
			} message: {
				Text("Please insert a project name for the story you are working on.")
			}
        } detail: {
            Text("Select an item")
		}.animation(.easeInOut, value: projects)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(projects[index])
            }
        }
    }
}
