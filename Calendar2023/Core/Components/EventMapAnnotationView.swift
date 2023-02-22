//
//  EventMapAnnotationView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 22.02.2023.
//

import SwiftUI

struct EventMapAnnotationView: View {
    var body: some View {
        
        VStack(spacing: 0){
            Image(systemName: "flag.checkered.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
                .font(.headline)
                .foregroundColor(Color.theme.background)
                .padding(6)
                .background(Color.theme.accent)
                .clipShape(Circle())
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.theme.accent)
                .frame(width: 10, height: 10)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -3)
                .padding(.bottom, 40)
        }
    }
}
struct EventMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        EventMapAnnotationView()
    }
}
