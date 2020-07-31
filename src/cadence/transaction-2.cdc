/*
  Prerequisited: Shadowrun contract from 0x01, 0x02 and 0x03 are deployed
  Instructions:
    - Pick 0x01 then 0x02 then 0x03 as signers for this transaction
*/

import Clues from 0x01
import Player from 0x02
import Game from 0x03

transaction {
  prepare(clueMaster: Account, cloneMaster: Account, admin: Account) {
    let clueMinter = &clueMaster.storage[Clues.ClueMinter] as &Clues.ClueMinter
    let cloneBay = &cloneMaster.storage[Player.CloneBay] as &Player.CloneBay
    let gameMaster = &admin.storage[Game.GameMaster] as &Game.GameMaster

    gameMaster.setup(clueMinter: clueMinter, cloneBay: cloneBay)
    gameMaster.ping()

    log("Initial setup complete")
  }
}