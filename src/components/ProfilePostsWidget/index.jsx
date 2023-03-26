import { useEffect, useState } from "react";
import { supabase } from "../../supabaseClient";
import { useParams } from "react-router-dom";
import {
  Card,
  CardContent,
  Typography,
  CardMedia,
  Modal,
  Box,
  Button,
 
} from "@mui/material";
import moment from "moment/moment";


function ProfilePostsWidget({list}) {
  const { id } = useParams();
  const [postList, setPostList] = useState([]);
  // const [open, setOpen] = useState(false);
  // const [anchor, setAnchor] = useState(null);

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
  
  
  // const openPostModel = (id, description, medias, created_at) => {
  //   openPopover()
  //   setOpen(true);

  //     return (
  //       <Popover
  //         key={id}
  //         open={Bool}
  //         onClose={() => {
  //           setOpen(false);
  //         }}
  //         anchorEl={anchor}
  //         anchorOrigin={{
  //           vertical:"center",
  //           horizontal:"center"
  //         }}
  //         transformOrigin={{
  //           vertical:'center',
  //           horizontal:'center'
  //         }}
       
  //       >
  //         <Card>
  //           <CardMedia component="img" image={medias[0].source} height="250" />
  //           <CardContent>
  //             <Typography variant="caption">{description}</Typography>
  //             <Typography variant="caption">{created_at}</Typography>
  //           </CardContent>
  //         </Card>
  //       </Popover>
  //     );
    
  // };
  const style = {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    width: 400,
    bgcolor: 'background.paper',
    border: '2px solid #000',
    boxShadow: 24,
    p: 4,
  };

 function BasicModal(id,description,medias,created_at) {
    const [open, setOpen] = useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);
  
    return (
      <div>
        <Button onClick={handleOpen}>Open modal</Button>
        <Modal
          open={open}
          onClose={handleClose}
          aria-labelledby="modal-modal-title"
          aria-describedby="modal-modal-description"
        >
          <Box sx={style}>
            <Typography id="modal-modal-title" variant="h6" component="h2">
              {description}
            </Typography>
            <Typography id="modal-modal-description" sx={{ mt: 2 }}>
              {created_at}
            </Typography>
          </Box>
        </Modal>
      </div>
    );
  }
  return (
    <>
    
      {postList.map(({ id, description, medias, created_at }) => (
        <Card
          onClick={() => {
            console.log(id,description,medias,created_at);
            // BasicModal(id, description, medias, created_at);
            
          }}
          sx={{ width:"30%", height:"45%" }}
          key={id}
        >
          <CardMedia component="img" image={medias[0].source} height="250" />
          {/* <ImageList
           variant="quilted"
           sx={{ height: "60%" }}
           cols={1}

           >
            {medias.map((pic) => (
              <ImageListItem key={pic.id}>
                <img src={pic.source} height="100%" alt={""} loading="lazy" />
              </ImageListItem>
            ))}
          </ImageList> */}
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
