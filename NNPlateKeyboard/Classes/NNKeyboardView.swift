//
//  NNKeyboardView.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/6.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit
import SwiftExpand

@objc protocol NNKeyBoardViewDeleagte {
    @objc func keyboardViewSelect(key: String)
}

class NNKeyboardView: UIView {
    @objc public var inputTextfield: UITextField!

    let itemWidth: CGFloat = ((kScreenWidth - kPadding*2 - 9*1.0)/10.0)
    let itemHeight: CGFloat = ((kKeyboardHeight - 5*4)/4.0)
    let blankPadding: CGFloat = 20

    @objc public var numType = NNKeyboardNumType.auto
    @objc public var plateNumber = ""
    @objc public var inputIndex = 0;
    @objc public var maxCount = 7

    var delegate: NNKeyBoardViewDeleagte?

    static var themeColor = UIColor(red: 65 / 256.0, green: 138 / 256.0, blue: 249 / 256.0, alpha: 1)
    
    lazy var listModel: NNKeyboardLayout = NNKeyboardEngine.generateLayout(inputIndex: 0, plateNumber: "", numberType:numType, isMoreType:false);
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:0 , y: 0, width: kScreenWidth, height: 226 + 5 + kIphoneXtabHeight))
        setUI()
    }
   
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    /// 按键点击提示视图
    lazy var promptView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 55, height: 74)
        view.image = UIImage.image(named: "pressed", podClass: NNPlateKeyboard.self)
        
        var label: UILabel {
            let view = UILabel(frame: CGRectMake(0, 0, 55, 55))
            view.font = UIFont.systemFont(ofSize: 29)
            view.textAlignment = .center
            view.tag = 100;
            return view;
        }
        view.addSubview(label);
        view.getViewLayer()
        return view;
    }()
   
    // MARK: - funtions
    func setUI() {
        collectionView.frame = self.bounds
        collectionView.register(UICTViewCellKeyBoard.self, forCellWithReuseIdentifier: "UICTViewCellKeyBoard")
        addSubview(collectionView)
        collectionView.reloadData()
              
        // 提示视图
        promptView.isHidden = true
        addSubview(promptView)
    }
    /// 获取功能键宽度
    func getFunItemSize(_ rowModels: [NNKeyboradModel], indexPath: IndexPath) -> CGFloat {
        let names = rowModels.map { $0.text }
       
        let listLeft = names.filter { $0.count == 1 }
        let listRight = names.filter { $0.count > 1 }
       
        let leftWidth: CGFloat = listLeft.count.toCGFloat*itemWidth + (listLeft.count.toCGFloat - 1)*1.0 + kPadding;
        let rightWidth = kScreenWidth - leftWidth - blankPadding - kPadding;
        let funItemWidth: CGFloat = (rightWidth - (listRight.count.toCGFloat - 1)*1.0)/listRight.count.toCGFloat - 1;

        return funItemWidth;
    }
    /// 获取所有键尺寸
    func keyItemSize(_ rowModels: [NNKeyboradModel], indexPath: IndexPath) -> CGSize {
        var width = itemWidth
        let keyModel = rowModels[indexPath.row]
        if keyModel.text.count == 1 {
            return CGSize(width: width, height: itemHeight);
        }
         
        let names = rowModels.map { $0.text }
        let funItemWidth: CGFloat = getFunItemSize(rowModels, indexPath: indexPath)
        let hasMoreOrBack = names.contains("返回") || names.contains("更多")
         
        width = funItemWidth
        if ["更多", "返回"].contains(keyModel.text) {
            width = funItemWidth + blankPadding
         
        } else if keyModel.text == "删除" && !hasMoreOrBack{
            width = funItemWidth + blankPadding
        }
        return CGSize(width: floor(width), height: itemHeight);
    }
    /// 更多/返回/删除键左边会和普通键位隔开
    func leftConstant(_ rowModels: [NNKeyboradModel], indexPath: IndexPath) -> CGFloat {
        let keyModel = rowModels[indexPath.row]
        if keyModel.text.count <= 1 {
            return 0.0;
        }
        let names = rowModels.map { $0.text }
        let hasMoreOrBack = names.contains("返回") || names.contains("更多")
       
        var leftConstant: CGFloat = 0.0
        if ["更多", "返回"].contains(keyModel.text) {
            leftConstant = blankPadding
              
        } else if keyModel.text == "删除"  && !hasMoreOrBack{
            leftConstant = blankPadding
        }
        return leftConstant;
    }
    /// 按键提示视图显示
    func showPrompt(item: UICTViewCellKeyBoard){
        guard let label = promptView.subviews.first as? UILabel else { return }
        promptView.center = CGPoint(x: item.center.x, y: item.center.y - itemHeight / 2 - 21)
        label.text = item.label.text
        label.textColor = NNKeyboardView.themeColor
        promptView.isHidden = false
    }
    /// 按键提示视图隐藏
    func hiddenPromt(){
        promptView.isHidden = true
    }
    /// 键盘视图更新
    func updateKeyboard(isMoreType: Bool){
        listModel = NNKeyboardEngine.generateLayout( inputIndex: inputIndex, plateNumber: plateNumber, numberType: numType, isMoreType:isMoreType);
        collectionView.reloadData()
    }
    
    // MARK: - lazy
    
    lazy var collectionView: UICollectionView = {
        // 初始化
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        // 设置分区头视图和尾视图宽高
        layout.headerReferenceSize = CGSize(width: kScreenWidth, height: 5)
        layout.footerReferenceSize = CGSize(width: kScreenWidth, height: 0)

        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.backgroundColor = UIColor(red: 238/256.0, green: 238/256.0, blue: 238/256.0, alpha: 1)
//        view.backgroundColor = UIColor.red
//        view.backgroundColor = UIColor.lightGray

        view.delegate = self
        view.dataSource = self
        return view
    }()

}

