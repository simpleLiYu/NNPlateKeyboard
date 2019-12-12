//
//  NNKeyboardEngine.swift
//  NNPlateKeborad
//
//  Created by Bin Shang on 2019/12/6.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit

//import SwiftExpand

/// 键盘引擎(键位布局和键位状态及其键盘类型切换)
class NNKeyboardEngine: NSObject {
    
    static let kSTR_NUM1_3 = "1,2,3,"
    static let kSTR_NUM4_0 = "4,5,6,7,8,9,0,"
    static let kSTR_NUM = kSTR_NUM1_3 + kSTR_NUM4_0

    static let kSTR_Q_Y = "Q,W,E,R,T,Y,"
    static let kSTR_Q_U = kSTR_Q_Y + "U,"
    static let kSTR_Q_P = kSTR_Q_U + "I,O,P,"
    static let kSTR_Q_AND_PMN = kSTR_Q_U + "P,M,N,"
    static let kSTR_Q_AND_P = kSTR_Q_U + "P,"
    
    static let kSTR_A_K = "A,S,D,F,G,H,J,K,"
    static let kSTR_A_L = kSTR_A_K + "L,"
    static let kSTR_A_AND_M = kSTR_A_L + "M,"
    static let kSTR_A_AND_B = kSTR_A_L + "B,"
    
    static let kSTR_DF = "D,F,"
    static let kSTR_ZX = "Z,X,"
    static let kSTR_Z_V = "Z,X,C,V,"
    static let kSTR_Z_N = kSTR_Z_V + "B,N,"
    static let kSTR_W_Z = "W,X,Y,Z,"
    
    static let kSTR_ABCDEFGHJKWXYZ = "A,B,C,D,E,F,G,H,J,K,W,X,Y,Z,"

    static let kCHAR_C = "C,"
    static let kCHAR_V = "V,"
    static let kCHAR_B = "B,"
    static let kCHAR_M = "M,"
    static let kCHAR_N = "N,"
    static let kCHAR_W = "W,"
    static let kCHAR_I = "I,"
    static let kCHAR_O = "O,"
    static let kCHAR_J = "J,"
    
    static let kCHAR_MACAO  = "澳,"
    static let kCHAR_HK     = "港,"
    static let kCHAR_TAI    = "台,"
    static let kCHAR_XUE    = "学,"
    static let kCHAR_MIN    = "民,"
    static let kCHAR_HANG   = "航,"
    static let kCHAR_SHI    = "使,"
    static let kCHAR_SPECIAL = "学,警,港,澳,航,挂,试,超,使,领,"

    static let kSTR_HK_MACAO = kCHAR_HK + kCHAR_MACAO;

    static let kSTR_More    = "更多,"
    static let kSTR_Back    = "返回,"
    static let kSTR_Delete  = "删除,"
    static let kSTR_Sure    = "确定"
    /// (第一位)默认省份
    static let kSTR_Keyboard_PVS = "京,津,晋,冀,蒙,辽,吉,黑,沪,苏,浙,皖,闽,赣,鲁,豫,鄂,湘,粤,桂,琼,渝,川,贵,云,藏,陕,甘,青,宁,新,台," + kSTR_More + kSTR_Delete + kSTR_Sure

    // MARK: - funtins
    /// 注册键位及其状态
    class func generateLayout(inputIndex: Int,
                              plateNumber: String,
                              numberType: NNKeyboardNumType,
                              isMoreType: Bool) -> NNKeyboardLayout {
//        var detectedNumType = numberType
//        if numberType == .auto {
//            detectedNumType = NNKeyboardEngine.detectNumTypeOf(plateNumber: plateNumber)
//        }
        // 根据车牌自动推断车牌类型
        let detectedNumType = NNKeyboardEngine.detectNumTypeOf(plateNumber: plateNumber)
        //获取键位布局
        var layout = NNKeyboardEngine.getKeyProvider(inputIndex: inputIndex, plateNumber: plateNumber, isMoreType: isMoreType)
        //键位状态注册
        layout = NNKeyboardEngine.keyStateRegist(inputIndex: inputIndex, keyString: plateNumber, listModel: layout, numberType: detectedNumType)
    
        layout.plateNumber = plateNumber
        layout.numberType = detectedNumType
        layout.inputIndex = inputIndex
//        layout.keys = layoutLout.row1 + layoutLout.row0 + layoutLout.row2 + layoutLout.row3
//        DDLog(layoutLout.keysDes)
//        DDLog(layoutLout.keysStateDes)

        return layout
    }
    ///键位布局
    static func getKeyProvider(inputIndex: Int, plateNumber: String, isMoreType: Bool) -> NNKeyboardLayout{
        var layout = NNKeyboardLayout()
        switch inputIndex {
        case 0:
            if !isMoreType {
                layout = NNKeyboardEngine.defaultProvinces()
                
            } else {
                layout.row0 = NNKeyboardEngine.getRowModels(string: kSTR_NUM)
                layout.row1 = NNKeyboardEngine.getRowModels(string: kSTR_Q_P)
                layout.row2 = NNKeyboardEngine.getRowModels(string: kSTR_A_L)
                layout.row3 = NNKeyboardEngine.getRowModels(string: kSTR_ZX + kCHAR_MIN + kCHAR_SHI + kSTR_Back + kSTR_Delete + kSTR_Sure)
            }
            
        case 1:
            if plateNumber.hasPrefix(kCHAR_MIN.replacingOccurrences(of: ",", with: "")) {
                layout = NNKeyboardEngine.defaultSpecial()
            } else {
                layout = NNKeyboardEngine.defaultNumbersAndLetters()
            }
        case 2, 3, 4, 5:
            if plateNumber.hasPrefix("W") {
                layout = NNKeyboardEngine.defaultProvinces()
            } else {
                layout = NNKeyboardEngine.defaultNumbersAndLetters()
            }
        case 6:
            if !isMoreType {
                layout = NNKeyboardEngine.defaultLast()
            } else {
                layout = NNKeyboardEngine.defaultSpecial()
            }
        case 7:
//            layout = NNKeyboardEngine.defaultLast()
            layout = NNKeyboardEngine.defaultNumbersAndLetters()

        default:
            break
        }
        return layout
    }
    
