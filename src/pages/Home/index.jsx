import Grid2 from "@mui/material/Unstable_Grid2";
import Map from "../../components/Map";
import SideBar from "../../components/SideBar";
import "./style.css";
function Home() {
  return (
    <div className="home">
      <Grid2 container>
        <Grid2 item className="sideBar" xs={3}>
          <SideBar />
        </Grid2>
        <Grid2 item xs>
          <Map />
        </Grid2>
      </Grid2>
    </div>
  );
}
export default Home;
