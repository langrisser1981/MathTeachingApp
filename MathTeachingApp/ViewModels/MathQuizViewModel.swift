//
//  MathQuizViewModel.swift
//  MathTeachingApp
//
//  Created by langrisser1981
//

import Foundation
import Combine

class MathQuizViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var settings = QuizSettings()
    @Published var problems: [MathProblem] = []
    @Published var currentProblemIndex = 0
    @Published var userAnswers: [UUID: UserAnswer] = [:]
    @Published var showValidation = false
    @Published var quizResults: [QuizResult] = []
    @Published var isQuizCompleted = false
    
    // MARK: - Computed Properties
    var currentProblem: MathProblem? {
        guard currentProblemIndex < problems.count else { return nil }
        return problems[currentProblemIndex]
    }
    
    var currentUserAnswer: UserAnswer? {
        guard let problem = currentProblem else { return nil }
        return userAnswers[problem.id]
    }
    
    var progress: Double {
        guard !problems.isEmpty else { return 0 }
        return Double(currentProblemIndex + 1) / Double(problems.count)
    }
    
    var totalCorrect: Int {
        quizResults.filter { $0.isAllCorrect }.count
    }
    
    var totalIncorrect: Int {
        quizResults.count - totalCorrect
    }
    
    // MARK: - 初始化測驗
    func startQuiz() {
        problems = []
        userAnswers = [:]
        quizResults = []
        currentProblemIndex = 0
        isQuizCompleted = false
        showValidation = false
        
        // 生成題目
        generateProblems()
    }
    
    private func generateProblems() {
        guard !settings.selectedTypes.isEmpty else { return }

        let types = Array(settings.selectedTypes)

        if settings.isMixedOrder {
            // 混合模式：隨機混合題型
            for _ in 0..<settings.numberOfProblems {
                let type = types.randomElement()!
                let problem = generateProblem(ofType: type)
                problems.append(problem)

                userAnswers[problem.id] = UserAnswer(
                    problemId: problem.id,
                    answers: [:]
                )
            }
        } else {
            // 依序模式：平均分配題型
            let problemsPerType = settings.numberOfProblems / types.count
            let remainder = settings.numberOfProblems % types.count

            for (index, type) in types.enumerated() {
                let count = problemsPerType + (index < remainder ? 1 : 0)

                for _ in 0..<count {
                    let problem = generateProblem(ofType: type)
                    problems.append(problem)

                    userAnswers[problem.id] = UserAnswer(
                        problemId: problem.id,
                        answers: [:]
                    )
                }
            }
        }
    }

    private func generateProblem(ofType type: ProblemType) -> MathProblem {
        let num1: Int
        let num2: Int

        switch type {
        case .addition:
            // 加法：兩個數字相加不超過最大值
            num1 = Int.random(in: settings.minNumber...settings.maxNumber)
            let maxNum2 = min(settings.maxNumber - num1, settings.maxNumber)
            num2 = Int.random(in: settings.minNumber...max(settings.minNumber, maxNum2))

        case .subtraction:
            // 減法：確保減數小於被減數
            num1 = Int.random(in: settings.minNumber...settings.maxNumber)
            num2 = Int.random(in: settings.minNumber...min(num1, settings.maxNumber))

        case .multiplication:
            // 乘法：使用較小的數字範圍
            let minFactor = max(2, settings.minNumber / 1000)
            let maxFactor = min(99, settings.maxNumber / 100)
            num1 = Int.random(in: minFactor...maxFactor)
            num2 = Int.random(in: minFactor...maxFactor)
        }

        return MathProblem(
            type: type,
            number1: num1,
            number2: num2,
            allowMultipleBlanksPerColumn: settings.allowMultipleBlanksPerColumn,
            blankCount: settings.difficulty.blankCount
        )
    }
    
    // MARK: - 答題相關
    func updateAnswer(for blankId: UUID, digit: Int?) {
        guard let problem = currentProblem else { return }
        
        if var answer = userAnswers[problem.id] {
            if let digit = digit {
                answer.answers[blankId] = digit
            } else {
                answer.answers.removeValue(forKey: blankId)
            }
            userAnswers[problem.id] = answer
        }
        
        // 清除驗證狀態
        showValidation = false
    }
    
    func validateCurrentAnswer() -> [UUID: Bool] {
        guard let problem = currentProblem,
              let userAnswer = userAnswers[problem.id] else {
            return [:]
        }
        
        var validationResults: [UUID: Bool] = [:]
        
        for blank in problem.blanks {
            if let userDigit = userAnswer.answers[blank.id] {
                validationResults[blank.id] = (userDigit == blank.correctDigit)
            } else {
                validationResults[blank.id] = false
            }
        }
        
        showValidation = true
        return validationResults
    }
    
    func checkAllBlanksAnswered() -> Bool {
        guard let problem = currentProblem,
              let userAnswer = userAnswers[problem.id] else {
            return false
        }
        
        return userAnswer.answers.count == problem.blanks.count
    }
    
    // MARK: - 導航
    func moveToNextProblem() {
        // 儲存當前結果
        saveCurrentResult()
        
        if currentProblemIndex < problems.count - 1 {
            currentProblemIndex += 1
            showValidation = false
        } else {
            // 測驗完成
            isQuizCompleted = true
        }
    }
    
    func moveToProblem(at index: Int) {
        guard index >= 0 && index < problems.count else { return }
        currentProblemIndex = index
        showValidation = false
    }
    
    private func saveCurrentResult() {
        guard let problem = currentProblem,
              let userAnswer = userAnswers[problem.id] else {
            return
        }
        
        var correctCount = 0
        for blank in problem.blanks {
            if let userDigit = userAnswer.answers[blank.id],
               userDigit == blank.correctDigit {
                correctCount += 1
            }
        }
        
        let result = QuizResult(
            id: UUID(),
            problemId: problem.id,
            userAnswer: userAnswer,
            problem: problem,
            correctCount: correctCount,
            totalBlanks: problem.blanks.count,
            isAllCorrect: correctCount == problem.blanks.count,
            answeredAt: Date()
        )
        
        // 更新或新增結果
        if let index = quizResults.firstIndex(where: { $0.problemId == problem.id }) {
            quizResults[index] = result
        } else {
            quizResults.append(result)
        }
    }
    
    // MARK: - 重置測驗
    func resetQuiz() {
        problems = []
        userAnswers = [:]
        quizResults = []
        currentProblemIndex = 0
        isQuizCompleted = false
        showValidation = false
    }
}
