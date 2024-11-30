import SwiftUI
import UIKit

struct PersonalAnimatedView: View {
    static let person_badge = UIImage(systemName: "person.badge.plus")!
    @State private var isAnimating = false
    @State private var showBadge = false
    
    var body: some View {
        SwiftUI.Image(systemName: showBadge ? "person.badge.plus" : "person")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .scaleEffect(isAnimating ? 1.2 : 1.0)
            .animation(.bouncy(duration: 1), value: isAnimating)
            .onAppear {
                // 設定定時器來自動切換圖示
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                    withAnimation(.spring()) {
                        showBadge.toggle()
                        isAnimating.toggle()
                    }
                }
            }
    }
}

#Preview {
    PersonalAnimatedView()
}
