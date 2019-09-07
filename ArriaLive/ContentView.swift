//
//  ALSlider.swift
//  ArriaLive
//
//  Created by Michael Arrington on 9/5/19.
//  Copyright © 2019 Duct Ape Productions. All rights reserved.
//

import SwiftUI

// MARK: Slot View
fileprivate struct SlotView: View {
	
	let position: CGFloat
	let lineThickness: CGFloat
	
	var body: some View {
		GeometryReader { (geometry) in
			ZStack {
				RoundedRectangle(cornerRadius: geometry.size.width / 2,
												 style: .circular)
					.foregroundColor(.purple)
				
				HStack {
					Spacer()
					
					RoundedRectangle(cornerRadius: 6,
													 style: .circular)
						.frame(width: geometry.size.width * (1 - self.position) - self.lineThickness * 2,
									 height: geometry.size.height - self.lineThickness * 2,
									 alignment: .bottomTrailing)
						.foregroundColor(.white)
						.padding(.trailing, self.lineThickness)
				}
			}
		}
	}
}

// MARK: Knob View
fileprivate struct KnobView: View {
	
	var body: some View {
		VStack {
			Spacer()
			ForEach(0..<7) { (_) in
				Rectangle()
					.frame(height: 1)
					.foregroundColor(.yellow)
			}
			Spacer()
		}
		.background(
			RoundedRectangle(cornerRadius: 4)
				.foregroundColor(.purple))
	}
}

// MARK: ALSlider
struct ALSlider: View {
	@State var position: CGFloat {
		didSet {
			// notify SDK
		}
	}
	
	var body: some View {
		GeometryReader { (geometry) in
			ZStack {
				SlotView(position: self.position, lineThickness: 2)
					.frame(height: 16)
				
				KnobView()
					.frame(width: 40, height: 80)
					.rotationEffect(Angle(degrees: -90))
					.position(x: geometry.size.width * self.position,
										y: geometry.size.height / 2)
					.gesture(DragGesture().onChanged { (value) in
						let pos = value.location.x / geometry.size.width
						self.position = max(0, min(pos, 1))
					})
			}
		}
	}
}

// MARK: Wrapper View
struct WrapperView: View {
	
	@State var position: Double = 0.0
	
	private var rotation: Double {
		switch UIDevice.current.orientation {
		case .landscapeLeft, .landscapeRight:
			return 0
		default:
			return 90
		}
	}
	
	var body: some View {
		VStack {
			ALSlider(position: 0.33)
			Slider(value: self.$position, in: 0...1)
		}
	}
}

struct ALSlider_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SlotView(position: 0.0, lineThickness: 2)
				.previewDisplayName("SlotView")
				.previewLayout(.fixed(width: 600, height: 16))
			KnobView()
				.previewDisplayName("KnobView")
				.previewLayout(.fixed(width: 40, height: 80))
			WrapperView()
				.previewDisplayName("ALSlider")
				.frame(width: 300)
			WrapperView()
				.previewDevice("iPad Pro (9.7-inch)")
				.padding()
		}
	}
}
