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
            VStack(alignment: .center) {
                TextEditor(text: $description)
                    .multilineTextAlignment(.leading)
                      .frame(maxWidth: .infinity,minHeight: 200)



                HStack {
                    DatePicker("", selection: $currentDate)

                    Text(timeRemaining())

                }
                .frame(maxWidth: .infinity)
                Grid(alignment:.center ,  horizontalSpacing: 0.2, verticalSpacing: 0.2) {

                    GridRow {
                        Button("09:30") {
                            currentDate =   calendar.date(bySettingHour: 9, minute: 30, second: 0, of: currentDate)!
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("12:00") {

                            currentDate =   calendar.date(bySettingHour: 12, minute: 00, second: 0, of: currentDate)!
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("18:30") {
                            currentDate =   calendar.date(bySettingHour: 18, minute: 30, second: 0, of: currentDate)!
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("22:00") {
                            currentDate =   calendar.date(bySettingHour: 22, minute: 00, second: 0, of: currentDate)!
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()


                    }.border(.separator, width: 1.0)

                    GridRow {
                        Button("+10 min") {
                            currentDate =   currentDate.addingTimeInterval(10 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("+1 godz") {
                            currentDate =    currentDate.addingTimeInterval(60 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("+3 godz") {

                            currentDate =   currentDate.addingTimeInterval(3 * 60 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("+1 dzień") {
                            currentDate =   currentDate.addingTimeInterval(24 * 60 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                    }.border(.separator, width: 1.0)

                    GridRow {
                        Button("-10 min") {
                            currentDate =   currentDate.addingTimeInterval(-10 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()
                        Button("-1 godz") {
                            currentDate =   currentDate.addingTimeInterval(-60 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("-3 godz") {
                            currentDate =   currentDate.addingTimeInterval(-3 * 60 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                        Button("-1 dzień") {
                            currentDate =   currentDate.addingTimeInterval(-24 * 60 * 60)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .padding()

                    }.border(.separator, width: 1.0)

                }

                HStack {
                    Button (role: .destructive){
                    } label: {
                        Image(systemName: "trash")
                    }

                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button {
                    } label: {
                        Image(systemName: "moon.zzz")
                    }

                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button {
                    } label: {
                        Image(systemName: "plus.circle")
                    }

                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button {
                    } label: {
                        Image(systemName: "alarm")
                    }

                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button {
                    } label: {
                        Image(systemName: "checkmark.circle")
                    }

                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
            }
            .font(.caption2)
        }


    }

    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd.MM  HH:mm"
        return dateFormatter.string(from: currentDate)
    }

    func timeRemaining() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: Date(), to: currentDate)
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
