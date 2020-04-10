//
//  ViewController.swift
//  clickToLive
//
//  Created by Brian Seaver on 3/17/20.
//  Copyright © 2020 clc.seaver. All rights reserved.
//

import UIKit
import AVFoundation

enum Category{
    
}

struct Scenario{
    var description: String
    var goodEffect: String
    var badEffect: String
    var goodAmount: Float
    var badAmount: Float
    var probability : Float
    var yes: String
    var yesYes: String
    var no: String
    
    
    
    
}

class ViewController: UIViewController, UINavigationControllerDelegate {
    var first = true
    var totPercent:CGFloat = 0.0
    var percent: CGFloat = 0.0
    var height: CGFloat = 0.0

    
    @IBOutlet weak var levelOutlet: UILabel!
    var level = 1
    var highestLevel = 1
    var min : Float = 0.5
    
    var doubleClick : CGFloat = 1.0
    var nationHealthDecrease : CGFloat = 0.0
    var happinessIncrease : CGFloat = 0.0
    var rationIncrease : CGFloat = 0.0
    
    var sound : AVAudioPlayer?
    
    var foodAlerts: [UIAlertController] = []
    
    var notLoaded = true
    var checkwinNum = 0
    
    var timer : Timer?
    var flashTimer : Timer?
    
    var foodGroupPercents: [FoodGroup: Float] = [:]
    
    @IBOutlet weak var nationPercentOutlet: UILabel!
    @IBOutlet weak var graphView: UIView!
    var path = UIBezierPath()
    var dotPath = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    let dotLayer = CAShapeLayer()
    var x: CGFloat = 0.0
    var y : CGFloat = 1000.0
    //var yrate: CGFloat = 0.2
    //var ychangeMult: CGFloat = 1.005
    var nationHealthRate : CGFloat = 1.0
    var nationHealthRateAdd : CGFloat = 0.05
    
    @IBOutlet weak var hospitalCapacityOutlet: UILabel!
    
    @IBOutlet weak var growthRateOutlet: UILabel!
    
    @IBOutlet weak var nextDayOutlet: UIButton!
    @IBOutlet weak var storeOutlet: UIButton!
    var day = 0
    @IBOutlet weak var dayLabel: UILabel!
    
    var money :Int =  0
    @IBOutlet weak var moneyLabel: UILabel!
    
    var hoursPassed = 0
    @IBOutlet weak var hoursPassedLabel: UILabel!
    
    @IBOutlet weak var coronaButton: UIButton!
    
    
    @IBOutlet weak var familyHealthOutlet: UIStackView!// not needed?
   
    @IBOutlet weak var foodPercentLabel: UILabel!
    @IBOutlet weak var foodChangeLabelOutlet: UILabel!
    @IBOutlet weak var familyPercentLabel: UILabel!
    @IBOutlet weak var familyChangeLabelOutlet: UILabel!
    @IBOutlet weak var nationPercentLabel: UILabel!
    @IBOutlet weak var nationChangeLabelOutlet: UILabel!
    @IBOutlet weak var happinessPercentLabel: UILabel!
    @IBOutlet weak var happinessChangeLabelOutlet: UILabel!
    @IBOutlet weak var tpPercentLabel: UILabel!
    @IBOutlet weak var tpChangeLabelOutlet: UILabel!
    
    
    
    var familyHealthAdd : Float = 0.001
    var nationHealthAdd : Float = 0.0001
    var foodAdd : Float = 0.005
    var happinessAdd: Float = 0.000
    var toiletPaperAdd: Float = 0.004
    
    
    var dailyFood : Float =  0.0
    var foodChange : Float = 0.0
    var dailyFamily : Float =  0.0
    var familyChange : Float = 0.0
    var dailyNation : Float = 0.0
    var nationChange : Float = 0.0
    var dailyHappiness : Float =  0.0
    var happyChange : Float = 0.0
    var dailyTp : Float =  0.0
    var tpChange : Float = 0.0
    
    @IBOutlet weak var healthProgressOutlet: UIProgressView!
    @IBOutlet weak var NationHealthProgressOutlet: UIProgressView!
    @IBOutlet weak var foodProgressOutlet: UIProgressView!
    @IBOutlet weak var happinessProgressOutlet: UIProgressView!
    @IBOutlet weak var tpProgressOutlet: UIProgressView!
    
    
    
    
    
    var scenarios : [Scenario] = []
    
//    override func viewWillAppear(_ animated: Bool) {
//        storeOutlet.isEnabled = true
//        nextDayOutlet.isEnabled = true
//    }
    
