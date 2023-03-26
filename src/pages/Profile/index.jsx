import { Container, Box } from "@mui/material";
import ProfileWidget from "../../components/ProfileWidget";
import ProfilePostsWidget from "../../components/ProfilePostsWidget";
import PostWidget from "../../components/PostWidget";
function Profile({list}) {
  return (
    <Container sx={{ mt: 8, height: "90vh"}}>
      <Box component="div" display="flex" gap={3} padding="0.5rem" mt="2rem">
        <Box
          className="post-list"
          boxShadow={3}
          borderRadius={3}
          bgcolor="white"
          width="30%"
          height="60vh"
          p={2}
        >
          <ProfileWidget />
        </Box>
        <Box
          bgcolor="white"
          boxShadow={3}
          borderRadius={3}
          width="68%"
          height="80vh"
          display="flex"
          gap={2}
          flexDirection="row"
          justifyContent="center"
          flexWrap="wrap"
          overflow="auto"
          pt={2}
        >
          <ProfilePostsWidget list={list} />
        </Box>
       
      </Box>
    </Container>
  );
}
export default Profile;
