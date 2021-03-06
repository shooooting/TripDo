//
//  ViewController.swift
//  TripDo
//
//  Created by 요한 on 2020/07/31.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

class ViewController: UIViewController {
  
  let layout = UICollectionViewFlowLayout()
  
  var userId: [Int64]?
  var userName: [String]?
  var userStartDate: [String]?
  var userEndDate: [String]?
  var currentIndex: CGFloat = 0
  var isOneStepPaging = true
  
  lazy var rightButton: UIBarButtonItem = {
    let b = UIBarButtonItem(
      image: UIImage(systemName: Common.SFSymbolKey.rightNavigation.rawValue),
      style: .plain,
      target: self,
      action: #selector(buttonPressed(_:))
    )
    b.tintColor = Common.subColor
    b.tag = 1
    
    return b
  }()
  
  //  fileprivate let titleLabel: UILabel = {
  //    let l = UILabel()
  //    let style = [NSAttributedString.Key.kern: 5, NSMutableAttributedString.Key.baselineOffset: -20]
  //    let attributeString = NSMutableAttributedString(string: "TripDo", attributes: style)
  //    l.attributedText = attributeString
  //    l.font = UIFont.preferredFont(forTextStyle: .largeTitle)
  //    l.textColor = Common.edgeColor
  //
  //    return l
  //  }()
  
  fileprivate let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "NavigationLogo")
    iv.contentMode = .scaleAspectFit
    
    return iv
  }()
  
  fileprivate let subTitleLabel: UILabel = {
    let l = UILabel()
    l.text = "여행의 시작,\n여행의 일정관리와 기록까지."
    l.font = UIFont.preferredFont(forTextStyle: .title2)
    l.numberOfLines = .zero
    l.textColor = Common.subColor
    
    return l
  }()
  
  fileprivate lazy var mainCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    cv.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
    cv.backgroundColor = Common.mainColor
    cv.showsHorizontalScrollIndicator = false
    
    return cv
  }()
  
  fileprivate let testView: UIView = {
    let v = UIView()
    v.backgroundColor = .cyan
    v.isHidden = true
    
    return v
  }()
  
  fileprivate let floatingButton: UIButton = {
    let b = UIButton()
    b.backgroundColor = Common.mainColor
    b.setImage(UIImage(systemName: Common.SFSymbolKey.plus.rawValue), for: .normal)
    b.tintColor = Common.subColor
    b.addTarget(self, action: #selector(floatingButtonDidTap), for: .touchUpInside)
    Common.shadowMaker(view: b)
    
    return b
  }()
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainCollectionView.delegate = self
    getUserInfo()
    setUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    print("viewWillApear")
    mainCollectionView.reloadData()
    getUserInfo()
  }
}

// MARK: - UI

extension ViewController {
  fileprivate func setUI() {
    let guid = view.safeAreaLayoutGuide
    view.backgroundColor = Common.mainColor
    
    floatingButton.frame = CGRect(
      x: view.bounds.maxX - 100,
      y: view.bounds.height - 120,
      width: view.frame.width / 6.5,
      height: view.frame.width / 6.5
    )
    floatingButton.layer.cornerRadius = floatingButton.bounds.width / 2
    
    // Layout
    
    view.bringSubviewToFront(floatingButton)
    [logoImageView, subTitleLabel, mainCollectionView, floatingButton].forEach {
      view.addSubview($0)
    }
    
    // Constraint
    
    logoImageView.snp.makeConstraints {
      $0.top.equalTo(guid)
      $0.leading.equalTo(guid).offset(40)
      $0.height.equalTo(80)
      $0.width.equalTo(140)
    }
    
    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(20)
      $0.leading.equalTo(guid).offset(40)
    }
    
    mainCollectionView.snp.makeConstraints {
      $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
      $0.trailing.leading.bottom.equalTo(guid)
    }
    
    setNavigation()
    setCollectionView()
  }
  
  fileprivate func setNavigation() {
    navigationItem.rightBarButtonItem = self.rightButton
    let navBar = self.navigationController?.navigationBar
    navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navBar?.shadowImage = UIImage()
    navBar?.isTranslucent = true
    navBar?.backgroundColor = UIColor.clear
    navBar?.barStyle = .black
  }
  
  fileprivate func setCollectionView() {
    mainCollectionView.dataSource = self
    mainCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    //    mainCollectionView.delegate = self
    //    mainCollectionView.isPagingEnabled = true
    
    layout.sectionInset = .init(top: 15, left: 40, bottom: 15, right: 40)
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    
  }
}

// MARK: - Action

extension ViewController {
  @objc fileprivate func floatingButtonDidTap() {
    print("floatingButtonDidTap")
    getUserInfo()
    
    let nameVC = NameViewController()
    navigationController?.pushViewController(nameVC, animated: true)
    mainCollectionView.reloadData()
  }
  
