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

import TagInput from "../../components/tagInput/TagInput";
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
  const handleTagsChange = (tags) => {
    formik.setFieldValue("tags", tags); // Do something with the updated tags, e.g. update formik state
  };

  const validationSchema = yup.object({
    description: yup.string("describe your post"),
    medias: yup.array().required("insert one media at least "),
    tags: yup
      .array()
      .of(yup.string())
      .required("add tags to your post"),
  });

  const handleSubmit = async (values, { setSubmitting }) => {
    setSubmitting(true);
    const { error, data: post } = await supabase
      .rpc("create_post", {
        description: values?.description,
        tags: values.tags,
        geo: `(${geo.lng},${geo.lat})`,
        user_id: user.id,
      })
      .select("id");

    if (error) {
      console.log("Create Post is failed please try again");
      setSubmitting(false);
      return;
    }

    createMediasCollection(`/${user.id}`, values.medias, post.id);
    setSubmitting(false);
    setOpen(true);
  };

  const formik = useFormik({
    initialValues: {
      description: "",
      tags: [],
      medias: [],
    },
    isInitialValid:false,
    validationSchema: validationSchema,
    
    onSubmit: handleSubmit,
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
            label="what is on your mind ?"
            type="text"
            value={formik.values.description}
            onChange={formik.handleChange}
            error={
              formik.touched.description && Boolean(formik.errors.description)
            }
            helperText={formik.touched.description && formik.errors.description}
          />

          <TagInput placeholder="tag your post!" onChange={handleTagsChange} />

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
            disabled={formik.isSubmitting||!formik.isValid}
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
