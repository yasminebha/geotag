import {
  Avatar,
  Box,
  CircularProgress,
  Divider,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  Typography,
} from "@mui/material";
import { useContext, useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { supabase } from "../../supabaseClient";
import { UserContext } from "../../utils/context/user";
import FriendButton from "../FriendButton";

function ProfileWidget() {
  const { id } = useParams();
  const { user, isUser ,islogged} = useContext(UserContext);

  const [profile, setProfile] = useState({});
  const [userProfile, setUserProfile] = useState({});

  const fetchProfile = async (id) => {
    const { data } = await supabase
      .from("profiles")
      .select(
        `
        id,
        picture,
        username,
        friendships!friendships_userID_fkey(
          profiles!friendships_friendID_fkey(
            id,
            picture,
            username,
            userID
          )
        )`
      )
      .eq("userID", id)
      .single();
    setProfile(data);
  };

  const fetchUserProfile = async (id) => {
    const { data } = await supabase
      .from("profiles")
      .select("id")
      .eq("userID", id)
      .single();
    setUserProfile(data);
  };

  useEffect(() => {
    if (user?.id !== undefined) {
      fetchUserProfile(user.id);
    }
  }, [user?.id]);

  useEffect(() => {
    if (id !== undefined) {
      fetchProfile(id);
    }
  }, [id]);

  if (!profile.id && !userProfile.id) {
    return <CircularProgress />;
  }

  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        textAlign: "center",
        backgroundColor: "#fff",
        boxShadow: 3,
        borderRadius: 3,
        p: 2,
      }}
    >
      <Avatar sx={{ width: 80, height: 80 }} src={profile.picture} />
      <Typography variant="h6" fontSize="1.5rem" mt={1} mb={2}>
        {profile.username}
      </Typography>
      {!isUser(id) && islogged
      
     && (
        <FriendButton userId={userProfile.id} friendId={profile.id} />
      )}
      <Divider sx={{ width: "100%", my: 2 }} />
      <Typography variant="body1" mb={1}>
        Biography
      </Typography>
      <Divider sx={{ width: "100%", my: 2 }} />
      <Typography variant="body1" mb={1}>
        Friends ({profile.friendships?.length || 0})
      </Typography>
      {profile.friendships?.length === 0 ||
      profile.friendships?.length === undefined ? (
        <Typography variant="body1">No Friends</Typography>
      ) : (
        <List sx={{ width: "100%" }}>
          {profile.friendships.map(
            ({
              profiles: {
                id: friendId,
                userID: friendUserId,
                picture,
                username,
              },
            }) => (
              <ListItem
                key={friendId}
                secondaryAction={
                  isUser(id) && (
                    <FriendButton
                      userId={profile.id}
                      friendId={friendId}
                      hasFriendship={true}
                      onCreate={(id) => {}}
                      onRemove={(id) => {
                        setProfile({
                          ...profile,
                          friendships: profile.friendships.filter(
                            ({ profiles }) => profiles.id !== id
                          ),
                        });
                      }}
                    />
                  )
                }
                alignItems="flex-start"
              >
                <ListItemAvatar>
                  <Link to={`/profile/${friendUserId}`}>
                    <Avatar src={picture} />
                  </Link>
                </ListItemAvatar>
                <ListItemText primary={username} />
              </ListItem>
            )
          )}
        </List>
      )}
    </Box>
  );
}
export default ProfileWidget;
