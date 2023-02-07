import { supabase } from "../supabaseClient";

export async function createMedia(baseUrl = "", file, postId = undefined) {
  if (!postId) throw new Error("Post id not provided!");

  let path = baseUrl;
  let mediaType = "image";

  const filename = `${Date.now()}.${file.type.split("/")[1]}`;

  if (file.type.includes("image")) {
    mediaType = "image";
    path += `/images/${filename}`;
  } else if (file.type.includes("video")) {
    mediaType = "video";
    path += `/videos/${filename}`;
  }

  const { data, error } = await supabase.storage
    .from("medias")
    .upload(path, file);

  if (error) {
    console.error(error);
  }

  return supabase.from("medias").insert({
    source: `https://bdrfsldnykzfwnvnwztn.supabase.co/storage/v1/object/public/medias/${data.path}`,
    type: mediaType,
    postID: postId,
  });
}

export function createMediasCollection(
  baseUrl = "",
  files = [],
  postId = undefined
) {
  // Create Queue
  files.forEach((file, i) =>
    setTimeout(() => createMedia(baseUrl, file, postId), 100 * i)
  );
}
