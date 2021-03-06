import React, { useState, useEffect } from "react";
import * as fcl from "@onflow/fcl";
import "./App.css";

// Flow Interactions
import simpleScript from "./flow/simple-script";
import deployContract from "./flow/deploy-contract";
import initGameMaster from "./flow/init-game-master";

// Cadence Files
import cluesContractUrl from "./cadence/Clues.cdc";
import playerContractUrl from "./cadence/Player.cdc";
import gameContractUrl from "./cadence/Game.cdc";

fcl
  .config()
  .put("challenge.handshake", "http://localhost:8701/flow/authenticate");
// .put("accessNode", "http://localhost:8080")

const deployCluesContract = async () => {
  const deployTx = await deployContract(cluesContractUrl);

  fcl.tx(deployTx).subscribe(txStatus => {
    if (fcl.tx.isExecuted(txStatus)) {
      console.log("Clues Contract was deployed");
    }
  });
};

const deployPlayerContract = async () => {
  const deployTx = await deployContract(playerContractUrl, {
    query: /(0x01)/g,
    "0x01": "0x01cf0e2f2f715450"
  });

  fcl.tx(deployTx).subscribe(txStatus => {
    if (fcl.tx.isExecuted(txStatus)) {
      console.log("Player Contract was deployed");
    }
  });
};

const deployGameContract = async () => {
  const deployTx = await deployContract(gameContractUrl, {
    query: /(0x01|0x02)/g,
    "0x01": "0x01cf0e2f2f715450",
    "0x02": "0x179b6b1cb6755e31",
    "0x03": "0xf3fcd2c1a78f5eee"
  });

  fcl.tx(deployTx).subscribe(txStatus => {
    if (fcl.tx.isExecuted(txStatus)) {
      console.log("Game Contract was deployed");
    }
  });
};

const summonGameMaster = async () => {
  console.log("Start Summoning");
  const summonTx = await initGameMaster();

  fcl.tx(summonTx).subscribe(txStatus => {
    if (fcl.tx.isExecuted(txStatus)) {
      console.log("Summoning has been completed!");
    }
  });
};

function App() {
  const [user, setUser] = useState(null);

  useEffect(() => fcl.currentUser().subscribe(setUser), []);

  const loggedIn = user && user.cid;

  return (
    <div>
      {loggedIn ? (
        <div>
          <p>Your address:</p>
          <p>{user.addr}</p>
          <div>
            <button onClick={deployCluesContract}>Deploy Clues Contract</button>
            <button onClick={deployPlayerContract}>
              Deploy Player Contract
            </button>
            <button onClick={deployGameContract}>Deploy Game Contract</button>
          </div>
          <button onClick={summonGameMaster}>Summon Game Master</button>
          <button onClick={fcl.unauthenticate}>Logout</button>
        </div>
      ) : (
        <button onClick={fcl.authenticate}>Login</button>
      )}
      <button onClick={simpleScript}>Click me</button>
    </div>
  );
}

export default App;
