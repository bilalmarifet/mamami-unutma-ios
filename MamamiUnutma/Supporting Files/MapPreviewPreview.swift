//
//  MapPreviewPreview.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 7.11.2021.
//

import SwiftUI


import UIKit
import MapKit

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}


struct MapPreviewPreview: View {
    
    @State var showingSheet = false
    var latitude: Double?
    var longitude: Double?
    @State var city: String?
    
    @State private var region: MKCoordinateRegion

    init(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
        if let latitude = latitude, let longitude = longitude {
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
        self.region = MKCoordinateRegion()
        
    }
    var body: some View {
        if let latitude = latitude, let longitude = longitude {
            HStack {
                Color.clear
                
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Image(systemName: "map.fill")
                        .frame(width: 25, height: 25)
                        .foregroundColor(.yellow)
                        .padding(.trailing, 5)
                    Text(city ?? "")
                }
                .sheet(isPresented: $showingSheet) {
                    NavigationView {
                        Map(coordinateRegion: $region, showsUserLocation: true,userTrackingMode: .constant(.follow))
                            .navigationTitle("Gidilecek yer")
                            .toolbar(content: {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
                                        
                                        if UIApplication.shared.canOpenURL(url!) { UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                        }
                                    }) {
                                        Image(systemName: "mappin")
                                            .imageScale(.large)
                                            .foregroundColor(.gray)
                                    }
                                }
                            })
                    }
                    

                    
                }
            }
            .onAppear {
                if city == nil {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    fetchCities(location: location) { value in
                        guard let value = value else {
                            return
                        }
                        city = value
                    }
                }
            }
        }else {
            EmptyView()
        }
    }
    func fetchCities(location: CLLocation, completion: @escaping (String?) -> ()) {
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            completion(city)
        }
    }
    
    
}


//class MapPreviewModel: ObservableObject {
//    @State var city = ""
//    init(latitude: Double, longitude: Double) {
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        fetchCities(location: location)
//    }
//    func fetchCities(location: CLLocation) {
//        location.fetchCityAndCountry { city, country, error in
//            guard let city = city, let country = country, error == nil else { return }
//            self.city = city
//        }
//    }
//
//
//}



struct MapPreviewPreview_Previews: PreviewProvider {
    static var previews: some View {
        MapPreviewPreview(latitude: 40.986150, longitude: 29.028500)
    }
}



