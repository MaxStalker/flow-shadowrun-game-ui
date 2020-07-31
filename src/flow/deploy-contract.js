import * as fcl from "@onflow/fcl";
import * as sdk from "@onflow/sdk";
import * as types from "@onflow/types";
import loadContract from "../utils/load-contract";

export default async (url, params) => {
  const user = fcl.currentUser();
  const { authorization } = user;
  const code = await loadContract(url, params);
  return fcl.send(
    [
      sdk.transaction`
          transaction(code: String) {
            prepare(acct: AuthAccount) {
              acct.setCode(code.decodeHex())
            }
          }
        `,
      fcl.args([
        fcl.arg(
          Buffer.from(code, "utf8").toString("hex"),
          types.Identity,
          "code"
        )
      ]),
      fcl.proposer(authorization),
      fcl.payer(authorization),
      fcl.authorizations([authorization]),
      fcl.limit(100)
    ],
    {
      node: "http://localhost:8080"
    }
  );
};
