//
//  HKWorkoutActivityType+Ext.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 22/3/25.
//

import HealthKit
import SwiftUI

extension HKWorkoutActivityType {

    /*
     Simple mapping of available workout types to a human readable name.
     */
    var name: String {
        switch self {
        case .americanFootball:             return "American Football"
        case .archery:                      return "Archery"
        case .australianFootball:           return "Australian Football"
        case .badminton:                    return "Badminton"
        case .baseball:                     return "Baseball"
        case .basketball:                   return "Basketball"
        case .bowling:                      return "Bowling"
        case .boxing:                       return "Boxing"
        case .climbing:                     return "Climbing"
        case .crossTraining:                return "Cross Training"
        case .curling:                      return "Curling"
        case .cycling:                      return "Cycling"
        case .dance:                        return "Dance"
        case .danceInspiredTraining:        return "Dance Inspired Training"
        case .elliptical:                   return "Elliptical"
        case .equestrianSports:             return "Equestrian Sports"
        case .fencing:                      return "Fencing"
        case .fishing:                      return "Fishing"
        case .functionalStrengthTraining:   return "Functional Strength Training"
        case .golf:                         return "Golf"
        case .gymnastics:                   return "Gymnastics"
        case .handball:                     return "Handball"
        case .hiking:                       return "Hiking"
        case .hockey:                       return "Hockey"
        case .hunting:                      return "Hunting"
        case .lacrosse:                     return "Lacrosse"
        case .martialArts:                  return "Martial Arts"
        case .mindAndBody:                  return "Mind and Body"
        case .mixedMetabolicCardioTraining: return "Mixed Metabolic Cardio Training"
        case .paddleSports:                 return "Paddle Sports"
        case .play:                         return "Play"
        case .preparationAndRecovery:       return "Preparation and Recovery"
        case .racquetball:                  return "Racquetball"
        case .rowing:                       return "Rowing"
        case .rugby:                        return "Rugby"
        case .running:                      return "Running"
        case .sailing:                      return "Sailing"
        case .skatingSports:                return "Skating Sports"
        case .snowSports:                   return "Snow Sports"
        case .soccer:                       return "Soccer"
        case .softball:                     return "Softball"
        case .squash:                       return "Squash"
        case .stairClimbing:                return "Stair Climbing"
        case .surfingSports:                return "Surfing Sports"
        case .swimming:                     return "Swimming"
        case .tableTennis:                  return "Table Tennis"
        case .tennis:                       return "Tennis"
        case .trackAndField:                return "Track and Field"
        case .traditionalStrengthTraining:  return "Traditional Strength Training"
        case .volleyball:                   return "Volleyball"
        case .walking:                      return "Walking"
        case .waterFitness:                 return "Water Fitness"
        case .waterPolo:                    return "Water Polo"
        case .waterSports:                  return "Water Sports"
        case .wrestling:                    return "Wrestling"
        case .yoga:                         return "Yoga"

        // iOS 10
        case .barre:                        return "Barre"
        case .coreTraining:                 return "Core Training"
        case .crossCountrySkiing:           return "Cross Country Skiing"
        case .downhillSkiing:               return "Downhill Skiing"
        case .flexibility:                  return "Flexibility"
        case .highIntensityIntervalTraining:    return "High Intensity Interval Training"
        case .jumpRope:                     return "Jump Rope"
        case .kickboxing:                   return "Kickboxing"
        case .pilates:                      return "Pilates"
        case .snowboarding:                 return "Snowboarding"
        case .stairs:                       return "Stairs"
        case .stepTraining:                 return "Step Training"
        case .wheelchairWalkPace:           return "Wheelchair Walk Pace"
        case .wheelchairRunPace:            return "Wheelchair Run Pace"

        // iOS 11
        case .taiChi:                       return "Tai Chi"
        case .mixedCardio:                  return "Mixed Cardio"
        case .handCycling:                  return "Hand Cycling"

        // iOS 13
        case .discSports:                   return "Disc Sports"
        case .fitnessGaming:                return "Fitness Gaming"

        // Catch-all
        default:                            return "Other"
        }
    }
    
