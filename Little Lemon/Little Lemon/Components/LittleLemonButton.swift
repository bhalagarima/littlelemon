//
//  LittleLemonButton.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-11-07.
//

import SwiftUI

enum ButtonType {
    case primary
    case secondary
    case highlighted
    case destructive
}

enum ButtonState {
    case active
    case inactive
}

struct LittleLemonButton: View {
    let buttonTitle: String
    var buttonImage: String?
    let buttonAction: () -> Void
    let buttonType: ButtonType
    let buttonState: ButtonState
    
    var body: some View {
        Button(role: .none,
               action: {
            buttonAction()
        }, label: {
            HStack{
                Text(buttonTitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
          }
        )
        .padding(8)
        .frame(minWidth: 100, maxWidth: .infinity)
        .padding(8)
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .clipShape(buttonType == .highlighted ? AnyShape(.capsule) : AnyShape(RoundedRectangle(cornerRadius: 8)))
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
    
    var foregroundColor: Color {
        switch (buttonType, buttonState) {
        case (.primary, _ ) , (.highlighted, .active):
            return .white
        case (.secondary, _):
            return .black
        case (.destructive, _):
            return .red
        case (.highlighted, .inactive):
            return Color("primaryColor")
        }
    }
    
    var backgroundColor: Color {
        switch (buttonType, buttonState) {
        case (.primary, _), (.highlighted, .active):
            return Color("primaryColor")
        case (.secondary, .active):
            return Color("secondaryColor")
        case (.secondary, .inactive):
            return .white
        case (.destructive, _):
            return .red
        case (.highlighted, .inactive):
            return Color("primaryColor").opacity(0.1)
        }
    }
}

struct LittleLemonButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            LittleLemonButton(
                buttonTitle: "Primary Active",
                buttonImage: "",
                buttonAction: {},
                buttonType: .primary,
                buttonState: .active
            )
            
            LittleLemonButton(
                buttonTitle: "Primary Inactive",
                buttonImage: "",
                buttonAction: {},
                buttonType: .primary,
                buttonState: .inactive
            )
            
            LittleLemonButton(
                buttonTitle: "Secondary Active",
                buttonImage: "",
                buttonAction: {},
                buttonType: .secondary,
                buttonState: .active
            )
            
            LittleLemonButton(
                buttonTitle: "Secondary Inactive",
                buttonImage: "",
                buttonAction: {},
                buttonType: .secondary,
                buttonState: .inactive
            )
            
            LittleLemonButton(
                buttonTitle: "Highlighted Active",
                buttonImage: "",
                buttonAction: {},
                buttonType: .highlighted,
                buttonState: .active
            )
            
            LittleLemonButton(
                buttonTitle: "Highlighted Inactive",
                buttonImage: "",
                buttonAction: {},
                buttonType: .highlighted,
                buttonState: .inactive
            )
        }
    }
}
