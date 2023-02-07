import { createContext, useEffect, useState } from "react";
import { supabase } from "../../supabaseClient";

export const UserContext = createContext();


export const UserProvider = ({ children }) => {
  const [islogged, setIsLogged] = useState(false);
  const [user, setUser] = useState(null);

  async function fetchUser() {
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (user) {
      setIsLogged(true);
      setUser(user);
      console.log(user);
    } else {
      console.log("no user is logged");
    }
  }

  useEffect(() => {
    fetchUser();
  }, []);

  return (
    <UserContext.Provider value={{ islogged, setIsLogged, user, setUser }}>
      {children}
    </UserContext.Provider>
  );
};
