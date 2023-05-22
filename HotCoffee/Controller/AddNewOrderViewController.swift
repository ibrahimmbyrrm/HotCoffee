//
//  AddNewOrderViewController.swift
//  HotCoffee
//
//  Created by İbrahim Bayram on 17.05.2023.
//

import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order : Order, controller : UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller : UIViewController)
}

class AddNewOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailTextField: UITextField!
    
    var delegate : AddCoffeeOrderDelegate?
    private var vm = AddCoffeeOrderViewModel()
    private var coffeeSizesSegmentedControl : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sized)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.coffeeSizesSegmentedControl.selectedSegmentTintColor = .systemCyan
    }
    
    @IBAction func close(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.addCoffeeOrderViewControllerDidClose(controller: self)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let name = nameTextField.text
        let email = emailTextField.text
        let selectedSize = coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else { fatalError("Error in selecting coffee")}
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case.success(let order):
                if let order = order , let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                }
            case.failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
        
    }
    
    


}