    func buildScenarios()
    {
        scenarios = [
            Scenario(description: "One of your kids is sick.  Go to the Doctor?", goodEffect: "Family Health", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.99, yes: "Your family health has improved!", yesYes: "However, you got others sick when you went to the doctor. Nation Health will suffer...", no: "Your family health will suffer...  However, you didn't spread your virus so you helped the nation growth rate!"),
            Scenario(description: "Grandma and Grandpa invite you over to play cards. Should you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.10, probability: 0.80, yes: "You increased your happiness by playing cards!", yesYes: "However, you were carrying the virus and got Grandma and Grandpa sick. They are now going to use hospital beds and the Nation Health will suffer...", no:  "Not playing cards has hurt your happiness...  However, you didn't get your Grandma and Grandpa sick so the nation growth rate has decreased!"),
            Scenario(description: "Your friends invite you to play beach volleyball.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.10, probability: 0.50, yes: "You increased your happiness by going to the park!", yesYes: "However, the corona virus spread amoung your friends so the nation health will suffer...", no:  "Not playing volleyball has hurt your happiness...  However, you didn't spread the virus so the Nation Growth rate has decreased!"),
                  Scenario(description: "It's St. Patrick's Day!  Your friends are celebrating at the Park.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.20, probability: 0.70, yes: "You increased your happiness by going to the park!", yesYes: "However, you contracted the corona virus at the park and spread it to many others.  The nation health will suffer...", no:  "Not going to the park has hurt your happiness...  However, you didn't contribute in spreading the virus, so the nation growth rate has decreased!"),
                        Scenario(description: "You won free tickets to Italy!  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.20, probability: 0.95, yes: "You increased your happiness by going to Italy!", yesYes: "However, you contracted the virus and have spread it to many people.  Nation health will suffer...", no:  "Not going to Italy has hurt your happiness...  However, you didn't contribute to the spread of the virius.  Nation growth rate will decrease!"),
                                 Scenario(description: "Your friend just called you a wimp for staying quarantined.  You have a desire to go TP their house.  Do you go?", goodEffect: "Happiness", badEffect: "Toilet Paper", goodAmount: 0.1, badAmount: 0.1, probability: 1.0, yes: "You increased your happiness by TP-ing your friends house!", yesYes: "However,  you lost a bunch of toilet paper.  Toilet Paper stock has suffered...", no:  "Not TP-ing your friends house has hurt your happiness...  However, you maintained your toilet paper stock!"),
                                          Scenario(description: "The blood bank needs blood.  Do you go give blood?", goodEffect: "Nation Health", badEffect: "Family Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.1, yes: "You improved the nation health by giving blood", yesYes: "However, you somehow contracted the virus.  Family health will suffer...", no:  "Not giving blood has hurt the nation's health... However, you kept your family from the virus.  Family health has improved!"),
                                                   Scenario(description: "A local food shelter needs volunteers to help hand out food.  Do you go?", goodEffect: "Nation Health", badEffect: "Family Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.2, yes: "You improved the Nation Health by volunteering at the food shelter!", yesYes: "However, you somehow contracted the virus.  Family health will suffer...", no:  "Not helping out at the shelter has hurt the nation's health...  However, you kept your family from the virus.  Family health has improved!"),
                                                             Scenario(description: "You have plans to fly to Florida for spring break.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.2, badAmount: 0.15, probability: 0.7, yes: "You increased your happiness by going on Spring Break!", yesYes: "However, you contracted the virus and have spread it to many people.  Nation health will suffer...", no:  "Not going on spring break has hurt your happiness...  However, you helped not spread the virus.  Nation Health has improved!"),
                                                                      Scenario(description: "You really only get a good workout at the gym.  Do you go?", goodEffect: "Family Health", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.5, yes: "You increased your family health by getting a good workout in! ", yesYes: "However, you were an asymptomatic carrier of the virus and spread it to many others.  Nation health will suffer", no:  "Not going to the gym has hurt your family heath.  However, you also didn't contribute to spreading the virus.  Nation growth rate will decrease!"),
                                                                       Scenario(description: "You haven't seen your friends in a long time and they are going to meet at the park.  Do you go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.1, badAmount: 0.1, probability: 0.5, yes: "You increased your happiness by going to the park!  ", yesYes: "However, you were carrying the virus and got others sick.  Health of nation will suffer...", no:  "Not going to the park has hurt your happiness...  However, the virus does not have a chance to spread.  Nation growth rate will decrease!"),
                                                                       Scenario(description: "You are sick of being in the house with your family!  A neighbor is having a backyard party.  Do you go?", goodEffect: "Happiness", badEffect: "Family Health", goodAmount: 0.15, badAmount: 0.2, probability: 0.3, yes: "You increased your happiness by going to the party!", yesYes: "However, you contracted the virus.  Family health will suffer...", no:  "Not going shopping has hurt your happiness...  However, you have no chance of getting the virus, so your family health has improved!"),
                                                                       Scenario(description: "Someone shows up to your house asking for toilet paper.  Do you give them some (5%)?", goodEffect: "Nation Health", badEffect: "Toilet Paper", goodAmount: 0.02 , badAmount: 0.05, probability: 1.0, yes: "You increased the nation health by helping others!", yesYes: "However, you lost 5% of your toilet paper...", no:  "Not helping out has hurt the Nation Health...  However, your toilet paper is sustained!"),
                                                                       Scenario(description: "You have had plans to go to Mardi Gras for 6 months.  Do you still go?", goodEffect: "Happiness", badEffect: "Nation Health", goodAmount: 0.15 , badAmount: 0.20, probability: 0.9, yes: "You increased your happiness by going to Mardi Gras", yesYes: "However, you helped spread the virus.  Health of nation will suffer...", no:  "Not going to Mardi Gras has hurt your happiness.  However, you didn't contribute to spreading the virus.  Nation growth rate will decrease!"),

            
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        height = graphView.frame.height
        if first{
        randomStart()
        
            first = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        //totPercent = graphView.frame.size.height
        
       // print("viewcontroller load")
        buildScenarios()
        
        //flashTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        storeOutlet.setTitleColor(UIColor.systemGray, for: .disabled)
        nextDayOutlet.setTitleColor(UIColor.systemGray, for: .disabled)
        //print(hospitalCapacityOutlet.frame.origin.y)
        //y = totPercent * 0.02
       // print("y in vdl = \(y)")
        
        storeOutlet.layer.cornerRadius = 10
        nextDayOutlet.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       
        healthProgressOutlet.transform = healthProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
        foodProgressOutlet.transform = foodProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
      // NationHealthProgressOutlet.transform = NationHealthProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
       happinessProgressOutlet.transform = happinessProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
        tpProgressOutlet.transform = tpProgressOutlet.transform.scaledBy(x: 1, y: 4.0)
        print("graph view height in view did load \(graphView.frame.height)")
        //randomStart()
        //drawCurve()
         
        
       
        
        
        storeOutlet.isEnabled = false
       nextDayOutlet.isEnabled = true
        resetDailyTotals()
        
        coronaButton.isEnabled = false
        
        
   
            
        
        
        
        
    }
    
    func updateLevel(){
        levelOutlet.text = "Level: \(level)"
    }
    
    func updateCapacity(){
        percent = (graphView.frame.height - y) / (graphView.frame.height - hospitalCapacityOutlet.frame.origin.y)*100.0
        nationPercentOutlet.text = "Hospital Capacity \(Int(percent))%"
    }
    
    func playSound(file f : String){
        let path = Bundle.main.path(forResource: f, ofType:nil)!
           let url = URL(fileURLWithPath: path)

           do {
               sound =  try AVAudioPlayer(contentsOf: url)
               sound?.play()
           } catch {
               print("can't play sound")
           }
        if f == "tickingClock.wav"{
            sound?.numberOfLoops = -1
        }
    }
    
    
    
    func drawCurve(){
        path.move(to: CGPoint(x: x,y: y))
        x+=1
        print("y before calculation \(y)")
        y = height - (height - y)*(1.0 + 1.0*nationHealthRate/24.0)
        print("graphview height: \(height)")
        
    
        print("difference: \(height - y)")
          print("y in draw curve \(y)")
        path.addLine(to: CGPoint(x: x ,y: y))
        
            //ychange*=nationHealthMult
        
        //path.addQuadCurve(to: CGPoint(x: 200, y: 80), controlPoint: CGPoint(x: 200, y: 80))
        
           shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
           shapeLayer.lineWidth = 3.0

          //graphView.display(shapeLayer)
        graphView.layer.addSublayer(shapeLayer)
        
        growthRateOutlet.text = "Growth Rate \(Int(nationHealthRate*100))%"
        percent = (graphView.frame.height - y) / (graphView.frame.height - hospitalCapacityOutlet.frame.origin.y)*100.0
        nationPercentOutlet.text = "Hospital Capacity \(Int(percent))%"
        //print("nationHealthRate: \(nationHealthRate)")
        //print("Capacity: \(percent)")
        
    }
    
    func randomStart(){
        
        let alert = UIAlertController(title: "Level \(level)", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        doubleClick = 1
        dailyFood = 0.005
        rationIncrease = 0.0
        happinessIncrease = 0
        nationHealthDecrease = 0
        buildScenarios()
        shapeLayer.removeFromSuperlayer()
        dotLayer.removeFromSuperlayer()
        
       
        //print (y)
        //nationHealthMult = 1.3
        //nationHealthMultAdd = 0.1
        day = 0;
        money = 0;
        hoursPassed = 0;
        dayLabel.text = "Day: \(day)"
        moneyLabel.text = "$\(money)"
        hoursPassedLabel.text = "Hour: \(hoursPassed)"
        
        
        y = height - (height * (0.02 + CGFloat(level)/100.0))
        print("starting total height \(height)")
        print("Starting y value \(y)")
               x = 1.0
        
        nationHealthRate = CGFloat(0.5 + 0.1 * Float(level))
               path = UIBezierPath()
              // drawCurve()
        
        var minny = min - Float(level - 1) * 0.1
        if minny < 0.15 {
            minny = 0.15
        }
        let max = minny + 0.1
        tpProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        happinessProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        //NationHealthProgressOutlet.setProgress(Float.random(in: 0.25...0.6), animated: true)
         foodProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        healthProgressOutlet.setProgress(Float.random(in: minny...max), animated: true)
        timer?.invalidate()
        sound?.stop()
        resetDailyTotals()
        
        storeOutlet.isEnabled = false
        nextDayOutlet.isEnabled = true
        coronaButton.isEnabled = false
        
        let each = dailyFood/5.0
           foodGroupPercents = [FoodGroup.fruit: each, FoodGroup.vegetable: each, FoodGroup.grain: each, FoodGroup.protein: each, FoodGroup.dairy: each]
          // print(foodGroupPercents)
        
        drawCurve()
        updateAll()
    }
    
   func checkLose(){
    //checkwinNum+=1
    //print("\(checkwinNum)Checking for win")
    var loserMessage = "Something"
    if foodProgressOutlet.progress == 0{
        loserMessage = "You ran out of food"
    }
    else if healthProgressOutlet.progress == 0{
        loserMessage = "Your family health reached 0%"
    }
    else if happinessProgressOutlet.progress == 0{
        loserMessage = "Your happiness reached 0%"
    }
    else if tpProgressOutlet.progress == 0{
        loserMessage = "You ran out of toilet paper"
    }
    
        if foodProgressOutlet.progress == 0 ||  healthProgressOutlet.progress == 0 || happinessProgressOutlet.progress == 0 || tpProgressOutlet.progress == 0{
            timer?.invalidate()
            sound?.stop()
            let loseAlert = UIAlertController(title: "You Lose!", message: loserMessage, preferredStyle: .alert)
            loseAlert.view.backgroundColor = UIColor.red
            loseAlert.addAction(UIAlertAction(title: "play again", style: .default, handler: { (action) in
                self.randomStart()}))
            present(loseAlert, animated: true){
                self.timer?.invalidate()
                self.playSound(file: "bomb.wav")
            }
        }
    else if path.cgPath.currentPoint.y <= hospitalCapacityOutlet.frame.origin.y{
            timer?.invalidate()
            sound?.stop()
            let loseAlert = UIAlertController(title: "You Lose", message: "Nation Health has overwhelemed the hospitals!", preferredStyle: .alert)
            loseAlert.view.backgroundColor = UIColor.red
            loseAlert.addAction(UIAlertAction(title: "play again", style: .default, handler: { (action) in
                self.randomStart()}))
            present(loseAlert, animated: true){
                self.timer?.invalidate()
                self.playSound(file: "bomb.wav")
            }
        }
    }
    
    func displayScenario(){
        if scenarios.count > 0{
        var explanationAlert = UIAlertController()
        let choice = Int.random(in: 0 ... scenarios.count - 1)
        let scenario = scenarios[choice]
        let alert = UIAlertController(title: "\(scenario.goodEffect) Opportunity!" , message: scenario.description, preferredStyle: .alert)
       // alert.view.backgroundColor = UIColor.green
        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (action) in
            switch scenario.goodEffect{
            case "Family Health":
                self.healthProgressOutlet.progress += scenario.goodAmount
                self.familyPercentLabel.backgroundColor = UIColor.systemGreen
            case "Nation Health":
                //print("Nation Health better")
                self.nationHealthRate-=CGFloat(scenario.badAmount)
//                self.NationHealthProgressOutlet.progress += scenario.goodAmount
//                self.nationPercentLabel.backgroundColor = UIColor.systemGreen
                case "Food":
                self.foodProgressOutlet.progress += scenario.goodAmount
                self.foodPercentLabel.backgroundColor = UIColor.systemGreen
                case "Happiness":
                self.happinessProgressOutlet.progress += scenario.goodAmount
            self.happinessPercentLabel.backgroundColor = UIColor.systemGreen
                case "Toilet Paper":
                   print("no gain of toilet paper")
//                self.tpProgressOutlet.progress += scenario.goodAmount
//                self.tpPercentLabel.backgroundColor = UIColor.systemGreen
            default:
                print("No good effect?")
            }
                
            if Float.random(in: 0...1.0) < scenario.probability{
                explanationAlert = UIAlertController(title: "UH-OH!", message: "\(scenario.yes)  \(scenario.yesYes)" , preferredStyle: .alert)
                explanationAlert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: {(alert) in
                    self.checkLose()
                    
                }))
        
                self.present(explanationAlert, animated: true){
                    self.updateAll()
                    
                    self.playSound(file: "gasp.wav")
                }
                
                switch scenario.badEffect{
                case "Family Health":
                    self.healthProgressOutlet.progress -= scenario.badAmount
                      self.familyPercentLabel.backgroundColor = UIColor.systemRed
                case "Nation Health":
                    self.nationHealthRate+=CGFloat(scenario.badAmount)
                    //print("nation health suffer")
//                    self.NationHealthProgressOutlet.progress -= scenario.badAmount
//                      self.nationPercentLabel.backgroundColor = UIColor.systemRed
                    case "Food":
                    self.foodProgressOutlet.progress -= scenario.badAmount
                      self.foodPercentLabel.backgroundColor = UIColor.systemRed
                    case "Happiness":
                    self.happinessProgressOutlet.progress -= scenario.badAmount
                      self.happinessPercentLabel.backgroundColor = UIColor.systemRed
                    case "Toilet Paper":
                    self.tpProgressOutlet.progress -= scenario.badAmount
                      self.tpPercentLabel.backgroundColor = UIColor.systemRed
                default:
                    print("No good effect?")
            }
            }
            else{
                explanationAlert = UIAlertController(title: "It's all good!", message: "\(scenario.yes)" , preferredStyle: .alert)
                explanationAlert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(explanationAlert, animated: true){
                    self.playSound(file: "trumpet.wav")
                }
            }
            
                
            self.updateAll()
            //self.dismiss(animated: true, completion: nil)
            
            }))
        alert.addAction(UIAlertAction(title: "no", style: .cancel, handler: { (aleret) in
            switch scenario.goodEffect{
            case "Family Health":
                self.healthProgressOutlet.progress -= scenario.goodAmount
                self.familyPercentLabel.backgroundColor = UIColor.systemRed
            case "Nation Health":
                self.nationHealthRate+=CGFloat(scenario.goodAmount)
                //print("nation health suffer")
//                self.NationHealthProgressOutlet.progress -= scenario.goodAmount
//                self.nationPercentLabel.backgroundColor = UIColor.systemRed
                case "Food":
                self.foodProgressOutlet.progress -= scenario.goodAmount
                self.foodPercentLabel.backgroundColor = UIColor.systemRed
                case "Happiness":
                self.happinessProgressOutlet.progress -= scenario.goodAmount
                self.happinessPercentLabel.backgroundColor = UIColor.systemRed
                case "Toilet Paper":
                self.tpProgressOutlet.progress -= scenario.goodAmount
            self.tpPercentLabel.backgroundColor = UIColor.systemRed
                
            default:
                print("No good effect?")
            }
            switch scenario.badEffect{
                        case "Family Health":
                            self.healthProgressOutlet.progress += scenario.badAmount
                            self.familyPercentLabel.backgroundColor = UIColor.systemGreen
                        case "Nation Health":
                            self.nationHealthRate-=CGFloat(scenario.badAmount)
                            //print("nation health suffer")
            //                self.NationHealthProgressOutlet.progress -= scenario.goodAmount
            //                self.nationPercentLabel.backgroundColor = UIColor.systemRed
                            case "Food":
                            self.foodProgressOutlet.progress += scenario.badAmount
                            self.foodPercentLabel.backgroundColor = UIColor.systemGreen
                            case "Happiness":
                            self.happinessProgressOutlet.progress += scenario.badAmount
                            self.happinessPercentLabel.backgroundColor = UIColor.systemGreen
                            case "Toilet Paper":
                             print("no toilet paper increase or decrease")
                            //self.tpProgressOutlet.progress += scenario.badAmount
                        //self.tpPercentLabel.backgroundColor = UIColor.systemRed
                        default:
                            print("No good effect?")
                        }
            explanationAlert = UIAlertController(title: "Good and Bad", message: "\(scenario.no)" , preferredStyle: .alert)
            explanationAlert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (alert) in
                self.checkLose()
            }))
            self.present(explanationAlert, animated: true){
                self.playSound(file: "trumpet.wav")
            }
            self.updateAll()
        }))
           
       
            present(alert, animated: true) {
                self.playSound(file: "doorbell.wav")
            }
           
        
        scenarios.remove(at: choice)
        }
        }
   
    
    func resetDailyTotals(){
        dailyHappiness = happinessProgressOutlet.progress
        dailyFood = foodProgressOutlet.progress
        dailyFamily = healthProgressOutlet.progress
        //dailyNation = NationHealthProgressOutlet.progress
        dailyTp = tpProgressOutlet.progress
        familyPercentLabel.backgroundColor = UIColor.black
        //nationPercentLabel.backgroundColor = UIColor.black
        foodPercentLabel.backgroundColor = UIColor.black
        tpPercentLabel.backgroundColor = UIColor.black
        happinessPercentLabel.backgroundColor = UIColor.black
    }
    
    func updateAll(){
        
        updateLevel()
        foodUpdate()
        updateFamilyHealth()
        //nationHealthUpdate()
        happinessUpdate()
        tpUpdate()
      //  print("food progress \(foodProgressOutlet.progress)")
        //print("Happiness progress \(happinessProgressOutlet.progress)")
        //print("Health progress \(healthProgressOutlet.progress)")
        //print("TP progress \(tpProgressOutlet.progress)")
        
        updateMoney()
        growthRateOutlet.text = "Growth Rate: \(Int(nationHealthRate*100))%"
        checkLose()
        
        
    }

    @IBAction func clickAction(_ sender: UIButton) {
        money+=Int(1.0*doubleClick)
        updateMoney()
      
    }
    
    func createFoodGroupAlert(message m: String)->UIAlertController{
        let foodAlert = UIAlertController(title: "You ran out of \(m)", message: "Family Health will suffer 3%", preferredStyle: .alert)
       
        
        return foodAlert
    }
    
    func showErrors(){
        if let error = foodAlerts.first{
            error.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                       self.healthProgressOutlet.progress -= 0.03
                       self.updateAll()
                self.foodAlerts.remove(at: 0)
                self.showErrors()
                
                        
                   }))
            present(error, animated: true, completion: nil)
        }
        else{
            displayScenario()
            //print("no more errors")
        }
        
    }
    
