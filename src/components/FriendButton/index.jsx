import PersonAddRoundedIcon from "@mui/icons-material/PersonAddRounded";
import PersonRemoveAlt1RoundedIcon from "@mui/icons-material/PersonRemoveAlt1Rounded";
import { IconButton } from "@mui/material";
import { useContext, useState } from "react";
import { supabase } from "../../supabaseClient";
import { UserContext } from "../../utils/context/user";

const noop = () => {};
function FriendButton({
  userId,
  friendId,
  hasFriendship = false,
  onCreate = noop,
  onRemove = noop,
}) {
  const [isFriend, setIsFriend] = useState(hasFriendship);
  const {islogged}=useContext(UserContext)

  const addFriend = async () => {
    const { error } = await supabase.rpc("create_friendship", {
      user_id: userId,
      friend_id: friendId,
    });
    if (!error) {
      setIsFriend(true);
      onCreate(friendId);
      alert("friend added successfuly");
    }
  };
  const removeFriend = async () => {
    const { error } = await supabase.rpc("remove_friendship", {
      user_id: userId,
      friend_id: friendId,
    });

    if (!error) {
      setIsFriend(false);
      onRemove(friendId);
      alert("friend removed successfuly");
    }
  };
  console.log("is friend : ======" + isFriend);
  return (
    <>
      {isFriend ? (
        <IconButton
          onClick={removeFriend}
          color="default"
          aria-label="remove friend"
          component="label"
        >
          <PersonRemoveAlt1RoundedIcon />
        </IconButton>
      ) : (
        <IconButton
          onClick={addFriend}
          color="default"
          aria-label="remove friend"
          component="label"
        >
          <PersonAddRoundedIcon />
        </IconButton>
      )}
    </>
  );
}
export default FriendButton;
