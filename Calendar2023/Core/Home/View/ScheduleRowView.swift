//
//  ScheduleRowView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 13.02.2023.
//

import SwiftUI

struct ScheduleRowView: View {
    
    let racingEvent: Race
    
    var body: some View {
        HStack(spacing: 0) {
            Text(racingEvent.round)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Rectangle()
                .frame(width: 40, height: 30)
                .cornerRadius(10)
            Text(racingEvent.raceName)
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
            Spacer()
            VStack(alignment: .trailing) {
                Text(racingEvent.date)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                Text(racingEvent.time)
                    .bold()
                    .foregroundColor(Color.theme.accent)
            }
//            .padding(.trailing)
            .frame(width: UIScreen.main.bounds.width / 3.5)
        }
        .font(.subheadline)
    }
}

struct ScheduleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRowView(racingEvent: dev.event)
    }
}
