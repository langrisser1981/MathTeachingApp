//
//  QuizView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: MathQuizViewModel
    @Environment(\.dismiss) var dismiss
    @State private var validationResults: [UUID: Bool] = [:]
    @FocusState private var focusedBlankId: UUID?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 進度條
                ProgressBar(progress: viewModel.progress)
                    .frame(height: 4)
                
                // 題目顯示
                if let problem = viewModel.currentProblem {
                    ScrollView {
                        VStack(spacing: 30) {
                            // 標題
                            HStack {
                                Text("第 \(viewModel.currentProblemIndex + 1) 題")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                                Text("共 \(viewModel.problems.count) 題")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            
                            // 減法算式
                            SubtractionProblemView(
                                problem: problem,
                                userAnswer: viewModel.currentUserAnswer,
                                validationResults: validationResults,
                                showValidation: viewModel.showValidation,
                                focusedBlankId: _focusedBlankId,
                                onAnswerChange: { blankId, digit in
                                    viewModel.updateAnswer(for: blankId, digit: digit)
                                }
                            )
                            .padding()
                            
                            // 操作按鈕
                            VStack(spacing: 15) {
                                // 驗證按鈕
                                Button(action: {
                                    if viewModel.checkAllBlanksAnswered() {
                                        validationResults = viewModel.validateCurrentAnswer()
                                        focusedBlankId = nil  // 收起鍵盤
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("驗證答案")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        viewModel.checkAllBlanksAnswered() ? 
                                        Color.blue : Color.gray.opacity(0.3)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .disabled(!viewModel.checkAllBlanksAnswered())
                                
                                // 下一題按鈕
                                if viewModel.showValidation {
                                    Button(action: {
                                        viewModel.moveToNextProblem()
                                        validationResults = [:]
                                    }) {
                                        HStack {
                                            Text(viewModel.currentProblemIndex < viewModel.problems.count - 1 ? 
                                                 "下一題" : "完成測驗")
                                                .font(.headline)
                                            Image(systemName: "arrow.right.circle.fill")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("結束") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isQuizCompleted) {
                ResultsView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - 進度條
struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress)
            }
        }
    }
}
