 /*
    Contract: BaseClues
    Description: This contract will hold all the structures required for clues
 */
 access(all) contract Clues {

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

    access(all) struct ClueDetails {
        pub let id: UInt16
        pub var description: String?

        init(id: UInt16, description: String?) {
            self.id = id
            self.description = description
        }
    }

    access(all) struct LockDetails{
        // REFACTOR: Allow several keys to be required via [String] array
        access(all) let lockedWith: String
        access(all) let locationLocked: String?

        init(lockedWith: String, locationLocked: String?){
            self.lockedWith = lockedWith
            self.locationLocked = locationLocked
        }
    }

    access(all) struct Reward{
        access(all) let name: String
        access(all) let rewardType: String

        init(name: String, rewardType: String){
            self.name = name
            self.rewardType = rewardType
        }
    }

    access(all) resource interface BaseClue{
        access(all) name: String
        access(all) id: UInt16
        access(all) description: String
        access(all) clueType: String

        access(all) fun getDetails():String
    }

    access(all) resource Key:BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String


        init(id: UInt16, name: String, description: String?){
            self.id = id
            self.clueType = "KEY"

            self.name = name
            self.description = description ?? "It's just a ".concat(self.name)
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource Map: BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String

        init(id: UInt16, name: String, description: String?){
            self.id = id
            self.clueType = "MAP"

            self.name = name
            self.description = description ?? "It's just a".concat(self.name)
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource Location: BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String

        init(id: UInt16, name: String, description: String?){
            self.id = id
            self.clueType = "LOCATION"

            self.name = name
            self.description = description ?? self.name
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource Treasure: BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String

        init(id: UInt16, name: String, description: String?){
            self.id = id
            self.clueType = "TREASURE"

            self.name = name
            self.description = description ?? self.name
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource Chest: BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String
        access(all) let lockDetails: LockDetails

        init(id: UInt16, name: String, description: String?, lockDetails: LockDetails){
            self.id = id
            self.clueType = "CHEST"
            self.name = name
            self.description = description ?? self.name
            self.lockDetails = lockDetails
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource Item: BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String

        init(id: UInt16, name: String, description: String?){
            self.id = id
            self.clueType = "QUEST ITEM"
            self.name = name
            self.description = description ?? self.name
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource Fixer: BaseClue{
        access(all) let id:UInt16
        access(all) let clueType: String
        access(all) let name:String
        access(all) let description: String

        init(id: UInt16, name: String, description: String?){
            self.id = id
            self.clueType = "CHEST"
            self.name = name
            self.description = description ?? self.name
        }

        access(all) fun getDetails(): String{
            return self.name.concat(": ").concat(self.description)
        }
    }

    access(all) resource ClueMinter {

        /*
            ⚠ REFACTOR
            We can use interfaces and optional bindings here for more generic approach
            Probably... 🤔
        */

        access(all) fun createLocation(id: UInt16, name: String, description: String?): @Location{
            return <- create Location(id:id, name: name, description: description)
        }

        access(all) fun createMap(id: UInt16, name: String, description: String?): @Map{
            return <- create Map(id:id, name: name, description: description)
        }

        access(all) fun createKey(id: UInt16, name: String, description: String?): @Key{
            return <- create Key(id:id, name: name, description: description)
        }

        access(all) fun createChest(id: UInt16, name: String, description: String?, lockDetails: LockDetails):@Chest{
            return <- create Chest(id: id, name: name, description: description, lockDetails: lockDetails)
        }
    }

    
    // We can give out new resources or we can share a reference
    access(all) fun createNewMinter():@ClueMinter{
        return <- create ClueMinter()
    }
    

    init(){
        // self.account.save<@ClueMinter>(<-create ClueMinter(), to: /storage/ClueMinter)
    }
 }
