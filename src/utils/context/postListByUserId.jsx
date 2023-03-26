import { createContext, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { supabase } from "../../supabaseClient";

export const PostListContext = createContext();

export const PostListProvider = ({ children }) => {
  const [postListByUserId, setPostListByUserId] = useState([]);

  const { id } = useParams();
  const fetchPostsById = async (id) => {
    const { data, error } = await supabase
      .from("posts")
      .select("*,medias(*)")
      .eq("userID", id);
    if (!error) {
      setPostListByUserId(data);
    }
  };

  useEffect(() => {
    fetchPostsById(id);
  }, [id]);

  console.log("====POST_LIST_CONTEXT====", postListByUserId);

  return (
    <PostListContext.Provider value={{ postListByUserId, setPostListByUserId }}>
      {postListByUserId.length > 0 ? children : null}
    </PostListContext.Provider>
  );
};
