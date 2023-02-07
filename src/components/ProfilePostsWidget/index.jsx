import { useEffect, useState } from "react";
import { supabase } from "../../supabaseClient";
import { useParams } from "react-router-dom";
import {
  ImageList,
  ImageListItem,
  Card,
  CardContent,
  Typography,
} from "@mui/material";
import moment from "moment/moment";


function ProfilePostsWidget() {

  const { id } = useParams();
  const [postList, setPostList] = useState([]);
 


  const fetchPostsById = async (id) => {
    const { data, error } = await supabase
      .from("posts")
      .select("*,medias(*)")
      .eq("userID", id);
    if (!error) {
      setPostList(data);
    }
  };
  useEffect(() => {
    fetchPostsById(id);
  }, [id]);


  return (
    <>
      {postList.map(({ id, description, medias, created_at }) => (
        <Card sx={{ width: "30%", height: "45%" }} key={id}>
          <ImageList
           variant="quilted" 
           sx={{ height: "60%" }} 
           cols={1}
           
           >
            {medias.map((pic) => (
              <ImageListItem key={pic.id}>
                <img src={pic.source} height="100%" alt={""} loading="lazy" />
              </ImageListItem>
            ))}
          </ImageList>
          <CardContent>
            <Typography variant="caption">{description}</Typography>
            <br />
            <Typography variant="caption">
              {moment(created_at).fromNow()}
            </Typography>
          </CardContent>
        </Card>
      ))}


    </>
  );
}
export default ProfilePostsWidget;
