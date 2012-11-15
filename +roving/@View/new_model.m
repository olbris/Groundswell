function new_model(self,model,filename_local)

% change our pointer to the model
self.model=model;

% set the figure title
if isempty(filename_local)
  title_string='Roving';
else
  title_string=sprintf('Roving - %s',filename_local);
end
set(self.figure_h,'name',title_string);

% determine the colorbar bounds
[data_min,data_max]=self.model.pixel_data_type_min_max();
self.colorbar_min_string=sprintf('%d',data_min);
self.colorbar_max_string=sprintf('%d',data_max);
self.colorbar_min=str2double(self.colorbar_min_string);
self.colorbar_max=str2double(self.colorbar_max_string);
 
% change the colorbar
cb_min=self.colorbar_min;
cb_max=self.colorbar_max;
set(self.colorbar_axes_h,'YLim',[cb_min cb_max]);
% cb_increment=(cb_max-cb_min)/256;
% set(self.colorbar_h,'YData',[cb_min+0.5*cb_increment...
%                              cb_max-0.5*cb_increment]);
set(self.colorbar_h,'YData',[cb_min cb_max]);
                           
% reset the frame index
self.frame_index=1;

% prepare the axes to hold the frame
indexed_frame=self.indexed_frame;
[n_row,n_col]=size(indexed_frame);
set(self.image_axes_h,'XLim',[0.5,n_col+0.5],...
                      'YLim',[0.5,n_row+0.5]);

% set the image to the current frame
if self.image_h
%  set(self.image_h,'EraseMode','normal');
  delete(self.image_h)
end  
self.image_h = ...
  image('Parent',self.image_axes_h,...
        'CData',indexed_frame,...
        'SelectionHighlight','off',...
        'ButtonDownFcn',@(~,~)(self.mouse_button_down_in_image()));      
%        'EraseMode','normal',...
% tempargh set(self.image_h,'EraseMode','none');
% Need to do this rigamarole with erase mode to make sure old movie
% frames don't get left behind.
      
% clear the existing ROI border lines, labels
delete(self.border_roi_h);
delete(self.label_roi_h);

% init roi state
self.selected_roi_index=zeros(0,1);
self.hide_rois=false;
self.border_roi_h=zeros(0,1);
self.label_roi_h=zeros(0,1);
% self.roi_struct=struct('roi_ids',cell(0,1), ...
%                        'border_h',cell(0,1), ...
%                        'label_h',cell(0,1));
      
% update the frame counter stuff
if isfinite(self.model.fs)
  FPS_edit_string=sprintf('%6.2f',self.model.fs);
else
  FPS_edit_string='   ?  ';
end  
set(self.FPS_edit_h,'String',FPS_edit_string);
set(self.frame_index_edit_h,'String',sprintf('%d',self.frame_index));
n_frame=self.model.n_frames;
set(self.of_n_frames_text_h,'String',sprintf(' of %d',n_frame));
%of_n_frames_text_extent=get(self.of_n_frames_text_h,'Extent');
%of_n_frames_text_position=get(self.of_n_frames_text_h,'Position');
%pos_new=[of_n_frames_text_position(1:2) of_n_frames_text_extent(3:4)];
%set(self.of_n_frames_text_h,'Position',pos_new);

% need to set image erase mode to none, since now there are no 
% more lines in front of the image
% tempargh set(self.image_h,'EraseMode','none');
set(self.delete_all_rois_menu_h,'Enable','off');
set(self.save_rois_to_file_menu_h,'Enable','off');  
set(self.hide_rois_menu_h,'Label','Hide ROIs');
set(self.hide_rois_menu_h,'Enable','off');
% disable the select ROI button
set(self.select_button_h,'Enable','off');
% enable the move all ROIs button
set(self.move_all_button_h,'Enable','off');  

% enable buttons, menus that need enabling
set(self.frame_index_edit_h,'enable','on');
set(self.FPS_edit_h,'enable','on');
set(self.elliptic_roi_button_h,'enable','on');
set(self.rect_roi_button_h,'enable','on');
set(self.polygonal_roi_button_h,'enable','on');
set(self.zoom_button_h,'enable','on');
set(self.pixel_data_type_min_max_menu_h,'enable','on');
set(self.min_max_menu_h,'enable','on');
set(self.five_95_menu_h,'enable','on');
set(self.abs_max_menu_h,'enable','on');
set(self.ninety_symmetric_menu_h,'enable','on');
set(self.rois_menu_h,'enable','on');
set(self.open_rois_menu_h,'enable','on');
set(self.to_start_button_h,'enable','on');
set(self.play_backward_button_h,'enable','on');
set(self.frame_backward_button_h,'enable','on');
set(self.stop_button_h,'enable','on');
set(self.frame_forward_button_h,'enable','on');
set(self.play_forward_button_h,'enable','on');
set(self.to_end_button_h,'enable','on');
set(self.mutation_menu_h,'enable','on');
set(self.motion_correct_menu_h,'enable','on');
set(self.load_overlay_menu_h,'enable','on');


% set the mode to elliptic_roi
self.set_mode('elliptic_roi');

end
