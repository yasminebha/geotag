import React from 'react'
import { Stack } from "@mui/system";
import "./style.css";

import Footer from "../Footer";
import Header from "../Header";
import PostsList from "../PostsList";

function SideBar() {
  return (
    <div className="sideBar">

    <Stack
      className="stack"
      direction="column"
      justifyContent="space-between"
      spacing={10}
      >
      <Header /> 
      <PostsList />
      <Footer />
    </Stack>
      </div>
  );
}
export default SideBar;
