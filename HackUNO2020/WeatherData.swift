//
//  WeatherData.swift
//  HackUNO2020
//
//  Created by Christopher Phillips on 3/7/20.
//  Copyright © 2020 Lion275. All rights reserved.
//

import Foundation

class CityResult{
    var score : Double;
    var cityName : String;
    init(name: String, total: Double){
        cityName = name;
        score = total;
    }
}

class City{
    var months = [Month]();
    var name : String;
    var longitude : Double;
    var laditude : Double;
    var elevation : Double;
    init(title : String, ltude : Double, latude : Double, elev : Double){
        months = [Month]();
        longitude = ltude;
        laditude = latude;
        elevation = elev;
        name = title;
    }
}

class Month{
    var days = [Day]();
    init(){
        days = [Day]();
    }
}

class Day{
    var aveWind : Double;
    var percipitation : Double;
    var snow : Double;
    var tempAve : Double;
    var tempMax : Int;
    var tempMin : Int;
    var maxGust : Double;
    var fog : Bool;
    var thunder : Bool;
    var smallHail : Bool;
    var hail : Bool;
    var glaze : Bool;
    var blowingSand : Bool;
    var haze : Bool;
    var blowingSnow : Bool;
    
    init(aw : Double,p : Double,s : Double,ta : Double,tmax : Int,tmin : Int,mg : Double,
         f : Bool,hf : Bool,th : Bool, sh : Bool, ha : Bool, g : Bool, bs : Bool, hz : Bool, bw : Bool){
        aveWind = aw;
        percipitation = p;
        snow = s;
        tempAve = ta;
        tempMax = tmax;
        tempMin = tmin;
        maxGust = mg;
        fog = f || hf;
        thunder = th;
        smallHail = sh;
        hail = ha;
        glaze = g;
        blowingSand = bs;
        haze = hz;
        blowingSnow = bw;
    }
    
    class func getAveWind(d : Day) -> Double{
        return d.aveWind;
    }
    class func getPercipitation(d : Day) -> Double{
        return d.percipitation;
    }
    class func getSnow(d : Day) -> Double{
        return d.snow;
    }
    class func getAveTemp(d : Day) -> Double{
        return d.tempAve;
    }
    class func getMaxTemp(d : Day) -> Double{
        return Double(d.tempMax);
    }
    class func getMinTemp(d : Day) -> Double{
        return Double(d.tempMin);
    }
    class func getMaxGust(d : Day) -> Double{
        return d.maxGust;
    }
    class func getFog(d : Day) -> Bool{
        return d.fog;
    }
    class func getThunder(d : Day) -> Bool{
        return d.thunder;
    }
    class func getSmallHail(d : Day) -> Bool{
        return d.smallHail;
    }
    class func getHail(d : Day) -> Bool{
        return d.hail;
    }
    class func getGlaze(d : Day) -> Bool{
        return d.fog;
    }
    class func getBlowingSand(d : Day) -> Bool{
        return d.blowingSand;
    }
    class func getHaze(d : Day) -> Bool{
        return d.haze;
    }
    class func getBlowingSnow(d : Day) -> Bool{
        return d.blowingSnow;
    }
}
