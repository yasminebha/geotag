import { Container, Box, Grid } from "@mui/material";
import ProfileWidget from "../../components/ProfileWidget";
import ProfilePostsWidget from "../../components/ProfilePostsWidget";

function Profile({list}) {
  return (
    <Container sx={{ mt: 8 }}>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
            <ProfileWidget />
          
        </Grid>
        <Grid item xs={12} md={8}>
          <Box
            bgcolor="white"
            boxShadow={3}
            borderRadius={3}
            height="80vh"
            display="flex"
            flexDirection="row"
            justifyContent="center"
            flexWrap="wrap"
            overflow="auto"
            p={2}
          >
            <ProfilePostsWidget list={list} />
          </Box>
        </Grid>
      </Grid>
    </Container>
  );
}

export default Profile;