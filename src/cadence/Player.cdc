import Clues from 0x01

 /*
    Contract: Player
    Description: This contract will hold player logic
 */
 access(all) contract Player {
    access(all) resource Runner {
        access(all) let sin: UInt16
        access(all) let name: String
        access(all) let clueByName: {String: UInt16}

        // Nested Resources
        access(all) var currentLocation: @Clues.Location
        access(all) let keyring: @{UInt16: Clues.Key}
        access(all) let chests: @{UInt16: Clues.Chest}
        access(all) let treasures: @{UInt16: Clues.Treasure}
        access(all) let fixers: @{UInt16: Clues.Fixer}
        access(all) let maps: @{UInt16: Clues.Map}
        access(all) let locations: @{UInt16: Clues.Location} // ⚠ REFACTOR to @{String: Location}

        init(id: UInt16, name: String, startingLocation: @Clues.Location){
            self.sin = id
            self.name = name
            self.keyring <- {}
            self.chests <- {}
            self.treasures <- {}
            self.fixers <- {}
            self.maps <- {}
            self.locations <- {}
            self.clueByName = {}
            self.currentLocation <- startingLocation
        }

        destroy(){
            destroy self.currentLocation
            destroy self.keyring
            destroy self.chests
            destroy self.treasures
            destroy self.fixers
            destroy self.maps
            destroy self.locations
        }

        access(all) fun ping(){
            log("My name is: ".concat(self.name))
        }

        pub fun intToString(_ num: Int):String {
            let digits = "0123456789"

            var numberString = ""
            var div = num
            while (div > 0){
                let rem = div % 10
                let digit = digits.slice(from: rem, upTo: rem + 1)
                numberString = digit.concat(numberString)
                div = (div - rem) / 10
            }
            return numberString
        }

        access(all) fun logCurrentLocation(){
            log("You are currently located in ".concat(self.currentLocation.name))
        }

        access(all) fun getLocationById(locationId: UInt16): @Clues.Location? {
            let location <- self.locations[locationId] <- nil
            return <- location
        }

        access(all) fun goTo(locationId: UInt16){
            if var newLocation <- self.getLocationById(locationId: locationId){
                self.currentLocation <-> newLocation
                self.pocket(clue: <- newLocation)
            } else {
                log("Going to unknown places in dangerous. Stay here")
            }
        }

        access(all) fun pocket(clue: @AnyResource){
            if let key <- clue as? @Clues.Key {
                let oldKey <- self.keyring[key.id] <- key
                destroy oldKey
            } else if let map <- clue as? @Clues.Map {
                let oldMap <- self.maps[map.id] <- map
                destroy oldMap
            } else if let chest <- clue as? @Clues.Chest {
                let oldChest <- self.chests[chest.id] <- chest
                destroy oldChest
            } else if let location <- clue as? @Clues.Location {
                let oldLocation <- self.locations[location.id] <- location
                destroy oldLocation
            } else {
                /*
                    ⚠ REFACTOR LATER
                    We should probably need to return clue back, rather
                    than destroying and change signature of method to
                    `` pocket(clue: @AnyResource): @AnyResource? ``
                */
                destroy clue
            }
        }

        //access(all) fun getMappingRef(itemType: String): &{UInt16: Clues.BaseClue} {
        //access(all) fun getMappingRef(itemType: String): &{UInt16: Clues.BaseClue}? {
        access(all) fun getMappingRef(itemType: String): &{UInt16: AnyResource{Clues.BaseClue}}? {
            var mapping: &{UInt16: AnyResource{Clues.BaseClue}}? = nil
            if (itemType == "KEY"){
                mapping = &self.keyring as &{UInt16: AnyResource{Clues.BaseClue}}
            } else if itemType == "CHEST"{
                mapping = &self.chests as &{UInt16: AnyResource{Clues.BaseClue}}
            } else if itemType == "LOCATION"{
                mapping = &self.locations as &{UInt16: AnyResource{Clues.BaseClue}}
            } else if itemType == "MAP"{
                mapping = &self.maps as &{UInt16: AnyResource{Clues.BaseClue}}
            }
            return mapping
        }

        access(all) fun listItems(itemType: String): [String?] {
            if let mapping = self.getMappingRef(itemType: itemType) as? &{UInt16: AnyResource{Clues.BaseClue}}  {
                let keys = mapping.keys
                var i = 0
                var list: [String?] = []

                while i < keys.length{
                    let id = keys[i]
                    let clueType = mapping[id]?.clueType ?? "VOID"
                    let clueName = mapping[id]?.name ?? "???"
                    let clueId = self.intToString(Int(id))
                    let description = clueType
                        .concat(" #")
                        .concat(clueId)
                        .concat(": ")
                        .concat(clueName)
                    list.append(description)
                    i = i + 1
                }
                return list
            }
            return []
        }
    }

    access(all) resource CloneBay {
        access(all) fun createRunner(id: UInt16, name: String, startingLocation: @Clues.Location): @Runner {
            let runner <- create Runner(id: id, name: name, startingLocation: <- startingLocation)
            return <- runner
        }
    }


    // We can give out new resources or we can share a reference
    access(all) fun buildCloneBay():@CloneBay {
        return <- create CloneBay()
    }


    init(){
        // No init needed here
    }
 }
