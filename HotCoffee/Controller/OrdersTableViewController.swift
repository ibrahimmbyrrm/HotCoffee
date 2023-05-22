//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by İbrahim Bayram on 17.05.2023.
//

import UIKit

class OrdersTableViewController: UITableViewController, AddCoffeeOrderDelegate {
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOrders()
    }
    
    // MARK: - Delegate functions of AddCoffeeOrdrDelegate -
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true)
    }
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        
        controller.dismiss(animated: true)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.orderViewModels.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderViewModels.count - 1, section: 0)], with: .automatic)
    }
    // MARK: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    private func fetchOrders() {
        guard let coffeOrderUrl = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("The url was incorrect")
        }
        
        let resource = Resource<[Order]>(url: coffeOrderUrl)
        
        Webservice().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderListViewModel.orderViewModels = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
                let addCoffeeOrderVC = navC.viewControllers.first as? AddNewOrderViewController else {
            fatalError("Error performing segue")
        }
        addCoffeeOrderVC.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderListViewModel.orderViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = orderListViewModel.oderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.text = vm.size
        return cell
    }
    
    
}