    func updateFoodGroups(){
        
        
        foodGroupPercents.forEach({ (key, value) -> Void in
                   
                   foodGroupPercents[key]! -= foodAdd*24/5
               })
        var numOut = 1
        while numOut != 0 {
        numOut = 0
        var totalNegative :Float = 0.0
        foodGroupPercents.forEach({ (key, value) -> Void in
            print("checking the values")
            if value < 0{
                print(value)
                numOut+=1
                totalNegative += -1.0*value
                foodGroupPercents[key]! = 0
                foodAlerts.append(self.createFoodGroupAlert(message: "\(key)"))
                //self.dismiss(animated: true, completion: nil)
                //print("Ran out of \(key)")
               // print("Family Health Suffered 3%")
            }
        })
        let divisor = 5 - numOut
        foodGroupPercents.forEach({ (key, value) -> Void in
            let d = Float(divisor)
            if value > 0{
            foodGroupPercents[key]! -= totalNegative/d
            }
        })
        }
//        foodGroupPercents.forEach({ (key, value) -> Void in
//            foodGroupPercents[key]! -= foodAdd*24/divisor
//        })
        showErrors()
          print(foodGroupPercents)
        }

    
    @objc func updateTimer(){
        //print("timer fired")
        //playSound(file: "tick.mp3")
        hoursPassed+=1
        hoursPassedLabel.text = "Hour: \(hoursPassed)"
        
        healthProgressOutlet.progress+=Float.random(in: -0.015...0.01)
        updateFamilyHealth()
        
          happinessProgressOutlet.progress+=Float.random(in: -0.015...0.01)
        
        
        happinessUpdate()
        
        foodProgressOutlet.progress-=foodAdd
        foodUpdate()
        
        tpProgressOutlet.progress-=toiletPaperAdd
        tpUpdate()
        
        drawCurve()
        checkLose()
        
        if hoursPassed == 23{
            if nationHealthRate <= 0.0 {
                sound?.stop()
                let winAlert = UIAlertController(title: "You Win Level \(level)", message: "You helped flatten the curve!", preferredStyle: .alert)
                winAlert.view.backgroundColor = UIColor.yellow
                winAlert.addAction(UIAlertAction(title: "Next Level", style: .default, handler: {(alert) in
                    
                    self.randomStart()
                }))
                present(winAlert, animated: true){
                    self.timer?.invalidate()
                    self.playSound(file: "applause.wav")
                    self.level+=1
                    if self.level > self.highestLevel{
                    self.highestLevel = self.level
                    }
                    let user = UserDefaults.standard
                    user.set(self.highestLevel, forKey: "level")
                }
            }
        }
        
        if(hoursPassed == 24){
            sound?.stop()
            timer?.invalidate()
            coronaButton.isEnabled = false
           
            nextDayOutlet.isEnabled = true
            storeOutlet.isEnabled = true
            //displayScenario()
            updateFoodGroups()
           
            
            //path = UIBezierPath()
//            dotPath = UIBezierPath(ovalIn: CGRect(x: x - 6, y: y-2.5, width: 6, height: 6))
//            
//            
//            dotLayer.path = dotPath.cgPath
//            dotLayer.fillColor = UIColor.white.cgColor
//
//            graphView.layer.addSublayer(dotLayer)
            
        }
        
        
        
        
    }
    
