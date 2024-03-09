<?php
/**
 * Hide the default file uploader for WordPress in favor of uploadcare uploader.
 *
 */
function wp_hide_default_file_upload()
{
  echo "<style>
  #plupload-upload-ui,
  .max-upload-size,
  .upload-ui {
    display: none !important;
  }

  .uc-picker-wrapper>p.max-upload-size {
    display: block !important;
  }

  .post-upload-ui {
    margin: 2em 0;
  }
</style>";
}
add_action('admin_head', 'wp_hide_default_file_upload');



