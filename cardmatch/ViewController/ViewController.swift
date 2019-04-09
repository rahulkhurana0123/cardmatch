//
//  ViewController.swift
//  cardmatch
//
//  Created by Rahul khurana on 03/01/19.
//  Copyright © 2019 Rahul khurana. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var cardModel = CardModel()
    var cardArray = [Card]()
    var firstIndexFlippedPathIndex:IndexPath?
    
    var timer : Timer?
    
    var milliSeconds :  Float = 60000
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardArray = cardModel.getCard()
        
        cardArray.shuffle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        SoundManager.playSound(.shuffle)
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add( timer!, forMode: RunLoop.Mode.common )
    }
    
    @objc func timeElapsed() {
        
        if(milliSeconds == 0)
        {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            checkGameEnded()
            return
        }
        milliSeconds -= 1
        
        
        let seconds = String(format: "%.2f", milliSeconds/1000)
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
    }
    func checkGameEnded()
    {
        
        var isWon = true;
        
        var title = ""
        var message = ""
        
        for  card in cardArray {
            
            if card.isMatched {
                isWon = true
                
            }
            else {
                isWon = false;
                break
            }
            
            
        }
        
        if isWon {
            if milliSeconds > 0
            {
                timer?.invalidate()
                
                title = "Congratulations"
                message = "You Won..!!!"
                showAlert(title, message)
                
            }
        }
        else{
            if milliSeconds > 0
            {
                return
            }
            else{
                title = "Oops"
                message = "Time Over."
                showAlert(title, message)
            }
        }
        
        
        
        
    }
    
    func showAlert(_ title : String, _ msg: String )
    {
        let alertController   = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if milliSeconds <= 0
        {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        
        let card = cardArray[indexPath.row]
        if card.isFlipped == false && card.isMatched == false {
            card.isFlipped = true
            cell.flipCard()
            SoundManager.playSound(.flip)
            if firstIndexFlippedPathIndex == nil {
                firstIndexFlippedPathIndex = indexPath
            }
            else{
                checkForMatchs(indexPath)
            }
        }
        
        
        
    }
    func checkForMatchs(_ secondFlippedCardIndexIndexPath :IndexPath) {
        
        
        let fistIndexCell = collectionView.cellForItem(at: firstIndexFlippedPathIndex!) as? CardCollectionViewCell
        
        let secondIndexCell = collectionView.cellForItem(at: secondFlippedCardIndexIndexPath) as? CardCollectionViewCell
        
        let firstFliipedIndexCard  = cardArray[firstIndexFlippedPathIndex!.row]
        let secondFlippedIndexCard = cardArray[secondFlippedCardIndexIndexPath.row]
        
        if firstFliipedIndexCard.imageName == secondFlippedIndexCard.imageName
        {
            firstFliipedIndexCard.isMatched = true
            secondFlippedIndexCard.isMatched = true
            fistIndexCell?.remove()
            secondIndexCell?.remove()
            SoundManager.playSound(.match)
            checkGameEnded()
        }
        else{
            fistIndexCell?.flipback()
            secondIndexCell?.flipback()
            firstFliipedIndexCard.isFlipped = false
            secondFlippedIndexCard.isFlipped = false;
            SoundManager.playSound(.noMatch)
            
        }
        if fistIndexCell == nil {
            collectionView.reloadItems(at: [firstIndexFlippedPathIndex!])
        }
        firstIndexFlippedPathIndex = nil
    }
    
}