    func updateFamilyHealth(){
        
        var current = healthProgressOutlet.progress
     healthProgressOutlet.setProgress(healthProgressOutlet.progress, animated: true)
        
        familyChange = current - dailyFamily
                      if familyChange < 0.0{
                          familyChangeLabelOutlet.backgroundColor = UIColor.red
                      }
                      else{
                        familyChangeLabelOutlet.backgroundColor = UIColor.systemGreen
                      }
//                      if current <= 0.10{
//                          familyPercentLabel.backgroundColor = UIColor.red
//                      }
//                      else {
//                         familyPercentLabel.backgroundColor = UIColor.systemGreen
//                      }
        if current > 0 && current < 0.01{
            current = 0.01
            
        }
                      familyPercentLabel.text = "\(Int(current*100))%"
                      
                      familyChangeLabelOutlet.text = "\(Int(familyChange*100))%"
                
      
       
    }
    
    func foodUpdate(){
    foodProgressOutlet.setProgress(foodProgressOutlet.progress, animated: true)
        
        var current = foodProgressOutlet.progress
        foodChange = current - dailyFood
        if foodChange < 0.0{
            foodChangeLabelOutlet.backgroundColor = UIColor.red
        }
        else {

            foodChangeLabelOutlet.backgroundColor = UIColor.systemGreen
        }
//        if current <= 0.24{
//            foodPercentLabel.backgroundColor = UIColor.red
//        }
//        else {
//            foodPercentLabel.backgroundColor = UIColor.systemGreen
//        }
        foodChangeLabelOutlet.text = "\(Int(foodChange*100))%"
        if current > 0 && current < 0.01{
            current = 0.01
            
        }
        foodPercentLabel.text = "\(Int(current*100))%"
         
       
        
     }
    
