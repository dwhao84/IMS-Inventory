import SwiftUI
import UIKit

struct PersonalAnimatedView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            SwiftUI.Image(systemName: "person")
                .resizable().scaledToFit()
                .imageScale(.large)
                .foregroundStyle(Color.black)
                .frame(width: 150, height: 130)
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        scale = 0.9
                    }
                }
            Text("Create your account")
                .bold()
        }
    }
}

#Preview {
    PersonalAnimatedView()
}
