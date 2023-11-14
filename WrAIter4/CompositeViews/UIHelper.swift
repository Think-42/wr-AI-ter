//
//  UIHelper.swift
//  WrAIter4
//
//  Created by Sam on 14.11.23.
//

import SwiftUI

extension Color {
	public static let buttonBackgroundColorDarkMode: Color = Color(white: 0.82)
	public static let buttonBackgroundColorLightMode: Color = Color(white: 0.1)
	
	public static let buttonFontColorDarkMode: Color = Color(white: 0)
	public static let buttonFontColorLightMode: Color = Color(white: 1)
	
	public static let cardBackgroundDarkMode: Color = Color(white: 0.2)
	public static let cardBackgroundLightMode: Color = Color(white: 1)
	
	public static let fontDarkMode: Color = Color(white: 0.8)
	public static let fontLightMode: Color = Color(white: 0.1)
	
	public static let fontSecoundaryDarkMode: Color = Color(white: 0.4)
	public static let fontSecondaryLightMode: Color = Color(white: 0.7)
	
	public static let overallBackgroundDarkMode: Color = Color(white: 0)
	public static let overallBackgroundLightMode: Color = Color(white: 0.95)
}

struct ButtonBackgroundFillModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(.horizontal, 24)
			.padding(.vertical, 16)
			.colorSchemeAwareBackgroundColor(light: Color.buttonBackgroundColorLightMode, dark: Color.buttonBackgroundColorDarkMode)
			.colorSchemeAwareForegroundColor(light: Color.buttonFontColorLightMode, dark: Color.buttonFontColorDarkMode)
			.fontWeight(.semibold)
			.foregroundColor(Color.primary)
			.cornerRadius(10)
			.shadow(radius: 4)
	}
}

public extension Color {
	static func colorSchemeAwareColor(lightColor: Color, darkColor: Color, colorScheme : ColorScheme) -> Color {
		return colorScheme == .light ? lightColor : darkColor
	}
}

struct ColorSchemeAwareForegroundModifier: ViewModifier {
	let lightColor: Color
	let darkColor: Color
	
	
	@Environment(\.colorScheme) var colorScheme
	
	func body(content: Content) -> some View {
		content
			.foregroundColor(colorScheme == .light ? lightColor : darkColor)
	}
}

extension View {
	public func colorSchemeAwareForegroundColor(light: Color, dark: Color) -> some View {
		self.modifier(ColorSchemeAwareForegroundModifier(lightColor: light, darkColor: dark))
	}
}

struct ColorSchemeAwareBackgroundModifier: ViewModifier {
	let lightColor: Color
	let darkColor: Color
	
	@Environment(\.colorScheme) var colorScheme
	
	func body(content: Content) -> some View {
		content
			.background(colorScheme == .light ? lightColor : darkColor)
	}
}

extension View {
	public func colorSchemeAwareBackgroundColor(light: Color, dark: Color) -> some View {
		self.modifier(ColorSchemeAwareBackgroundModifier(lightColor: light, darkColor: dark))
	}
}

extension View {
	public func addBackgroundFillToButton() -> some View {
		self.modifier(ButtonBackgroundFillModifier())
	}
}

public struct StepView<T: CaseIterable & CustomStringConvertible & Hashable>: View {
	@Binding var activeStep: T
	
	public init(activeStep: Binding<T>) {
		self._activeStep = activeStep
	}
	
	public var body: some View {
		ZStack {
			HStack {
				let all = T.allCases as! [T]
				ForEach(all, id: \.self) { step in
					
					SingleStepView(step: step, isActive: step == activeStep)
						.onTapGesture {
							self.activeStep = step
						}
					
					if step != all.last {
						Spacer()
						
						Rectangle()
							.frame(height: 1)
						
						Spacer()
					}
				}
			}
			.padding(.horizontal, 0)
			.animation(.easeInOut(duration: 0.3), value: activeStep)
			.background(.clear)
		}.background(.clear)
			.padding(.top, 8)
			.padding(.bottom, 8)
	}
}

struct SingleStepView<T: CaseIterable & CustomStringConvertible & Hashable>: View {
	let step: T
	let isActive: Bool
	
	var body: some View {
		ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
			let all = T.allCases as! [T]
			let stepIndex = all.firstIndex(of: step) ?? 0
			
			Image(systemName: "\(stepIndex + 1).circle\(isActive ? ".fill" : "")")
				.font(.body)
			
			Text(step.description)
				.font(.caption)
				.fontWidth(.condensed)
				.fontWeight(isActive ? .bold : .regular)
				.fixedSize()
				.frame(width: 0, height: 0, alignment: .center)
				.offset(CGSize(width: 0, height: 12.0))
		}
	}
}

public protocol Steppable: CaseIterable, CustomStringConvertible, Hashable, Codable {
	mutating func next()
	mutating func previous()
}

public extension CaseIterable where Self: Steppable & Equatable {
	mutating func next() {
		let all = Self.allCases as! [Self]
		let currentIndex = all.firstIndex(of: self)!
		let nextIndex = all.index(after: currentIndex)
		self = all.indices.contains(nextIndex) ? all[nextIndex] : self
		
		self.didSet()
	}
	
	mutating func previous() {
		let all = Self.allCases as! [Self]
		guard let currentIndex = all.firstIndex(of: self) else { return }
		if currentIndex == all.startIndex {
			
		} else {
			let previousIndex = all.index(before: currentIndex)
			self = all[previousIndex]
		}
		
		self.didSet()
	}
	
	func didSet() {
		
	}
}


public struct TextFieldBasicStyled: View {
	let placeholder: String
	@Binding var text: String
	let lineWidth: CGFloat
	
	@Environment(\.colorScheme) var colorScheme
	
	public init(placeholder: String, text: Binding<String>, lineWidth: CGFloat = 2) {
		self.placeholder = placeholder
		self._text = text
		self.lineWidth = lineWidth
	}
	
	public var body: some View {
		TextField(placeholder, text: self.$text, axis: .vertical)
			.font(.body)
			.multilineTextAlignment(.leading)
			.padding()
			.colorSchemeAwareBackgroundColor(light: Color.cardBackgroundLightMode, dark: Color.cardBackgroundDarkMode)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.overlay(
				RoundedRectangle(cornerRadius: 10)
					.stroke(Color.colorSchemeAwareColor(lightColor: Color.fontLightMode, darkColor: Color.fontDarkMode, colorScheme: colorScheme), lineWidth: lineWidth)
			)
		//.colorSchemeAwareForegroundColor(light: Color.fontLightMode, dark: Color.fontDarkMode)
		//.clipShape(RoundedRectangle(cornerRadius: 10))
	}
	
}

public extension Collection {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

public struct IconButtonModifier: ViewModifier {
	public func body(content: Content) -> some View {
		ZStack(alignment: .center) {
			content
				.font(.headline)
				.colorSchemeAwareForegroundColor(light: Color(white: 0.3), dark: .fontSecoundaryDarkMode)
		}.frame(width: 20, height: 20)
			.padding(6)
			.colorSchemeAwareBackgroundColor(light: Color(white: 0.8), dark: Color(white: 0.5))
			.cornerRadius(6)
	}
}

extension View {
	public func iconButton() -> some View {
		self.modifier(IconButtonModifier())
	}
}
