//
//  Library.swift
//  AppleMusic
//
//  Created by White on 11/14/22.
//

import SwiftUI
import URLImage
struct Library: View {
    
    @State  var tracks = UserDefaults.standard.SavedTracks()
    @State private var track: SearchViewModel.Cell!
    
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView{
            VStack{
                HStack(spacing: 20){
                    
                    Button(action: {
                        self.track = self.tracks[0]
                        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                    }, label: {
                        Image(systemName: "play.fill")
                            .frame(width: 168, height: 50) .background(Color.init(uiColor: #colorLiteral(red: 0.9215686321, green: 0.9215685725, blue: 0.9215685725, alpha: 1))).cornerRadius(10)
                    })
                    
                    Button(action: {
                        self.tracks = UserDefaults.standard.SavedTracks()
                    }, label: {
                        Image(systemName: "arrow.2.circlepath")
                            .frame(width: 168, height: 50) .background(Color.init(uiColor: #colorLiteral(red: 0.9215686321, green: 0.9215685725, blue: 0.9215685725, alpha: 1))).cornerRadius(10)
                    })
                    
                    
                }.padding().frame( height: 50)
                
                List {
                    ForEach(tracks){
                        track in
                        LibraryCell(cell: track).gesture(
                            TapGesture().onEnded(
                                { _ in
                                    
                                    let keyWindow = UIApplication.shared.connectedScenes.filter({
                                        $0.activationState == .foregroundActive
                                    }).map({
                                        $0 as? UIWindowScene
                                    }).compactMap({
                                        $0
                                    }).first?.windows.filter({$0.isKeyWindow}).first
                                    let tabBarVc = keyWindow?.rootViewController as? MainTabBarController
                                    tabBarVc?.trackDetailView.delegate = self
                            self.track = track
                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: self.track)
                                    
                                }
                            ))
                    }.onDelete(perform: Delete)
                }.listStyle(.plain)
            .navigationBarTitle("Library")
        }
    }
}
    func Delete(at offsets: IndexSet){
        
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData,forKey: UserDefaults.favouriteTrackKey)
        }
        
    }
    
    
    
}

struct LibraryCell: View{
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack{
            URLImage(URL(string: cell.iconUrlString ?? "")!) { image in
                image
                    .resizable().frame(width:60, height:60).cornerRadius(2)
            }
            VStack(alignment: .leading){
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

extension  Library: TrackMovingDelegate{
    
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex - 1 == -1  {
            nextTrack = tracks[tracks.count - 1]
        }else{
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else { return nil }
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count{
            nextTrack = tracks[0]
        }else{
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    
    
}
