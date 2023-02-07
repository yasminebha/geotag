import LockOpenOutlinedIcon from "@mui/icons-material/LockOpenOutlined";
import {
  Avatar,
  Container,
  CssBaseline,
  Grid,
  Typography,
} from "@mui/material";
import Button from "@mui/material-next/Button";
import Box from "@mui/material/Box";
import TextField from "@mui/material/TextField";
import { useFormik } from "formik";
import { Link, useNavigate } from "react-router-dom";
import * as yup from "yup";
import { supabase } from "../../supabaseClient";

const SignIn = () => {
  const navigate = useNavigate();

  const validationSchema = yup.object({
    email: yup.string("enter a valid email").required("email is required"),
    password: yup
      .string("enter your password")
      .min(8, "Password should be of minimum 8 characters length")
      .required("Password is required"),
  });

  const formik = useFormik({
    initialValues: {
      email: "",
      password: "",
    },
    validationSchema: validationSchema,
    onSubmit: async (values, { setSubmitting }) => {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: values.email,
        password: values.password,
      });
      if (error) {
        console.log("user not found");
        setSubmitting(false);
      } else {
        console.log("user logged in successfully");

        setSubmitting(true);
        navigate("/", { replace: true }, alert("logged in successfully"));
        window.location.reload(true);
      }
    },
  });

  return (
    <Container component="main" maxWidth="xs">
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
          <LockOpenOutlinedIcon />
        </Avatar>

        <Typography component="h1" variant="h5">
          Sign In
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
            value={formik.values.email}
            onChange={formik.handleChange}
            error={formik.touched.email && Boolean(formik.errors.email)}
            helperText={formik.touched.email && formik.errors.email}
            autoComplete="on"
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
            autoComplete="current-password"
          />

          <Button
            className="w-full color"
            fullWidth
            variant="filledTonal"
            type="submit"
            disabled={formik.isSubmitting}
            sx={{ mr: 3, mb: 2 }}
          >
            sign In
          </Button>
          <Grid container>
            <Grid item xs>
              {/* <Link to="/" variant="body2">
                Forgot password?
              </Link> */}
            </Grid>
            <Grid item>
              <Link to="/signup" variant="body2">
                {"you don't have an account? Sign up"}
              </Link>
            </Grid>
          </Grid>
        </Box>
      </Box>
    </Container>
  );
};

export default SignIn;
