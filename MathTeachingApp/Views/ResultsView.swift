//
//  ResultsView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI

struct ResultsView: View {
    @ObservedObject var viewModel: MathQuizViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 總體成績
                    VStack(spacing: 15) {
                        Image(systemName: viewModel.totalCorrect == viewModel.problems.count ? 
                              "star.fill" : "chart.bar.fill")
                            .font(.system(size: 60))
                            .foregroundColor(viewModel.totalCorrect == viewModel.problems.count ? 
                                           .yellow : .blue)
                        
                        Text("測驗完成!")
                            .font(.title)
                            .bold()
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("\(viewModel.totalCorrect)")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.green)
                                Text("答對")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                Text("\(viewModel.totalIncorrect)")
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.red)
                                Text("答錯")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("正確率: \(String(format: "%.1f", Double(viewModel.totalCorrect) / Double(viewModel.problems.count) * 100))%")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    
                    // 題目列表
                    VStack(alignment: .leading, spacing: 10) {
                        Text("題目列表")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ForEach(Array(viewModel.quizResults.enumerated()), id: \.element.id) { index, result in
                            ResultRowView(
                                questionNumber: index + 1,
                                result: result,
                                onTap: {
                                    viewModel.moveToProblem(at: index)
                                    dismiss()
                                }
                            )
                        }
                    }
                    
                    // 操作按鈕
                    VStack(spacing: 15) {
                        Button(action: {
                            viewModel.startQuiz()
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("重新測驗")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "house.fill")
                                Text("回到首頁")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("測驗結果")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - 結果列表項目
struct ResultRowView: View {
    let questionNumber: Int
    let result: QuizResult
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // 題號
                Text("第\(questionNumber)題")
                    .font(.headline)
                    .frame(width: 80, alignment: .leading)
                
                // 算式預覽
                Text("\(result.problem.number1) - \(result.problem.number2) = \(result.problem.correctAnswer)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // 成績
                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: result.isAllCorrect ? 
                          "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(result.isAllCorrect ? .green : .red)
                        .font(.title2)
                    
                    Text("\(result.correctCount)/\(result.totalBlanks)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}
