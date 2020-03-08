//
//  ViewController.swift
//  HackUNO2020
//
//  Created by Christopher Phillips on 3/6/20.
//  Copyright © 2020 Lion275. All rights reserved.
//

import UIKit

class numberedButton : UIButton{
    var num : Int;
    required init(n : Int) {

        num = n;
        
        super.init(frame: .zero);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var results = [CityResult]();

class ViewController: UIViewController  {

    var functionString = "D";
    var changeType = 0;
    var changeCharacter : Character = "D";
    var changeIndex : String.Index?
    let functionNamesD = ["Add", "Subtract", "Multiply", "Divide","Count","Average","Max","Min","1","2","3","4","5","6","7","8","9"];
    let functionDescriptionsD = ["adds the two numbers together", "Subtracts the second value from the first","Multiplies the two numbers together","Divides the first number by the second. Technical Note: if the second number is equal to 0 it will be evaluated as 0.0001","Returns the total number of days in the selection where the condition is true.","Returns the average value for all the days in the selection.","Returns the maximum value from the selection.","Returns the minimum value from the selection.","The number 1","The number 2","The number 3","The number 4","The number 5","The number 6","The number 7","The number 8","The number 9",];
    let functionCodesD = ["+(D,D)","-(D,D)","X(D,D)","/(D,D)","A[0](Z)","A[1](Y)","A[2](Y)","A[3](Y)","N[1]","N[2]","N[3]","N[4]","N[5]","N[6]","N[7]","N[8]","N[9]"];
    let functionNamesZ = ["Fog","Thunder","Small Hail","Hail","Glaze","Blowing Sand","Haze","Blowing Snow"]
    let functionDescriptionsZ = ["True if their was fog during the day","True if their was Thunder during the day","True if their was small hail during the day","True if their was hail during the day","True if their was falling freezing percipitation during the day","True if their was blowing sand during the day","True if their was haze during the day","True if their was blowing snow during the day"];
    let functionCodesZ = ["F[7]","F[8]","F[9]","F[10]","F[11]","F[12]","F[13]","F[14]"];
    let functionNamesY = ["Min Temp","Max Temp","Average Temp","Average Wind","Percipitaion", "Snowfall", "Wind Gust"];
    let functionDescriptionsY = ["The low temperture for the day.", "The high temperture for the day.","The average temperature for the day","The average wind speed for the day.","The amount of rainfall.","The amount of snowfall","The speed of the strongest 5 second gust during the day"];
    let functionCodesY = ["F[0]","F[1]","F[2]","F[3]","F[4]","F[5]","F[6]"];
    let functionNamesB = ["&","or",">","<","not"];
    let functionDescriptionsB = ["True if both conditions are true","True if either condition is true", "True if the first number is larger than the second.","True if the first number is smaller than the second.","True if the condition is false. False if the condition is true."];
    let functionCodesB = ["&(B,B)","O(B,B)",">(D,D)","<(D,D)","!(B)"]
    var buttonList = [numberedButton]();
    var functionNames = [String]();
    var functionDescriptions = [String]();
    var functionCodes = [String]();
    var allDays = [Day]();
    var functionNode : DoubleNode = NumberNode(t1: 2);
    override func viewDidLoad() {
        super.viewDidLoad()
        functionScroller.contentSize = functionDisplay.frame.size;
        functionNames = functionNamesD;
        functionDescriptions = functionDescriptionsD;
        functionCodes = functionCodesD;
        resultButton.isHidden = true;
        setButtons();
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func setButtons(){
        for b in buttonList{
            b.removeFromSuperview();
        }
        buttonList = [numberedButton]();
        
        for bn in 0...functionCodes.count - 1{
            let buttonX = 10;
            let buttonY = 60 * bn;
            let buttonWidth = 150;
            let buttonHeight = 50;
            let button = numberedButton(n: bn);
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight);
            button.backgroundColor = .red;
            button.setTitle(functionNames[bn], for: .normal);
            button.addTarget(self, action: #selector(updateText), for: .touchUpInside);
            buttonsScroll.addSubview(button);
            buttonList.append(button);
        }
        buttonsScroll.contentSize = CGSize(width: 150, height: 80 * (functionCodes.count - 1));
    }
    
    func parseFunctionPart(part : String) -> DoubleNode{
        print("Function Part: " + part);
        let result = NumberNode(t1: 0.0);
        let char = part[part.startIndex];
        print("Char: " + String(char));
        if(char == "-"){
            return createOperatorNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "-");
        } else if(char == "+"){
            return createOperatorNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "+");
        }else if(char == "/"){
            return createOperatorNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "/");
        }else if(char == "X"){
            return createOperatorNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "X");
        }else if(char == "A"){
            return createAggNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
        } else if(char == "F"){
            return createDayFunction(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
        }else if(char == "N"){
            return createNumberNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
        }
        return result;
    }
    