extension NNKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        DDLog(listModel.rowArray()[section].count)
        return listModel.rowArray()[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               
        let cell = collectionView.dequeueReusableCell(for: UICTViewCellKeyBoard.self, indexPath: indexPath)
        cell.label.text = String(format:"%d",indexPath.row)
        
        let rowModels = listModel.rowArray()[indexPath.section]
        let keyModel = rowModels[indexPath.row]
        cell.label.text = keyModel.text
        cell.isEnabledStatus = keyModel.enabled
               
        cell.leftConstant = leftConstant(rowModels, indexPath: indexPath)
//        DDLog("\(indexPath.section)_\(keyModel.text)_\(cell.leftConstant)")

//        cell.getViewLayer()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //没有值时点击删除键有点击效果但是不做处理
        guard let cell = collectionView.cellForItem(at: indexPath) as? UICTViewCellKeyBoard else { return }
//        plateChange(cell.label.text ?? "")
        delegate?.keyboardViewSelect(key: cell.label.text ?? "")
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let rowModels = listModel.rowArray()[indexPath.section]
        let keyModel = rowModels[indexPath.row]
        if keyModel.enabled {
            guard let cell = collectionView.cellForItem(at: indexPath) as? UICTViewCellKeyBoard else { return keyModel.enabled}
            showPrompt(item: cell)
        }
        return keyModel.enabled
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        hiddenPromt()
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowModels = listModel.rowArray()[indexPath.section]
//        let keyModel = rowModels[indexPath.row]
        return keyItemSize(rowModels, indexPath: indexPath)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout;

        let rowCount: Int = collectionView.numberOfItems(inSection: section)
        if section == 2 && rowCount != 10 {
            let left = (kScreenWidth - itemWidth*rowCount.toCGFloat - layout.minimumLineSpacing*(rowCount.toCGFloat - 1.0))*0.5;
            return UIEdgeInsets(top: 0, left: left, bottom: 0, right: left);
        }
        return UIEdgeInsets(top: 0, left: kPadding, bottom: 0, right: kPadding);
    }
            
}
