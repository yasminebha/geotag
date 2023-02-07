import { createContext, useContext, useEffect, useState } from "react";

export const LocationContext = createContext({ lat: 0, lng: 0 });

export const useGeoLocation = () => useContext(LocationContext);

export const LocationProvider = ({ children }) => {
  const [position, setPosition] = useState(undefined);

  useEffect(() => {
    navigator.geolocation.getCurrentPosition(({ coords }) => {
      setPosition({ lng: coords.longitude, lat: coords.latitude });
    });
  }, []);

  return (
    <LocationContext.Provider value={position}>
      {position !== undefined ? children : <div>Loading Position</div>}
    </LocationContext.Provider>
  );
};
