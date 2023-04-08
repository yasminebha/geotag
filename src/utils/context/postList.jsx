import { createContext, useEffect, useState } from "react";
import { supabase } from "../../supabaseClient";
import { useGeoLocation } from "./geolocation";

export const PostListContext = createContext();

export const PostListProvider = ({ children }) => {
  const [state, setState] = useState({ cards: [], activeCardId: 0 });

  const geo = useGeoLocation();

  const setCards = (cards) => {
    setState({ ...state, cards });
  };

  const setActiveCard = (id) => {
    setState({ ...state, activeCardId: id });
  };

  const fetchPosts = async () => {
    const { data, error } = await supabase
      .rpc("get_nearby_posts", {
        ...geo,
        rad:50,
      })
      .select(`*`);

    if (!error) {
      setCards(data);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  console.log("====POST_LIST_CONTEXT====", state.activeCardId);

  return (
    <PostListContext.Provider value={{ state, setCards, setActiveCard }}>
      {state.cards.length > 0 ? children : null}
    </PostListContext.Provider>
  );
};
