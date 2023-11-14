import SwiftUI
import Foundation
import Combine

#Preview {
	if #available(iOS 17.0, *) {
		SimpleMatrixTestPreview()
	} else {
		EmptyView()
		// Fallback on earlier versions
	}
}

public extension String {
	// TODO: a better way would be to use AttributedString with an opacity value and a ZStack
	//	var fixWidow: String {
	//		// "\u{200B}" is a zero-widht whitespace
	//		// Apple is "smart" with texts and tries to avoid orphans. If you dont want that, you can use this modifier... Than line breaks are more like you expect them to be, but might look less asethtically pleasing.
	//		self + String(repeating: "\u{200B}", count: 15)
	//	}
}

@available(iOS 17.0, *)
public struct SimpleMatrixTestPreview : View {
	@StateObject var matrixText = SimpleMatrixText(targetText: "Das ist ein sehr langer Text und ich frage mich wie das da aussieht.")
	
	public init() {
		
	}
	
	public var body: some View {
		VStack {
			VStack(alignment: .leading) {
				SimpleMatrixTextWrapper(matrixText: matrixText) { string in
					Text(string)
				}
				.multilineTextAlignment(.leading)
				.fontDesign(.monospaced)
			}
			Button {
				matrixText.next()
			} label: {
				Text("call 'next()'")
			}
		}
	}
}

@available(iOS 17.0, *)
public struct SimpleMatrixTextWrapper<Content: View>: View {
	@ObservedObject var matrixText: SimpleMatrixText
	
	let content: (AttributedString) -> Content
	
	public init(matrixText: SimpleMatrixText,
				@ViewBuilder content: @escaping (AttributedString) -> Content
	) {
		self.matrixText = matrixText
		self.content = content
	}
	
	public var body: some View {
		ZStack {
			content(matrixText.text)
			content(matrixText.targetText)
		}
	}
}


public class SimpleMatrixText: ObservableObject {
	@Published var text: AttributedString = ""
	@Published var targetText: AttributedString
	
	private var timerSubscription: AnyCancellable?
	private let timer = Timer.publish(every: 0.05, on: .main, in: .default).autoconnect()
	
	
	private var currentTick: Int = 0
	
	public init(targetText: String) {
		self.targetText = AttributedString(targetText)
		self.targetText.foregroundColor = UIColor(white: 0, alpha: 0.5)
	}
	
	public func next() {
		print("test")
		startTimer()
	}
	
	private func startTimer() {
		print("test3")
		
		timerSubscription = timer.sink { [weak self] _ in
			print("Timer ticked!")
			guard let strongSelf = self else { return }
			strongSelf.moveTextTowardsTargetText()
		}
	}
	
	private func moveTextTowardsTargetText() {
		print("testsafdasdf")
		currentTick += 1
		
		self.text = AttributedString(String(targetText.description).prefix(currentTick))
		
		if currentTick >= targetText.description.count {
			timerSubscription?.cancel()
		}
	}
}

@available(iOS 17.0, *)
private struct MatrixTestPreview : View {
	@State var text: String = "abcedfghi"
	@State var isLoading: Bool = false
	
	var body: some View {
		MatrixTextWrapper(text: self.$text, isLoading: self.$isLoading) { displayText in
			TextFieldBasicStyled(placeholder: "Test", text: displayText)
		}
		
		MatrixTextWrapper(text: self.$text, isLoading: self.$isLoading) { displayText in
			Text(displayText.wrappedValue)
		}
		
		Button {
			text = "Das ist ein sehr langer Text und ich frage mich wie das da aussieht."
		} label: {
			Text("Set text to 1")
		}
		
		Button {
			text = "Das ist ein anderer Text... mal schauen ob er das auc genauso gut kann, oder ob er da ein bisschen schlechter wird. Es bleibt spannend"
		} label: {
			Text("Set text to 2")
		}
		
		Button {
			isLoading = true
		} label: {
			Text("isLoading")
		}
	}
}

// FIXME: the binding does not work... the value is not changed.
@available(iOS 17.0, *)
public struct MatrixTextWrapper<Content: View>: View {
	@Binding var text: String
	@Binding var isLoading: Bool
	@State var displayText: String
	
	@StateObject
	var matrixText: MatrixText
	
	let content: (Binding<String>) -> Content
	
	public init(text: Binding<String>,
				isLoading: Binding<Bool>,
				@ViewBuilder content: @escaping (Binding<String>) -> Content
	) {
		self._text = text
		self._isLoading = isLoading
		self._displayText = State(initialValue: text.wrappedValue)
		self._matrixText = StateObject(wrappedValue: MatrixText(text: text.wrappedValue))
		self.content = content
	}
	
	public var body: some View {
		content($displayText)
			.fontDesign(.monospaced)
			.onChange(of: matrixText.text) { _, _ in
				self.displayText = matrixText.text
			}
			.onChange(of: text) { _, _ in
				isLoading = false
				matrixText.state = .movingTo(targetText: text)
			}
		//FIXME: that causes a feedback loop that would be necessary to change the text to displayText based on a TextField... that has to be solved with an internal state or something like it...
		//			.onChange(of: displayText, { oldValue, newValue in
		//				self.text = displayText
		//			})
			.onChange(of: isLoading) { _, _ in
				if isLoading {
					matrixText.state = .random
				}
			}
	}
}