  @objc private func buttonPressed(_ sender: Any) {
    if let button = sender as? UIBarButtonItem {
      switch button.tag {
      case 1:
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
      default:
        print("error")
      }
    }
  }
}


// MARK: - CoreData

extension ViewController {
  fileprivate func getUserInfo() {
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    userId = userInfo.map { $0.id }
    userStartDate = userInfo.map { $0.startDate ?? "nil" }
    userEndDate = userInfo.map { $0.endDate ?? "nil" }
    
    print("getUserId :", userId as Any)
    print("getUserInfo :", userName as Any)
    print("getUserStartDate :", userStartDate as Any)
    print("getUserEndDate :", userEndDate as Any)
    print("show task =", task.map { $0.taskId })
  }
  
  fileprivate func saveUserInfo(id: Int64, startDate: String, endDate: String, task: NSSet) {
    CoreDataManager.coreDataShared.saveUser(
      id: id,
      startDate: startDate,
      endDate: endDate,
      task: task,
      date: Date()) { (onSuccess) in
        print("saved =", onSuccess)
    }
  }
  
  fileprivate func deleteUserInfo(id: Int64) {
    CoreDataManager.coreDataShared.deleteUser(id: id) { (onSuccess) in
      print("delete =", onSuccess)
    }
  }
  fileprivate func deleteUserTask(id: Int64) {
    CoreDataManager.coreDataShared.deleteTask(taskId: id) { (onSuccess) in
      print("delete =", onSuccess)
    }
  }
  
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    userId?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    let task: [Task] = CoreDataManager.coreDataShared.getTasks()
    
    cell.getTripNameString = userName![indexPath.row]
    cell.getTripStartDateString = "\(userStartDate![indexPath.row]) ~ \(userEndDate![indexPath.row])"
    
    // delete button
    cell.closeButtonAction = {
      let alert = UIAlertController(title: "기록을 제거합니다", message: "저장한 기록을 삭제하시겠습니까 ?", preferredStyle: UIAlertController.Style.alert)
      let okAction = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
        print("🙏delete cell =", indexPath.row)
        print("delete Id =", userInfo[indexPath.row].id)
        self.deleteUserInfo(id: userInfo[indexPath.row].id)
        self.deleteUserTask(id: userInfo[indexPath.row].id)
        print("show task =", task.map { $0.taskId })
        self.viewWillAppear(true)
      }
      let cancel = UIAlertAction(title: "취소", style: .destructive, handler : nil)
      alert.addAction(cancel)
      alert.addAction(okAction)
      self.present(alert, animated: true)
    }
    
    // task count
    let taskTemp = task.filter({
      $0.taskId == userInfo[indexPath.row].id
    })
    
    cell.taskString = "more \(taskTemp.count) task.."
    cell.getAddress = taskTemp.map { $0.address! }
    cell.getTaskTitle = taskTemp.map { $0.title! }
    
    // initialize
    cell.mapView.removeAnnotations(cell.mapView.annotations)
    cell.mapView.removeOverlays(cell.mapView.overlays)
    cell.locationArray = []
    let longitude = taskTemp.map { $0.longitude }
    let latitude = taskTemp.map { $0.latitude }
    print(indexPath.row)
    
    for i in 0...taskTemp.count - 1 {
      let location = CLLocationCoordinate2D(latitude: latitude[i], longitude: longitude[i])
      if location.latitude != 0 && location.longitude != 0 {
        cell.addAnnotation(at: location, with: i, subTitle: "")
        cell.locationArray.append(location)
      }
      cell.getLocation = location
      cell.getDays = i
    }
    
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
  {
    let layout = self.mainCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let cellWidthIncludingSpacing = view.frame.width - layout.sectionInset.left - layout.sectionInset.right + 15
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    var roundedIndex = round(index)
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      roundedIndex = floor(index)
    } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
      roundedIndex = ceil(index)
    } else {
      roundedIndex = round(index)
    }
    
    if isOneStepPaging {
      if currentIndex > roundedIndex {
        currentIndex -= 1
        roundedIndex = currentIndex
      } else if currentIndex < roundedIndex {
        currentIndex += 1
        roundedIndex = currentIndex
      }
    }
    
    offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    targetContentOffset.pointee = offset
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("didSelectItemAt", indexPath.row)
    
    let userInfo: [UserInfo] = CoreDataManager.coreDataShared.getUsers()
    
    let detailVC = DetailViewController()
    detailVC.modalPresentationStyle = .fullScreen
    detailVC.cellIndexPath = indexPath.row
    present(detailVC, animated: false)
    print("🤧", userInfo[indexPath.row].id)
  }
  
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    print("didUnhighlightItemAt")
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    layout.sectionInset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    15
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right
    let height = collectionView.frame.height - layout.sectionInset.top - layout.sectionInset.bottom
    
    return CGSize(width: width, height: height)
  }
}
