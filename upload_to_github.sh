#!/bin/bash

# MathTeachingApp GitHub 上傳腳本
# 此腳本會將專案上傳到 GitHub

echo "======================================"
echo "MathTeachingApp GitHub 上傳腳本"
echo "======================================"
echo ""

# 設定變數
GITHUB_USERNAME="langrisser1981"
REPO_NAME="MathTeachingApp"
GITHUB_REPO="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

echo "📝 檢查 Git 是否已安裝..."
if ! command -v git &> /dev/null; then
    echo "❌ 錯誤: Git 未安裝，請先安裝 Git"
    echo "   下載連結: https://git-scm.com/downloads"
    exit 1
fi
echo "✅ Git 已安裝"
echo ""

echo "📝 檢查 GitHub CLI 是否已安裝..."
if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI 未安裝"
    echo "   你需要手動在 GitHub 上建立 repository"
    echo "   或安裝 GitHub CLI: https://cli.github.com/"
    USE_GH_CLI=false
else
    echo "✅ GitHub CLI 已安裝"
    USE_GH_CLI=true
fi
echo ""

# 初始化 Git repository
echo "📝 初始化 Git repository..."
git init
echo "✅ Git repository 初始化完成"
echo ""

# 加入所有檔案
echo "📝 加入所有檔案到 Git..."
git add .
echo "✅ 檔案已加入"
echo ""

# 建立第一個 commit
echo "📝 建立第一個 commit..."
git commit -m "Initial commit: MathTeachingApp for Grade 3 Math Practice

- 實作 MVVM 架構
- 支援四位數減法練習
- 包含隨機空格填空功能
- 即時驗證與視覺化回饋
- 成績統計與結果摘要"
echo "✅ Commit 建立完成"
echo ""

# 設定主分支名稱
echo "📝 設定主分支為 main..."
git branch -M main
echo "✅ 主分支設定完成"
echo ""

if [ "$USE_GH_CLI" = true ]; then
    echo "======================================"
    echo "使用 GitHub CLI 建立 Repository"
    echo "======================================"
    echo ""
    
    # 檢查是否已登入
    echo "📝 檢查 GitHub CLI 登入狀態..."
    if ! gh auth status &> /dev/null; then
        echo "⚠️  尚未登入 GitHub CLI"
        echo "📝 開始登入流程..."
        gh auth login
    else
        echo "✅ 已登入 GitHub CLI"
    fi
    echo ""
    
    # 建立 repository
    echo "📝 建立 GitHub repository..."
    gh repo create ${REPO_NAME} --public --source=. --remote=origin --description="一款專為小學三年級學生設計的數學練習App，專注於加減法運算訓練"
    
    if [ $? -eq 0 ]; then
        echo "✅ Repository 建立成功"
        echo ""
        
        # 推送到 GitHub
        echo "📝 推送程式碼到 GitHub..."
        git push -u origin main
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "======================================"
            echo "✅ 成功！專案已上傳到 GitHub"
            echo "======================================"
            echo ""
            echo "🔗 Repository 網址:"
            echo "   https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
            echo ""
            echo "📱 下一步:"
            echo "   1. 前往 GitHub 查看你的專案"
            echo "   2. 閱讀 SETUP_INSTRUCTIONS.md 了解如何在 Xcode 中設置專案"
            echo "   3. 開始開發或邀請其他人協作！"
        else
            echo "❌ 推送失敗，請檢查網路連線或權限設定"
        fi
    else
        echo "❌ Repository 建立失敗"
        echo "   可能原因:"
        echo "   - Repository 名稱已存在"
        echo "   - 網路連線問題"
        echo "   - 權限不足"
    fi
else
    echo "======================================"
    echo "手動建立 Repository 的步驟"
    echo "======================================"
    echo ""
    echo "由於 GitHub CLI 未安裝，請按照以下步驟手動建立 repository:"
    echo ""
    echo "1️⃣  前往 GitHub 網站:"
    echo "   https://github.com/new"
    echo ""
    echo "2️⃣  填寫 Repository 資訊:"
    echo "   - Repository name: ${REPO_NAME}"
    echo "   - Description: 一款專為小學三年級學生設計的數學練習App"
    echo "   - Public (勾選)"
    echo "   - 不要勾選 'Initialize this repository with a README'"
    echo ""
    echo "3️⃣  建立 Repository 後，執行以下指令:"
    echo ""
    echo "   git remote add origin ${GITHUB_REPO}"
    echo "   git push -u origin main"
    echo ""
    echo "4️⃣  完成後，你的專案就會出現在:"
    echo "   https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    echo ""
fi

echo ""
echo "======================================"
echo "📚 相關檔案說明"
echo "======================================"
echo ""
echo "README.md              - 專案說明文件"
echo "SETUP_INSTRUCTIONS.md  - Xcode 設置指南"
echo "LICENSE                - MIT 授權條款"
echo ".gitignore             - Git 忽略檔案設定"
echo ""
echo "🎉 準備工作完成！祝你開發順利！"
