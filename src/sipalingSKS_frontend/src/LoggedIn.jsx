import React, { useEffect, useState } from "react";
import { useAuth } from "./use-auth-client";

const whoamiStyles = {
  border: "1px solid #1a1a1a",
  marginBottom: "1rem",
};

function LoggedIn() {
  const [result, setResult] = useState("");  
  const { whoamiActor, logout } = useAuth(); 

  const handleClick = async () => {
      const whoami = await whoamiActor.whoami(); 
      setResult(whoami);  
  };
  
  return (
    <div className="container">
      <h1>Internet Identity Client</h1>
      <h2>You are authenticated!</h2>
      <p>To see how a canister views you, click this button!</p>
      <button
        type="button"
        id="whoamiButton"
        className="primary"
        onClick={handleClick}
      >
        Who am I?
      </button>
      <input
        type="text"
        readOnly
        id="whoami"
        value={result}
        placeholder="your Identity"
        style={whoamiStyles}
      />
      <br />
      <button id="logout" onClick={logout}>
        Log out
      </button>
    </div>
  );
}

export default LoggedIn;
