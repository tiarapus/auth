import Types "Types";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Debug "mo:base/Debug";

import UserServices "/Services/UserServices";

actor Resumid {

    private var users : HashMap.HashMap<Principal, Types.UserData> = HashMap.HashMap(0, Principal.equal, Principal.hash);

    // Function to return the caller's principal
    public shared(msg) func whoami() : async Principal {
        return msg.caller;
    };

    // Function to authenticate a user
    public shared(msg) func authenticateuser() : async Types.UserData {
        let callerPrincipal = msg.caller;  
        let result = await UserServices.authenticateUser(users, callerPrincipal);

        // Handle Result type: either return user data or handle errors
        switch (result) {
            case (#ok userData) {
                return userData;
            };
            case (#err errorMessage) {
                Debug.print("Authentication failed: " # errorMessage);
                throw Error.reject(errorMessage); // Optional: Customize error handling logic
            };
        };
    };

    // Query to fetch a user by their Principal ID
    public query func getUserById(userId: Principal) : async ?Types.UserData {
        switch (users.get(userId)) {
            case (null) {
                Debug.print("No user found for ID: " # Principal.toText(userId));
                return null;
            };
            case (?user) {
                Debug.print("User found: " # Principal.toText(userId));
                return ?user;
            };
        };
    };
};
