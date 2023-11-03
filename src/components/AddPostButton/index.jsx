import { Typography } from "@mui/material";
import { Button } from "@mui/material-next";
import { useContext } from "react";
import { Link } from "react-router-dom";

import { UserContext } from "../../utils/context/user";

import "./style.css";

  function AddPostButton() {
    const{islogged}=useContext(UserContext)
  return (
    <div >
      {islogged &&
        
          <Link title="create post" className="link add-post-button-container " to="/newpost">
            <Button
              className="new-post-button"
              size="small"
              variant="elevated"
              fontWeight="700"
            >
            
            </Button>
          </Link>
        
       
      
      }
    </div>
  );
}
export default AddPostButton;
