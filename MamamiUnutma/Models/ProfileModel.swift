//
//  ProfileModel.swift
//  MamamiUnutma
//
//  Created by Oguz Marifet on 24.10.2021.
//

import Foundation


struct ProfileModel:Hashable, Codable  {
    
    static var temp = ProfileModel(id: "123", name: "Bilal Oguz", surname: "Marife", profilPhoto: "https://media-exp1.licdn.com/dms/image/C5603AQEc2R2YZHBOng/profile-displayphoto-shrink_400_400/0/1540075461128?e=1640822400&v=beta&t=85E7eASfjICl0kov07-67GCyeEwsyPDqoCESljMJuvg", long: 41.008240, lat: 28.978359)
    var id: String
    var name: String
    var surname: String
    var profilPhoto: String
    var long: Float
    var lat: Float
}
