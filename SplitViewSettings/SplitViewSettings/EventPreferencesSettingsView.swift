//
//  EventPreferencesSettingsView.swift
//  SplitViewSettings
//
//  Created by Jacek Kosinski U on 10/03/2024.
//

import SwiftUI


enum EventDetailTypes {
    case favoritesManagement
    case secretData
}

struct EventPreferencesSettingsView: View {
    @State var selectedEventTypes: Set<String> = ["Music", "Food"]

    @State private var sortingOption: String = "Date"

    let allEventTypes = ["Music", "Food", "Sports", "Art", "Theatre", "Technology"]

    var body: some View {
        Form {
            Section(header: Text("Select Event Types")) {
                ForEach(allEventTypes, id: \.self) { eventType in
                    Toggle(isOn: Binding(
                        get: {
                            self.selectedEventTypes.contains(eventType)
                        },
                        set: {
                            if $0 {
                                self.selectedEventTypes.insert(eventType)
                            } else {
                                self.selectedEventTypes.remove(eventType)
                            }
                        }
                    )) {
                        Text(eventType)
                    }
                }
            }

            Section(header: Text("Sort Events By")) {
                Picker("Sort By", selection: $sortingOption) {
                    ForEach(["Date", "Popularity"], id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Favorites")) {

                    NavigationLink(value: EventDetailTypes.favoritesManagement) {
                        Text("Manage Favorites")
                    }.padding(.vertical)

                    NavigationLink(value: EventDetailTypes.secretData) {
                        Text("Manage Secrets")
                    } .padding(.vertical)


            }

            // If you want, you can keep .navigationDestination near the NavigationLink that sets the value
            .navigationDestination(for: EventDetailTypes.self) { eventDetailType in
                switch eventDetailType {
                case .favoritesManagement:
                    EventFavoritesManagementView()
                case .secretData:
                    EventFavoritesManagementView()
                }
            }


        }
        .navigationTitle("Event Preferences")
    }

}


struct EventFavoritesManagementView: View {
    @State private var favoriteEvents: [String] = ["Jazz Concert", "Art Expo", "Tech Meetup"]
    @State private var newFavorite: String = ""

    var body: some View {
        List {
            Section(header: Text("Add New Favorite")) {
                HStack {
                    TextField("Event Name", text: $newFavorite)
                    Button(action: {
                        if !newFavorite.isEmpty {
                            favoriteEvents.append(newFavorite)
                            newFavorite = ""
                        }
                    }) {
                        Text("Add")
                    }
                }
            }

            Section(header: Text("Current Favorites")) {
                ForEach(favoriteEvents, id: \.self) { event in
                    Text(event)
                }
                .onDelete { indexSet in
                    favoriteEvents.remove(atOffsets: indexSet)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Manage Favorites")
    }
}


#Preview {
    NavigationStack{
        EventPreferencesSettingsView()
    }
}