    func happinessUpdate(){
        var current = happinessProgressOutlet.progress
        
        happinessProgressOutlet.setProgress(current, animated: true)
        
       
       happyChange = current - dailyHappiness
        if happyChange < 0.0{
            happinessChangeLabelOutlet.backgroundColor = UIColor.red
        }
        else{
            happinessChangeLabelOutlet.backgroundColor = UIColor.systemGreen
        }
//        if current <= 0.10{
//            happinessPercentLabel.backgroundColor = UIColor.red
//        }
//        else {
//            happinessPercentLabel.backgroundColor = UIColor.systemGreen
//        }
        if current > 0 && current < 0.01{
            current = 0.01
            
        }
        happinessPercentLabel.text = "\(Int(current*100))%"
        
        happinessChangeLabelOutlet.text = "\(Int(happyChange*100))%"
        
      
       
    }
    
    func tpUpdate(){
        var current = tpProgressOutlet.progress
          tpProgressOutlet.setProgress(current, animated: true)
        
        tpChange = current - dailyTp
               if tpChange < 0.0{
                   tpChangeLabelOutlet.backgroundColor = UIColor.red
               }
               else{
                tpChangeLabelOutlet.backgroundColor = UIColor.systemGreen
               }
//               if current <= 0.10{
//                   tpPercentLabel.backgroundColor = UIColor.red
//               }
//               else {
//                  tpPercentLabel.backgroundColor = UIColor.systemGreen
//               }
        if current > 0 && current < 0.01{
            current = 0.01
            
        }
               tpPercentLabel.text = "\(Int(current*100))%"
               
               tpChangeLabelOutlet.text = "\(Int(tpChange*100))%"
         
      }
    
