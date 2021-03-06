//
//  ViewController.swift
//  Blocks-slide
//

//2016-03-10T04:42:53.381015Z 1 [Note] A temporary password is generated for root@localhost: hiPsSaM(y86c

//If you lose this password, please consult the section How to Reset the Root Password in the MySQL reference manual.

//  Created by Serx on 3/9/16.
//  Copyright © 2016 serxlee. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    //MARK: - ----all Properties----
    //MARK: -
    
    
    
    //how many blocks the blocks slide onece, 2 or 3...
    var allPs: allProperties = allProperties()
    
    let numberBlocksSlideOnce: Int = 2
    var level: Int!
    var isContinue: Int!
    
    var stateArray: [Int] =
        [0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,
        0,0,0,0,0,0,-1]
    

    var BlocksPositionXY: [CGPoint] = []
    
    var doubleArrayNumberBlcoks = DoubleDimensionalArrayInt(rows: 10, columns: 10)
    var doubleArrayBoolBlocks = DoubleDimensionalArrayBool(rows: 10, columns: 10)
    var doubleArrayBoolImage = DoubleDimensionalArrayInt(rows: 10, columns: 10)
    var doubleArrayPointBlocks = DoubleDimensionalArrayPoint(rows: 10, columns: 10)
    var doubleArrayChooseBlocks = DoubleDimensionalArrayBool(rows: 10, columns: 10)
    
    //the second view size
    var grayView: UIView!
    var grayViewLenght: CGFloat!
    var grayViewHeight: CGFloat!
    
    //set the oringinal position and the lenght of the blocks (face to the grayview)
    var positionOfBlcoks = CGPoint(x: 0.0, y: 0.0)
    var sizeOfBlocks: CGSize!
    var blockLenght: CGFloat!


    //swipe every direction
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    
    //tap gesture
    var tapSingleFingerOneClick = UITapGestureRecognizer()
    var tapSingleFingerDoubleClick = UITapGestureRecognizer()
    
    //the move Event use
    var FSTBlocks: [(Int, Int)] = [(-1, -1),(-1, -1),(-1, -1)]
    var Nums: [(Int, Int)] = [(-1, -1),(-1, -1),(-1, -1)]
    //for fore direction x and y
    let numAdd: [(Int, Int)] = [(0, 0),(0, -1), (0, 1), (-1, 0), (1, 0)]
    var firstTimeToMove = true
    
    //MARK: coreData
    var managedContext: NSManagedObjectContext!
    var markEntity: NSEntityDescription!
    var markFetch: NSFetchRequest!

    
    //the data get from the coreData, the first of the result dictionatry.
    var resultOfMark: NSDictionary!
    
    var flagFirst: Bool = false
    var flagSecond: Bool = false
    var flagThird: Bool = false

    //mark time

    
    
    
    //MARK: - ----Apple Inc. func----
    //MARK: -
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        UIRoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    //MARK: - -----individual func----
    //MARK: -
    
    
    
    
    //the method is link the database and get the data.
    func coreDataInit(){
        markEntity = NSEntityDescription.entityForName("Mark", inManagedObjectContext: managedContext)
        markFetch = NSFetchRequest(entityName: "Mark")
        do {
            let result = try managedContext.executeFetchRequest(markFetch) as! [NSDictionary]
            if result.count > 0{
                resultOfMark = result.first
            }
        }catch let error as NSError{
            print("Error: \(error) " +
                "description \(error.localizedDescription)")
        }
    }
    
    func getDataFromPlist(){
        let storege = storeTheLastTime()
        storege.startToRead()
        stateArray = storege.toReadArray as! [Int]
        print(stateArray)
    }
    
    func allBlocksPoint(){
        for index_j in 0...6{
            for index_i in 0...6{
                doubleArrayPointBlocks[index_i, index_j] = CGPoint(x: blockLenght * CGFloat(index_i), y: blockLenght * CGFloat(index_j))
            }
        }
    }
    
    //set the location, if there is a block, the doubleArrayBoolBlocks's value if ture.
    func isThereA_Block(){
        var x = 0
        var y = 0
        var gg: [Int] = []
        if (isContinue == 1){
            getDataFromPlist()
            gg = stateArray
            for i in 0...gg.count - 2{
                if gg[i] >= 1{
                    
                    let lim = gg[i] - 1
                    
                    y = i / 6
                    x = i % 6
                    //game load
                    level = gg.last
                    doubleArrayBoolImage[x, y] = lim
                    doubleArrayBoolBlocks[x, y] = true
                }
            }
        }else if isContinue == 2{
            let random = RandomBlocksArray()
            gg = random.startRandom(16)
            for i in 0...gg.count - 1{
                if gg[i] == 1{
                    y = i / 6
                    x = i % 6
                    
                    //game load
                    doubleArrayBoolBlocks[x, y] = true
                }
            }
        }
        createBlocksToMove()
        
        stateArray =
            [0,0,0,0,0,0,
             0,0,0,0,0,0,
             0,0,0,0,0,0,
             0,0,0,0,0,0,
             0,0,0,0,0,0,
             0,0,0,0,0,0,-1]
        getCorrentState()
    }

    
    //a method of get the device size
    func getDevicesSize(){
        let calculateBound: CGFloat = 0.058
        let masterX: CGFloat = getTrueLength(true)
        let masterY: CGFloat = getTrueLength(false)
        let boundWide = masterX * calculateBound
        grayViewLenght = masterX - boundWide
        grayViewHeight = grayViewLenght
        blockLenght = grayViewLenght / 6
        let blockLenghtShrink = blockLenght - 1.0
        
        sizeOfBlocks = CGSize(width: blockLenghtShrink, height: blockLenghtShrink)
        
        let pointOfBackground = CGPoint(x: boundWide / 2 - 4, y: masterY - grayViewHeight - masterY / 6 - 4)
        let sizeOfBackground = CGSize(width: grayViewLenght + 8, height: grayViewHeight + 8)
    
        //MARK:grayview handing all the blocks
        grayView = UIView(frame: CGRect(origin: pointOfBackground, size: sizeOfBackground))
        grayView.backgroundColor = UIColor.whiteColor()
        
        grayView.layer.cornerRadius = 3.0
        view.addSubview(grayView)
    }
    
    let numberOfImage: Int  = 16

    func createBlocksToMove(){

        let image = HandleImage()
        image.initTheImage(level)
        
        var numOfBlocks: Int = 0
        
        var numOfPingTu = 0
        let random = RandomBlocksArray().randomAllBlocks(numberOfImage)
        
        for index_j in 0...5{
            for index_i in 0...5{
                
                //if the position of the matrix has a block, create a blocks in the position
                if checkTheBackground(index_i, yy: index_j){
                    
                    let view2 = UIImageView(frame: CGRect(x: doubleArrayPointBlocks[index_i, index_j].x + 4, y: doubleArrayPointBlocks[index_i, index_j].y + 4, width: sizeOfBlocks.width, height: sizeOfBlocks.height))
                    
                    if numOfPingTu < numberOfImage{
                        
                        var lim_index: Int!
                        
                        if isContinue == 1{
                            
                            lim_index = doubleArrayBoolImage[index_i, index_j]
                        }else if isContinue == 2{
                            
                            lim_index = random()
                            doubleArrayBoolImage[index_i, index_j] = lim_index
//                            print(doubleArrayBoolImage[index_i, index_j])
                        }
                        
                        image.number = (numberOfImage, lim_index)
                        view2.image = image.smallImage()
                        numOfPingTu += 1
                    }else{
                        view2.backgroundColor = UIColor.grayColor()
                    }
                    
                    //set corner radius
                    view2.layer.masksToBounds = true
//                    view2.layer.cornerRadius = 3.0
                    view2.backgroundColor = UIColor.clearColor()
                    view2.kt_addCorner(radius: 3.0)
                    
//                    view2.layer.borderWidth = 0.5
//                    view2.layer.borderColor = UIColor.blackColor().CGColor
                    
                    //set the tag for everyone block
                    view2.tag = numOfBlocks + 1
                    
                    doubleArrayNumberBlcoks[index_i, index_j] = numOfBlocks + 1
                    grayView.addSubview(view2)
                    
                    numOfBlocks += 1
                }
            }
        }
    }
    
    /*
        according to the system version to get the real height and lenght
        while the isWidth if TRUE，is said that you get the lenght，FALSE is said that you get the height
    */
    func getTrueLength(isWidth:Bool)->CGFloat{
        
        let myRect:CGRect = UIScreen.mainScreen().bounds;
        
        //get the device's system version
        let myDeviceVersion:Float = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        var length:CGFloat = 0.0
        
        //if the iOS version lower than 8.0 and the orientation is landscsape
        if(myDeviceVersion < 8.0&&(self.interfaceOrientation == UIInterfaceOrientation.LandscapeLeft||self.interfaceOrientation == UIInterfaceOrientation.LandscapeRight)){
            
            if(isWidth){
                length = myRect.size.height
            }else{
                length = myRect.size.width
            }
        }
        else{
            if(isWidth){
                length = myRect.size.width
            }
            else{
                length = myRect.size.height
            }
        }
        return length;
    }
    
    //TODO: gesture recognizer's attribute
    func setGestureAttribute(){
        
        tapSingleFingerOneClick.numberOfTouchesRequired = 1
        tapSingleFingerOneClick.numberOfTapsRequired = 1
        tapSingleFingerOneClick.delegate = self
        tapSingleFingerOneClick = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleSingleFingerEvent(_:)))
        self.grayView.addGestureRecognizer(tapSingleFingerOneClick)
        
        swipeUp.numberOfTouchesRequired = 1
        swipeDown.numberOfTouchesRequired = 1
        swipeLeft.numberOfTouchesRequired = 1
        swipeRight.numberOfTouchesRequired = 1
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipe(_:)))
        
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        
        self.grayView.addGestureRecognizer(swipeUp)
        self.grayView.addGestureRecognizer(swipeDown)
        self.grayView.addGestureRecognizer(swipeLeft)
        self.grayView.addGestureRecognizer(swipeRight)
        
        swipeUp.enabled = false
        swipeDown.enabled = false
        swipeLeft.enabled = false
        swipeRight.enabled = false
        
        swipeUp.delegate = self
        swipeDown.delegate = self
        swipeLeft.delegate = self
        swipeRight.delegate = self
    }
    
    func exchange(){
        
        let limX = FSTBlocks[0].0
        let limY = FSTBlocks[0].1
        FSTBlocks[0].0 = FSTBlocks[1].0
        FSTBlocks[0].1 = FSTBlocks[1].1
        FSTBlocks[1].0 = limX
        FSTBlocks[1].1 = limY
    }
    
    func checkTheBackground(xx: Int, yy: Int) -> Bool{
        
        if doubleArrayBoolBlocks[xx, yy]{
            return true
        }
        return false
    }
    
    func panIsAllowMove(direction: Int) -> Bool{
        
        if FSTBlocks[0].1 + numAdd[direction].1  == FSTBlocks[1].1 && FSTBlocks[0].0 + numAdd[direction].0 == FSTBlocks[1].0{
            
            if !checkTheBackground(FSTBlocks[1].0 + numAdd[direction].0, yy: FSTBlocks[1].1 + numAdd[direction].1){
                return true
            }
        }else{
            if !checkTheBackground(FSTBlocks[0].0 + numAdd[direction].0, yy: FSTBlocks[0].1 + numAdd[direction].1) && !checkTheBackground(FSTBlocks[1].0 + numAdd[direction].0, yy: FSTBlocks[1].1 + numAdd[direction].1){
                return true
            }
        }
        return false
    }
    
    //MARK: slide Two Blocks once
    func handleTwoBlockMoveEvent(direction: Int){
        
        var allowMove = false
        var changeLenght: CGFloat = blockLenght
        
        /*
            if this time is the selected blocks first time to move,
            get the blocks position from the BlocksPositionXY
        
            else get the blocks position from the Nums
        */
        if firstTimeToMove{
            FSTBlocks[0].0 = Int(BlocksPositionXY[0].x)
            FSTBlocks[0].1 = Int(BlocksPositionXY[0].y)
            FSTBlocks[1].0 = Int(BlocksPositionXY[1].x)
            FSTBlocks[1].1 = Int(BlocksPositionXY[1].y)
        }
        if !firstTimeToMove{
            FSTBlocks[0].0 = Nums[0].0
            FSTBlocks[0].1 = Nums[0].1
            FSTBlocks[1].0 = Nums[1].0
            FSTBlocks[1].1 = Nums[1].1
        }
        //up
        if direction == 1 && FSTBlocks[0].1 > 0 && FSTBlocks[1].1 > 0{
            
            if FSTBlocks[0].1 < FSTBlocks[1].1{
                exchange()
            }
            changeLenght = -changeLenght
            allowMove = panIsAllowMove(direction)
            //down
        }else if direction == 2 && FSTBlocks[0].1 < 5 && FSTBlocks[1].1 < 5{
            
            if FSTBlocks[0].1 > FSTBlocks[1].1{
                exchange()
            }
            allowMove = panIsAllowMove(direction)
            //left
        }else if direction == 3 && FSTBlocks[0].0 > 0 && FSTBlocks[1].0 > 0{
            
            if FSTBlocks[0].0 < FSTBlocks[1].0{
                exchange()
            }
            changeLenght = -changeLenght
            allowMove = panIsAllowMove(direction)
            //right
        }else if direction == 4 && FSTBlocks[0].0 < 5 && FSTBlocks[1].0 < 5{
            
            if FSTBlocks[0].0 > FSTBlocks[1].0{
                exchange()
            }
            allowMove = panIsAllowMove(direction)
        }
        if allowMove{
            //save the next state to the Nums
            Nums[0].0 = FSTBlocks[0].0 + numAdd[direction].0
            Nums[0].1 = FSTBlocks[0].1 + numAdd[direction].1
            Nums[1].0 = FSTBlocks[1].0 + numAdd[direction].0
            Nums[1].1 = FSTBlocks[1].1 + numAdd[direction].1
            
            //update the posistion of the selected blocks
            BlocksPositionXY[0] = CGPoint(x: Nums[0].0, y: Nums[0].1)
            BlocksPositionXY[1] = CGPoint(x: Nums[1].0, y: Nums[1].1)
            
            firstTimeToMove = false
            for subview in grayView.subviews{
                if subview.tag == doubleArrayNumberBlcoks[FSTBlocks[1].0, FSTBlocks[1].1]{
                    
                    doubleArrayBoolBlocks[FSTBlocks[1].0, FSTBlocks[1].1] = false
                    doubleArrayNumberBlcoks[FSTBlocks[1].0, FSTBlocks[1].1] = 0
                    
                    //handle the image
                    doubleArrayBoolImage[Nums[1].0, Nums[1].1] = doubleArrayBoolImage[FSTBlocks[1].0, FSTBlocks[1].1]
                    doubleArrayBoolImage[FSTBlocks[1].0, FSTBlocks[1].1] = 0
                    
                    UIImageView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        
                        if direction == 1 || direction == 2{
                            subview.frame.origin.y = subview.frame.origin.y + changeLenght
                        }else if direction == 3 || direction == 4{
                            subview.frame.origin.x = subview.frame.origin.x + changeLenght
                        }
                        
                        }, completion: nil)
                    
                    doubleArrayBoolBlocks[Nums[1].0, Nums[1].1] = true
                    doubleArrayNumberBlcoks[Nums[1].0, Nums[1].1] = subview.tag
                }
            }
            for subview in grayView.subviews{
                if subview.tag == doubleArrayNumberBlcoks[FSTBlocks[0].0, FSTBlocks[0].1]{
                    
                    doubleArrayBoolBlocks[FSTBlocks[0].0, FSTBlocks[0].1] = false
                    doubleArrayNumberBlcoks[FSTBlocks[0].0, FSTBlocks[0].1] = 0
                    
                    //handle the image
                    doubleArrayBoolImage[Nums[0].0, Nums[0].1] = doubleArrayBoolImage[FSTBlocks[0].0, FSTBlocks[0].1]
                    doubleArrayBoolImage[FSTBlocks[0].0, FSTBlocks[0].1] = 0
                    
                    UIImageView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        
                        if direction == 1 || direction == 2{
                            subview.frame.origin.y = subview.frame.origin.y + changeLenght
                        }else if direction == 3 || direction == 4{
                            subview.frame.origin.x = subview.frame.origin.x + changeLenght
                        }
                        
                        }, completion: nil)
                    
                    doubleArrayBoolBlocks[Nums[0].0, Nums[0].1] = true
                    
                    doubleArrayNumberBlcoks[Nums[0].0, Nums[0].1] = subview.tag
                }
            }
            
            if checkIfFinishGame(){
                var alert = UIAlertController()
                alert = UIAlertController(title: "恭喜你", message: "你已经通过本关", preferredStyle: UIAlertControllerStyle.Alert)
                
                let alertOK = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
                
                alert.addAction(alertOK)
                alert.actions
            }
        }
    }
    
    //the swipe event
    func swipe(recognizer: UISwipeGestureRecognizer){

        if recognizer == swipeUp{
            handleTwoBlockMoveEvent(1)
        }else if recognizer == swipeDown{
            handleTwoBlockMoveEvent(2)
        }else if recognizer == swipeLeft{
            handleTwoBlockMoveEvent(3)
        }else{
            handleTwoBlockMoveEvent(4)
        }
        stateArray =
        [0,0,0,0,0,0,
            0,0,0,0,0,0,
            0,0,0,0,0,0,
            0,0,0,0,0,0,
            0,0,0,0,0,0,
            0,0,0,0,0,0, -1]
        
        getCorrentState()
    }
    
    func findThePositionInt(positionRAW: CGPoint) -> Bool{
        
        for index_i in 0...5{
            for index_j in 0...5{
                
                if checkTheBackground(index_i, yy: index_j) && !doubleArrayChooseBlocks[index_i, index_j]{
                    
                    let contrastStart = doubleArrayPointBlocks[index_i, index_j]
                    let contrastEnd = doubleArrayPointBlocks[index_i + 1, index_j + 1]
                    if positionRAW.x >= contrastStart.x && positionRAW.x <= contrastEnd.x && positionRAW.y >= contrastStart.y && positionRAW.y <= contrastEnd.y{
                        
                        //indicate the block is selected
                        
                        doubleArrayChooseBlocks[index_i, index_j] = true
                        
                        BlocksPositionXY.append(CGPoint(x: index_i, y: index_j))
                        return true

                    }
                }
                
                else if checkTheBackground(index_i, yy: index_j) && !doubleArrayChooseBlocks[index_i, index_j]{
                    return false
                }
            }
        }
        return false
    }
    //save the first float up view
    var showFirst: (Bool, Int, Int, UIView) = (false,-1, -1, UIView())
    
    func handleSeletedBlocks(whichBlock: Int, showShadow: Bool){
        
        var point = CGPoint(x: -1, y: -1)

        if whichBlock == 1{
            point = BlocksPositionXY[0]
        }else if whichBlock == 2{
            point = BlocksPositionXY[1]
        }
        
        let blockNum = doubleArrayNumberBlcoks[Int(point.x), Int(point.y)]
        
        for subview in grayView.subviews{
            if subview.tag == blockNum{
                
                if !showFirst.0{
                    showFirst = (true,Int(point.x), Int(point.y), subview)
                }
                //animate
                UIImageView.animateWithDuration(0.1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    self.grayView.bringSubviewToFront(subview)
                    
                    if showShadow{
                        subview.frame.origin.x = subview.frame.origin.x - 2.0
                        subview.frame.origin.y = subview.frame.origin.y + 4.0
                        subview.frame.size.height = subview.frame.size.height + 0.5
                        subview.frame.size.width = subview.frame.size.width + 0.5
                        
                        subview.layer.masksToBounds = !showShadow
                        let shadowPath = UIBezierPath(rect: subview.layer.bounds)
                        subview.layer.shadowOffset = CGSizeMake(3, -5)
                        subview.layer.shadowRadius = 4.0
                        subview.layer.shadowColor = UIColor.blackColor().CGColor
                        subview.layer.shadowOpacity = 0.3
                        subview.layer.shadowPath = shadowPath.CGPath
                    }else{
                        subview.frame.origin.x = subview.frame.origin.x + 2.0
                        subview.frame.origin.y = subview.frame.origin.y - 4.0
                        subview.frame.size.height = subview.frame.size.height - 0.5
                        subview.frame.size.width = subview.frame.size.width - 0.5
                        
                        //delect the shadow
                        subview.layer.shadowOffset = CGSizeMake(0,0)
                        subview.layer.shadowColor = UIColor.clearColor().CGColor
                        subview.layer.masksToBounds = !showShadow
                        subview.backgroundColor = UIColor.clearColor()


                    }
                    
                    if self.showFirst.0{
                        if self.showFirst.2 == Int(point.y) && self.showFirst.1 > Int(point.x){
                            self.grayView.bringSubviewToFront(self.showFirst.3)
                        }
                        if self.showFirst.1 == Int(point.x) && self.showFirst.2 < Int(point.y){
                            self.grayView.bringSubviewToFront(self.showFirst.3)
                        }
                    }
                    
                    }, completion: nil)
            }
        }
    }
    
    func handleSingleFingerEvent(recognizer: UITapGestureRecognizer){
        if recognizer.numberOfTapsRequired == 1{
            let number = self.numberBlocksSlideOnce
            let limPosition = recognizer.locationInView(self.grayView)

            //MARK: slide two blocks once
            if number == 2{
                
                if !flagFirst{
                    if findThePositionInt(limPosition){
                        flagFirst = true
                        handleSeletedBlocks(1, showShadow: true)
                    }
                }else if flagFirst && !flagSecond{
                    if findThePositionInt(limPosition){
                        flagSecond = true
                        handleSeletedBlocks(2, showShadow: true)
                    }else{
                        flagFirst = false
                        handleSeletedBlocks(1, showShadow: false)
                        doubleArrayChooseBlocks[Int(BlocksPositionXY[0].x), Int(BlocksPositionXY[0].y)] = false
                        BlocksPositionXY = []
                    }
                }
                if flagFirst && flagSecond {
                    
                    recognizer.numberOfTapsRequired = 2
                    swipeUp.enabled = true
                    swipeDown.enabled = true
                    swipeLeft.enabled = true
                    swipeRight.enabled = true
                    
                    for position in BlocksPositionXY{
                        doubleArrayChooseBlocks[Int(position.x), Int(position.y)] = false
                    }
                }
                
            //FIXME: slide three blocks once
            }else if number == 3{
                
            }
        }else if recognizer.numberOfTapsRequired == 2{
            
            firstTimeToMove = true
            recognizer.numberOfTapsRequired = 1
            
            swipeUp.enabled = false
            swipeDown.enabled = false
            swipeLeft.enabled = false
            swipeRight.enabled = false
            
            flagFirst = false
            flagSecond = false
            flagThird = false
            
            handleSeletedBlocks(1, showShadow: false)
            handleSeletedBlocks(2, showShadow: false)
            
            showFirst.0 = false

            for position in BlocksPositionXY{
                doubleArrayChooseBlocks[Int(position.x), Int(position.y)] = false
            }
            BlocksPositionXY = []
        }
    }
    

    //every move the blocks, check the game is finish ?
    func checkIfFinishGame() -> Bool{
        
        for index_i in 1...4{
            for index_j in 1...4{
                if !checkTheBackground(index_i, yy: index_j){
                    return false
                }
            }
        }
        return true
    }
    
    func getCorrentState(){
        
        for index_i in 0...5{
            for index_j in 0...5{
                if checkTheBackground(index_i, yy: index_j){
                    stateArray[index_j * 6 + index_i] = (1 + doubleArrayBoolImage[index_i, index_j])
                }
//                print(doubleArrayBoolImage[index_i, index_j])
            }
        }
        stateArray[36] = level
        appdelegageArray = NSArray(array: stateArray)
//        print(appdelegageArray)
    }
    
    
    @IBAction func goToMenu(sender: UIButton) {
        
        let store = storeTheLastTime()
        store.toWriteArray = NSMutableArray(array: appdelegageArray)
        store.startToWrite()
    }

    func UIRoad(){
        getDevicesSize()
        
        //Obtain the device's screen size, and Set the blocks's side
        allBlocksPoint()
        
        isThereA_Block()
        
        //call the method: set gesture recognizer attribute
        setGestureAttribute()
    }
    
}