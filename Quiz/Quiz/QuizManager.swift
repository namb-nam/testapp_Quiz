//
//  QuizManager.swift
//  Quiz
//
//  Created by TakahiroNANBU on 2020/08/16.
//  Copyright © 2020 wings. All rights reserved.
//

import UIKit

class QuizManager {
    var quizzes: [Quiz]
    var currentIndex: Int
    var score: Int
    
    enum Status {
        case inAnswer
        case done
    }
    var status: Status
    
    init() {
        quizzes = []
        //問題文・正解・画像名で問題を作成
        quizzes.append(Quiz(text: "猫は人間をでかい猫だと思ってる？", correctAnswer: true, imageName: "cat"))
        quizzes.append(Quiz(text: "犬は食べ物のうまさを匂いで判断してる？", correctAnswer: true, imageName: "dog"))
        quizzes.append(Quiz(text: "虎の縞模様は皮膚までつながってない？", correctAnswer: false, imageName: ",tiger"))
        quizzes.append(Quiz(text: "熊は走る時全部の足がバラバラに動いている？", correctAnswer: true, imageName: "bear"))
        quizzes.append(Quiz(text: "パンダの好物は笹？", correctAnswer: true, imageName: "panda"))
        
        currentIndex = 0
        score = 0
        status = .inAnswer
        
    }
    
    var currentQuiz: Quiz {
        get {
            return self.quizzes[currentIndex]
        }
    }
    
    func answerQuiz(answer: Bool) {
        if (self.currentQuiz.correctAnswer == answer) {
            score += 1
        }
    }
    
    func nextQuiz() {
        if currentIndex < quizzes.count - 1 {
            currentIndex += 1
        } else {
            status = .done
        }
    }

}