    func nationHealthUpdate(){
        let current = NationHealthProgressOutlet.progress
        
NationHealthProgressOutlet.setProgress(NationHealthProgressOutlet.progress, animated: true)
      
        nationChange = current - dailyNation
                      if nationChange < 0.0{
                          nationChangeLabelOutlet.backgroundColor = UIColor.red
                      }
                      else{
                        nationChangeLabelOutlet.backgroundColor = UIColor.systemGreen
        
                      }
//                      if current <= 0.10{
//                          nationPercentLabel.backgroundColor = UIColor.red
//                      }
//                      else {
//                         nationPercentLabel.backgroundColor = UIColor.systemGreen
//                      }
                      nationPercentLabel.text = "\(Int(current*100))%"
                      
                      nationChangeLabelOutlet.text = "\(Int(nationChange*100))%"
                
       
    }
    
    func updateMoney(){
        
             moneyLabel.text = "$\(money)"
           //  foodBarLabel.frame = CGRect(origin: foodBarLabel.frame.origin, size: CGSize(width: foodBarLabel.frame.width, height: money))
    }
    
    func nextDay(){
        let user = UserDefaults.standard
        user.set(self.level, forKey: "level")
        
        storeOutlet.isEnabled = false
               nextDayOutlet.isEnabled = false
               resetDailyTotals()
               updateAll()
        print(foodGroupPercents)
    }
    
