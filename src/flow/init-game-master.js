import * as fcl from "@onflow/fcl";
import * as sdk from "@onflow/sdk";
import * as types from "@onflow/types";
import loadContract from "../utils/load-contract";
import initGameMasterTransaction from "../cadence/InitGameMaster.cdc";

import {
  cluesCodeAddress,
  playerCodeAddress,
  gameMasterAddress
} from "../flow/addresses";

export default async () => {
  const user = fcl.currentUser();
  const { authorization } = user;
  const code = await loadContract(initGameMasterTransaction, {
    query: /(0x01|0x02|0x03)/g,
    "0x01": cluesCodeAddress,
    "0x02": playerCodeAddress,
    "0x03": gameMasterAddress
  });

  return fcl.send([
    sdk.transaction(code),
    fcl.proposer(authorization),
    fcl.payer(authorization),
    fcl.authorizations([authorization]),
    fcl.limit(100)
  ]);
};
