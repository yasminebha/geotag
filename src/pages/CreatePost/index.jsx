import CloseIcon from "@mui/icons-material/Close";
import { Container, CssBaseline, Typography } from "@mui/material";
import Button from "@mui/material-next/Button";
import Alert from "@mui/material/Alert";
import Box from "@mui/material/Box";
import Collapse from "@mui/material/Collapse";
import IconButton from "@mui/material/IconButton";
import TextField from "@mui/material/TextField";
import "filepond/dist/filepond.min.css";
import { useFormik } from "formik";
import { useContext, useState } from "react";
import { FilePond, registerPlugin } from "react-filepond";
import * as yup from "yup";
import { supabase } from "../../supabaseClient";
import { UserContext } from "../../utils/context/user";
import "./style.css";
//filePond for images uploading
import FilePondPluginImageEdit from "filepond-plugin-image-edit";
import "filepond-plugin-image-edit/dist/filepond-plugin-image-edit.css";
import FilePondPluginImageExifOrientation from "filepond-plugin-image-exif-orientation";
import FilePondPluginImagePreview from "filepond-plugin-image-preview";
import "filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css";

import { useGeoLocation } from "../../utils/context/geolocation";
import { createMediasCollection } from "../../utils/media";

registerPlugin(
  FilePondPluginImageExifOrientation,
  FilePondPluginImagePreview,
  FilePondPluginImageEdit
);

const CreatePost = () => {
  const { user } = useContext(UserContext);
  const [open, setOpen] = useState(false);

  const geo = useGeoLocation();

  const validationSchema = yup.object({
    description: yup.string().required("description is required"),
    medias: yup.array().required("insert at least one picture"),
  });

  const formik = useFormik({
    initialValues: {
      description: "",
      medias: [],
    },
    validationSchema: validationSchema,
    onSubmit: async (values, { setSubmitting }) => {
      setSubmitting(true);
      const { error } = await supabase.from("posts").insert({
        description: values.description,
        userID: user.id,
        geo: `(${geo.lng},${geo.lat})`,
      });

      if (error) {
        console.log("Create Post is failed please try again");
        setSubmitting(false);
        return;
      }

      const { data: post } = await supabase
        .from("posts")
        .select("id")
        .eq("userID", user.id)
        .eq("description", values.description)
        .maybeSingle();

      createMediasCollection(`/${user.id}`, values.medias, post.id);
      setSubmitting(false);
      setOpen(true);
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
        <Typography component="h1" variant="h5">
          New Post
        </Typography>

        <Box
          className="form"
          component="form"
          onSubmit={formik.handleSubmit}
          noValidate
          sx={{ mt: 1 }}
        >
          <TextField
            fullWidth
            margin="normal"
            id="description"
            name="description"
            label="description"
            type="text"
            value={formik.values.description}
            onChange={formik.handleChange}
            error={
              formik.touched.description && Boolean(formik.errors.description)
            }
            helperText={formik.touched.description && formik.errors.description}
          />

          <FilePond
            onupdatefiles={(uploads) => {
              const files = uploads.map(({ file }) => file);
              formik.setFieldValue("medias", files);
            }}
            instantUpload={false}
            allowMultiple={true}
            maxFiles={10}
            labelIdle='Drag & Drop your files or <span class="filepond--label-action">Browse</span>'
          />

          <Button
            className="w-full color"
            fullWidth
            variant="filledTonal"
            type="submit"
            disabled={formik.isSubmitting}
            sx={{ mr: 3, mb: 2, color: "white" }}
          >
            Create
          </Button>

          <Box sx={{ width: "100%" }}>
            <Collapse in={open}>
              <Alert
                action={
                  <IconButton
                    aria-label="close"
                    color="inherit"
                    size="small"
                    onClick={() => {
                      setOpen(false);
                    }}
                  >
                    <CloseIcon fontSize="inherit" />
                  </IconButton>
                }
                sx={{ mb: 2 }}
              >
                post created successfuly!
              </Alert>
            </Collapse>
          </Box>
        </Box>
      </Box>
    </Container>
  );
};
export default CreatePost;
