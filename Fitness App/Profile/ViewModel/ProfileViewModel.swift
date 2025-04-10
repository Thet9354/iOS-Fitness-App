//
//  ProfileViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 6/4/25.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var isEdittingName = false
    @Published var currentName: String = ""
    @Published var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    
    @Published var isEdittingImage = false
    @Published var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    @Published var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    
    @Published var showAlert = false
    
    var images = ["avatar 1", "avatar 2", "avatar 3", "avatar 4", "avatar 5", "avatar 6", "avatar 7", "avatar 8", "avatar 9", "avatars 10"]
    
    func presentEditName() {
        isEdittingName = true
        isEdittingImage = false
    }
    
    func presentEditImage() {
        isEdittingName = false
        isEdittingImage = true
    }
    
    func dismissEdit() {
        isEdittingName = false
        isEdittingImage = false
    }
    
    func setNewName() {
        profileName = currentName
        UserDefaults.standard.set(currentName, forKey: "profileName")
        self.dismissEdit()
    }
    
    func didSelectNewImage(name: String) {
        selectedImage = name
    }
    
    func setNewImage() {
        profileImage = selectedImage
        UserDefaults.standard.set(selectedImage, forKey: "profileImage")
        self.dismissEdit()
    }
    
    func presentEmailApp() {
        let emailSubject = "Fitness App - Contact Us"
        let emailRecipient = "thetpine254@gmail.com"
        
        let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedRecipient = emailRecipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(encodedRecipient)?subject=\(encodedSubject)"
        
        guard let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlert = true
            } 
        }
        
        
        
    }
    
}
