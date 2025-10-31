# MathTeachingApp - 快速開始指南

## 🎯 如何上傳到 GitHub

### 方法一：使用提供的腳本（推薦）

1. 解壓縮下載的 `MathTeachingApp.tar.gz`
   ```bash
   tar -xzf MathTeachingApp.tar.gz
   cd MathTeachingApp
   ```

2. 執行上傳腳本
   ```bash
   ./upload_to_github.sh
   ```

3. 腳本會自動：
   - 初始化 Git repository
   - 建立第一個 commit
   - 如果有安裝 GitHub CLI，會自動建立 repository 並上傳
   - 如果沒有 GitHub CLI，會提供手動步驟

### 方法二：手動上傳

1. 在 GitHub 建立新的 repository
   - 前往: https://github.com/new
   - Repository name: `MathTeachingApp`
   - Description: 一款專為小學三年級學生設計的數學練習App
   - 設為 **Public**
   - **不要**勾選 "Initialize this repository with a README"

2. 在本地執行指令
   ```bash
   cd MathTeachingApp
   git init
   git add .
   git commit -m "Initial commit: MathTeachingApp for Grade 3 Math Practice"
   git branch -M main
   git remote add origin https://github.com/langrisser1981/MathTeachingApp.git
   git push -u origin main
   ```

## 📱 如何在 Xcode 中運行

詳細步驟請參考 `SETUP_INSTRUCTIONS.md` 檔案。

簡要步驟：
1. 在 Xcode 建立新的 iOS App 專案
2. 選擇 SwiftUI 和 Swift
3. 將下載的原始碼檔案加入專案中
4. 設定 iOS Deployment Target 為 15.0
5. 執行專案

## 📂 專案結構

```
MathTeachingApp/
├── README.md                    # 專案說明
├── SETUP_INSTRUCTIONS.md        # 詳細設置指南
├── LICENSE                      # MIT 授權
├── .gitignore                   # Git 忽略檔案
├── upload_to_github.sh          # GitHub 上傳腳本
└── MathTeachingApp/             # 原始碼
    ├── Models/                  # 資料模型
    │   └── Models.swift
    ├── ViewModels/              # 視圖模型
    │   └── MathQuizViewModel.swift
    ├── Views/                   # UI 視圖
    │   ├── SettingsView.swift
    │   ├── QuizView.swift
    │   ├── SubtractionProblemView.swift
    │   ├── BlankInputView.swift
    │   └── ResultsView.swift
    └── App/                     # App 入口
        └── MathTeachingApp.swift
```

## 🔗 相關連結

- GitHub Repository: https://github.com/langrisser1981/MathTeachingApp
- 問題回報: https://github.com/langrisser1981/MathTeachingApp/issues

## 💡 需要協助？

如果遇到任何問題：
1. 查看 `SETUP_INSTRUCTIONS.md` 中的常見問題排除
2. 在 GitHub Issues 中提出問題
3. 確保已安裝最新版本的 Xcode

## 🎉 開始使用

上傳到 GitHub 後，你可以：
- ✅ 與其他開發者協作
- ✅ 使用 GitHub Issues 追蹤問題
- ✅ 建立不同的分支進行功能開發
- ✅ 使用 Pull Request 進行程式碼審查
- ✅ 透過 GitHub Actions 設置 CI/CD

祝你開發順利！🚀
