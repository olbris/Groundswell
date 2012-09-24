function [t_exposure,success]= ...
  rectify_exposure_times(t_exposure_raw,n_frame,normal_mode)

% Figures out which of the exposure times in t_exposure_raw correspond to
% frames, and returns just those times in t_exposure.  This is done by
% taking into account the number of frames acquired (n_frame) and 
% the mode that the frames were acquired in.  normal_mode is a boolean,
% which is true if the frames were acquired in normal (i.e.
% non-frame-transfer) mode, and false if the frames were acquired in
% frame-transfer mode.

% If frames were acquired in normal (i.e. non-frame-transfer) mode, then
% typically n_pulses==n_frames+1, with the last pulse being shorter than
% the others, and not corresponding to a frame.  (We call a short pulse at
% the end that doesn't correspond to a frame a "vestigial" pulse.)  If
% frames were acquired in frame-transfer more, then typically
% n_pulses==n_frames+2, with the first pulse corresponding to no frame, and
% the last pulse being a vestigial pulse (and thus not corresponding to any
% frame either).
%
% The general strategy for dealing with all this is: If in FT mode, ignore
% the first pulse.  Then match each frame to a pulse, in order.  If you run
% out of pulses before you run out of frames, throw an error.  If not,
% all is well, you're done.  (A consequence of this is that having many
% more pulses than frames is a problem.)
%
% However, we do warn the user if they've said the data was acquired in
% normal mode but n_pulses==n_frames+2, and we also warn them if they've
% said the data was acquired in FT mode but n_pulses==n_frames+1.  But they
% can ignore these warnings and proceed if they want to.

n_exposure_raw=length(t_exposure_raw);
if normal_mode
  if n_exposure_raw>n_frame
    % if the roi data is not in frame transfer mode, throw up a warning if
    % there are two more pulses than frames, since that's the usual signature
    % of frame transfer data
    if n_exposure_raw==n_frame+2
      button_label= ...
        questdlg(...
          sprintf(['There are %d frames, and %d exposure pulses.  ' ...
                   'Data acquired in frame-transfer mode typically has ' ...
                   'two more pulses than frames.  Are you sure you want ' ...
                   'to proceed, treating this as non-frame-transfer data?'], ...
                  n_frame,n_exposure_raw), ...
          'Really non-frame-transfer?', ...
          'Proceed','Cancel', ...
          'Cancel');
      if ~strcmp(button_label,'Proceed')
        %self.view.unhourglass();
        t_exposure=zeros(0,1);
        success=false;
        return;
      end
    end
    % ignore exposure pulses at end
    t_exposure=t_exposure_raw(1:n_frame);
    success=true;
  elseif n_exposure_raw<n_frame
    errordlg(...
      sprintf(['There are %d frames, but only %d exposure pulses.  ' ...
               'Aborting.'], ...
              n_frame,n_exposure_raw));
    t_exposure=zeros(0,1);
    success=false;
    %self.view.unhourglass();
    return;
  else
    % If n_expsoure==n_frame, nothing to do.  (Although, this case actually
    % seems to be somewhat unusual, since in normal mode there's usually n+1
    % exposure pulses, where n is the number of frames, and the last pulse is
    % shorter than the rest, and doesn't correspond to a frame.)
    t_exposure=t_exposure_raw;
    success=true;
  end
else
  % optical data was acquired in frame-transfer mode
  
  % frame-transfer mode should always have an initial exposure pulse
  % that does not correspond to a frame.  If there are extra pulses, even
  % taking the above into account, they are assumed to come _after_ the
  % frames.

  if n_exposure_raw>n_frame+1
    % ignore first pulse, and any extra pulses at end
    t_exposure=t_exposure_raw(2:n_frame+1);
    success=true;
  elseif n_exposure_raw<n_frame+1
    % not enough exposure pulses
    if n_exposure_raw==n_frame
      % A special case that requires some explaining.
      errordlg(...
        sprintf(['There are %d frames, and %d exposure pulses, ' ...
                 'but the first pulse is ignored for ' ...
                 'frame-transfer data, so there are not enough ' ...
                 'exposure pulses.  Aborting.'], ...
                n_frame,n_exposure_raw));
    else
      % The usual case, given that n_exposure<n_frame+1
      errordlg(...
        sprintf(['There are %d frames, but only %d exposure pulses.  ' ...
                 '(And the first pulse is ignored for ' ...
                 'frame-transfer data.)  ' ...
                 'Aborting.'], ...
                n_frame,n_exposure_raw+1));
      % n_exposure is one less than the true number of of exposure pulses.        
    end    
    %self.view.unhourglass();
    t_exposure=zeros(0,1);
    success=false;
    return;
  else  % i.e. if n_exposure==n_frame+1
    % While not necessarily a problem, this is the usual signature of data 
    % acquired in non-frame-transfer mode.  Double-check with the user.
    button_label= ...
      questdlg(...
        sprintf(['There are %d frames, and %d exposure pulses.  ' ...
                 'Data acquired in non-frame-transfer mode typically has ' ...
                 'one more pulse than frames.  Are you sure you want ' ...
                 'to proceed, treating this as frame-transfer data?'], ...
                n_frame,n_exposure_raw), ...
        'Really frame-transfer?', ...
        'Proceed','Cancel', ...
        'Cancel');
    if ~strcmp(button_label,'Proceed')
      %self.view.unhourglass();
      t_exposure=zeros(0,1);
      success=false;
      return;
    end
    % if user is sure, ignore first exposure pulse
    t_exposure=t_exposure_raw(2:end);  
    success=true;
  end
end

end
