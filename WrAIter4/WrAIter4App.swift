//
//  WrAIter4App.swift
//  WrAIter4
//
//  Created by Sam on 04.09.23.
//


/*
 
 Next up ToDos:
 
 - also think about the export thing
 
 */

import SwiftUI
import SwiftData
import TipKit

let USE_GPT_3_5 = false

@main
struct WrAIter4App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
				.preferredColorScheme(.light)
				.task {
					try? Tips.configure([
						.displayFrequency(.immediate),
						.datastoreLocation(.applicationDefault)
					])
					
					Tips.showAllTipsForTesting()
				}
        }
        .modelContainer(sharedModelContainer)
		
    }
}
