import {
  Avatar,
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
import "./style.css";

function ProfileWidget() {
  const { user } = useContext(UserContext);
  const [isSameUser, setIsSameUser] = useState(true);
  const [profile, setProfile] = useState({});
  const [friendList, setFriendList] = useState([]);
  const [friends, setFriends] = useState([]);
  const { id } = useParams();

  const fetchProfile = async (id) => {
    const { data } = await supabase
      .from("profiles")
      .select("picture,username")
      .eq("userID", id)
      .single();
    setProfile(data);
  };

  const checkIsSameUser = () => {
    if (user) if (id !== user.id) setIsSameUser(false);
  };

  const fetchFriends = async (id) => {
    const { data, error } = await supabase
      .from("friendships")
      .select("friendID")
      .eq("userID", id);
    if (!error) {
      setFriendList(data);
    } else throw new Error("fetching failed");
  };

  const Friends = () => {
    friendList.map(async (friend) => {
      const { data, error } = await supabase
        .from("profiles")
        .select("*")
        .eq("userID", friend.friendID)
        .single();
      if (!error) setFriends([data, ...friends]);
    });
  };

  useEffect(() => {
    if (id !== undefined) {
      checkIsSameUser();
      fetchProfile(id);
      fetchFriends(id);
    } else {
      console.log("id is not provided");
    }
  }, [id]);

  useEffect(() => {
    Friends();
  }, [friendList]);
  console.log("is same user =========="+isSameUser)
  return (
    <div className="widget">
      <div className="header">
        <Avatar sx={{ width: 80, height: 80 }} src={profile.picture} />
        <Typography variant="h6" fontSize="1rem">
          {profile.username}
        </Typography>
        {!isSameUser && <FriendButton />}
      </div>
      <div>biography</div>
      {friendList.length === 0 ? (
        <div>friendList Empty </div>
      ) : (
        <List>
          {friends.map(({ picture, username, userID }) => (
            <ListItem
              key={userID}
              secondaryAction={<FriendButton friendId={userID} />}
            >
              <ListItemAvatar>
                <Link to={`/profile/${userID}`}>
                  <Avatar src={picture} />
                </Link>
              </ListItemAvatar>
              <ListItemText primary={username} />
            </ListItem>
          ))}
        </List>
      )}
    </div>
  );
}
export default ProfileWidget;
