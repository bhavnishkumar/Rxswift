//
//  HomeVC.swift
//  RxSwiftMVVMDemo
//
//  Created by Admin on 13/07/22.
//

import UIKit
import RxSwift
import RxCocoa



class HomeVC: UIViewController{
    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    var  filterData = [PostData]()
    var viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    let searchText = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        tableview.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableview.delegate = self
        
        
        let nib = UINib(nibName: "PhotosCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "PhotosCell")
        
        filteration() // Filteration with seacrchbar
        //observe data
        viewModel.tableData.subscribe(onNext: { value in
            print(value)
           // self.tableview.reloadData()
        }).disposed(by: disposeBag)
        
        
        viewModel.listItems.observe(on: MainScheduler.instance).bind(to: self.tableview.rx.items(cellIdentifier: "PhotosCell", cellType: PhotosCell.self)) { (row,item,cell) in
            cell.titleLbl.text = item.text ?? ""
            Helper.showImage(imageView: cell.imageView1, url: item.image ?? "" , isHidePlaceholder: false, isShowIndicator: true)
            
            
        }.disposed(by: disposeBag)
        
        tableview.rx.itemInserted.subscribe { index in
            print("Item inserted")
            
        }.disposed(by: disposeBag)
        
        
        //Item Selected
        tableview.rx.itemSelected.subscribe({ index in
            guard let indexPath  = index.element else {return}
            
            Toast.shared.showAlert(type: .success, message: "You have clicked on index:\(index.element?.row ?? 0)", showimage: true, style: ToastStyle.notificationBanner)
        }).disposed(by: disposeBag)
        
        viewModel.fetchData(vc: self) //call apis
        
        
        //Item delete in tabelview
        tableview.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
                
        }).disposed(by: disposeBag)
        
        
        
        logoutBtn.rx.tap.subscribe { [weak self] event in
            if let nextVc = AppStoryboard.main.instance.instantiateViewController(withIdentifier: "OnBoardVC") as? OnBoardVC  {
                if #available(iOS 13, *) {
                    guard let sceneDelegate =  UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    let nav = UINavigationController.init(rootViewController: nextVc)
                    nav.isNavigationBarHidden = true
                    sceneDelegate.window?.rootViewController = nav
                    sceneDelegate.window?.makeKeyAndVisible()
                }else{
                    
                    
                    guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let nav = UINavigationController.init(rootViewController: nextVc)
                    nav.isNavigationBarHidden = true
                    appDelegate.window?.rootViewController = nav
                    appDelegate.window?.makeKeyAndVisible()
                }
                
                resetDefaults()
                Toast.shared.showAlert(type: .success, message: "Logout Succesfully", showimage: true, style: ToastStyle.notificationBanner)
            }}.disposed(by: disposeBag)
    }
    
    
    //MARK:- Filteration items
    func filteration(){
        searchTF.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance).distinctUntilChanged()
            .subscribe { [weak self] query in
                guard
                    let query = query.element else { return }
                self?.searchText.accept(query)
            }
            .disposed(by: disposeBag)
        
        
        searchText.throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe({ [unowned self] event in
                
                guard let query = event.element, !query.isEmpty  else {
                    self.viewModel.filteredItems.accept(self.viewModel.tableData.value)
                    return
                }
                
                self.viewModel.filteredItems.accept(
                    self.viewModel.tableData.value.filter {
                        $0.text?.lowercased().contains(query.lowercased()) ?? false
                    }
                )
                
            })
            .disposed(by: disposeBag)
        
        
        self.viewModel.listItems.subscribe(onNext: { [unowned self] things in
            if things.isEmpty {
                if self.viewModel.isDataLoading{
                    self.tableview.setEmptyMessage("")
                }else{
                    self.tableview.setEmptyMessage("No Search Item available \n🐶")
                }
                
            } else {
                self.tableview.restore()
            }
        }).disposed(by: disposeBag)
        

        
        
    }
    
    
    //Pagination
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        self.viewModel.isDataLoading = false
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if ((tableview.contentOffset.y + tableview.frame.size.height) >= tableview.contentSize.height){
            if !self.viewModel.isDataLoading{
                self.viewModel.isDataLoading = true
                self.viewModel.limit = (self.viewModel.limit + 50)
                viewModel.fetchData(vc: self) //call apis
                
            }
        }
    }
}


extension HomeVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
