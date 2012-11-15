function resize(self)

% IMPORTANT: Need to make sure we save the current
% main figure units, set them to pels, then set them back at the end
% Some functions, like errordlg(), set them briefly to other things, and
% sometimes the resize callback gets called during this interval, and that
% causes the figure to get messed-up.

% get current units, save; set units to pels
units_before=get(self.figure_h,'units');
set(self.figure_h,'units','pixels');

% get figure size
pos=get(self.figure_h,'position');
figure_width=pos(3);
figure_height=pos(4);

%
% calculate various UI sizes and offsets
%
%n_mode_buttons=6;
mode_button_width=70;
mode_button_height=30;
mode_button_spacer_height=0;
button_image_pad_width=20;  % pad between mode/action buttons and image 
% The "colorbar area" is a rectangle to the right of the "image frame".
% The colorbar area just contains two rectangles, the colorbar itself (on
% the left) and the "colorbar label area" on the right.
colorbar_label_area_width=30;
colorbar_width=30;
colorbar_area_width=colorbar_width+colorbar_label_area_width;
image_colorbar_pad_width=15;  % pad between image area and colorbar
n_vcr_buttons=7;
vcr_button_width=60;
vcr_button_height=20;
figure_right_pad_size=20;
figure_left_pad_size=20;
frame_index_and_fps_editbox_frame_height=40;
vcr_button_bar_frame_height=50;
image_frame_area_width=figure_width - ...
                 (figure_left_pad_size+...
                  mode_button_width+...
                  button_image_pad_width+...
                  image_colorbar_pad_width+...
                  colorbar_area_width+...
                  figure_right_pad_size);
image_frame_area_height= ...
  figure_height - ...
    (frame_index_and_fps_editbox_frame_height+ ...
     vcr_button_bar_frame_height);
image_frame_area_width=max(image_frame_area_width,1);
image_frame_area_height=max(image_frame_area_height,1);
% The "frame" is the area where the image goes.  It consists of a
% transparent "matte" surrounding the image, with the image centered in the
% frame.
colorbar_area_height=image_frame_area_height;
vcr_button_spacer_width=10;
vcr_button_bar_width= ...
  n_vcr_buttons*vcr_button_width+(n_vcr_buttons-1)*vcr_button_spacer_width;
vcr_button_bar_x_offset= ...
  figure_left_pad_size+mode_button_width+...
  button_image_pad_width+(image_frame_area_width-vcr_button_bar_width)/2;
% The zoom factor for the image should be as large as possible s.t.
% the image still fits within the image frame
n_col=diff(get(self.image_axes_h,'xlim'));
n_row=diff(get(self.image_axes_h,'ylim'));
zoom=min((image_frame_area_width/n_col), ...
         (image_frame_area_height/n_row));
% unpack the sizes of certain UI elements that were determined
% upon view creation
frame_text_width=self.frame_text_width;
frame_text_height=self.frame_text_height;
frame_index_edit_width=self.frame_index_edit_width;
frame_index_edit_height=self.frame_index_edit_height;
of_n_frames_text_width=self.of_n_frames_text_width;
of_n_frames_text_height=self.of_n_frames_text_height;
FPS_text_width=self.FPS_text_width;
FPS_text_height=self.FPS_text_height;
FPS_edit_width=self.FPS_edit_width;
FPS_edit_height=self.FPS_edit_height;


%
% Set positions of UI widgets
%

% position the colorbar axes
set(self.colorbar_axes_h, ... = ...
    'Position',[figure_left_pad_size+...
                  mode_button_width+...
                  button_image_pad_width+...
                  image_frame_area_width+...
                  image_colorbar_pad_width,...
                vcr_button_bar_frame_height,...
                colorbar_width,...
                colorbar_area_height]);

% position the image axes
image_area_width=zoom*n_col;
image_area_height=zoom*n_row;
matte_width=(image_frame_area_width-image_area_width)/2;
matte_height=(image_frame_area_height-image_area_height)/2;
set(self.image_axes_h, ...
    'Position',[figure_left_pad_size+mode_button_width+button_image_pad_width+ ...
                  matte_width,...
                vcr_button_bar_frame_height+matte_height,...
                image_area_width,...
                image_area_height]);

