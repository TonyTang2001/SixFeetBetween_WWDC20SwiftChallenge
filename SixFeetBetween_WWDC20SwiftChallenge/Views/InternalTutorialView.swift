import SwiftUI

public struct InTutorialView: View {
    
    @State private var xDistance: CGFloat = 0
    @State private var yDistance: CGFloat = 0
    @State private var isDragging: Bool = false
    
    @State var animate1Start = false
    @State var animate1End = false
    @State var animate2Start = false
    @State var animate2End = false
    @State var animate3Start = false
    @State var animate3End = false
    @State var animate4Start = false
    @State var animate4End = false
    @State var animate5Start = false
    @State var animate5End = false
    @State var animate6Start = false
    
    public init() {}
    public var body: some View {
        ZStack {
            VStack {
                FactoryView()
                    .frame(width: mapIconSize, height: mapIconSize)
                    .opacity(self.animate2Start ? 1 : 0)
                
                Spacer()
                
                LabView()
                    .frame(width: mapIconSize, height: mapIconSize)
                    .opacity(self.animate1Start ? 1 : 0)
            }
            .animation(Animation.easeInOut(duration: 0.8))
            
            InternalTutorialPart1View(animate1Start: $animate1Start, animate1End: $animate1End, animate2Start: $animate2Start, animate2End: $animate2End, animate3Start: $animate3Start)
            .opacity((self.animate1Start && !self.animate2End) ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
            InternalTutorialPart2View(animate3Start: $animate3Start, animate3End: $animate3End, animate4Start: $animate4Start)
            .opacity((self.animate3Start && !self.animate3End) ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
            VStack {
                Spacer()
                
                Text("To reach your destination, \nyou will need to use \"Bink\".\n\nTo move, just drag anywhere on screen, \nninja will blink once you release your finger.\n\nJust TRY IT OUT!")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity((self.animate4Start && !self.animate4End) ? 1 : 0)
                    .animation(Animation.easeInOut(duration: 0.8))
                
                Spacer()
                
                PlayerView(inputX: $xDistance, inputY: $yDistance, showPathPreview: $isDragging, gameEnded: .constant(false), tutorialMode: true)
                
                Spacer()
                
                Button(action: {
                    self.animate4End = true
                    self.animate5Start = true
                }) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.system(.title, design: .rounded))
                }
                .opacity((self.animate4Start && !self.animate4End) ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.8))
                
                Spacer()
            }
                .background(Color.white.opacity(0.00001))
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.isDragging = true
                        self.xDistance = value.translation.width
                        self.yDistance = value.translation.height
                    })
                    .onEnded({ (value) in
                        self.isDragging = false
                    })
                )
                .opacity((self.animate4Start && !self.animate4End) ? 1 : 0)
            
            InternalTutorialPart3View(animate5End: $animate5End, animate6Start: $animate6Start)
            .opacity((self.animate5Start && !self.animate5End) ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
            VStack {
                Spacer()
                Spacer()
                Text("That's all.\nIt's your time to save the world.")
                    .fontWeight(.semibold)
                    .font(.system(.title, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(self.animate6Start ? 1 : 0)
                Spacer()
                Text("Go to the Next page to start.")
                    .fontWeight(.semibold)
                    .font(.system(.callout, design: .rounded))
                    .multilineTextAlignment(.center)
                    .opacity(self.animate6Start ? 1 : 0)
                Spacer()
            }
            .opacity(self.animate6Start ? 1 : 0)
            .animation(Animation.easeInOut(duration: 0.8))
            
        }
        .onAppear {
            self.animate1Start = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.animate2Start = true
            }
        }
        
        
    }
    
}

struct InTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        InTutorialView()
    }
}
