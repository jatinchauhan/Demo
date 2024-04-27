//
//  ViewController.swift
//  JatinC_Task
//
//  Created by Jatin Chauhan on 27/04/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ViewControllerViewModel = .init()
    var loaderView: UIView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    func setupUI() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.tableView.tableFooterView = .init()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.register(UINib(nibName: "LoaderCell", bundle: nil), forCellReuseIdentifier: "LoaderCell")

        self.tableView.tableFooterView = createSpinnerFooter()

        self.viewModel.fetchData { newRecords in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.dataModel = self.viewModel.list[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailVC
        vc?.dataModel = (self.viewModel.list[indexPath.row], indexPath.row)
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > (contentHeight - scrollView.frame.size.height + 10) {
            if self.viewModel.isApiCalling == true { return }
            self.tableView.tableFooterView = createSpinnerFooter()
            self.viewModel.fetchData { newRecords in
                DispatchQueue.main.async {
                    if newRecords > 0 {
                        CATransaction.begin()
                        CATransaction.setDisableActions(true)
                        
                        let oldRecords = self.viewModel.list.count - newRecords
                        let indexPaths = (oldRecords...(oldRecords + newRecords - 1)).map { IndexPath(row: $0, section: 0) }
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexPaths, with: .none)
                        self.tableView.endUpdates()
                        CATransaction.commit()
                    }
                    self.tableView.tableFooterView = nil
                }
            }
        }
    }
}

extension ViewController: DetailVCDelegate {
    func didUpdatedData(dataModel: DataModel, index: Int) {
        var dataModelCopy = dataModel
        dataModelCopy.detailAPICalled = true
        self.viewModel.list[index] = dataModelCopy
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [.init(row: index, section: 0)], with: .none)
        }
        
    }
}
