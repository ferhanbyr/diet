import SwiftUI

struct CustomButtonView: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    let disabled: Bool
    let type: ButtonType
    
    init(
        title: String,
        isLoading: Bool = false,
        disabled: Bool = false,
        type: ButtonType = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.disabled = disabled
        self.type = type
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: type.tintColor))
                } else {
                    Text(title)
                        .foregroundColor(type.textColor)
                        .font(.custom(type.fontName, size: type.fontSize))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: type.height)
        .background(disabled ? Color.gray.opacity(0.3) : type.backgroundColor)
        .cornerRadius(type.cornerRadius)
        .disabled(disabled || isLoading)
        .shadow(radius: 5)

    }
}

enum ButtonType {
    case primary
    case secondary
    case small
    case link
    
    var backgroundColor: Color {
        switch self {
        case .primary: return Color("LoginGreen")
        case .secondary: return Color("LoginGreen2")
        case .small: return Color("BittersweetOrange")
        case .link: return Color("SoftBlue")
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary, .small: return .white
        case .secondary: return .white
        case .link: return .blue
        }
    }
    
    var height: CGFloat {
        switch self {
        case .primary: return 60
        case .secondary: return 60
        case .small: return 36
        case .link: return 30
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .primary, .secondary: return 18
        case .small, .link: return 14
        }
    }
    
    var fontName: String {
        switch self {
        case .primary: return "DynaPuff"
        case .secondary: return "DynaPuff"
        case .small: return "DynaPuff"
        case .link: return "DynaPuff"
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .primary, .secondary: return 10
        case .small: return 8
        case .link: return 0
        }
    }
    
    var tintColor: Color {
        switch self {
        case .primary, .small: return .white
        case .secondary, .link: return .blue
        }
    }
}

#Preview {
    OnboardingView()
}
