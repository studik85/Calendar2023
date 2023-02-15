//
//  ScheduleRowView.swift
//  Calendar2023
//
//  Created by Andrey Studenkov on 13.02.2023.
//

import SwiftUI

struct ScheduleRowView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    let racingEvent: Race
    
    var body: some View {
        HStack(spacing: 0) {
            Text(racingEvent.round)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            EventFlagImageView(event: racingEvent)
                .frame(width: 30, height: 16)
                .cornerRadius(4)
            Text(racingEvent.raceName)
                .font(.caption)
                .bold()
                .lineLimit(0)
                .minimumScaleFactor(0.7)
                .padding(.leading, 45)
                .foregroundColor(Color.theme.accent)
            Spacer()
            VStack(alignment: .trailing) {
                Text(vm.convertUTCDateToLocalDateString(date: racingEvent.date, time: racingEvent.time))
                    .font(.caption)
                    .bold()
                    .lineLimit(0)
                    .foregroundColor(Color.theme.accent)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: UIScreen.main.bounds.width / 3.5)
        }
        .font(.subheadline)
    }
}

struct ScheduleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRowView(racingEvent: dev.event)
            .environmentObject(dev.homeVM)
    }
}
