//
//  DetailViewModel.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import Foundation

class DetailViewModel {
    var dataModel: DataModel?
    
    func fetchDetails(dataModel: DataModel, compelition: @escaping (() -> Void)) {
        APIManager.shared.sendRequest(endPoint: .detail(dataModel.id.string), method: .GET, parameters: nil) {
            (result: Result<DataModel?, Error>) in
            switch result {
            case .success(let newModel):
                self.dataModel = newModel
                DispatchQueue.main.async {
                    compelition()
                }
                break;
            case .failure(let error):
                print("Error : ", error.localizedDescription)
                break;
            }
        }
    }
}
