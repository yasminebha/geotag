import React from "react";
import ReactDOM from "react-dom/client";
import SignIn from "./pages/SignIn";
import "./index.css";
import Home from "./pages/Home";
import Signup from "./pages/Signup";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import CreatePost from "./pages/CreatePost";
import { UserProvider } from "./utils/context/user";
import { LocationProvider } from "./utils/context/geolocation";
import NotFound from "./pages/NotFound";
import Profile from "./pages/Profile";
import { PostListProvider } from "./utils/context/postList";
const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <Router>
    <LocationProvider>
      <UserProvider>
        <PostListProvider>
          <Routes>
            <Route exact path="/" element={<Home />} />
            <Route path="/signup" element={<Signup />} />
            <Route path="/signin" element={<SignIn />} />
            <Route path="/newpost" element={<CreatePost />} />
            <Route path="/profile/:id" element={<Profile />} />
            <Route path="*" element={<NotFound />} />
          </Routes>
        </PostListProvider>
      </UserProvider>
    </LocationProvider>
  </Router>
);
