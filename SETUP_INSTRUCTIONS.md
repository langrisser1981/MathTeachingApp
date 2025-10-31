# MathTeachingApp 專案設置指南

## 📋 前置需求

- macOS 12.0 或更新版本
- Xcode 14.0 或更新版本
- iOS 15.0+ 模擬器或實體裝置

## 🚀 在 Xcode 中建立專案的步驟

由於 GitHub 上的專案只包含 Swift 原始碼檔案，你需要在 Xcode 中手動建立專案並導入這些檔案。

### 步驟 1: 建立新的 Xcode 專案

1. 開啟 Xcode
2. 選擇 **File > New > Project**
3. 選擇 **iOS > App**
4. 點擊 **Next**
5. 填寫專案資訊：
   - **Product Name**: `MathTeachingApp`
   - **Team**: 選擇你的開發者團隊（如果有）
   - **Organization Identifier**: 輸入你的組織識別碼（例如：com.yourname）
   - **Interface**: 選擇 **SwiftUI**
   - **Language**: 選擇 **Swift**
   - **Storage**: 選擇 **None**
   - 取消勾選 **Use Core Data**
   - 取消勾選 **Include Tests**
6. 點擊 **Next**，選擇儲存位置
7. 點擊 **Create**

### 步驟 2: 組織專案結構

1. 在 Xcode 左側的 Project Navigator 中，刪除自動生成的 `ContentView.swift`

2. 建立資料夾群組：
   - 在專案名稱上按右鍵，選擇 **New Group**
   - 建立以下群組：
     - `Models`
     - `ViewModels`
     - `Views`
     - `App`

### 步驟 3: 加入檔案

從 GitHub clone 下來的專案中，將檔案依照以下對應關係加入到 Xcode：

1. **Models 群組**：
   - 加入 `MathTeachingApp/Models/Models.swift`

2. **ViewModels 群組**：
   - 加入 `MathTeachingApp/ViewModels/MathQuizViewModel.swift`

3. **Views 群組**：
   - 加入 `MathTeachingApp/Views/SettingsView.swift`
   - 加入 `MathTeachingApp/Views/QuizView.swift`
   - 加入 `MathTeachingApp/Views/SubtractionProblemView.swift`
   - 加入 `MathTeachingApp/Views/BlankInputView.swift`
   - 加入 `MathTeachingApp/Views/ResultsView.swift`

4. **App 群組**：
   - 用 `MathTeachingApp/App/MathTeachingApp.swift` 取代自動生成的同名檔案

**加入檔案的方法**：
- 將檔案拖曳到對應的群組中，或
- 在群組上按右鍵 > **Add Files to "MathTeachingApp"** > 選擇檔案 > 確保勾選 **Copy items if needed**

### 步驟 4: 設定部署目標

1. 在 Project Navigator 中選擇專案（藍色圖示）
2. 在 **TARGETS** 下選擇 **MathTeachingApp**
3. 在 **General** 標籤下，將 **Deployment Info > iOS Deployment Target** 設定為 **15.0**

### 步驟 5: 執行專案

1. 在 Xcode 頂部選擇一個模擬器（例如：iPhone 15 Pro）
2. 按下 **⌘R** 或點擊 **Run** 按鈕
3. 等待建置完成，App 應該會在模擬器中啟動

## 🎨 專案結構說明

```
MathTeachingApp/
├── Models/                      # 資料模型層
│   └── Models.swift            # 包含所有資料結構
├── ViewModels/                 # 視圖模型層
│   └── MathQuizViewModel.swift # 測驗邏輯處理
├── Views/                      # 視圖層
│   ├── SettingsView.swift      # 設定頁面
│   ├── QuizView.swift          # 測驗頁面
│   ├── SubtractionProblemView.swift # 減法算式顯示
│   ├── BlankInputView.swift    # 空格輸入元件
│   └── ResultsView.swift       # 結果頁面
└── App/
    └── MathTeachingApp.swift   # App 入口點
```

## 🐛 常見問題排除

### 問題 1: 找不到某些 Swift 檔案
**解決方法**: 確保所有檔案都已正確加入到專案中，檢查 Xcode 左側的 Project Navigator。

### 問題 2: 編譯錯誤 "Cannot find 'XXX' in scope"
**解決方法**: 確保所有相依的檔案都已加入專案，特別是 `Models.swift`。

### 問題 3: App 無法在實體裝置上執行
**解決方法**: 
- 確保已設定正確的開發者團隊
- 在 **Signing & Capabilities** 中檢查 Bundle Identifier 是否唯一
- 確保裝置已信任你的開發者證書

### 問題 4: 模擬器運行緩慢
**解決方法**: 
- 選擇較新的 iOS 版本模擬器
- 關閉其他耗資源的應用程式
- 考慮在實體裝置上測試

## 📱 測試建議

1. **基本功能測試**：
   - 設定不同的題目數量
   - 嘗試不同的難度等級
   - 測試空格填寫和驗證功能

2. **邊界條件測試**：
   - 測試最小和最大數字範圍
   - 測試 1 題和 20 題的極端情況

3. **UI/UX 測試**：
   - 在不同尺寸的裝置上測試
   - 測試橫向和直向模式
   - 測試鍵盤顯示和隱藏

## 🎓 學習資源

- [SwiftUI 官方文檔](https://developer.apple.com/documentation/swiftui/)
- [Swift 程式語言指南](https://docs.swift.org/swift-book/)
- [iOS App 開發教學](https://developer.apple.com/tutorials/app-dev-training)

## 📞 需要協助？

如果遇到任何問題，歡迎在 GitHub Issues 中提出！
