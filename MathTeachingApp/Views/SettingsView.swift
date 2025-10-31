//
//  SettingsView.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = MathQuizViewModel()
    @State private var showQuiz = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("測驗設定")) {
                    Stepper("題目數量: \(viewModel.settings.numberOfProblems)", 
                           value: $viewModel.settings.numberOfProblems, 
                           in: 1...20)
                    
                    Picker("難度", selection: $viewModel.settings.difficulty) {
                        ForEach(QuizSettings.Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("數字範圍")) {
                    HStack {
                        Text("最小值")
                        Spacer()
                        TextField("1000", value: $viewModel.settings.minNumber, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Text("最大值")
                        Spacer()
                        TextField("9999", value: $viewModel.settings.maxNumber, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.startQuiz()
                        showQuiz = true
                    }) {
                        HStack {
                            Spacer()
                            Text("開始測驗")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .navigationTitle("數學練習 - 減法")
            .fullScreenCover(isPresented: $showQuiz) {
                QuizView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    SettingsView()
}
