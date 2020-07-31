import * as fcl from "@onflow/fcl";
import * as sdk from "@onflow/sdk";

export default async () => {
  const response = await fcl.send([
    sdk.script`
      pub fun main():Int {
        log("Logging is awesome")
        return 42
      }
    `
  ]);

  const result = await fcl.decode(response);
  console.log({ result });
};
