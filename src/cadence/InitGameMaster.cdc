import Clues from 0x01
import Player from 0x02
import Game from 0x03

transaction {
  prepare(acct: AuthAccount) {

    acct.save<@Clues.ClueMinter>(<- Clues.createNewMinter(), to: /storage/clueMinter)
    acct.save<@Player.CloneBay>(<- Player.buildCloneBay(), to: /storage/cloneBay)
    acct.save<@Game.GameMaster>(<- Game.summonGameMaster(), to: /storage/gameMaster)

    let clueMinterRef = acct.borrow<&Clues.ClueMinter>(from: /storage/clueMinter)!
    let cloneBayRef = acct.borrow<&Player.CloneBay>(from: /storage/cloneBay)!
    //let gameMaster = acct.borrow<&Game.GameMaster>(from: /storage/gameMaster)!

    gameMaster.setup(clueMinter: clueMinterRef, cloneBay: cloneBayRef)
    gameMaster.ping()

    log("Initial setup complete")
  }
}
