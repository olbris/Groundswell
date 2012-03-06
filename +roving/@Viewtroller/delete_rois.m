function delete_rois(self,roi_indices_to_delete)

% do it
%roi_struct_old=self.roi_struct;
n_roi_old=length(self.model.roi);
keep=true([n_roi_old 1]);
keep(roi_indices_to_delete)=false;
toss=~keep;

% kill widgets
delete(self.border_roi_h(toss));
delete(self.label_roi_h(toss));

% modify the viewtroller handle arrays
border_roi_h=self.border_roi_h(keep);
label_roi_h=self.label_roi_h(keep);

% modify selected_roi_index, etc.
selected_roi_index=self.selected_roi_index;
if ~isempty(selected_roi_index)
  if any(roi_indices_to_delete==selected_roi_index)
    % the selected ROI is being deleted
    % gray the rename, delete roi menus
    set(self.delete_roi_menu_h,'Enable','off');
    set(self.rename_roi_menu_h,'Enable','off');
    % set the state
    selected_roi_index=zeros(0,1);
  else
    % the selected ROI is not one of the ones being deleted
    selected_roi_index=selected_roi_index-...
                       sum(roi_indices_to_delete<selected_roi_index);
  end
end

% commit changes to the viewtroller
self.border_roi_h=border_roi_h;
self.label_roi_h=label_roi_h;
%self.roi_struct=roi_struct;
self.selected_roi_index=selected_roi_index;
  
% change the model
self.model.delete_rois(roi_indices_to_delete);

% modify ancillary crap
n_roi=length(self.model.roi);
if n_roi==0
  % need to set image erase mode to none, since now there are no 
  % more lines in front of the image
  set(self.image_h,'EraseMode','none');
  set(self.delete_all_rois_menu_h,'Enable','off');
  set(self.save_rois_to_file_menu_h,'Enable','off');  
  set(self.hide_rois_menu_h,'Enable','off');
  self.set_hide_rois(0);
  % disable the select ROI button
  set(self.select_button_h,'Enable','off');
  % enable the move all ROIs button
  set(self.move_all_button_h,'Enable','off');  
  % change the mode to elliptic_roi
  self.set_mode('elliptic_roi');
  set(self.export_to_tcs_menu_h,'Enable','off');
  self.card_birth_roi_next=1;  % reset this
end

end