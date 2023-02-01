//
//  Library.swift
//  MyMusic
//
//  Created by Дарья Носова on 26.01.2023.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                GeometryReader { geometry in
                    HStack {
                        Button {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 5, height: 50)
                                .accentColor(Color.init("myPink"))
                                .background(Color.init(.systemGray6))
                                .cornerRadius(10)
                        }
                        Button {
                            self.tracks = UserDefaults.standard.savedTracks()
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 5, height: 50)
                                .accentColor(Color.init("myPink"))
                                .background(Color.init(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                    }
                }.padding().frame(height: 50)
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture()
                            .onEnded{ _tracks in
                                self.track = track
                                self.showingAlert = true
                            }
                                .simultaneously(with: TapGesture()
                                    .onEnded{ _ in
                                        let keyWindow = UIApplication.shared.connectedScenes
                                            .filter({$0.activationState == .foregroundActive})
                                            .map({$0 as? UIWindowScene})
                                            .compactMap({$0})
                                            .first?.windows
                                            .filter({$0.isKeyWindow}).first
                                        let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                        tabBarVC?.trackDetailView.delegate = self
                                        
                                        self.track = track
                                        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                                    }))
                    }
                    .onDelete(perform: delete(at:))
                    
                }.listStyle(.inset)
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Are you sure that you want to delete this track?"), buttons: [.destructive(Text("Delete"), action: {
                    self.delete(track: self.track)
                }), .cancel()
                                                                                                      ])
            })
            .navigationBarTitle("Library")
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell) {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return }
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack{
            URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
                image.resizable().frame(width: 60, height: 60).cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
        
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    func moveBackToPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var previousTrack: SearchViewModel.Cell
        if myIndex - 1 == -1 {
            previousTrack = tracks[tracks.count - 1]
        } else {
            previousTrack = tracks[myIndex - 1]
        }
        self.track = previousTrack
        return previousTrack
    }
    
    func moveForvardToNextTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
}
