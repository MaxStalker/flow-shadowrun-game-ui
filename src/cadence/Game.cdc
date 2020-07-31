import Clues from 0x01cf0e2f2f715450
import Player from 0x179b6b1cb6755e31

access(all) contract Game{
    access(all) resource GameMaster{
        access(all) var clueCounter: UInt16
        access(all) var runnerCounter: UInt16
        access(all) var cloneBay: &Player.CloneBay?
        access(all) var clueMinter: &Clues.ClueMinter?
        access(all) let rewards: {String: [Clues.Reward]}

        init() {
            self.clueCounter = 1
            self.runnerCounter = 1
            self.cloneBay = nil
            self.clueMinter = nil
            self.rewards = {
                // Location based rewards
                "Head Quarters": [ Clues.Reward(name: "Seattle Map", rewardType: "MAP") ],
                "Black Market": [ Clues.Reward(name: "Rusted Key", rewardType: "KEY"), Clues.Reward(name: "Junkyard", rewardType: "LOCATION") ],
                "Junkyard": [ Clues.Reward(name: "Rusted Metalic Box", rewardType: "CHEST") ],
                "Library": [ Clues.Reward(name: "Dragon Book", rewardType: "ITEM"), Clues.Reward(name: "DnD Magazine", rewardType: "ITEM") ],
                "Dragon Chamber": [ Clues.Reward(name: "ENDGAME", rewardType: "ITEM")],

                // Item based rewards
                "Seattle Map": [ Clues.Reward(name: "Black Market", rewardType: "LOCATION") ],
                "Library Card": [ Clues.Reward(name: "Library", rewardType: "LOCATION") ],
                "Dragon Book": [ Clues.Reward(name: "Dragon Shaped Jade Key", rewardType: "KEY") ],

                // Quest rewards
                // "Quest - Start - Heal Me": [ Clues.Reward(name: "Junkyard", rewardType: "LOCATION"), Clues.Reward( name: "Rusted Key", rewardType: "KEY") ],
                // "Quest - End - Heal Me": [ Clues.Reward(name: "Dragon Temple", rewardType: "LOCATION") ],

                // Chest rewards
                "Rusted Metalic Box": [ Clues.Reward(name: "Cough Medecine", rewardType: "ITEM"), Clues.Reward(name: "Library Card", rewardType: "ITEM") ],

                // Doors and Gates
                "Dragon Fountain": [ Clues.Reward(name: "Dragon Chamber", rewardType: "LOCATION")]
            }
        }

        destroy(){
          // Clean up and destroy resources
          // destroy self.cloneBay
          // destroy self.minter
        }

        // ⚠ IMPORTANT: This is only for test purposes!
        access(all) fun purge(){
            self.clueCounter = 1
            self.runnerCounter = 1
        }

        access(all) fun setup(clueMinter: &Clues.ClueMinter, cloneBay: &Player.CloneBay) {
          self.clueMinter = clueMinter
          self.cloneBay = cloneBay
        }

        access(all) fun ping(){
          log("Hey, there 👋! Have some fun! 😉")
        }

        pub fun getName(id: UInt16): String {
          let names = [
          "Abaccus",
          "Bazillion",
          "Conspirator",
          "Dimitri",
          "Eidelon Prime",
          "Figlimaton",
          "Gramatron Dew"
          ]
          return names[Int(id) % names.length]
        }

        pub fun getLocationDescription(location: String): String {
            let descriptions = {
              "Library" : "The old town library lost it's function, when Matrix become widely available. It's more of a landmark right now, which also serves as storage for old books",
              "Junkyard" : "Favorite place of rats and junkers. You can also buy and sell some rare stuff. Though usually it's a junk from nearby pile, but you never know, what might end up there.",
              "Black Market" : "Out of all places in town, you want to spend here the least amount of time. Trust my metalic kidney",
              "DocWagon Clinic": "The life of the Runner is not only glitter and unicorns. Sometimes you get wounded. Sometimes you need an arm replacement or you have an extra one to share with your local chummer",
              "Dragon Temple": "Old temple located on the outskirts of town. Surpisingly it looks like an old mansion with dragon shaped shapes here and there."
            }
            return descriptions[location] ?? "Some random place nobody cares"
        }

        access(all) fun getEventText(_ eventName: String): String {
          let eventLogs = {
            "EXPLORE-MAP": "You decide to spent some time and examine the map in details. You read the legend and analyzed the paths to each of those outlined locations and now know how to get there",
            "CHEST-REWARD": "You've succesfully opened a chest and found ",
            "CHEST-DUST": "You've found nothing of value. Sorry..."
            }
          return eventLogs[eventName] ?? "😇 GOD Subroutine: ⚙ Bug in Matrix. Replaying last 5 seconds ⚙"
        }

        access(all) fun emitGameEvent(_ eventName: String, _ description: String?){
            let eventText = self.getEventText(eventName)
            let maybeDescription = description ?? ""
            log("Game Master: ".concat(eventText).concat(maybeDescription))
        }

        access(all) fun summonSinner(): @Player.Runner? {
          self.runnerCounter = self.runnerCounter + UInt16(1)
          let runnerName = self.getName(id: self.runnerCounter)
          if let minter = self.clueMinter{
            if let cloneBay = self.cloneBay{
              let startingLocation <- minter.createLocation(id: UInt16(0), name: "Head Quarters" , description: "This is your starting point")
              return <- cloneBay.createRunner(id: self.runnerCounter, name: runnerName, startingLocation: <- startingLocation)
            }
          }
          return nil
        }

        access(all) fun giveMap(runner: &Player.Runner, mapName: String){
          /*  ⚠ REFACTOR:  Move out of here */
          let descriptions = {
            "Seattle Map" : "Pretty torn out map of Seattle. Several landmarks are outlined with red and blue marker"
          }
          if let minter = self.clueMinter{
            self.clueCounter = self.clueCounter + UInt16(1)
            var newMap <- minter.createMap(id: self.clueCounter, name: mapName, description: descriptions[mapName])
            runner.pocket(clue: <- newMap)
          }
        }

        access(all) fun giveLocation(runner: &Player.Runner, locationName: String){
          /*  ⚠ REFACTOR:  Move out of here */
          let descriptions = {
            "Black Market" : "This is your usual market in Chineese district. The word Black comes from the fact that it only works during night time",
            "Junkyard" : "Two blocks away from Black Market there is old (almost) abandoned Junkyard - ideal place for junkers and homeless"
          }
          if let minter = self.clueMinter{
            self.clueCounter = self.clueCounter + UInt16(1)
            var newMap <- minter.createLocation(id: self.clueCounter, name: locationName, description: descriptions[locationName])
            runner.pocket(clue: <- newMap)
          }
        }

        access(all) fun giveKey(runner: &Player.Runner, keyName: String){
          /*  ⚠ REFACTOR:  Move out of here */
          let descriptions = {
            "Rusted Key" : "Ordinary iron key. A bit rusted on the side"
          }
          if let minter = self.clueMinter{
            self.clueCounter = self.clueCounter + UInt16(1)
            var newKey <- minter.createKey(id: self.clueCounter, name: keyName, description: descriptions[keyName])
            runner.pocket(clue: <- newKey)
          }
        }

        access(all) fun giveChest(runner: &Player.Runner, chestName: String){
          /*  ⚠ REFACTOR:  Move out of here */
          let descriptions = {
            "Rusted Metalic Box" : "Rusted metalic box, which was used to store candies. Now sports small lock on the side"
          }
          let locks = {
            "Rusted Metalic Box": Clues.LockDetails(lockedWidth: "Rusted Key", locationLocked: nil),
            "Dragon Fountain" : Clues.LockDetails(lockedWidth: "Jade Key", locationLocked: "Dragon Temple")
          }
          if let minter = self.clueMinter{
            self.clueCounter = self.clueCounter + UInt16(1)
            let lockDetails = locks[chestName] ?? Clues.LockDetails(lockedWidth: "Not locked", locationLocked: nil)
            var newKey <- minter.createChest(id: self.clueCounter, name: chestName, description: descriptions[chestName], lockDetails: lockDetails)
            runner.pocket(clue: <- newKey)
          }
        }
        
        access(all) fun examine(runner: &Player.Runner, itemType: String, itemId: UInt16){
          if let mapping = runner.getMappingRef(itemType: itemType) {
            if let clueType = mapping[itemId]?.clueType{
              let name = mapping[itemId]?.name ?? "...an illusion"
              log("This is ".concat(name))

              if let rewards = self.rewards[name] {
                if rewards.length > 0 {
                  self.giveRewards(runner: runner, rewards: rewards)
                }
              }
            }   
          } else {
            log("You do not hold anything in your hands, kid...")
          }
        }

        
        /*
        access(all) fun open(runner: &Player.Runner, chest: @Clues.Chest, key: @Clues.Key){
          // TODO: Finish code to open chest   
        }
        */
        

        access(all) fun giveRewards(runner: &Player.Runner, rewards: [Clues.Reward]){
          var i = 0
          while (i < rewards.length) {
            let rewardType = rewards[i].rewardType
            let rewardName = rewards[i].name

            if (rewardType == "MAP"){
              self.giveMap(runner: runner, mapName: rewardName)
            }

            if (rewardType == "LOCATION"){
              self.giveLocation(runner: runner, locationName: rewardName)
            }

            if (rewardType == "KEY"){
              self.giveKey(runner: runner, keyName: rewardName)
            }

            if (rewardType == "CHEST"){
              self.giveChest(runner: runner, chestName: rewardName)
            }

            i = i + 1
          }
        }

        access(all) fun exploreCurrentLocation(runner: &Player.Runner){
            let location = runner.currentLocation.name
            if let rewards = self.rewards[location] {
              if rewards.length > 0 {

                self.giveRewards(runner: runner, rewards: rewards)
                // REFACTOR: Clear rewards here to prevent double claiming...
              
              }
            }
        }
    }

      init(){
        // let oldMaster <- self.account.storage[GameMaster] <- create GameMaster()
        // destroy oldMaster


        // TODO: Remove previously owned GameMaster resource if it present in path
        self.account.save<@GameMaster>(<-create GameMaster(), to: /storage/GameMaster)
    }
}
