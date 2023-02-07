import { useState } from "react";
import { supabase } from "../../supabaseClient";
import { useFormik } from "formik";
import TextField from "@mui/material/TextField";
import { Avatar, Container, CssBaseline, Typography } from "@mui/material";
import { Link, useNavigate } from "react-router-dom";
import * as yup from "yup";
import Button from "@mui/material-next/Button";
import Box from "@mui/material/Box";
import LockOutlinedIcon from "@mui/icons-material/LockOutlined";

import "./style.css";
import { createMedia } from "../../utils/media";
const validationSchema = yup.object({
  email: yup.string("enter a valid email").required("email is required"),
  password: yup
    .string("enter your password")
    .min(8, "Password should be of minimum 8 characters length")
    .required("Password is required"),
  username: yup.string().required("username is required"),
  picture: yup.string(),
});
const uploadUserAvatar = async (file, username) => {
  
  if (!username) throw new Error(" id not provided!");
  let url = "";
  // const imgName=file.replace(/^.*[\\\/]/, '')
  const filename = `${username}${file.name}`;

  url += filename;

  const { data, error } = await supabase.storage
    .from("avatars")
    .upload(url, file);

  if (error) {
    console.error(error);
  }
  const picPath = `https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/avatars/${data.path}`;
  console.log(picPath);
  
  return picPath;
};
const Signup = () => {
  const navigate = useNavigate();
  const [, setUser] = useState();
  const formik = useFormik({
    initialValues: {
      username: "",
      email: "",
      password: "",
      picture: "",
    },
    validationSchema: validationSchema,
    onSubmit: async (values, { setSubmitting }) => {
      const pictureSrc = await uploadUserAvatar(values.picture, values.username)
      const {
        data: { user },
      } = await supabase.auth.signUp({
        email: values.email,
        password: values.password,
        options: {
          data: {
            username: values.username,
            picture:pictureSrc
          },
        },
      });
      const { error } = await supabase.from("profiles").insert({
        username: user.user_metadata.username,
        userID: user.id,
        picture: user.user_metadata.picture,
      });

      if (error) {
        console.log("error");
        setSubmitting(false);
      } else {
        console.log("user created successfully");
        setUser(user);
        
        navigate(
          "/SignIn",
          { replace: true },
          alert("confirm your email to signin")
        );
      }
    },
  });

  return (
    <Container component="main" maxWidth="xs" sx={{}}>
      <CssBaseline />
      <Box
        sx={{
          marginTop: 8,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
        }}
      >
        <Avatar sx={{ m: 1, bgcolor: "#7ed49a" }}>
          <LockOutlinedIcon />
        </Avatar>

        <Typography component="h1" variant="h5">
          Sign up
        </Typography>

        <Box
          noValidate
          sx={{ mt: 1 }}
          component="form"
          onSubmit={formik.handleSubmit}
        >
          <TextField
            fullWidth
            margin="normal"
            id="email"
            name="email"
            label="Email"
            type="email"
            value={formik.values.email}
            onChange={formik.handleChange}
            error={formik.touched.email && Boolean(formik.errors.email)}
            helperText={formik.touched.email && formik.errors.email}
            autoFocus
          />
          <TextField
            margin="normal"
            fullWidth
            id="password"
            name="password"
            label="Password"
            type="password"
            value={formik.values.password}
            onChange={formik.handleChange}
            error={formik.touched.password && Boolean(formik.errors.password)}
            helperText={formik.touched.password && formik.errors.password}
            autoComplete="on"
          />
          <TextField
            fullWidth
            margin="normal"
            id="username"
            name="username"
            label="username"
            type="text"
            value={formik.values.username}
            onChange={formik.handleChange}
            error={formik.touched.username && Boolean(formik.errors.username)}
            helperText={formik.touched.username && formik.errors.username}
          />
          {/* <TextField
            margin="normal"
            fullWidth
            id="picture"
            name="picture"
            type="file"
            value={formik.values.picture}
            onChange={formik.handleChange}
            error={formik.touched.picture && Boolean(formik.errors.picture)}
            helperText={formik.touched.picture && formik.errors.picture}
          /> */}
          <input
            id="file"
            name="file"
            type="file"
            onChange={(event) => {
              formik.setFieldValue("picture", event.currentTarget.files[0]);
            }}
            className="form-control"
          />
          <Button
            className="w-full color"
            fullWidth
            variant="filledTonal"
            type="submit"
            disabled={formik.isSubmitting}
            sx={{ mr: 3, mb: 2 }}
          >
            sign up
          </Button>

          <Link to="/signin" variant="body2">
            {"Do you have an account? Sign In"}
          </Link>
        </Box>
      </Box>
    </Container>
  );
};

export default Signup;
