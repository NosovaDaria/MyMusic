//
//  Library.swift
//  MyMusic
//
//  Created by Дарья Носова on 26.01.2023.
//

import SwiftUI
import URLImage

struct Library: View {
    
    var tracks = UserDefaults.standard.savedTracks()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                GeometryReader { geometry in
                    HStack {
                        Button {
                            print("123")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 5, height: 50)
                                .accentColor(Color.init("myPink"))
                                .background(Color.init(.systemGray6))
                                .cornerRadius(10)
                        }
                        Button {
                            print("321")
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 5, height: 50)
                                .accentColor(Color.init("myPink"))
                                .background(Color.init(.systemGray6))
                                .cornerRadius(10)
                        }

                    }
                }.padding().frame(height: 50)
                
                List(tracks) { track in
                    LibraryCell(cell: track)
                }.listStyle(.inset)
            }
            .navigationBarTitle("Library")
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
