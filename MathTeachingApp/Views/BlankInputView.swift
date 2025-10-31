//
//  BlankInputView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI
import os.log

private let logger = Logger(subsystem: "com.lenny.MathTeachingApp", category: "BlankInput")

struct BlankInputView: View {
    let blank: BlankPosition
    let userAnswer: UserAnswer?
    let isCorrect: Bool?
    let showValidation: Bool
    @FocusState var focusedBlankId: UUID?
    let onAnswerChange: (UUID, Int?) -> Void
    
    @State private var text: String = ""

    var body: some View {
        ZStack {
            // 背景顏色 - 根據驗證結果
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)

            // 邊框
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 3)

            // 輸入框
            TextField("", text: $text)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($focusedBlankId, equals: blank.id)
                .tint(.clear)  // 隱藏游標
                .onChange(of: text) { newValue in
                    logger.info("═══ TEXT CHANGED ═══")
                    logger.info("BlankID: \(blank.id)")
                    logger.info("New text value: '\(newValue)'")

                    // 過濾只保留數字
                    let filtered = newValue.filter { $0.isNumber }
                    logger.info("After filtering: '\(filtered)'")

                    if !filtered.isEmpty {
                        // 只保留最後一個數字
                        let lastDigit = String(filtered.last!)
                        logger.info("Selected digit: '\(lastDigit)'")

                        // 如果過濾後的結果與當前文字不同，更新它
                        if text != lastDigit {
                            logger.info("Updating text to: '\(lastDigit)'")
                            text = lastDigit
                        }

                        // 更新答案
                        if let digit = Int(lastDigit) {
                            logger.info("Calling onAnswerChange with: \(digit)")
                            onAnswerChange(blank.id, digit)
                        }

                        // 收起鍵盤
                        logger.info("Dismissing keyboard")
                        focusedBlankId = nil
                    } else if newValue.isEmpty {
                        // 清空
                        logger.info("Clearing")
                        onAnswerChange(blank.id, nil)
                    }
                    logger.info("═══ END ═══")
                }
                .onChange(of: focusedBlankId) { newFocusedId in
                    let isFocused = (newFocusedId == blank.id)
                    logger.info("FOCUS CHANGED - BlankID: \(blank.id), Is focused: \(isFocused), Current text: '\(text)'")

                    // 當獲得焦點時，清空文字欄位，以便接收新的輸入
                    if isFocused {
                        logger.info("Got focus - clearing text to accept new input")
                        text = ""
                    }
                }
            
            // 正確答案提示(驗證後且錯誤時顯示)
            if showValidation, let isCorrect = isCorrect, !isCorrect {
                VStack {
                    Spacer()
                    Text("\(blank.correctDigit)")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(4)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(5)
                }
            }
            
            // 驗證圖示
            if showValidation, let isCorrect = isCorrect {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? .green : .red)
                            .font(.title3)
                    }
                    Spacer()
                }
                .padding(5)
            }
        }
        .frame(width: 60, height: 70)
        .onAppear {
            // 載入已有的答案
            if let answer = userAnswer?.answers[blank.id] {
                text = "\(answer)"
            } else {
                text = ""
            }
        }
        .onChange(of: blank.id) { _ in
            // 當空格ID改變時（新題目），重新載入答案
            if let answer = userAnswer?.answers[blank.id] {
                text = "\(answer)"
            } else {
                text = ""
            }
        }
        .onChange(of: userAnswer?.answers[blank.id]) { newAnswer in
            // 當答案改變時（但不是由本元件觸發的），同步更新text
            if let answer = newAnswer {
                if text != "\(answer)" {
                    text = "\(answer)"
                }
            } else if !text.isEmpty {
                text = ""
            }
        }
    }
    
    private var backgroundColor: Color {
        if showValidation, let isCorrect = isCorrect {
            return isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2)
        }
        return Color.yellow.opacity(0.2)
    }
    
    private var borderColor: Color {
        if showValidation, let isCorrect = isCorrect {
            return isCorrect ? Color.green : Color.red
        }
        if focusedBlankId == blank.id {
            return Color.blue
        }
        return Color.orange
    }
}
