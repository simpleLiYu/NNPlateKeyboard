//
//  NNKeyboardAccessoryView.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/10.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit
import SwiftExpand

@objc protocol NNKeyboardAccessoryViewDeleagte {
    @objc func keyboardAccessoryView(inputIndex: Int)
}

class NNKeyboardAccessoryView: UIView {

    var maxCount: Int = 7 {
        willSet{
            _ = changeLayoutItemSize(newValue)
            collectionView.reloadData()
        }
    }
    
    var inputIndex = 0

    var plateNumber: String = ""{
        willSet{
            guard newValue.count < 7 else { return }
            maxCount = (newValue.count == 7 ? 7 : 8)
//            _ = changeLayoutItemSize(count)
//            collectionView.reloadData()
        }
    }
    
    weak var delegate: NNKeyboardAccessoryViewDeleagte?

    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(switchBtn)
        addSubview(collectionView)
        addSubview(selectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switchBtn.snp.makeConstraints { (make) in
            make.top.right.height.equalToSuperview();
            make.width.equalTo(70);
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview();
            make.right.equalTo(switchBtn.snp.left);
        }

        let itemSize = changeLayoutItemSize(maxCount)
        selectView.frame = CGRect(x: selectView.frame.minX, y: selectView.frame.minY, width: itemSize.width, height: selectView.frame.height)
    }

    // MARK: - funtions
    /// 改变 cell 尺寸
    func changeLayoutItemSize(_ maxCount: Int) -> CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero}
        let width = (bounds.width - (CGFloat(maxCount) - 1)*layout.minimumLineSpacing - 70)/CGFloat(maxCount);
        layout.itemSize = CGSize(width: width, height: collectionView.bounds.height)
        return layout.itemSize;
    }
    
    // MARK: - lazy
    
    @objc public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsets.zero;
        layout.scrollDirection = .horizontal

        let view: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        view.register(UICTViewCellKeyBoardAccessoryView.self, forCellWithReuseIdentifier: "UICTViewCellKeyBoardAccessoryView")
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isScrollEnabled = false
        
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    @objc public lazy var switchBtn: UIButton = {
        let view: UIButton = UIButton(type: .custom)
//        view.setImage(UIImage(named: "plateNumberSwitch_N"), for: .normal)
//        view.setImage(UIImage(named: "plateNumberSwitch_H"), for: .selected)
//        let image = UIImage(named: "\(NNPlateKeyboard.self).bundle/Image/plateNumberSwitch_N")
//        let imageH = UIImage(named: "\(NNPlateKeyboard.self).bundle/Image/plateNumberSwitch_H")
        view.setImage(UIImage.image(named: "plateNumberSwitch_N", podClass: NNPlateKeyboard.self), for: .normal)
        view.setImage(UIImage.image(named: "plateNumberSwitch_H", podClass: NNPlateKeyboard.self), for: .selected)
        
        view.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        view.imageView?.contentMode = .scaleAspectFit
        
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = UIColor.line.cgColor;
//        view.addTarget(self, action: #selector(handleActionBtn(_:)), for: .touchUpInside)
        return view;
    }()
    
    lazy var selectView: UIView = {
        let view: UIView = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = NNKeyboardView.themeColor.cgColor
        return view;
    }()
}

extension NNKeyboardAccessoryView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK:- collectionViewDelegate

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICTViewCellKeyBoardAccessoryView", for: indexPath) as! UICTViewCellKeyBoardAccessoryView
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.line.cgColor

        if indexPath.row == inputIndex {
            selectView.frame = cell.frame
        }
//        cell.textLabel.text = "\(indexPath.row)"
        cell.textLabel.text = plateNumber.count > indexPath.row ? "\(plateNumber[indexPath.row])" : "";
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICTViewCellKeyBoardAccessoryView", for: indexPath)
        selectView.frame = cell.frame
        delegate?.keyboardAccessoryView(inputIndex: indexPath.row)
    }
}