    /// Returns an SF Symbol representing each workout type.
        var image: String {
            switch self {
            case .americanFootball:             return "football.fill"
            case .archery:                      return "target"
            case .badminton, .racquetball:      return "tennis.racket"
            case .baseball:                     return "baseball.fill"
            case .basketball:                   return "basketball.fill"
            case .bowling:                      return "figure.bowling"
            case .boxing, .martialArts:         return "figure.boxing"
            case .climbing:                     return "figure.climbing"
            case .crossTraining:                return "figure.highintensity.intervaltraining"
            case .curling:                      return "curling.stone"
            case .cycling:                      return "bicycle"
            case .dance, .danceInspiredTraining: return "figure.dance"
            case .elliptical:                   return "figure.elliptical"
            case .fencing:                      return "figure.fencing"
            case .fishing:                      return "fish.fill"
            case .functionalStrengthTraining,
                 .traditionalStrengthTraining:  return "figure.strengthtraining.traditional"
            case .golf:                         return "figure.golf"
            case .gymnastics:                   return "figure.gymnastics"
            case .hiking:                       return "figure.hiking"
            case .hockey:                       return "hockey.puck.fill"
            case .lacrosse:                     return "lacrosse.stick"
            case .paddleSports:                 return "figure.rower"
            case .rowing:                       return "rowing.machine.fill"
            case .rugby:                        return "rugbyball.fill"
            case .running:                      return "figure.run"
            case .crossCountrySkiing, .downhillSkiing: return "figure.skiing.downhill"
            case .skatingSports:                return "skates.fill"
            case .snowboarding:                 return "figure.snowboarding"
            case .soccer:                       return "soccerball"
            case .softball:                     return "softball.fill"
            case .squash:                       return "tennisball"
            case .stairClimbing:                return "figure.stair.stepper"
            case .surfingSports:                return "figure.surfing"
            case .swimming:                     return "figure.pool.swim"
            case .tableTennis:                  return "tabletennis.racket"
            case .tennis:                       return "tennisball.fill"
            case .trackAndField:                return "medal.fill"
            case .volleyball:                   return "volleyball.fill"
            case .walking:                      return "figure.walk"
            case .waterFitness, .waterPolo, .waterSports: return "figure.pool.swim"
            case .wrestling:                    return "figure.wrestling"
            case .yoga:                         return "figure.yoga"
            case .coreTraining:                 return "figure.core.training"
            case .highIntensityIntervalTraining: return "figure.highintensity.intervaltraining"
            case .jumpRope:                     return "figure.jumprope"
            case .kickboxing:                   return "figure.kickboxing"
            case .pilates:                      return "figure.pilates"
            case .taiChi:                       return "figure.taichi"
            case .mixedCardio:                  return "figure.mixed.cardio"
            case .handCycling:                  return "bicycle"
            case .discSports:                   return "figure.disc.sports"
            case .fitnessGaming:                return "gamecontroller.fill"
            default:                            return "figure.exercise"
            }
        }
    
    /// Returns a SwiftUI color associated with each workout type.
        var color: Color {
            
            switch self {
            case .running, .cycling, .hiking, .walking:
                return Color.green
            case .swimming, .waterFitness, .waterPolo, .waterSports:
                return Color.teal
            case .yoga, .mindAndBody, .pilates:
                return Color.green
            case .climbing, .functionalStrengthTraining, .traditionalStrengthTraining:
                return Color.blue
            case .boxing, .martialArts, .wrestling:
                return Color.red
            case .dance, .danceInspiredTraining:
                return Color.purple
            case .rowing:
                return Color.yellow
            case .snowboarding:
                return Color.indigo
            case .elliptical, .stairClimbing:
                return Color.pink
            case .golf:
                return Color.green
            case .tennis, .tableTennis:
                return Color.orange
            case .baseball, .basketball, .soccer, .volleyball:
                return Color.red
            case .badminton, .racquetball, .squash:
                return Color.pink
            case .crossCountrySkiing, .downhillSkiing:
                return Color.indigo
            case .surfingSports, .snowSports:
                return Color.teal
            case .hockey:
                return Color.red
            case .skatingSports:
                return Color.purple
            case .equestrianSports:
                return Color.brown
            case .fishing, .hunting:
                return Color.pink
            case .handball, .lacrosse:
                return Color.pink
            case .play, .preparationAndRecovery:
                return Color.yellow
            case .discSports, .fitnessGaming:
                return Color.green
            case .mixedMetabolicCardioTraining, .mixedCardio, .highIntensityIntervalTraining:
                return Color.orange
            case .coreTraining, .stepTraining, .jumpRope, .barre, .flexibility:
                return Color.pink
            case .wheelchairWalkPace, .wheelchairRunPace, .handCycling:
                return Color.blue
                
            // Catch-all
            default:
                return Color.green
                 
            }
        }

}
