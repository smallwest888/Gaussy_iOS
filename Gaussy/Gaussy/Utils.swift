

import Foundation

func checkAndConvertNumber(_ input: String) -> Double? {
    // 正则表达式匹配整数
    let integerPattern = #"^-?\d+$"#
    // 正则表达式匹配小数
    let decimalPattern = #"^-?\d+\.\d+$"#
    // 正则表达式匹配分数（例如：1/2）
    let fractionPattern = #"^-?\d+/\d+$"#

    // 检查是否为整数
    if input.range(of: integerPattern, options: .regularExpression) != nil {
        if let intValue = Int(input) {
            return Double(intValue)
        } else {
            return nil
        }
    }
    // 检查是否为小数
    else if input.range(of: decimalPattern, options: .regularExpression) != nil {
        if let doubleValue = Double(input) {
            return doubleValue
        } else {
            return nil
        }
    }
    // 检查是否为分数
    else if input.range(of: fractionPattern, options: .regularExpression) != nil {
        let components = input.components(separatedBy: "/")
        if components.count == 2,
           let numerator = Double(components[0]),
           let denominator = Double(components[1]),
           denominator != 0 {
            let result = numerator / denominator
            return result
        } else {
            return nil
        }
    }
    // 无法匹配任何模式
    else {
        return nil
    }
}

func checkDoubleIsInt(_ num: Double) -> Bool {
    return round(num) - num == 0.0
}

func getRankDataListFromStr(_ str: String) -> [Item] {
    if let data = str.data(using: .utf8),
       let decodedItems = try? JSONDecoder().decode([Item].self, from: data) {
        return decodedItems
    }
    return []
}

func getRankDataStrFromList(_ items: [Item]) -> String {
    // 将对象数组数据编码成 JSON 字符串并保存到 UserDefaults 中
    if let encodedData = try? JSONEncoder().encode(items),
       let jsonString = String(data: encodedData, encoding: .utf8) {
       return jsonString
    } else {
        return "[]"
    }
}
