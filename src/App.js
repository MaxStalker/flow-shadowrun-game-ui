import React, { useState, useEffect } from "react";
import * as fcl from "@onflow/fcl";
import "./App.css";

// Flow Interactions
import simpleScript from "./flow/simple-script";
import deployContract from './flow/deploy-contract';

// Cadence Files
import cluesContract from "./cadence/Clues.cdc";

fcl
  .config()
  .put("challenge.handshake", "http://localhost:8701/flow/authenticate");
// .put("accessNode", "http://localhost:8080")

const deployCluesContract = async () => {};

const deployPlayerContract = async () => {};

const deployGameContract = async () => {};

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
          <button onClick={() => {}}>Deploy Contract</button>
        </div>
      ) : (
        <button onClick={fcl.authenticate}>Login</button>
      )}
      <button onClick={simpleScript}>Click me</button>
    </div>
  );
}

export default App;
