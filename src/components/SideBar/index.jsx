import React from 'react'
import { Stack } from "@mui/system";
import "./style.css";


import Header from "../Header";
import PostsList from "../PostsList";

function SideBar() {
  return (
    <div className="sideBar">

    <Stack
      className="stack"
      direction="column"
      spacing={{ xs: 2, sm: 4 }}
        alignItems="center"
        justifyContent={{ xs: "flex-start", sm: "space-between" }}
      >
      <Header /> 
      <PostsList />
    
    </Stack>
      </div>
  );
}
export default SideBar;