% VCR-style controls
set(self.to_start_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (1-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);
set(self.play_backward_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (2-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);
set(self.frame_backward_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (3-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);
set(self.stop_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (4-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);
set(self.frame_forward_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (5-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);
set(self.play_forward_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (6-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);
set(self.to_end_button_h , ...
            'Position',...
              [vcr_button_bar_x_offset+...
                 (7-1)*(vcr_button_width+vcr_button_spacer_width),...
               (vcr_button_bar_frame_height-vcr_button_height)/2,...
               vcr_button_width,...
               vcr_button_height]);

% set the position of the text object that says "Frame"
frame_text_left_margin=figure_left_pad_size+mode_button_width+...
                       button_image_pad_width;
frame_text_baseline= ...
  figure_height-(frame_index_and_fps_editbox_frame_height+frame_text_height)/2;
set(self.frame_text_h, ...
    'Position',[frame_text_left_margin,...
                frame_text_baseline,...
                frame_text_width,...
                frame_text_height]);
              
% set the position of the editbox containing the current frame index
set(self.frame_index_edit_h,...
    'Position',[frame_text_left_margin+frame_text_width,...
                frame_text_baseline+...
                  (frame_text_height-frame_index_edit_height)/2+2,...
                frame_index_edit_width,...
                frame_index_edit_height]);
              
% set the position of the text object that says "of <number of frames total>"
set(self.of_n_frames_text_h, ...
      'Position',[frame_text_left_margin+frame_text_width+...
                    frame_index_edit_width,...
                  frame_text_baseline,...
                  of_n_frames_text_width,...
                  of_n_frames_text_height]);
                      
% Set the positions of frames-per-second controls
FPS_elements_width=FPS_text_width+FPS_edit_width;
FPS_elements_left_margin=figure_left_pad_size+mode_button_width+...
                         button_image_pad_width+image_frame_area_width-...
                         FPS_elements_width;
FPS_elements_baseline= ...
  figure_height-(frame_index_and_fps_editbox_frame_height+FPS_text_height)/2;
set(self.FPS_text_h, ...
    'Position',[FPS_elements_left_margin,...
                FPS_elements_baseline,...
                FPS_text_width,...
                FPS_text_height]);
set(self.FPS_edit_h,...
    'Position',[FPS_elements_left_margin+FPS_text_width,...
                FPS_elements_baseline+...
                  (FPS_text_height-FPS_edit_height)/2+2,...
                FPS_edit_width,...
                FPS_edit_height]);

% Set the positions of the mode buttons
mode_button_bar_y_offset= ...
  vcr_button_bar_frame_height+image_frame_area_height-mode_button_height;
set(self.elliptic_roi_button_h , ...
            'Position',...
              [figure_left_pad_size,...
               mode_button_bar_y_offset-...
                 (1-1)*(mode_button_height+mode_button_spacer_height),...
               mode_button_width,...
               mode_button_height]);
set(self.rect_roi_button_h , ...
            'Position',...
              [figure_left_pad_size,...
               mode_button_bar_y_offset-...
                 (2-1)*(mode_button_height+mode_button_spacer_height),...
               mode_button_width,...
               mode_button_height]);
set(self.polygonal_roi_button_h , ...
            'Position',...
              [figure_left_pad_size,...
               mode_button_bar_y_offset-...
                 (3-1)*(mode_button_height+mode_button_spacer_height),...
               mode_button_width,...
               mode_button_height]);
set(self.select_button_h , ...
            'Position',...
              [figure_left_pad_size,...
               mode_button_bar_y_offset-...
                 (4-1)*(mode_button_height+mode_button_spacer_height),...
               mode_button_width,...
               mode_button_height]);
set(self.zoom_button_h , ...
            'Position',...
              [figure_left_pad_size,...
               mode_button_bar_y_offset-...
                 (5-1)*(mode_button_height+mode_button_spacer_height),...
               mode_button_width,...
               mode_button_height]);
set(self.move_all_button_h , ...
            'Position',...
              [figure_left_pad_size,...
               mode_button_bar_y_offset-...
                 (6-1)*(mode_button_height+mode_button_spacer_height),...
               mode_button_width,...
               mode_button_height]);

             
% restore fig units
set(self.figure_h,'units',units_before);

end
