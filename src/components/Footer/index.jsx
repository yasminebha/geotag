import { Typography } from "@mui/material";
import { Button } from "@mui/material-next";
import { useContext } from "react";
import { Link } from "react-router-dom";

import { UserContext } from "../../utils/context/user";

import "./style.css";

  function Footer() {
    const{islogged}=useContext(UserContext)
 

  // const [islogged, setIsLogged] = useState(false);
  // useEffect(() => {
  //   async function fetchUserState() {
  //     const {data: { user }} = await supabase.auth.getUser();
  //     if (user) {
  //       setIsLogged(true);
  //       console.log(user);
  //       console.log(islogged);
  //     } else {
  //       console.log("no user is logged");
  //     }
  //   }
  //   fetchUserState();
  // }, [islogged]);
 

 
  return (
    <div className="footer">
      {islogged ? (
        
          <Link className="link" to="/newpost">
            <Button
              className="button"
              size="small"
              variant="elevated"
              fontWeight="700"
            >
              <Typography fontSize={14}>Create Post</Typography>
            </Button>
          </Link>
        
       
      ) : (
        <Link className="link" to="/signin">
          <Button
            className="button"
            size="small"
            variant="elevated"
            fontWeight="700"
          >
            <Typography fontSize={14}>Create Post</Typography>
          </Button>
        </Link>
      )}
    </div>
  );
}
export default Footer;
