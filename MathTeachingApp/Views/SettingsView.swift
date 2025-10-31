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
                Section(header: Text("題型選擇"), footer: Text("至少選擇一種題型")) {
                    ForEach(ProblemType.allCases, id: \.self) { type in
                        Toggle(type.rawValue, isOn: Binding(
                            get: { viewModel.settings.selectedTypes.contains(type) },
                            set: { isSelected in
                                if isSelected {
                                    viewModel.settings.selectedTypes.insert(type)
                                } else {
                                    viewModel.settings.selectedTypes.remove(type)
                                }
                            }
                        ))
                    }

                    if viewModel.settings.selectedTypes.count > 1 {
                        Toggle("混合出題", isOn: $viewModel.settings.isMixedOrder)
                            .help(viewModel.settings.isMixedOrder ? "題型隨機混合" : "依序完成各題型")
                    }
                }

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

                Section(header: Text("進階選項"), footer: Text("開啟後，同一位數可能出現多個空格，需根據整體算式判斷答案")) {
                    Toggle("允許進階題型", isOn: $viewModel.settings.allowMultipleBlanksPerColumn)
                }
                
                Section {
                    Button(action: {
                        guard !viewModel.settings.selectedTypes.isEmpty else { return }
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
                    .listRowBackground(viewModel.settings.selectedTypes.isEmpty ? Color.gray : Color.blue)
                    .disabled(viewModel.settings.selectedTypes.isEmpty)
                }
            }
            .navigationTitle("數學練習")
            .fullScreenCover(isPresented: $showQuiz) {
                QuizView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    SettingsView()
}
