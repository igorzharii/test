//
//  UIImageView+Network.swift
//  TestProj
//
//  Created by Igor Zharii on 03.03.2021.
//
import UIKit
import Alamofire

extension UIImageView {
    func downloadAndSetImage( url: URL?) {
        guard let url = url else {return}
        AF.request(url.absoluteString, method: .get).responseString { response in
            switch response.result {
            case .success:
                let image = UIImage(data: response.data!, scale: 1)
                self.image = image
            case .failure(let error):
                print("error")
            }
        }
    }
}
