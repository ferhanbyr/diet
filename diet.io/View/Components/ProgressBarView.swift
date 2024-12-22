import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(color.opacity(0.3))
                
                Rectangle()
                    .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width))
                    .foregroundColor(color)
                    .animation(.linear, value: progress)
            }
            .cornerRadius(10)
        }
    }
} 