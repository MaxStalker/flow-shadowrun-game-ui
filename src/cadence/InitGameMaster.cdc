import Clues from 0x01
import Player from 0x02
import Game from 0x03

transaction {
  prepare(clueMaster: Account) {
    let clueMinter = &clueMaster.storage[Clues.ClueMinter] as &Clues.ClueMinter
    let cloneBay = &cloneMaster.storage[Player.CloneBay] as &Player.CloneBay
    let gameMaster = &admin.storage[Game.GameMaster] as &Game.GameMaster

    gameMaster.setup(clueMinter: clueMinter, cloneBay: cloneBay)
    gameMaster.ping()

    log("Initial setup complete")
  }
}
