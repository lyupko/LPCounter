//
//  Counter.swift
//  TestCounter
//
//  Created by Lyubomyr Hlozhyk on 8/1/16.
//  Copyright © 2016 Lyupko. All rights reserved.
//

import Foundation

public class LPCounter {
    
    //MARK: - Private Properties
    
    private var startTime: CFAbsoluteTime?

    private var endTime: CFAbsoluteTime?
    
    private var topCounter: LPTopCounter?
    
    private var identifier: String?
    
    
    //MARK: - Public Properties
    
    public var durationElapsed: CFAbsoluteTime? {
        guard let hasStartTime = self.startTime else {
            print("Duration haven't startTime")
            return nil
        }
        return CFAbsoluteTimeGetCurrent() - hasStartTime
    }
    
    public var totalTime: CFAbsoluteTime? = 0.0
    
    //MARK: - Constructors
    
    public convenience init(startImmediately now: Bool, topCounter: LPTopCounter, globalIdentifier: String = #function) {
        self.init(startImmediately: now)
        self.topCounter = topCounter
        self.identifier = globalIdentifier
    }
    
    public init(startImmediately now: Bool) {
        if now {
            start()
        }
    }
    
    deinit {
        guard self.startTime != nil && self.endTime != nil else {
            return
        }
        self.stop()
    }
    
    //MARK: - Private methods
    
    private func addElapsedTime(time: CFAbsoluteTime?) {
        
        guard time != nil else {
            print("Duration haven't startTime")
            return
        }
        
        if let counter = topCounter {
            counter.add(time!, from: identifier!)
        }
    }
    
    //MARK: - Public methods
    
    public func start() {
        if self.startTime == nil {
            self.startTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    public func reset() {
        self.startTime = nil
        self.endTime = nil
        self.totalTime = nil
    }
    
    public func stop() {
        defer {
            self.startTime = nil
            self.endTime = nil
        }
        
        guard let hasStartTime = self.startTime else {
            print("Duration haven't startTime")
            return
        }
        
        self.endTime = CFAbsoluteTimeGetCurrent()
        totalTime = self.endTime! - hasStartTime
        addElapsedTime(self.endTime! - hasStartTime)
    }
    
    // MARK: - Methods of class
    
    public static func durationFunc <A> (@autoclosure f: () -> A) -> (result: A, duration: CFAbsoluteTime) {
        let timer = LPCounter(startImmediately: false)
        timer.start()
        let result = f()
        timer.stop()
        return (result, timer.totalTime!)
    }
    
}

