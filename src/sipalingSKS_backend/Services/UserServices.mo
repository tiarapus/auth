import Types "../Types";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import UUID "mo:idempotency-keys/idempotency-keys";
import Random "mo:base/Random"; // Make sure to import the Random module

module UserService {
    public func authenticateUser(
        users: Types.User,  
        userId: Principal,
    ) : async Result.Result<Types.UserData, Text> {  
        if (Principal.isAnonymous(userId)) {
            return #err("Anonymous principals are not allowed");
        };

        switch (users.get(userId)) {
            case (?existingUser) {
                return #ok(existingUser);
            };
            case null {
                // If no existing user
                let entropy = await Random.blob();  
                let uid = UUID.generateV4(entropy);  
                let name = "user-" # uid; 
                
                let timestamp = Time.now();  
                let timeZone = #fixed(#hours(7));  
                let localDateTime = LocalDateTime.fromTime(timestamp, timeZone);  
                let createdAt = LocalDateTime.toTextFormatted(localDateTime, #iso);  

                let role = 1;
                
                let newUser: Types.UserData = {
                    id = userId;
                    name = name;
                    role = role;
                    createdAt = createdAt;
                };
                users.put(userId, newUser);  
                return #ok(newUser);
            };
        };
    };
};

