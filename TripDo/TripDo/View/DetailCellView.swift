//
//  DetailCellView.swift
//  TripDo
//
//  Created by 요한 on 2020/08/10.
//  Copyright © 2020 요한. All rights reserved.
//

import UIKit
import SnapKit

class DetailCellView: UICollectionViewCell {
  static let identifier = "DetailCellView"
  
  var checkButtonToggle: (() -> ())?
  
  var countString: String? {
    didSet {
      countLabel.text = countString
    }
  }
  
  var checkButtonBool: Bool? {
    didSet {
      checkButtonBool == true ?
        checkButton.setImage(UIImage(systemName: Common.SFSymbolKey.check.rawValue), for: .normal):
        checkButton.setImage(UIImage(systemName: Common.SFSymbolKey.uncheck.rawValue), for: .normal)
    }
  }
  
  var dateString: String? {
    didSet {
      dateLabel.text = dateString
    }
  }
  
  var titleString: String? {
    didSet {
      titleLabel.text = titleString
    }
  }
  
  var addressString: String? {
    didSet {
      addressLabel.text = addressString
    }
  }
  
  fileprivate let checkView: UIView = {
    let v = UIView()
    
    return v
  }()
  
  lazy var checkButton: UIButton = {
    let b = UIButton()
    b.addTarget(self, action: #selector(didTabButtons), for: .touchUpInside)
    b.tintColor = Common.mainColor
    
    return b
  }()
  
  fileprivate let countLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.mainColor
    
    return l
  }()
  
  fileprivate let dateLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.preferredFont(forTextStyle: .footnote)
    l.textColor = Common.mainColor
    
    return l
  }()
  
  fileprivate let titleLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.preferredFont(forTextStyle: .title2)
    l.textColor = Common.mainColor
    
    return l
  }()
  
  fileprivate let addressLabel: UILabel = {
    let l = UILabel()
    l.font = UIFont.preferredFont(forTextStyle: .body)
    l.textColor = Common.mainColor.withAlphaComponent(0.7)
    
    return l
  }()
  
  fileprivate lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
    sv.axis = .vertical
    sv.spacing = 10
    
    return sv
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    
    setUI()
  }
  
  // MARK: - Layout
  
  private func setUI() {
    
    [checkView, dateLabel, stackView].forEach {
      self.addSubview($0)
    }
    checkView.addSubview(checkButton)
    checkView.addSubview(countLabel)
    
    checkView.snp.makeConstraints {
      $0.top.bottom.equalTo(self)
      $0.leading.equalTo(self).offset(10)
      $0.width.equalTo(self.frame.height / 2)
    }
    
    checkButton.snp.makeConstraints {
      $0.centerX.equalTo(checkView)
      $0.centerY.equalTo(checkView)
      $0.width.equalTo(50)
      $0.height.equalTo(50)
    }
    
    countLabel.snp.makeConstraints {
      $0.centerX.equalTo(checkView)
      $0.top.equalTo(self).offset(10)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.trailing.equalTo(self).offset(10)
      $0.leading.equalTo(checkView.snp.trailing)
    }
    
    stackView.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom)
      $0.trailing.equalTo(self)
      $0.leading.equalTo(checkView.snp.trailing)
    }
  }
  
  // MARK: - Action
  
  @objc fileprivate func didTabButtons() {
    print("didTabButton")
    checkButtonToggle?()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
