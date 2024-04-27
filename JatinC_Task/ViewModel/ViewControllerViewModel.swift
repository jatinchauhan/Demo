//
//  ViewControllerViewModel.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import Foundation

class ViewControllerViewModel {
    var list: [DataModel] = []
    private var offSet: Int = 0
    private var limit: Int = 20
    var isApiCalling = false
    private var isListFinished = false
    
    func fetchData(compelition: @escaping ((Int) -> Void)) {
        if isApiCalling { return }
        if isListFinished { return }
        
        isApiCalling = true
        
        APIManager.shared.sendRequest(endPoint: .list, method: .GET, parameters: ["_start":offSet.string, "_limit": limit.string]) {
            (result: Result<[DataModel]?, Error>) in
            switch result {
            case .success(let newList):
                if newList?.count == 0 {
                    self.isListFinished = true
                    compelition(newList?.count ?? 0)
                    return
                }
                
                self.list.append(contentsOf: newList ?? [])
                
                compelition(newList?.count ?? 0)

                self.isApiCalling = false
                self.offSet += self.limit

                break;
            case .failure(let error):
                print("Error : ", error.localizedDescription)
                self.isApiCalling = false
                break;
            }
        }
    }
}
