//
//  DetailVC.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import UIKit
protocol DetailVCDelegate {
    func didUpdatedData(dataModel: DataModel, index: Int)
}
class DetailVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBody: UILabel!
    
    var delegate: DetailVCDelegate?
    var viewModel: DetailViewModel = .init()
    var dataModel: (DataModel, Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.setupUI()
        }
        
    }
    
    func setupUI() {
        if self.dataModel?.0.detailAPICalled == true {
            self.viewModel.dataModel = self.dataModel?.0
            self.setData()
        }
        else {
            self.viewModel.fetchDetails(dataModel: (self.dataModel?.0)!) {
                self.setData()
                self.delegate?.didUpdatedData(dataModel: self.viewModel.dataModel!, index: (self.dataModel?.1)!)
            }
        }
    }
    
    func setData() {
        self.lblTitle.text = self.viewModel.dataModel?.title
        self.lblBody.text = self.viewModel.dataModel?.title
    }
}
