import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Text "mo:base/Text";

module {
  public type User = HashMap.HashMap<Principal, UserData>;
   type UserData = {
        createdAt : Text;
        id : Principal;
        name : Text;
        role : Int;
    };

    
};