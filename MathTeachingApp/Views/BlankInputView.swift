//
//  BlankInputView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI

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
                    // 只允許輸入0-9的單一數字
                    let filtered = newValue.filter { $0.isNumber }

                    // 如果輸入新數字，取代原有數字（只保留最後一個字元）
                    if filtered.count > 1 {
                        text = String(filtered.suffix(1))
                    } else {
                        text = filtered
                    }

                    // 更新答案
                    if let digit = Int(text) {
                        onAnswerChange(blank.id, digit)
                        // 輸入完成後自動收起鍵盤
                        focusedBlankId = nil
                    } else {
                        onAnswerChange(blank.id, nil)
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
