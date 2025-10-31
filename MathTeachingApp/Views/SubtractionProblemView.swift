//
//  SubtractionProblemView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI
import os.log

private let logger = Logger(subsystem: "com.lenny.MathTeachingApp", category: "SubtractionProblem")

struct SubtractionProblemView: View {
    let problem: MathProblem
    let userAnswer: UserAnswer?
    let validationResults: [UUID: Bool]
    let showValidation: Bool
    @FocusState var focusedBlankId: UUID?
    let onAnswerChange: (UUID, Int?) -> Void
    
    var body: some View {
        let digits1 = digitArray(from: problem.number1)
        let digits2 = digitArray(from: problem.number2)
        let answerDigits = digitArray(from: problem.correctAnswer)

        // 乘法的對齊方式不同：操作數按自己的長度對齊，答案另外對齊
        // 加法和減法：所有數字都對齊到最長的長度
        let maxLength: Int
        if problem.type == .multiplication {
            maxLength = max(digits1.count, digits2.count)
        } else {
            maxLength = max(digits1.count, digits2.count, answerDigits.count)
        }

        // Debug logging
        let _ = logger.info("Problem: \(problem.number1) \(problem.type.symbol) \(problem.number2) = \(problem.correctAnswer)")
        let _ = logger.info("Digits1: \(digits1.description), Digits2: \(digits2.description), Answer: \(answerDigits.description)")
        let _ = logger.info("Blanks: \(problem.blanks.map { "(\($0.rowName), idx:\($0.digitIndex), digit:\($0.correctDigit))" }.joined(separator: ", "))")

        return VStack(alignment: .trailing, spacing: 10) {
            // 將數字轉換為陣列以便處理每一位

            // 第一列: 第一個數字
            HStack(spacing: 15) {
                let padding1 = maxLength - digits1.count
                ForEach(0..<maxLength, id: \.self) { index in
                    if index < padding1 {
                        Text("")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .frame(width: 60, height: 70)
                    } else {
                        let digit1Index = index - padding1
                        DigitOrBlankView(
                            digit: digit1Index < digits1.count ? digits1[digit1Index] : nil,
                            blank: blankAt(row: 0, index: digit1Index),
                            userAnswer: userAnswer,
                            validationResult: validationResults,
                            showValidation: showValidation,
                            focusedBlankId: _focusedBlankId,
                            onAnswerChange: onAnswerChange
                        )
                    }
                }
            }

            // 運算符號和第二列: 第二個數字
            HStack(spacing: 15) {
                Text(problem.type.symbol)
                    .font(.system(size: 50, weight: .bold))
                    .frame(width: 60, height: 70)

                // 第二個數字需要右對齊，所以前面補空位
                let padding2 = maxLength - digits2.count
                ForEach(0..<maxLength, id: \.self) { index in
                    if index < padding2 {
                        // 前面補空位對齊
                        Text("")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .frame(width: 60, height: 70)
                    } else {
                        // 顯示第二個數字
                        let digit2Index = index - padding2
                        DigitOrBlankView(
                            digit: digit2Index < digits2.count ? digits2[digit2Index] : nil,
                            blank: blankAt(row: 1, index: digit2Index),
                            userAnswer: userAnswer,
                            validationResult: validationResults,
                            showValidation: showValidation,
                            focusedBlankId: _focusedBlankId,
                            onAnswerChange: onAnswerChange
                        )
                    }
                }
            }

            // 分隔線
            Divider()
                .frame(height: 3)
                .background(Color(uiColor: .label))
                .padding(.vertical, 5)

            // 答案列
            HStack(spacing: 15) {
                // 乘法：答案可能比操作數長，需要獨立對齊
                // 加減法：答案與操作數一起對齊
                let answerMaxLength = problem.type == .multiplication ? answerDigits.count : maxLength
                let answerPadding = answerMaxLength - answerDigits.count

                ForEach(0..<answerMaxLength, id: \.self) { index in
                    if index < answerPadding {
                        // 前面補空位對齊
                        Text("")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .frame(width: 60, height: 70)
                    } else {
                        // 顯示答案的數字
                        let answerIndex = index - answerPadding
                        DigitOrBlankView(
                            digit: answerIndex < answerDigits.count ? answerDigits[answerIndex] : nil,
                            blank: blankAt(row: 2, index: answerIndex),
                            userAnswer: userAnswer,
                            validationResult: validationResults,
                            showValidation: showValidation,
                            focusedBlankId: _focusedBlankId,
                            onAnswerChange: onAnswerChange
                        )
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
    
    // 輔助函數: 將數字轉換為位數陣列
    private func digitArray(from number: Int) -> [Int] {
        return String(number).compactMap { Int(String($0)) }
    }
    
    // 輔助函數: 找到特定位置的空格
    private func blankAt(row: Int, index: Int) -> BlankPosition? {
        return problem.blanks.first { $0.row == row && $0.digitIndex == index }
    }
}

// MARK: - 數字或空格元件
struct DigitOrBlankView: View {
    let digit: Int?
    let blank: BlankPosition?
    let userAnswer: UserAnswer?
    let validationResult: [UUID: Bool]
    let showValidation: Bool
    @FocusState var focusedBlankId: UUID?
    let onAnswerChange: (UUID, Int?) -> Void
    
    var body: some View {
        if let blank = blank {
            // 這是一個空格
            BlankInputView(
                blank: blank,
                userAnswer: userAnswer,
                isCorrect: validationResult[blank.id],
                showValidation: showValidation,
                focusedBlankId: _focusedBlankId,
                onAnswerChange: onAnswerChange
            )
        } else if let digit = digit {
            // 這是一個固定數字
            Text("\(digit)")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .frame(width: 60, height: 70)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                )
        } else {
            // 空位(用於對齊)
            Text("")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .frame(width: 60, height: 70)
        }
    }
}