    ///键位状态注册
    static func keyStateRegist(inputIndex: Int, keyString: String, listModel: NNKeyboardLayout, numberType: NNKeyboardNumType) -> NNKeyboardLayout {
        var okString = ""
        if numberType == .newEnergy || numberType == .wuJing {
            okString = keyString.count == 8 ? kSTR_Sure : ""
        } else {
            okString = keyString.count == 7 ? kSTR_Sure : ""
        }
        let disOkString = okString == "" ? kSTR_Sure : ""

        var list = listModel
        switch inputIndex {
        case 0:
            if numberType == .newEnergy {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_TAI + kSTR_More + disOkString), listModel: list, isEnabled:false)
            } else {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_TAI + disOkString), listModel: list, isEnabled:false)
            }

        case 1:
            if numberType == .wuJing {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_J + kSTR_Delete + okString), listModel: list, isEnabled:true)
                
            } else if numberType == .embassy {
                list = NNKeyboardEngine.keyStateChange(keyString:(kSTR_NUM1_3 + kSTR_Delete + okString), listModel: list, isEnabled:true)
                
            } else if numberType == .airport {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_HANG + kSTR_Delete + okString), listModel: list, isEnabled:true)
                
            } else {
                list = NNKeyboardEngine.keyStateChange(keyString:(kSTR_NUM4_0 + kCHAR_I + disOkString), listModel: list, isEnabled:false)
                
            }

        case 2:
            if numberType == .wuJing {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_TAI + kSTR_More + disOkString), listModel: list, isEnabled:false)
            } else if numberType == .embassy{
                list = NNKeyboardEngine.keyStateChange(keyString:(kSTR_NUM + kSTR_Delete + okString), listModel: list, isEnabled:true)
            } else {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_I + kCHAR_O + disOkString), listModel: list, isEnabled:false)
            }

        case 3:
            if numberType == .embassy{
                list = NNKeyboardEngine.keyStateChange(keyString:(kSTR_NUM + kSTR_Delete + okString), listModel: list, isEnabled:true)
            } else {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_I + kCHAR_O + disOkString), listModel: list, isEnabled:false)
            }

        case 4,5:
            list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_I + kCHAR_O + disOkString), listModel: list, isEnabled:false)

        case 6:
            if keyString.replacingOccurrences(of: ",", with: "").hasPrefix("粤Z") {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_HK + kCHAR_MACAO + kSTR_Delete + kSTR_More + okString), listModel: list, isEnabled:true)
            } else if numberType == .embassy || numberType == .airport || numberType == .newEnergy{
                list = NNKeyboardEngine.keyStateChange(keyString:(kSTR_More + disOkString), listModel: list, isEnabled:false)
            } else {
                list = NNKeyboardEngine.keyStateChange(keyString:(kCHAR_HK + kCHAR_MACAO + kCHAR_HANG + kCHAR_SHI + disOkString), listModel: list, isEnabled:false)
            }

        case 7:
            list = NNKeyboardEngine.keyStateChange(keyString: (kCHAR_I + kCHAR_O + disOkString), listModel: list, isEnabled:false)

        default:
            break
        }
        return listModel
    }
    
    static func getRowModels(string: String) -> [NNKeyboradModel] {
        var list: [NNKeyboradModel] = []
        let stringS = string.split(separator: ",")
        stringS.forEach { (key) in
            let model = NNKeyboradModel()
            model.enabled = true
            model.text = "\(key)";
//            model.isFunKey = [kSTR_More, kSTR_Back, kSTR_Delete, kSTR_Sure].contains(model.text)
            list.append(model)
        }
        return list;
    }
    
    static func defaultNumbersAndLetters() ->NNKeyboardLayout{
        let listModel = NNKeyboardLayout()
        listModel.row0 = NNKeyboardEngine.getRowModels(string: kSTR_NUM)
        listModel.row1 = NNKeyboardEngine.getRowModels(string: kSTR_Q_P)
        listModel.row2 = NNKeyboardEngine.getRowModels(string: kSTR_A_L + "M")
        listModel.row3 = NNKeyboardEngine.getRowModels(string: kSTR_Z_N + kSTR_Delete + kSTR_Sure)
        return listModel
    }
    
    static func defaultSpecial() ->NNKeyboardLayout{
        let listModel = NNKeyboardLayout()
        listModel.row0 = NNKeyboardEngine.getRowModels(string: kCHAR_SPECIAL)
        listModel.row1 = NNKeyboardEngine.getRowModels(string: kSTR_NUM)
        listModel.row2 = NNKeyboardEngine.getRowModels(string: kSTR_A_K)
        listModel.row3 = NNKeyboardEngine.getRowModels(string: kSTR_W_Z + kSTR_Back + kSTR_Delete + kSTR_Sure)
        return listModel
    }
    
    static func defaultLast() -> NNKeyboardLayout{
        let listModel = NNKeyboardLayout()
        listModel.row0 = NNKeyboardEngine.getRowModels(string: kSTR_NUM)
        listModel.row1 = NNKeyboardEngine.getRowModels(string: kSTR_Q_U + "P,M,N")
        listModel.row2 = NNKeyboardEngine.getRowModels(string: kSTR_A_L + "B,")
        listModel.row3 = NNKeyboardEngine.getRowModels(string: kSTR_Z_V + kSTR_More + kSTR_Delete + kSTR_Sure)
        return listModel
    }
    
    static func defaultProvinces() ->NNKeyboardLayout{
        let row0_keys = (kSTR_Keyboard_PVS as NSString).substring(loc: 0, len: 20)
        let row1_keys = (kSTR_Keyboard_PVS as NSString).substring(loc: 20, len: 20)
        let row2_keys = (kSTR_Keyboard_PVS as NSString).substring(loc: 40, len: 16)
        let row3_keys = (kSTR_Keyboard_PVS as NSString).substring(from: 56)
        
        let listModel = NNKeyboardLayout()
        listModel.row0 = NNKeyboardEngine.getRowModels(string: row0_keys)
        listModel.row1 = NNKeyboardEngine.getRowModels(string: row1_keys)
        listModel.row2 = NNKeyboardEngine.getRowModels(string: row2_keys)
        listModel.row3 = NNKeyboardEngine.getRowModels(string: row3_keys)
        return listModel
    }
    
    static func keyStateChange(keyString: String, listModel: NNKeyboardLayout, isEnabled: Bool) ->NNKeyboardLayout {
        let list = listModel
        list.row0 = NNKeyboardEngine.keyStateChange(keyString: keyString, rowModels: list.row0, isEnabled:isEnabled)
        list.row1 = NNKeyboardEngine.keyStateChange(keyString: keyString, rowModels: list.row1, isEnabled:isEnabled)
        list.row2 = NNKeyboardEngine.keyStateChange(keyString: keyString, rowModels: list.row2, isEnabled:isEnabled)
        list.row3 = NNKeyboardEngine.keyStateChange(keyString: keyString, rowModels: list.row3, isEnabled:isEnabled)
        return list
    }
        
    static func keyStateChange(keyString: String, rowModels: [NNKeyboradModel], isEnabled: Bool) -> [NNKeyboradModel] {
        for model in rowModels {
            model.enabled = keyString.contains(model.text) ? isEnabled : !isEnabled
//            DDLog("\(model.text)_\(model.enabled)")
        }
        return rowModels
    }
        
    static func detectNumTypeOf(plateNumber: String) -> NNKeyboardNumType {
        if plateNumber.count == 8 {
            return .newEnergy
        }
        
        if plateNumber.count >= 1 {
            if plateNumber.hasPrefix(kCHAR_W.replacingOccurrences(of: ",", with: "")) {
                return .wuJing
            } else if plateNumber.hasPrefix(kCHAR_MIN.replacingOccurrences(of: ",", with: "")) {
                return .airport
            } else if plateNumber.hasPrefix(kCHAR_SHI.replacingOccurrences(of: ",", with: ""))  {
                return .embassy
            }
        }
        return .auto
    }

}
