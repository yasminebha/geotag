import "@fontsource/roboto/300.css";
import Button from "@mui/material-next/Button";
import { Link, useNavigate } from "react-router-dom";
import "./style.css";

import { Logout } from "@mui/icons-material";
import {
  Avatar,
  Grid,
  IconButton,
  ListItemIcon,
  Menu,
  MenuItem,
  Tooltip,
  Typography,
} from "@mui/material";
import { useContext, useState } from "react";
import { supabase } from "../../supabaseClient";
import { UserContext } from "../../utils/context/user";
function Header() {
  const navigate = useNavigate();
  const [anchorEl, setAnchorEl] = useState(null);
  const open = Boolean(anchorEl);
  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };
  const { islogged, setIsLogged, user } = useContext(UserContext);
  const logout = async () => {
    const { error } = await supabase.auth.signOut();
    setIsLogged(false);
    console.log(error);
  };

  return (
    <Grid
      direction="row"
      wrap="nowrap"
      container
      spacing={3}
      className="header "
    >
      <Grid item>
        <Typography variant="h3" color={"#7adf9c"} fontWeight="800">
          Geotag
        </Typography>
      </Grid>
      <Grid item className="LinkItems">
        <div className="Account">
          {islogged ? (
            <>
              <Typography variant="caption">
                {user.user_metadata.username}
              </Typography>
              <Tooltip title="Account settings">
                <IconButton
                  onClick={handleClick}
                  size="small"
                  sx={{ ml: 2 }}
                  aria-controls={open ? "account-menu" : undefined}
                  aria-haspopup="true"
                  aria-expanded={open ? "true" : undefined}
                >
                  <Avatar src={user.user_metadata.picture} />
                </IconButton>
              </Tooltip>
              <Menu
                anchorEl={anchorEl}
                id="account-menu"
                open={open}
                onClose={handleClose}
                onClick={handleClose}
                PaperProps={{
                  elevation: 0,
                  sx: {
                    overflow: "visible",
                    filter: "drop-shadow(0px 2px 8px rgba(0,0,0,0.32))",
                    mt: 1.5,
                    "& .MuiAvatar-root": {
                      width: 32,
                      height: 32,
                      ml: -0.5,
                      mr: 1,
                    },
                    "&:before": {
                      content: '""',
                      display: "block",
                      position: "absolute",
                      top: 0,
                      right: 14,
                      width: 10,
                      height: 10,
                      bgcolor: "background.paper",
                      transform: "translateY(-50%) rotate(45deg)",
                      zIndex: 0,
                    },
                  },
                }}
                transformOrigin={{ horizontal: "right", vertical: "top" }}
                anchorOrigin={{ horizontal: "right", vertical: "bottom" }}
              >
                <MenuItem
                // onClick={() => {
                //   navigate(`/profile/${user.id}`);
                // }}
                >
                  <Avatar src={user.user_metadata.picture} />
                  <Link to={`/profile/${user.id}`}>Profile</Link>
                </MenuItem>

                <MenuItem onClick={logout}>
                  <ListItemIcon>
                    <Logout fontSize="small" />
                  </ListItemIcon>
                  Logout
                </MenuItem>
              </Menu>
            </>
          ) : (
            <Button
              className="button"
              disabled={false}
              size="small"
              variant="elevated"
            >
              <Link className="link" to="/signin">
                SignIn
              </Link>
            </Button>
          )}
        </div>
      </Grid>
    </Grid>
  );
}
export default Header;
