//
//  DetailView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 20.02.2023.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var event: Race?
    
    var body: some View {
        ZStack{
            if let event = event {
                DetailView(event: event)
            }
        }
    }
    
}


struct DetailView: View {
    
    let event: Race
    
    init(event: Race) {
        self.event = event
    }
    
    var body: some View {

                Text(event.raceName)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(event: dev.event)
    }
}
