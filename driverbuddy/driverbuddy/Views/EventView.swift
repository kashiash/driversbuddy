//
//  EventView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 04/03/2024.
//

import SwiftUI

struct EventView: View {
    @State var description = "jakis fajny tekst"

    @State var currentDate: Date = .now.addingTimeInterval(1000005 * 600)

    let calendar = Calendar.current

    var body: some View {
        Form{
            VStack {
                TextField("",text: $description)
                HStack {
                    DatePicker("", selection: $currentDate)

                    Text(timeRemaining())
                        .font(.caption)
                        .padding()
                }

               // LazyVGrid(columns: columns, spacing: 10) {
                HStack {
                    Button("09:30") { 
                        currentDate =   calendar.date(bySettingHour: 9, minute: 30, second: 0, of: currentDate)!
                    }

                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                    Button("12:00") {

                        currentDate =   calendar.date(bySettingHour: 12, minute: 00, second: 0, of: currentDate)!
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("18:30") { 
                        currentDate =   calendar.date(bySettingHour: 18, minute: 30, second: 0, of: currentDate)!
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("22:00") {
                        currentDate =   calendar.date(bySettingHour: 22, minute: 00, second: 0, of: currentDate)!
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                }
              //  .padding()
                .font(.caption)

                HStack {
                    Button("+10 min") { 
                        currentDate =   currentDate.addingTimeInterval(10 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("+1 godz") { 
                        currentDate =    currentDate.addingTimeInterval(60 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("+3 godz") {

                        currentDate =   currentDate.addingTimeInterval(3 * 60 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("+1 dzień") { 
                        currentDate =   currentDate.addingTimeInterval(24 * 60 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                }
              //  .padding()
                .font(.caption)

                HStack {
                    Button("-10 min") { 
                        currentDate =   currentDate.addingTimeInterval(-10 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("-1 godz") { 
                        currentDate =   currentDate.addingTimeInterval(-60 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("-3 godz") { 
                        currentDate =   currentDate.addingTimeInterval(-3 * 60 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    Button("-1 dzień") { 

                        currentDate =   currentDate.addingTimeInterval(-24 * 60 * 60)
                    }
                    .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                }

                .font(.caption)
            }
            Button("OK") {}
                .buttonStyle(.borderedProminent)
        }

    }

    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd.MM  HH:mm"
        return dateFormatter.string(from: currentDate)
    }

    func timeRemaining() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentDate, to: Date())
        let hoursRemaining = components.hour ?? 0
        let minutesRemaining = components.minute ?? 0

        if hoursRemaining < 1 {
            return "Za \(minutesRemaining) minut"
        } else if hoursRemaining < 48 {
            return "Za \(hoursRemaining) godzin"
        } else {
            let daysRemaining = hoursRemaining / 24
            return "Za \(daysRemaining) dni"
        }
    }
}

#Preview {
    EventView()
}
