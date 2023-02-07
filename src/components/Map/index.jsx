import { useContext, useEffect, useState } from "react";
import { MapContainer, TileLayer, Marker, useMap } from "react-leaflet";
import "./style.css";

import { PostListContext } from "../../utils/context/postList";
import { useGeoLocation } from "../../utils/context/geolocation";

function LocationMarker() {
  const geo = useGeoLocation();

  const map = useMap();

  useEffect(() => {
    map.flyTo([geo.lat, geo.lng], map.getZoom());
  }, []);

  return <Marker position={[geo.lat, geo.lng]} />;
}

function Map() {
  const { postList } = useContext(PostListContext);
  const [markes, setMarkes] = useState([]);

  useEffect(() => {
    const markes = postList.map((item) => {
      return item.geo
        .replace(/[\(\)]/g, "")
        .split(",")
        .map((x) => parseFloat(x));
    });

    setMarkes(markes);
  }, []);

  return (
    <MapContainer
      id="map"
      zoom={13}
      center={[51.505, -0.09]}
      scrollWheelZoom={true}
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <LocationMarker />

      {markes.map((position, key) => {
        return <Marker key={key} position={[position[1], position[0]]} />;
      })}
    </MapContainer>
  );
}

export default Map;
