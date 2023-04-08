import DeleteIcon from "@mui/icons-material/Delete";
import {
  Box,
  Card,
  CardContent,
  CardMedia,
  Grid,
  Modal,
  Typography,
} from "@mui/material";
import IconButton from "@mui/material/IconButton";
import moment from "moment/moment";
import { useContext, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import SwiperCore, { Navigation, Pagination } from "swiper";
import { Swiper, SwiperSlide } from "swiper/react";
import "swiper/swiper.min.css";
import { supabase } from "../../supabaseClient";
import { UserContext } from "../../utils/context/user";

SwiperCore.use([Navigation, Pagination]);

function ProfilePostsWidget() {
  const { id: profileId } = useParams();
  const [postList, setPostList] = useState([]);
  const [selectedIndex, setSelectedIndex] = useState(null);
  const [open, setOpen] = useState(false);

  const { isUser } = useContext(UserContext);

  const fetchPostsById = async (id) => {
    const { data, error } = await supabase
      .from("posts")
      .select("*,medias(*)")
      .eq("userID", id);
    if (!error) {
      setPostList(data);
    }
  };

  const deletePostByID = async (postid) => {
    if (window.confirm("are you sure you want to delete this post")) {
      const { error } = await supabase.rpc("deletePostByID", {
        post_id: postid,
      });
      if (!error) {
        alert("post deleted successfuly");
        window.location.reload(true);
      } else {
        console.error(error);
        alert("failed to delete post");
      }
    }
  };

  useEffect(() => {
    fetchPostsById(profileId);
  }, [profileId]);

  const handleOpen = (index) => {
    setSelectedIndex(index);
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setSelectedIndex(null);
  };

  const handleSwiperClick = (event) => {
    event.stopPropagation();
  };

  return (
    <>
      <Grid container spacing={2}>
        {postList.map(({ id, description, medias, created_at }, index) => (
          <Grid item xs={12} sm={6} md={4} key={id}>
            <Card sx={{ height: "50%" }}>
              <CardMedia
                onClick={() => handleOpen(index)}
                component="img"
                image={medias[0].source}
                height="250"
              />
              <CardContent>
                <Typography variant="caption">{description}</Typography>
                <br />
                <Typography variant="caption">
                  {moment(created_at).fromNow()}
                </Typography>
              </CardContent>

              {isUser(profileId) && (
                <IconButton
                  aria-label="delete"
                  onClick={() => deletePostByID(profileId)}
                >
                  <DeleteIcon />
                </IconButton>
              )}
            </Card>
          </Grid>
        ))}
      </Grid>

      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box
          sx={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            width: "90%",
            height: "80%",
            bgcolor: "background.paper",
            border: "2px solid #000",
            boxShadow: 24,
            overflow: "hidden",
          }}
        >
          <Swiper
            spaceBetween={0}
            slidesPerView={1}
            navigation
            pagination={{ clickable: true }}
            initialSlide={selectedIndex}
          >
            {postList[selectedIndex]?.medias.map((media) => (
              <SwiperSlide key={media.id} onClick={handleSwiperClick}>
                {media.type.startsWith("image") ? (
                  <img src={media.source} style={{ width: "100%" }} alt={""} />
                ) : (
                  <video
                    src={media.source}
                    style={{ width: "100%" }}
                    controls
                  />
                )}
              </SwiperSlide>
            ))}
          </Swiper>
        </Box>
      </Modal>
    </>
  );
}
export default ProfilePostsWidget;
