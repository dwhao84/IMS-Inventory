
import UIKit

// 定義基本的 Bin 計算協議
protocol BinCalculatable {
    func calculate(bin40By60: Int, bin60x80: Int) -> String
}

// 實現計算邏輯
struct BinCalculator: BinCalculatable {
    func calculate(bin40By60: Int, bin60x80: Int) -> String {
        var outputText = ""
        
        if bin40By60 > 0 && bin60x80 > 0 {
            outputText += "Bin數量大於1\n"
            outputText += "12483 CORNER POST F BIN H850MM WHI * \(bin40By60 * 4 + bin60x80 * 4)\n"
            outputText += "17740 SIDE F BIN L400 H700MM WHI * \(bin40By60 * 2)\n"
            outputText += "17739 SIDE F BIN L600 H700MM WHI * \(bin40By60 * 2 + bin60x80 * 2)\n"
            outputText += "17743 SIDE F BIN L800 H700MM WHI * \(bin60x80 * 2)\n"
        } else if bin40By60 > 0 {
            outputText += "40 * 60的Bin 大於 1\n"
            outputText += "12483 CORNER POST F BIN H850MM WHI * \(bin40By60 * 4)\n"
            outputText += "17740 SIDE F BIN L400 H700MM WHI * \(bin40By60 * 2)\n"
            outputText += "17739 SIDE F BIN L600 H700MM WHI * \(bin40By60 * 2)\n"
        } else if bin60x80 > 0 {
            outputText += "60 * 80的Bin 大於 1\n"
            outputText += "12483 CORNER POST F BIN H850MM WHI * \(bin60x80 * 4)\n"
            outputText += "17739 SIDE F BIN L600 H700MM WHI * \(bin60x80 * 2)\n"
            outputText += "17743 SIDE F BIN L800 H700MM WHI * \(bin60x80 * 2)\n"
        }
        
        return outputText
    }
}

// 使用方式
func calculateStandardBins(qtyOfBin_forty_By_Sixty: Int, qtyOfBinSixty_By_Eighty: Int) -> String {
    let calculator = BinCalculator()
    return calculator.calculate(bin40By60: qtyOfBin_forty_By_Sixty, bin60x80: qtyOfBinSixty_By_Eighty)
}
