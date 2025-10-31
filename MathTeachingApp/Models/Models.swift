//
//  Models.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import Foundation

// MARK: - 題目類型
enum ProblemType: String, Codable, CaseIterable {
    case addition = "加法"
    case subtraction = "減法"
    case multiplication = "乘法"

    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "×"
        }
    }
}

// MARK: - 題目模型
struct MathProblem: Identifiable, Codable {
    let id: UUID
    let type: ProblemType   // 題目類型
    let number1: Int        // 第一個數字（被加數/被減數/被乘數）
    let number2: Int        // 第二個數字（加數/減數/乘數）
    let correctAnswer: Int  // 正確答案
    let blanks: [BlankPosition]  // 空格位置
    let allowMultipleBlanksPerColumn: Bool  // 是否允許同一位數多個空格

    init(type: ProblemType, number1: Int, number2: Int, allowMultipleBlanksPerColumn: Bool = false, blankCount: Int = 3) {
        self.id = UUID()
        self.type = type
        self.number1 = number1
        self.number2 = number2

        // 根據題型計算答案
        switch type {
        case .addition:
            self.correctAnswer = number1 + number2
        case .subtraction:
            self.correctAnswer = number1 - number2
        case .multiplication:
            self.correctAnswer = number1 * number2
        }

        self.allowMultipleBlanksPerColumn = allowMultipleBlanksPerColumn
        self.blanks = Self.generateBlanks(
            type: type,
            for: number1,
            number2: number2,
            answer: correctAnswer,
            allowMultipleBlanksPerColumn: allowMultipleBlanksPerColumn,
            blankCount: blankCount
        )
    }
    
    // 生成空格位置
    private static func generateBlanks(
        type: ProblemType,
        for num1: Int,
        number2: Int,
        answer: Int,
        allowMultipleBlanksPerColumn: Bool,
        blankCount: Int
    ) -> [BlankPosition] {
        var positions: [BlankPosition] = []

        // 將數字轉換為陣列
        let digits1 = String(num1).map { Int(String($0))! }
        let digits2 = String(number2).map { Int(String($0))! }
        let answerDigits = String(answer).map { Int(String($0))! }

        // 乘法只有答案空格
        if type == .multiplication {
            let answerBlankCount = min(blankCount, answerDigits.count)
            let selectedIndices = Array(0..<answerDigits.count).shuffled().prefix(answerBlankCount)

            for index in selectedIndices {
                positions.append(BlankPosition(
                    row: 2,
                    digitIndex: index,
                    correctDigit: answerDigits[index]
                ))
            }

            return positions.sorted { $0.digitIndex < $1.digitIndex }
        }

        if allowMultipleBlanksPerColumn {
            // 進階模式：允許同一位數出現多個空格
            var availablePositions: [(row: Int, index: Int)] = []

            // 收集所有可用位置
            for i in 0..<digits1.count {
                availablePositions.append((0, i))  // 第一列
            }
            for i in 0..<digits2.count {
                availablePositions.append((1, i))  // 第二列
            }
            for i in 0..<answerDigits.count {
                availablePositions.append((2, i))  // 答案列
            }

            // 隨機選擇
            let selectedPositions = availablePositions.shuffled().prefix(blankCount)

            for (row, index) in selectedPositions {
                let correctDigit: Int
                switch row {
                case 0: correctDigit = digits1[index]
                case 1: correctDigit = digits2[index]
                default: correctDigit = answerDigits[index]
                }

                positions.append(BlankPosition(
                    row: row,
                    digitIndex: index,
                    correctDigit: correctDigit
                ))
            }
        } else {
            // 標準模式：確保每個位數最多只有一個空格
            let maxLength = max(digits1.count, digits2.count, answerDigits.count)
            var columnPositions: [Int: [(row: Int, index: Int)]] = [:]

            // 收集每個 column 的可用位置 (從右邊數起)
            for column in 0..<maxLength {
                var availableInColumn: [(row: Int, index: Int)] = []

                // 被減數 (從右邊數起)
                let digit1Index = digits1.count - 1 - column
                if digit1Index >= 0 {
                    availableInColumn.append((0, digit1Index))
                }

                // 減數 (從右邊數起)
                let digit2Index = digits2.count - 1 - column
                if digit2Index >= 0 {
                    availableInColumn.append((1, digit2Index))
                }

                // 答案 (從右邊數起)
                let answerIndex = answerDigits.count - 1 - column
                if answerIndex >= 0 {
                    availableInColumn.append((2, answerIndex))
                }

                if !availableInColumn.isEmpty {
                    columnPositions[column] = availableInColumn
                }
            }

            // 隨機選擇空格，確保每個 column 最多一個
            let availableColumns = Array(columnPositions.keys).shuffled()
            let selectedColumns = availableColumns.prefix(blankCount)

            for column in selectedColumns {
                // 從這個 column 的可用位置中隨機選一個
                if let positionsInColumn = columnPositions[column], !positionsInColumn.isEmpty {
                    let selected = positionsInColumn.randomElement()!
                    let (row, index) = selected

                    let correctDigit: Int
                    switch row {
                    case 0: correctDigit = digits1[index]
                    case 1: correctDigit = digits2[index]
                    default: correctDigit = answerDigits[index]
                    }

                    positions.append(BlankPosition(
                        row: row,
                        digitIndex: index,
                        correctDigit: correctDigit
                    ))
                }
            }
        }

        return positions.sorted { ($0.row, $0.digitIndex) < ($1.row, $1.digitIndex) }
    }
}

// MARK: - 空格位置
struct BlankPosition: Identifiable, Codable {
    let id = UUID()
    let row: Int           // 0: 被減數, 1: 減數, 2: 答案
    let digitIndex: Int    // 從左到右的位置(0-based)
    let correctDigit: Int  // 正確數字
    
    var rowName: String {
        switch row {
        case 0: return "被減數"
        case 1: return "減數"
        default: return "答案"
        }
    }
}

// MARK: - 用戶答案
struct UserAnswer: Codable {
    var problemId: UUID
    var answers: [UUID: Int]  // BlankPosition.id -> 用戶填入的數字
    var isCorrect: Bool {
        // 檢查是否所有空格都已填寫且正確
        return answers.count > 0 && answers.values.allSatisfy { $0 >= 0 && $0 <= 9 }
    }
}

// MARK: - 測驗結果
struct QuizResult: Identifiable, Codable {
    let id: UUID
    let problemId: UUID
    let userAnswer: UserAnswer
    let problem: MathProblem
    let correctCount: Int
    let totalBlanks: Int
    let isAllCorrect: Bool
    let answeredAt: Date
    
    var scorePercentage: Double {
        return Double(correctCount) / Double(totalBlanks) * 100
    }
}

// MARK: - 測驗設定
struct QuizSettings: Codable {
    var numberOfProblems: Int = 5  // 預設5題
    var minNumber: Int = 1000      // 最小數字(四位數)
    var maxNumber: Int = 9999      // 最大數字(四位數)
    var difficulty: Difficulty = .medium
    var allowMultipleBlanksPerColumn: Bool = false  // 允許同一位數出現多個空格（進階題型）
    var selectedTypes: Set<ProblemType> = [.subtraction]  // 選擇的題型
    var isMixedOrder: Bool = false  // 是否混合出題順序

    enum Difficulty: String, Codable, CaseIterable {
        case easy = "簡單"
        case medium = "中等"
        case hard = "困難"

        var blankCount: Int {
            switch self {
            case .easy: return 2
            case .medium: return 3
            case .hard: return 4
            }
        }
    }
}