    @IBAction func nextDayAction(_ sender: UIButton) {
        foodAdd = foodAdd * pow(0.80, Float(rationIncrease))
        toiletPaperAdd = toiletPaperAdd * pow(0.80,Float(rationIncrease))
        print ("foodAdd = \(foodAdd)")
        print ("toiletPaperAdd = \(toiletPaperAdd)")
            nationHealthRate -= (0.05 * nationHealthDecrease)
        healthProgressOutlet.progress += Float(0.05 * (happinessIncrease + 1.0))
        
            growthRateOutlet.text = "Growth Rate \(Int(nationHealthRate*100))%"
        if nationHealthDecrease > 0{
           // growthRateOutlet.backgroundColor = UIColor.green

        //growthRateOutlet.alpha = 0
//            [UIView.animate(withDuration: 1.0, delay: 0.1, options: UIView.AnimationOptions.autoreverse , animations: {
//                self.growthRateOutlet.alpha = 1
//            }, completion: { (true) in
//                print("done with flash")
//
//            })]
           }
        
            
//        [UIView animateWithDuration:1.5 , delay:0.5 ,options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:{
//                self.growthRateOutlet.alpha = 0;
//        } completion:nil];
        
        
            
        
       
            happinessProgressOutlet.progress += Float(0.05 * happinessIncrease)
        
        
        nextDay()
        hoursPassed = 0
        day+=1
        dayLabel.text = "Day: \(day)"
        hoursPassedLabel.text = "Hour: \(hoursPassed)"
        coronaButton.isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        playSound(file: "tickingClock.wav")
        
        //nationHealthMult-=nationHealthMultAdd
       // print(nationHealthRate)
    }
   
    
    @IBAction func storeAction(_ sender: UIButton) {
        performSegue(withIdentifier: "storeSegue", sender: nil)
    }
    
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let store = segue.destination as! StoreViewController
        store.cash = money
        store.food = self.foodProgressOutlet.progress
        store.tp = self.tpProgressOutlet.progress
        store.happiness = self.happinessProgressOutlet.progress
        store.nationHealth = self.nationHealthRate
        store.familyHealth = self.healthProgressOutlet.progress
        store.foodGroupPercents = foodGroupPercents
       store.doubleClick = doubleClick
        store.nationHealthDecrease = nationHealthDecrease
        store.happinessIncrease = happinessIncrease
        store.rationIncrease = rationIncrease
        
        store.level = level
      
        
    }
 
    
   func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let vc = viewController as? HomeViewController{
        vc.highestLevel = highestLevel
        print("level being sent over \(vc.highestLevel)")
        vc.setUpLevels()
    }
    }
    
    
  
    
}

