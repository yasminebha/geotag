import Grid from "@mui/material/Grid";
import Map from "../../components/Map";
import SideBar from "../../components/SideBar";
import "./style.css";
import AddPostButton from "../../components/AddPostButton";

import SearchByTagBar from "../../components/SearchByTagBar";

function Home() {
  return (
    <div className="home">
      <Grid container >
        <Grid item xs={12} sm={3}>
          <SideBar />
        </Grid>
        <Grid item xs={12} sm={9}>
          <div className="map-container">
            <SearchByTagBar />
            <AddPostButton />
            <Map />
          </div>
        </Grid>
      </Grid>
    </div>
  );
}

export default Home;
