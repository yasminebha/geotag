import { createContext, useEffect, useState } from "react";
import { supabase } from "../../supabaseClient";
import { useGeoLocation } from "./geolocation";

export const PostListContext = createContext();

export const PostListProvider = ({ children }) => {
  const [postList, setPostList] = useState([]);

  const geo = useGeoLocation();

  const fetchPosts = async () => {
    const { data, error } = await supabase.rpc("nearby_posts", {
      ...geo,
      rad: 100,
    });

    if (!error) {
      setPostList(data);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  console.log("====POST_LIST_CONTEXT====", postList);

  return (
    <PostListContext.Provider value={{ postList, setPostList }}>
      {postList.length > 0 ? children : null}
    </PostListContext.Provider>
  );
};
