//
//  4_Export.swift
//  WrAIter4
//
//  Created by Sam on 13.09.23.
//

import SwiftUI
import OSLog

struct Export: View {
	let logger = Logger(subsystem: "Export", category: "AI")
	
	let project: Project
	let exportAI: ExportAI = .init()
	
	func createFile(fileContent: String) -> URL {
		do {
			if let data = fileContent.data(using: .utf8) {
				// Create a temporary file with the ".fountain" extension
				let tempDirectory = NSTemporaryDirectory()
				let tempFileURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent("exported_script").appendingPathExtension("fountain")
				
				// Write the data to the file
				try data.write(to: tempFileURL)
				
				return tempFileURL
			}
		} catch {
			logger.critical("\(error)")
		}
		return URL(string: "https://img.freepik.com/vektoren-kostenlos/hoppla-404-fehler-mit-einer-kaputten-roboterkonzeptillustration_114360-5529.jpg?w=1380&t=st=1695056026~exp=1695056626~hmac=04178d291a7f39fcb9307c48c1bac99b060e3edaf763571ae0f1bb5efe5537f2")!
	}
	
    var body: some View {
		ScrollView {
			Button {
				runExportAI()
			} label: {
				Text(project.export.isEmpty ? "Generate Export" : "Re-Generate Export")
					.addBackgroundFillToButton()
			}.padding(.vertical, 32)
			
			if !project.export.isEmpty {
				Text(project.export)
					.frame(width: 500)
					.multilineTextAlignment(.leading)
					.fontDesign(.monospaced)
					
			}
			HStack {
				Spacer()
				Text("")
				Spacer()
			}
			
			if !project.export.isEmpty {
				ShareLink(item: createFile(fileContent: project.export)) {
					Text("Share")
						.addBackgroundFillToButton()
				}
			}
		}.scrollIndicators(.hidden)
    }
	
	func runExportAI() {
		DispatchQueue.main.async {
			Task {
				do {
					let output = try await exportAI.run(input: project)
					
					project.export = output
				} catch {
					logger.critical("We encountered an error! \(error)")
				}
			}
		}
	}
}
