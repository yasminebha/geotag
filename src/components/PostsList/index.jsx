import { useContext, useEffect } from "react";
import "swiper/css";
import { Swiper, SwiperSlide } from "swiper/react";
import PostCard from "../PostCard";

import { PostListContext } from "../../utils/context/postList";
import "./style.css";
function PostsList() {
  const { postList } = useContext(PostListContext);

  const handleSlideChange = (swiper) => {
    const activeSlide = postList[swiper.activeIndex];
    console.log(activeSlide.id);
  };

  useEffect(() => {}, []);

  return (
    <Swiper
      onSlideChange={handleSlideChange}
      direction={"vertical"}
      slidesPerView={1}
      className="list"
    >
      {postList.map(
        ({ id, description, created_at, user_metadata, user_id }) => (
          <SwiperSlide key={id}>
            <PostCard
              userID={user_id}
              loading="lazy"
              id={id}
              desc={description}
              username={user_metadata.username}
              avatar={user_metadata.picture}
              createdAt={created_at}
            />
          </SwiperSlide>
        )
      )}
    </Swiper>
  );
}
export default PostsList;