class MatrixText: ObservableObject {
	@Published var text: String
	@Published var state: TextState {
		didSet {
			handleStateChange()
		}
	}
	
	enum TextState {
		case constant(text: String)
		case movingTo(targetText: String)
		case random
	}
	
	let ticksNeededToTransformTheWholeWord: Int = 10 // how many ticks are needed for the transformation from "movingTo" to "constant"
	
	private var timerSubscription: AnyCancellable?
	private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
	
	
	// variables for "changingTo"
	private var currentTick: Int = 0
	private var maxTicks: Int = 10
	
	private var lengthChangePerTick: Double = -1 // the overall length of the string
	private var charsToMatchPerTick: Double = -1 // the length of the targetText displayed already
	
	init(text: String) {
		self.text = text
		self.state = .constant(text: text)
	}
	
	private func handleStateChange() {
		// Stop the timer if it's running
		timerSubscription?.cancel()
		
		switch state {
		case .constant(let text):
			self.text = text
			currentTick = 0
			lengthChangePerTick = -1
			charsToMatchPerTick = -1
		case .movingTo(let targetText):
			// calculate the initial values
			let lengthDiff: Int = targetText.count - text.count
			lengthChangePerTick = Double(lengthDiff) / Double(maxTicks)
			charsToMatchPerTick = Double(targetText.count) / Double(maxTicks)
			
			startTimer()
		case .random:
			startTimer()
		}
	}
	
	private func startTimer() {
		timerSubscription = timer.sink { [weak self] _ in
			self?.changeText()
		}
	}
	
	private func changeText() {
		switch state {
		case .constant(_):
			print("[Text:] Something went wrong!")
		case .movingTo(let targetText):
			moveTextTowardsTargetText(targetText: targetText)
		case .random:
			self.text = text.randomizeText(probability: 0.1)
		}
	}
	
	private func moveTextTowardsTargetText(targetText: String) {
		assert(lengthChangePerTick != -1)
		assert(charsToMatchPerTick != -1)
		
		currentTick += 1
		
		adjustTextLength(to: targetText.count)
		self.text = text.randomizeText(probability: 0.1)
		setCharsToTargetTextAccordingToCurrentTick(targetText: targetText)
		
		if currentTick >= maxTicks {
			state = .constant(text: targetText)
		}
	}
	
	private func setCharsToTargetTextAccordingToCurrentTick(targetText: String) {
		let charsThatShouldBeSetToTargetText = max(1,Int(Double(charsToMatchPerTick * Double(currentTick)).rounded(.toNearestOrEven)))
		let textToOverride: String = String(targetText.prefix(charsThatShouldBeSetToTargetText))
		text = text.override(with: textToOverride)
	}
	
	private func adjustTextLength(to targetLength: Int) {
		guard targetLength != text.count else {
			return
		}
		
		if lengthChangePerTick > 0 {
			increaseTextLength(upTo: targetLength)
		} else if lengthChangePerTick < 0 {
			decreaseTextLength(downTo: targetLength)
		}
	}
	
	private func increaseTextLength(upTo targetLength: Int) {
		var numberToAdd = max(1, Int(lengthChangePerTick.rounded(.toNearestOrEven)))
		while numberToAdd > 0 {
			text += String.randomCharacterOfCharArray()
			numberToAdd -= 1
		}
	}
	
	private func decreaseTextLength(downTo targetLength: Int) {
		var numberToRemove = max(1, abs(Int(lengthChangePerTick.rounded(.toNearestOrEven))))
		while numberToRemove > 0 {
			text = String(text.dropLast())
			numberToRemove -= 1
		}
	}
}

extension String {
	static let charArray: [Character] = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	
	public func randomizeText(probability: Double) -> String {
		return String(self.map {
			Double.random(in: 0...1) < probability ? (String.charArray.randomElement() ?? $0) : $0
		})
	}
	
	public static func randomCharacterOfCharArray() -> String {
		return String(String.charArray.randomElement() ?? "x")
	}
}

extension String {
	public func override(with str: String) -> String {
		// get the prefix of the original string that we want to replace
		let replaced = self.prefix(str.count)
		// create the new string by replacing the prefix with the new string and appending the rest
		let result = str + self.dropFirst(replaced.count)
		return result
	}
}

import Foundation

extension AttributedString {
	public func override(with str: AttributedString) -> AttributedString {
		// Check if the original string is shorter than the one we want to use for replacement.
		// If so, simply return the new string
		if self.characters.count < str.characters.count {
			return str
		}
		
		// Create a mutable copy of the original attributed string to modify
		var result = NSMutableAttributedString(attributedString: self.nsAttributedString)
		
		// Get the range of the prefix of the original string that we want to replace
		let rangeToReplace = NSRange(location: 0, length: str.characters.count)
		
		// Replace the prefix range with the new attributed string
		result.replaceCharacters(in: rangeToReplace, with: str.nsAttributedString)
		
		return AttributedString(result)
	}
}

extension AttributedString {
	var nsAttributedString: NSAttributedString {
		return NSAttributedString(self)
	}
}
