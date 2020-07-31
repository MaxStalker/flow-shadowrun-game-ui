import React from "react";
import * as fcl from "@onflow/fcl";

import simpleScript from "./flow/simple-script";


fcl
  .config()
  .put("challenge.handshake", "http://localhost:8701/flow/authenticate")
  // .put("accessNode", "http://localhost:8080")

function App() {
  return (
    <div>
      <button onClick={simpleScript}>Click me</button>
    </div>
  );
}

export default App;
