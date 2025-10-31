# MathTeachingApp

一款專為小學三年級學生設計的數學練習App,專注於加減法運算訓練。

## 📱 功能特色

- ✅ **四位數減法練習**: 支援1000-9999範圍的減法運算
- ✅ **隨機空格填空**: 每題自動生成2-3個空格,訓練學生計算能力
- ✅ **即時驗證**: 完成填寫後立即檢查答案正確性
- ✅ **視覺化回饋**: 
  - 空格用黃色背景標示
  - 正確答案顯示綠色
  - 錯誤答案顯示紅色並提示正確數字
- ✅ **彈性設定**: 可調整題目數量(1-20題)、難度等級、數字範圍
- ✅ **進度追蹤**: 顯示當前答題進度
- ✅ **成績統計**: 
  - 統計答對/答錯數量
  - 計算正確率
  - 可重新檢視任一題目

## 🛠 技術架構

- **開發語言**: Swift
- **UI框架**: SwiftUI
- **架構模式**: MVVM (Model-View-ViewModel)
- **最低系統需求**: iOS 15.0+

## 📁 專案結構

```
MathTeachingApp/
├── Models/              # 資料模型
│   ├── MathProblem.swift
│   ├── BlankPosition.swift
│   ├── UserAnswer.swift
│   ├── QuizResult.swift
│   └── QuizSettings.swift
├── ViewModels/          # 視圖模型
│   └── MathQuizViewModel.swift
├── Views/               # UI 視圖
│   ├── SettingsView.swift
│   ├── QuizView.swift
│   ├── SubtractionProblemView.swift
│   ├── BlankInputView.swift
│   └── ResultsView.swift
└── App/
    └── MathTeachingApp.swift
```

## 🚀 開始使用

### 環境需求

- Xcode 14.0 或更新版本
- macOS 12.0 或更新版本
- iOS 15.0+ 目標裝置或模擬器

### 安裝步驟

1. Clone 此專案
```bash
git clone https://github.com/langrisser1981/MathTeachingApp.git
```

2. 開啟 Xcode 專案
```bash
cd MathTeachingApp
open MathTeachingApp.xcodeproj
```

3. 選擇目標裝置並執行 (⌘R)

## 📖 使用說明

1. **設定測驗參數**
   - 選擇題目數量 (1-20題)
   - 選擇難度等級 (簡單/中等/困難)
   - 設定數字範圍

2. **開始練習**
   - 點擊「開始測驗」按鈕
   - 在黃色空格中填入數字
   - 點擊「驗證答案」檢查結果

3. **查看結果**
   - 完成所有題目後查看成績統計
   - 可點擊任一題目重新檢視答案

## 🎯 未來規劃

- [ ] 加入說明頁面: 展示借位與補位的概念
- [ ] 講解功能: 答錯時提供步驟說明
- [ ] 難度分級: 根據借位次數調整難度
- [ ] 成績紀錄: 使用 CoreData 儲存歷史成績
- [ ] 獎勵機制: 連續答對給予獎章
- [ ] 加法題型: 擴展到加法練習
- [ ] 多語言支援: 英文、簡體中文等

## 📄 授權

MIT License

## 👨‍💻 作者

langrisser1981

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request!

---

如果這個專案對你有幫助,請給個 ⭐️ Star 支持一下!
