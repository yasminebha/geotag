import { IconButton } from "@mui/material";
import Avatar from "@mui/material/Avatar";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import CardHeader from "@mui/material/CardHeader";
import CardMedia from "@mui/material/CardMedia";
import { red } from "@mui/material/colors";
import MoreVertIcon from "@mui/icons-material/MoreVert";
import Typography from "@mui/material/Typography";
import moment from "moment/moment";
import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { Pagination, Navigation } from "swiper";
import "swiper/css";
import "swiper/css/pagination";
import { Swiper, SwiperSlide } from "swiper/react";
import { supabase } from "../../supabaseClient";
import "./style.css";

const PostCard = ({ id, desc, username, avatar, createdAt, userID, tags }) => {
  const [medias, setMedias] = useState([]);

  const fetchMedias = async (postId) => {
    const { data } = await supabase
      .from("medias")
      .select("*")
      .eq("postID", postId);

    setMedias(data);
  };

  useEffect(() => {
    fetchMedias(id);
  }, [id]);

  return (
    <Card className="card m-auto">
      <CardHeader
        avatar={
          <Link to={`/profile/${userID}`}>
            <Avatar sx={{ bgcolor: red[500] }} src={avatar} />
          </Link>
        }
        action={
          <IconButton aria-label="settings">
            <MoreVertIcon />
          </IconButton>
        }
        title={username}
        subheader={moment(createdAt).format("MMMM Do YYYY")} //created_at
      />
      <Swiper
        spaceBetween={30}
        modules={[Pagination, Navigation]}
        pagination={{
          clickable: true,
        }}
        navigation={true}
        className="mySwiper"
      >
        {medias.length > 0 &&
          medias.map(({ id, source }) => {
            return (
              <SwiperSlide key={id}>
                <CardMedia
                  component="img"
                  image={source} //post image
                  width={400}
                  height={400}
                />
              </SwiperSlide>
            );
          })}
      </Swiper>
      <CardContent>
        <Typography variant="body2" color="text.secondary">
          {desc}
        </Typography>
        {tags !== null &&
          tags.map((tag) => {
            return (
              <Link  key={tag}  to={"/"}>
                <Typography
                  key={tag}
                  variant=""
                  sx={{ color: "#48855c", fontWeight: "600" }}
                >
                  {"#" + tag}
                </Typography>
              </Link>
            );
          })}
      </CardContent>
    </Card>
  );
};

export default PostCard;
