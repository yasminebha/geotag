import { useContext, useEffect, useState } from "react";
import "swiper/css";
import { Swiper, SwiperSlide } from "swiper/react";
import PostCard from "../PostCard";

import { PostListContext } from "../../utils/context/postList";
import "./style.css";
function PostsList() {
  const { state, setActiveCard } = useContext(PostListContext);

  
  const handleSlideChange = (swiper) => {
    const activeSlide = state.cards[swiper.realIndex];
    setActiveCard(activeSlide.id);
  };
  useEffect(() => {
    if (state.cards.length > 0) {
      const firstActiveSlide = state.cards[0];
      setActiveCard(firstActiveSlide.id);
    }
  
  }, []);

  return (
    <Swiper
      onSlideChange={handleSlideChange}
      direction={"vertical"}
      slidesPerView={1}
      className="list"
    >
      {state.cards.map(
        ({ id, description, created_at, user_metadata, user_id,tags }) => (
          <SwiperSlide key={id}>
            <PostCard
              userID={user_id}
              loading="lazy"
              id={id}
              desc={description}
              username={user_metadata.username}
              avatar={user_metadata.picture}
              createdAt={created_at}
              tags={tags}
            />
          </SwiperSlide>
        )
      )}
    </Swiper>
  );
}
export default PostsList;
