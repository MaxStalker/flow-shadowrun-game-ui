/*
  Prerequisited: Contracts from 0x01, 0x02 and 0x03 are deployed
  Instructions:
    - Pick 0x03 and then 0x04 as signers for this transaction
*/

import Player from 0x02
import Game from 0x03

transaction {
  prepare(admin: Account, player: Account) {
    let gameMaster = &admin.storage[Game.GameMaster] as &Game.GameMaster
    gameMaster.purge()

    // Uncomment if you want to reset the game
    let oldSinner <- player.storage[Player.Runner] <- gameMaster.summonSinner();
    destroy oldSinner

    // Create reference to player's Runner
    let runner = &player.storage[Player.Runner]as &Player.Runner

    log("------> Check Runner name:")
    runner.ping()
    log("------> Current Location:")
    runner.logCurrentLocation() 

    log("------> Look around for items and clues")
    gameMaster.exploreCurrentLocation(runner: runner)

    log("------> You have found a map!")
    log(runner.listItems(itemType: "MAP"))

    log("------> Try to examine this map")
    gameMaster.examine(runner: runner, itemType: "MAP", itemId: UInt16(2))
    log(runner.listItems(itemType: "LOCATION"))

    log("------> There is a new location you would like to visit")
    runner.goTo(locationId: UInt16(3)) 
    runner.logCurrentLocation()
    log(runner.listItems(itemType: "LOCATION"))

    log("------> Take a look around for items, quests and clues")
    gameMaster.exploreCurrentLocation(runner: runner)
    log("------> You have got new quest - Bring Cough Medecine from secret stash in Junkyard")
    log("------> You have got new quest item - Rusted Key")
    log(runner.listItems(itemType: "LOCATION"))
    log(runner.listItems(itemType: "KEY"))

    log("------> You walk to Junkyard")
    runner.goTo(locationId: UInt16(5)) 
    log("------> You try to find a box")
    runner.logCurrentLocation()
    gameMaster.exploreCurrentLocation(runner: runner)
    log("------> You have found a box")
    log(runner.listItems(itemType: "CHEST"))
  }
}