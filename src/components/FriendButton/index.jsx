import PersonAddRoundedIcon from "@mui/icons-material/PersonAddRounded";
import PersonRemoveAlt1RoundedIcon from "@mui/icons-material/PersonRemoveAlt1Rounded";
import { IconButton } from "@mui/material";
import { useContext, useState } from "react";
import { supabase } from "../../supabaseClient";
import { UserContext } from "../../utils/context/user";

function FriendButton({ friendId }) {
  const [isFriend, setIsFriend] = useState(false);
  const { user } = useContext(UserContext);

  const addFriend = async () => {
    const { error } = await supabase.rpc("create_friendship", {
      user_id: user.id,
      friend_id: friendId,
    }); 
    console.log(friendId)

    if (!error) {
      setIsFriend(true);

      alert("friend added successfuly");
    }
  };

  const removeFriend = async () => {
    const { error } = await supabase.rpc("remove_friendship", {
      user_id: user.id,
      friend_id: friendId,
    });

    if (!error) {
      setIsFriend(false);

      alert("friend removed successfuly");
    }
  };
 console.log("is friend : ======"+isFriend)
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
