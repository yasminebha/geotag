import { useCallback, useContext, useEffect, useMemo, useRef } from "react";
import { MapContainer, Marker, Popup, TileLayer, useMap } from "react-leaflet";
import { useGeoLocation } from "../../utils/context/geolocation";
import { PostListContext } from "../../utils/context/postList";
import "./style.css";

function UserMarker() {
  const geo = useGeoLocation();

  const map = useMap();

  useEffect(() => {
    map.flyTo([geo.lat, geo.lng], map.getZoom());
  }, []);

  return (
    <Marker className='user-position-marker'  position={[geo.lat, geo.lng]}>
      <Popup>your position</Popup>
    </Marker>
  );
}

function Map() {
  const mapRef = useRef();
  // const popupRef = useRef();
  // const selectedMarkerRef = useRef();
  const { state } = useContext(PostListContext);

  const mapCardToMarker = (card) => {
    const coords = card.geo
      .replace(/[\(\)]/g, "")
      .split(",")
      .map((x) => parseFloat(x));

    return {
      id: card.id,
      coords: [coords[1], coords[0]],
      user_metadata: card.user_metadata,
      created_at:card.created_at,
    };
  };

  const selectedMarker  = state.cards
    .map(mapCardToMarker)
    .find((marker) => marker.id === state.activeCardId);

  const mapMarkerToElement = (marker) => {
    return (
      <Marker key={marker.id} position={marker.coords} riseOnHover={true}>
        <Popup  autoOpen={true} className="custom-popup">
          <div>
            <img src={marker.user_metadata.picture} alt="user avatar" />
            <p>{marker.user_metadata.username}</p>
          </div>
        </Popup>
      </Marker>
    );
  };
  // const popOverautoOpen=(marker)=>{
  //   return(
  //     <Marker key={marker.id} position={marker.coords}>

  //     <Popup ref={popupRef} autoOpen={true} autoPan  className="custom-popup">
  //     <div>
  //       <img src={marker.user_metadata.picture} alt="user avatar" />
  //       <p>{marker.user_metadata.username}</p>
  //     </div>
  //   </Popup>
  //     </Marker>
  //   )

  // }

  useEffect(() => {
    if (mapRef.current !== null && selectedMarker !== null) {
      mapRef.current.flyTo(selectedMarker.coords);
      console.log(selectedMarker);
     
      // popOverautoOpen(selectedMarker)
 
    }
  }, [mapRef.current, selectedMarker]);

  return (
    <MapContainer
      id="map"
      zoom={13}
      center={[51.505, -0.09]}
      scrollWheelZoom={true}
      ref={mapRef}
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <UserMarker />
      {state.cards.map(mapCardToMarker).map(mapMarkerToElement)}
    </MapContainer>
  );
}

export default Map;
