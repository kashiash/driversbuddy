//
//  CanvasObservableModel.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 13/03/2024.
//

import Foundation

@MainActor

@Observable final class CanvasObservableModel {


    public var selectedDamage : CarDamage? = nil




  func start() async {
    // MainActor here
    _ =  await doWork()
  }

  // nonisolated means that this function did not work in main actor
  private nonisolated func doWork() async -> Bool {
    // Which actor?
    sleep(10)
    return true
  }
}
