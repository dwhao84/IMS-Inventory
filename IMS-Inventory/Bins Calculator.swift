// MARK: - 定義資料結構
struct BinCalculationResult {
    let components: [BinComponent]
    
    struct BinComponent {
        let partNumber: String
        let description: String
        let quantity: Int
    }
}

// MARK: - Protocol
protocol BinCalculatable {
    func calculateStandardBins(qtyOfBin_forty_By_Sixty: Int, qtyOfBinSixty_By_Eighty: Int) -> BinCalculationResult
    func calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: Int, qtyOfPalletBin_Eighty_By_OneHundredTwenty: Int) -> BinCalculationResult
}

// MARK: - Calculator 實作
class BinCalculator: BinCalculatable {
    func calculateStandardBins(qtyOfBin_forty_By_Sixty: Int, qtyOfBinSixty_By_Eighty: Int) -> BinCalculationResult {
        var components: [BinCalculationResult.BinComponent] = []
        
        if qtyOfBin_forty_By_Sixty > 0 && qtyOfBinSixty_By_Eighty > 0 {
            components = [
                .init(partNumber: "12483", description: "CORNER POST F BIN H850MM WHI",
                     quantity: qtyOfBin_forty_By_Sixty * 4 + qtyOfBinSixty_By_Eighty * 4),
                .init(partNumber: "17740", description: "SIDE F BIN L400 H700MM WHI",
                     quantity: qtyOfBin_forty_By_Sixty * 2),
                .init(partNumber: "17739", description: "SIDE F BIN L60 H700MM WHI",
                     quantity: qtyOfBin_forty_By_Sixty * 2 + qtyOfBinSixty_By_Eighty * 2),
                .init(partNumber: "17743", description: "SIDE F BIN L800 H700MM WHI",
                     quantity: qtyOfBinSixty_By_Eighty * 2)
            ]
        } else if qtyOfBin_forty_By_Sixty > 0 {
            components = [
                .init(partNumber: "12483", description: "CORNER POST F BIN H850MM WHI",
                     quantity: qtyOfBin_forty_By_Sixty * 4),
                .init(partNumber: "17740", description: "SIDE F BIN L400 H700MM WHI",
                     quantity: qtyOfBin_forty_By_Sixty * 2),
                .init(partNumber: "17739", description: "SIDE F BIN L600 H700MM WHI",
                     quantity: qtyOfBin_forty_By_Sixty * 2)
            ]
        } else {
            components = [
                .init(partNumber: "12483", description: "CORNER POST F BIN H850MM WHI",
                     quantity: qtyOfBinSixty_By_Eighty * 4),
                .init(partNumber: "17739", description: "SIDE F BIN L600 H700MM WHI",
                     quantity: qtyOfBinSixty_By_Eighty * 2),
                .init(partNumber: "17743", description: "SIDE F BIN L800 H700MM WHI",
                     quantity: qtyOfBinSixty_By_Eighty * 2)
            ]
        }
        
        return BinCalculationResult(components: components)
    }
    
    func calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: Int,
                           qtyOfPalletBin_Eighty_By_OneHundredTwenty: Int) -> BinCalculationResult {
        // 實作 Pallet Bins 的計算邏輯
        // 這裡需要加入實際的計算邏輯
        var components: [BinCalculationResult.BinComponent] = []
        
        // 根據不同情況加入組件...
        
        return BinCalculationResult(components: components)
    }
}
