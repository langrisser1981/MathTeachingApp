//
//  SubtractionProblemView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI

struct SubtractionProblemView: View {
    let problem: MathProblem
    let userAnswer: UserAnswer?
    let validationResults: [UUID: Bool]
    let showValidation: Bool
    @FocusState var focusedBlankId: UUID?
    let onAnswerChange: (UUID, Int?) -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            // 將數字轉換為陣列以便處理每一位
            let digits1 = digitArray(from: problem.number1)
            let digits2 = digitArray(from: problem.number2)
            let answerDigits = digitArray(from: problem.correctAnswer)
            
            // 確保所有行都有相同的位數
            let maxLength = max(digits1.count, digits2.count, answerDigits.count)
            
            // 第一列: 被減數
            HStack(spacing: 15) {
                ForEach(0..<maxLength, id: \.self) { index in
                    DigitOrBlankView(
                        digit: index < digits1.count ? digits1[index] : nil,
                        blank: blankAt(row: 0, index: index),
                        userAnswer: userAnswer,
                        validationResult: validationResults,
                        showValidation: showValidation,
                        focusedBlankId: _focusedBlankId,
                        onAnswerChange: onAnswerChange
                    )
                }
            }
            
            // 減號和第二列: 減數
            HStack(spacing: 15) {
                Text("-")
                    .font(.system(size: 50, weight: .bold))
                    .frame(width: 60, height: 70)
                
                ForEach(0..<maxLength-1, id: \.self) { index in
                    DigitOrBlankView(
                        digit: index < digits2.count ? digits2[index] : nil,
                        blank: blankAt(row: 1, index: index),
                        userAnswer: userAnswer,
                        validationResult: validationResults,
                        showValidation: showValidation,
                        focusedBlankId: _focusedBlankId,
                        onAnswerChange: onAnswerChange
                    )
                }
            }
            
            // 分隔線
            Divider()
                .frame(height: 3)
                .background(Color(uiColor: .label))
                .padding(.vertical, 5)
            
            // 答案列
            HStack(spacing: 15) {
                ForEach(0..<maxLength, id: \.self) { index in
                    DigitOrBlankView(
                        digit: index < answerDigits.count ? answerDigits[index] : nil,
                        blank: blankAt(row: 2, index: index),
                        userAnswer: userAnswer,
                        validationResult: validationResults,
                        showValidation: showValidation,
                        focusedBlankId: _focusedBlankId,
                        onAnswerChange: onAnswerChange
                    )
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
