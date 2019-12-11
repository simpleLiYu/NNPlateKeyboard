//
//  NNKeyboardLayout.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/6.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit

class NNKeyboardLayout: NSObject {

    var row0: [NNKeyboradModel] = []
    var row1: [NNKeyboradModel] = []
    var row2: [NNKeyboradModel] = []
    var row3: [NNKeyboradModel] = []
    var keys: [NNKeyboradModel] = []
    
    //车牌号第几位
    var inputIndex = 0
    //plateNumber 当前预设的车牌号码；
    var plateNumber: String = ""
    //numberType 当前键盘所处的键盘类型；
    var numberType: NNKeyboardNumType?
    
    func rowArray() -> [[NNKeyboradModel]] {
        return [self.row0, self.row1, self.row2, self.row3]
    }
    /// 键描述
    var keysDes: String {
        return "\n\(row0.map { $0.text })\n\(row1.map { $0.text })\n\(row2.map { $0.text })\n\(row3.map { $0.text })"
    }
    var keysStateDes: String {
        return "\n\(row0.map { $0.enabled })\n\(row1.map { $0.enabled })\n\(row2.map { $0.enabled })\n\(row3.map { $0.enabled })"
    }
}

/// 键盘布局类型
@objc public enum NNKeyboardNumType: Int {
    case auto = 0
    /// 前两位是民航
    case airport
    /// 前两位是WJ
    case wuJing
    case police
    /// 大使馆(第一位是使)
    case embassy
    /// 新能源(第3位和第8位区分)
    case newEnergy
}

/// 按键模型
class NNKeyboradModel: NSObject {
    /// 按键名称
    var text: String = "-"
    /// 按键是否可点击
    var enabled = true
    /// 是否是功能键
    var isFunKey = true

    convenience init(_ text: String, enabled: Bool, isFunKey: Bool = false) {
        self.init()
        self.text = text;
        self.enabled = enabled;
        self.isFunKey = isFunKey;
    }
}