    func createNumberNode(part : String) -> DoubleNode{
        print("Number Node: " + part);
        let t1 = Double(String(part[part.index(after: part.startIndex)..<part.index(before: part.endIndex)]));
        return NumberNode(t1: t1!);
    }
    
    func parseFunctionPartB(part : String) -> BoolNode{
        print("Function Part: " + part);
        let char = part[part.startIndex];
        print("Char: " + String(char));
        if(char == "&"){
            return createBoolNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "&");
        } else if(char == "<"){
            return createBoolNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "<");
        }else if(char == ">"){
            return createBoolNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: ">");
        }else if(char == "O"){
            return createBoolNode(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "O");
        }else if(char == "F"){
            return createDayFunctionB(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
        }
        return GreaterThanNode(t1: NumberNode(t1: 0.0), t2: NumberNode(t1: 2.3));
    }
    
    func createOperatorNode(part : String, sign : Character) -> DoubleNode {
        print("Operator: " + part);
        let result = NumberNode(t1: 0.0);
        let subStr = part[part.index(after: part.startIndex)..<part.endIndex];
        var count = 1;
        var firstVariable = part.count;
        var partPart = String(subStr);
        var splitIndex = part.startIndex;
        var splitCount = 0;
        var tries = 0;
        var found = false;
        var searchInd = part.startIndex;
        while(!found && tries < 15){
            tries += 1;
            print("count: " + String(count) + "  " + String(splitCount) + "    " + partPart)
            firstVariable = partPart.count;
            if(count > 1){
                var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
                searchInd = endInd;
                let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
                if(firstLP < firstVariable){
                    firstVariable = firstLP;
                }
                endInd = (partPart.firstIndex(of: ")")) ?? partPart.endIndex;
                let firstRP = String(partPart[partPart.startIndex..<endInd]).count;
                print("LP: " + String(firstLP) + " RP: " + String(firstRP));
                if(firstRP < firstVariable){
                    print("Decrease Count");
                    count -= 1;
                    searchInd = endInd;
                    firstVariable = firstRP;
                } else {
                    print("Increase Count");
                    count += 1;
                }
                partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
            } else {
                var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
                searchInd = endInd;
                let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
                if(firstLP < firstVariable){
                    firstVariable = firstLP;
                }
                endInd = (partPart.firstIndex(of: ",")) ?? partPart.endIndex;
                let firstC = String(partPart[partPart.startIndex..<endInd]).count;
                if(firstC < firstVariable){
                    found = true;
                    firstVariable = firstC;
                    searchInd = endInd;
                } else {
                    count += 1;
                }
                partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
            }
            splitCount += firstVariable + 1;
        }
        splitIndex = part.index(part.startIndex, offsetBy: splitCount);
        let t1 = parseFunctionPart(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
        let t2 = parseFunctionPart(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
        if( sign == "-"){
            return SubtractionNode(t1: t1, t2: t2);
        } else if( sign == "X"){
            return MultiplicationNode(t1: t1, t2: t2);
        } else if( sign == "+"){
            return AdditionNode(t1: t1, t2: t2);
        } else if( sign == "/"){
            return DivisionNode(t1: t1, t2: t2);
        }
        return result;
    }
    
    func createNotNode(part : String) -> BoolNode{
        print("Not: " + part);
        let t1 = parseFunctionPartB(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
        return notNode(t1: t1);
    }
    
    func createBoolNode(part : String, sign : Character) -> BoolNode {
        print("BoolOperator: " + part);
        let result = GreaterThanNode(t1: NumberNode(t1: 0.0), t2: NumberNode(t1: 2.3));
        let subStr = part[part.index(after: part.startIndex)..<part.endIndex];
        var count = 1;
        var firstVariable = part.count;
        var partPart = String(subStr);
        var splitIndex = part.startIndex;
        var splitCount = 0;
        var tries = 0;
        var found = false;
        var searchInd = part.startIndex;
        while(!found && tries < 15){
            tries += 1;
            print("count: " + String(count) + "  " + String(splitCount) + "    " + partPart)
            firstVariable = partPart.count;
            if(count > 1){
                var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
                searchInd = endInd;
                let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
                if(firstLP < firstVariable){
                    firstVariable = firstLP;
                }
                endInd = (partPart.firstIndex(of: ")")) ?? partPart.endIndex;
                let firstRP = String(partPart[partPart.startIndex..<endInd]).count;
                print("LP: " + String(firstLP) + " RP: " + String(firstRP));
                if(firstRP < firstVariable){
                    print("Decrease Count");
                    count -= 1;
                    searchInd = endInd;
                    firstVariable = firstRP;
                } else {
                    print("Increase Count");
                    count += 1;
                }
                partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
            } else {
                var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
                searchInd = endInd;
                let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
                if(firstLP < firstVariable){
                    firstVariable = firstLP;
                }
                endInd = (partPart.firstIndex(of: ",")) ?? partPart.endIndex;
                let firstC = String(partPart[partPart.startIndex..<endInd]).count;
                if(firstC < firstVariable){
                    found = true;
                    firstVariable = firstC;
                    searchInd = endInd;
                } else {
                    count += 1;
                }
                partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
            }
            splitCount += firstVariable + 1;
        }
        splitIndex = part.index(part.startIndex, offsetBy: splitCount);
        if( sign == "&"){
            let t1 = parseFunctionPartB(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
            let t2 = parseFunctionPartB(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
            return andNode(t1: t1, t2: t2);
        } else if( sign == ">"){
            let t1 = parseFunctionPart(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
            let t2 = parseFunctionPart(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
            return GreaterThanNode(t1 : t1, t2 : t2);
        } else if( sign == "<"){
            let t1 = parseFunctionPart(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
            let t2 = parseFunctionPart(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
            return LessThanNode(t1 : t1, t2 : t2);
        } else if( sign == "O"){
            let t1 = parseFunctionPartB(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
            let t2 = parseFunctionPartB(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
            return orNode(t1 : t1, t2 : t2);
        }
        return result;
    }
    
    func createAggNode(part : String) -> DoubleNode{
        print("Aggregate func: " + part);
        let result = NumberNode(t1: 0.0);
        var type = 0;
        type =  Int(part[part.index(after: part.startIndex)..<part.firstIndex(of: "]")!])!;
        if(type == 0){
            let t1 = parseFunctionPartB(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
            return CountNode(f: t1);
        } else if(type == 1){
            let t1 = parseFunctionPart(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
            return AverageNode(f: t1);
        } else if(type == 2){
            let t1 = parseFunctionPart(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
            return MaxNode(f: t1);
        } else if(type == 3){
            let t1 = parseFunctionPart(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
            return MinNode(f: t1);
        }
        return result;
    }
    
    func createDayFunctionB(part : String) -> BoolNode{
        print("Day Func Bool: " + part);
        var type = 0;
        type =  Int(part[part.index(after: part.startIndex)..<part.firstIndex(of: "]")!])!;
        if( type == 7){
            return DayFunctionBoolNode(dayFunction: Day.getFog);
        } else if( type == 8){
            return DayFunctionBoolNode(dayFunction: Day.getThunder);
        } else if( type == 9){
            return DayFunctionBoolNode(dayFunction: Day.getSmallHail);
        } else if( type == 10){
            return DayFunctionBoolNode(dayFunction: Day.getHail);
        } else if( type == 11){
            return DayFunctionBoolNode(dayFunction: Day.getGlaze);
        } else if( type == 12){
            return DayFunctionBoolNode(dayFunction: Day.getBlowingSand);
        } else if( type == 13){
            return DayFunctionBoolNode(dayFunction: Day.getHaze);
        } else if( type == 14){
            return DayFunctionBoolNode(dayFunction: Day.getBlowingSnow);
        }
        return GreaterThanNode(t1: NumberNode(t1: 0.0), t2: NumberNode(t1: 2.3));
    }
    
    func createDayFunction(part : String) -> DoubleNode{
        print("Day Func Double: " + part);
        var type = 0;
        type =  Int(part[part.index(after: part.startIndex)..<part.firstIndex(of: "]")!])!;
        if( type == 0){
            return DayFunctionDoubleNode(dayFunction: Day.getMinTemp);
        } else if( type == 1){
            return DayFunctionDoubleNode(dayFunction: Day.getMaxTemp);
        } else if( type == 2){
            return DayFunctionDoubleNode(dayFunction: Day.getAveTemp);
        } else if( type == 3){
            return DayFunctionDoubleNode(dayFunction: Day.getAveWind);
        } else if( type == 4){
            return DayFunctionDoubleNode(dayFunction: Day.getPercipitation);
        } else if( type == 5){
            return DayFunctionDoubleNode(dayFunction: Day.getSnow);
        } else if( type == 6){
            return DayFunctionDoubleNode(dayFunction: Day.getMaxGust);
        }
        
        return NumberNode(t1: 7.2);
    }
    
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var functionScroller: UIScrollView!
    
    @IBOutlet weak var functionDisplay: UITextView!
    
    @IBOutlet weak var functionDescription: UITextView!
    @objc func updateText(sender: numberedButton){
        functionDescription.text = functionDescriptions[sender.num];
        changeType = sender.num;
    }
    
    @IBAction func changeFunction(_ sender: Any) {
        
        changeIndex = functionString.firstIndex(of: changeCharacter);
        if(changeIndex != nil){
            functionString = String(functionString[functionString.startIndex..<changeIndex!]) + functionCodes[changeType] +
                String(functionString[functionString.index(after: changeIndex!)..<functionString.endIndex]);
        }
        print(functionString);
        var firstVariable = functionString.count;
        var endInd = (functionString.firstIndex(of: "D")) ?? functionString.endIndex;
        let firstD = String(functionString[functionString.startIndex..<endInd]).count;
        if(firstD < firstVariable){
            firstVariable = firstD;
            changeCharacter = "D";
        }
        endInd = (functionString.firstIndex(of: "Y")) ?? functionString.endIndex;
        let firstY = String(functionString[functionString.startIndex..<endInd]).count;
        if(firstY < firstVariable){
            firstVariable = firstY;
            changeCharacter = "Y";
        }
        endInd = (functionString.firstIndex(of: "Z")) ?? functionString.endIndex;
        let firstZ = String(functionString[functionString.startIndex..<endInd]).count;
        if(firstZ < firstVariable){
            firstVariable = firstZ;
            changeCharacter = "Z";
        }
        endInd = (functionString.firstIndex(of: "B")) ?? functionString.endIndex;
        let firstB = String(functionString[functionString.startIndex..<endInd]).count;
        if(firstB < firstVariable){
            firstVariable = firstB;
            changeCharacter = "B";
        }
        if(firstVariable == functionString.count){
            print("Function Completed");
            functionNode = parseFunctionPart(part: functionString);
            for n in 1...11{
                results.append(processCity(filename: "city" + String(n)));
            }
            results.sort(by: higherScore(a:b:))
            for a in results{
                print(a.cityName + " -> " + String(a.score));
            }
            resultButton.isHidden = false;
            return;
        }
        if(changeCharacter == "D"){
            functionNames = functionNamesD;
            functionDescriptions = functionDescriptionsD;
            functionCodes = functionCodesD;
        } else if(changeCharacter == "Z"){
            functionNames = functionNamesZ;
            functionDescriptions = functionDescriptionsZ;
            functionCodes = functionCodesZ;
        } else if(changeCharacter == "Y"){
            functionNames = functionNamesY;
            functionDescriptions = functionDescriptionsY;
            functionCodes = functionCodesY;
        }else if(changeCharacter == "B"){
            functionNames = functionNamesB;
            functionDescriptions = functionDescriptionsB;
            functionCodes = functionCodesB;
        }
        let funcString = functionPartString(part: functionString);
        let variableSelected = funcString.firstIndex(of: "X");
        functionDisplay.text = funcString[funcString.startIndex..<(variableSelected ?? funcString.endIndex)] + "[[X]]" + funcString[funcString.index(after: variableSelected ?? funcString.startIndex)..<funcString.endIndex];
        setButtons()
    }
    
    func higherScore(a : CityResult, b: CityResult) -> Bool {
        return a.score > b.score;
    }
    
    @IBOutlet weak var buttonsScroll: UIScrollView!
    
    func processCity(filename : String) -> CityResult{
        let fileURL = Bundle.main.path(forResource: filename, ofType: "txt")
        // Read from the file
        var readStringData = ""
        do {
            readStringData = try String(contentsOfFile: fileURL!, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL ?? "errrrorr"), Error: " + error.localizedDescription)
        }
        
        var data = readStringData.split(separator: ",")
        
        let myCity = City(title: String(data[0]), ltude: Double(data[1]) ?? 0, latude: Double(data[2]) ?? 0, elev: Double(data[3]) ?? 0);
        var index = 5;
        let daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
        for m in 1...12{
            let aMonth = Month();
            var date = 1;
            let monthSize = daysInMonth[m - 1];
            while(date <= monthSize){
                //print(String(m) + "\t" + String(date) + "\t" + String(data[index - 1]));
                aMonth.days.append(Day(aw: Double(data[index]) ?? 0, p: Double(data[index + 1]) ?? 0,
                                       s: Double(data[index + 3]) ?? 0, ta: Double(data[index + 4]) ?? 0,
                                       tmax: Int(data[index + 5]) ?? 0, tmin: Int(data[index + 6]) ?? 0, mg: Double(data[index + 8]) ?? 0, f: data[index + 9] != "0", hf: data[index + 10] != "0", th: data[index + 11] != "0", sh: data[index + 12] != "0", ha: data[index + 13] != "0", g: data[index + 14] != "0", bs: data[index + 15] != "0", hz: data[index + 16] != "0", bw: data[index + 17] != "0"))
                date += 1;
                index += 19;
            }
            myCity.months.append(aMonth);
        }
        
        allDays = [Day]();
        for m in 0...11{
            allDays += myCity.months[m].days
        }
        functionNode.days = allDays;
        return CityResult(name: myCity.name, total: functionNode.value());
    }
    
}



func functionPartString(part : String) -> String{
    print("Function Part: " + part);
    let result = "";
    let char = part[part.startIndex];
    print("Char: " + String(char));
    if(char == "-"){
        return operatorNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "-");
    } else if(char == "+"){
        return operatorNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "+");
    }else if(char == "/"){
        return operatorNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "/");
    }else if(char == "X"){
        return operatorNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "X");
    }else if(char == "A"){
        return aggNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
    } else if(char == "F"){
        return dayFunctionString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
    }else if(char == "N"){
        return numberNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
    } else if(char == "D"){
        return "X";
    } else if(char == "B"){
        return "X";
    } else if(char == "Y"){
        return "X";
    } else if(char == "Z"){
        return "X";
    }
    return result;
}

func numberNodeString(part : String) -> String{
    print("Number Node: " + part);
    let t1 = String(part[part.index(after: part.startIndex)..<part.index(before: part.endIndex)]);
    return " "  + t1 + " ";
}

func functionPartBString(part : String) -> String{
    print("Function Part: " + part);
    let char = part[part.startIndex];
    print("Char: " + String(char));
    if(char == "&"){
        return boolNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "&");
    } else if(char == "<"){
        return boolNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "<");
    }else if(char == ">"){
        return boolNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: ">");
    }else if(char == "O"){
        return boolNodeString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]), sign: "O");
    }else if(char == "F"){
        return dayFunctionBString(part: String(part[part.index(after: part.startIndex)..<part.endIndex]));
    }
    return "";
}

func operatorNodeString(part : String, sign : Character) -> String {
    print("Operator: " + part);
    let result = "";
    let subStr = part[part.index(after: part.startIndex)..<part.endIndex];
    var count = 1;
    var firstVariable = part.count;
    var partPart = String(subStr);
    var splitIndex = part.startIndex;
    var splitCount = 0;
    var tries = 0;
    var found = false;
    var searchInd = part.startIndex;
    while(!found && tries < 15){
        tries += 1;
        print("count: " + String(count) + "  " + String(splitCount) + "    " + partPart)
        firstVariable = partPart.count;
        if(count > 1){
            var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
            searchInd = endInd;
            let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
            if(firstLP < firstVariable){
                firstVariable = firstLP;
            }
            endInd = (partPart.firstIndex(of: ")")) ?? partPart.endIndex;
            let firstRP = String(partPart[partPart.startIndex..<endInd]).count;
            print("LP: " + String(firstLP) + " RP: " + String(firstRP));
            if(firstRP < firstVariable){
                print("Decrease Count");
                count -= 1;
                searchInd = endInd;
                firstVariable = firstRP;
            } else {
                print("Increase Count");
                count += 1;
            }
            partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
        } else {
            var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
            searchInd = endInd;
            let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
            if(firstLP < firstVariable){
                firstVariable = firstLP;
            }
            endInd = (partPart.firstIndex(of: ",")) ?? partPart.endIndex;
            let firstC = String(partPart[partPart.startIndex..<endInd]).count;
            if(firstC < firstVariable){
                found = true;
                firstVariable = firstC;
                searchInd = endInd;
            } else {
                count += 1;
            }
            partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
        }
        splitCount += firstVariable + 1;
    }
    splitIndex = part.index(part.startIndex, offsetBy: splitCount);
    let t1 = functionPartString(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
    let t2 = functionPartString(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
    if( sign == "-"){
        return "(" + t1 + " - " + t2 + ")";
    } else if( sign == "X"){
        return "(" + t1 + " * " + t2 + ")";
    } else if( sign == "+"){
        return "(" + t1 + " + " + t2 + ")";
    } else if( sign == "/"){
        return "(" + t1 + " / " + t2 + ")";
    }
    return result;
}

func notNodeString(part : String) -> String{
    print("Not: " + part);
    let t1 = functionPartBString(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
    return "not(" + t1 + ")";
}

func boolNodeString(part : String, sign : Character) -> String {
    print("BoolOperator: " + part);
    let result = "";
    let subStr = part[part.index(after: part.startIndex)..<part.endIndex];
    var count = 1;
    var firstVariable = part.count;
    var partPart = String(subStr);
    var splitIndex = part.startIndex;
    var splitCount = 0;
    var tries = 0;
    var found = false;
    var searchInd = part.startIndex;
    while(!found && tries < 15){
        tries += 1;
        print("count: " + String(count) + "  " + String(splitCount) + "    " + partPart)
        firstVariable = partPart.count;
        if(count > 1){
            var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
            searchInd = endInd;
            let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
            if(firstLP < firstVariable){
                firstVariable = firstLP;
            }
            endInd = (partPart.firstIndex(of: ")")) ?? partPart.endIndex;
            let firstRP = String(partPart[partPart.startIndex..<endInd]).count;
            print("LP: " + String(firstLP) + " RP: " + String(firstRP));
            if(firstRP < firstVariable){
                print("Decrease Count");
                count -= 1;
                searchInd = endInd;
                firstVariable = firstRP;
            } else {
                print("Increase Count");
                count += 1;
            }
            partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
        } else {
            var endInd = (partPart.firstIndex(of: "(")) ?? partPart.endIndex;
            searchInd = endInd;
            let firstLP = String(partPart[partPart.startIndex..<endInd]).count;
            if(firstLP < firstVariable){
                firstVariable = firstLP;
            }
            endInd = (partPart.firstIndex(of: ",")) ?? partPart.endIndex;
            let firstC = String(partPart[partPart.startIndex..<endInd]).count;
            if(firstC < firstVariable){
                found = true;
                firstVariable = firstC;
                searchInd = endInd;
            } else {
                count += 1;
            }
            partPart = String(partPart[partPart.index(after: searchInd)..<partPart.endIndex]);
        }
        splitCount += firstVariable + 1;
    }
    splitIndex = part.index(part.startIndex, offsetBy: splitCount);
    let t1 = functionPartBString(part: String(part[part.index(after: part.startIndex)..<splitIndex]));
    let t2 = functionPartBString(part: String(part[part.index(after: splitIndex)..<part.index(before: part.endIndex)]));
    if( sign == "&"){
        return "(" + t1 + " & " + t2 + ")";
    } else if( sign == ">"){
        return "(" + t1 + " & " + t2 + ")";
    } else if( sign == "<"){
        return "(" + t1 + " & " + t2 + ")";
    } else if( sign == "O"){
        return "(" + t1 + " & " + t2 + ")";
    }
    return result;
}

func aggNodeString(part : String) -> String{
    print("Aggregate func: " + part);
    let result = "";
    var type = 0;
    type =  Int(part[part.index(after: part.startIndex)..<part.firstIndex(of: "]")!])!;
    if(type == 0){
        var t1 = functionPartBString(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
        if(t1.count < 1){
            t1 = "X";
        }
        return "Count(" + t1 + ")";
    } else if(type == 1){
        var t1 = functionPartString(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
        if(t1.count < 1){
            t1 = "X";
        }
        return "Average(" + t1 + ")";
    } else if(type == 2){
        var t1 = functionPartString(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
        if(t1.count < 1){
            t1 = "X";
        }
        return "Max(" + t1 + ")";
    } else if(type == 3){
        var t1 = functionPartString(part: String(part[part.index(after: part.firstIndex(of: "(")!)..<part.index(before: part.endIndex)]));
        if(t1.count < 1){
            t1 = "X";
        }
        return "Min(" + t1 + ")";
    }
    return result;
}

func dayFunctionBString(part : String) -> String{
    print("Day Func Bool: " + part);
    var type = 0;
    type =  Int(part[part.index(after: part.startIndex)..<part.firstIndex(of: "]")!])!;
    if( type == 7){
        return "Fog";
    } else if( type == 8){
        return "Thunder";
    } else if( type == 9){
        return "Small Hail";
    } else if( type == 10){
        return "Hail";
    } else if( type == 11){
        return "Glaze";
    } else if( type == 12){
        return "Blowing Sand";
    } else if( type == 13){
        return "Haze";
    } else if( type == 14){
        return "Fog";
    }
    return "";
}

func dayFunctionString(part : String) -> String{
    print("Day Func Double: " + part);
    var type = 0;
    type =  Int(part[part.index(after: part.startIndex)..<part.firstIndex(of: "]")!])!;
    if( type == 0){
        return "Min Temp";
    } else if( type == 1){
        return "Max Temp";
    } else if( type == 2){
        return "Ave Temp";
    } else if( type == 3){
        return "Ave Wind";
    } else if( type == 4){
        return "Rain";
    } else if( type == 5){
        return "Snow";
    } else if( type == 6){
        return "Max Gust";
    }
    
    return "";
}
