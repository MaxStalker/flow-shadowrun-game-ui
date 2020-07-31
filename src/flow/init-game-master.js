import * as fcl from "@onflow/fcl";
import * as sdk from "@onflow/sdk";
import loadContract from "../utils/load-contract";
import initGameMasterTransaction from "../cadence/InitGameMaster.cdc";

import {
  cluesCodeAddress,
  playerCodeAddress,
  gameMasterAddress
} from "./addresses";

export default async () => {
  const user = fcl.currentUser();
  const { authorization } = user;
/*  const code = await loadContract(initGameMasterTransaction, {
    query: /(0x01|0x02|0x03)/g,
    "0x01": cluesCodeAddress,
    "0x02": playerCodeAddress,
    "0x03": gameMasterAddress
  });
  */
  const code = `
  import Clues from ${cluesCodeAddress}
  import Player from ${playerCodeAddress}
  import Game from ${gameMasterAddress}
  
  transaction {
    prepare(acct: AuthAccount) {
  
      acct.save<@Clues.ClueMinter>(<- Clues.createNewMinter(), to: /storage/clueMinter)
      acct.save<@Player.CloneBay>(<- Player.buildCloneBay(), to: /storage/cloneBay)
      acct.save<@Game.GameMaster>(<- Game.summonGameMaster(), to: /storage/gameMaster)
  
      let clueMinterRef = acct.borrow<&Clues.ClueMinter>(from: /storage/clueMinter)!
      let cloneBayRef = acct.borrow<&Player.CloneBay>(from: /storage/cloneBay)!
      let gameMaster = acct.borrow<&Game.GameMaster>(from: /storage/gameMaster)!
  
      gameMaster.setup(clueMinter: clueMinterRef, cloneBay: cloneBayRef)
      gameMaster.ping()
  
      log("Initial setup complete")
    }
  }
  `

  return fcl.send([
    sdk.transaction(code),
    fcl.proposer(authorization),
    fcl.payer(authorization),
    fcl.authorizations([authorization]),
    fcl.limit(100)
  ]);
};
