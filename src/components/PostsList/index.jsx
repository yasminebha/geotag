import { useContext } from "react";
import "swiper/css";
import { Swiper, SwiperSlide } from "swiper/react";
import PostCard from "../PostCard";
import { Lazy } from "swiper";

import "swiper/css/lazy";
import "./style.css";
import { PostListContext } from "../../utils/context/postList";
function PostsList() {
  const { postList } = useContext(PostListContext);

  return (
    <Swiper
      direction={"vertical"}
      slidesPerView={1}
      className="list"
      lazy={true}
      modules={[Lazy]}
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
