//
//  EventFlagImageView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 14.02.2023.
//

import SwiftUI




struct EventFlagImageView: View {
    
    @StateObject var vm: EventFlagImageViewModel
    
    init(event: Race) {
        _vm = StateObject(wrappedValue: EventFlagImageViewModel(event: event))
    }
    
    
    var body: some View {
        ZStack{
            if let image = vm.flagImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct EventFlagImageView_Previews: PreviewProvider {
    static var previews: some View {
        EventFlagImageView(event: dev.event)
    }
}
