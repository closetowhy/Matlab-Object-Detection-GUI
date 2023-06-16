function varargout = kursova(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kursova_OpeningFcn, ...
                   'gui_OutputFcn',  @kursova_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kursova is made visible.
function kursova_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kursova (see VARARGIN)

% Choose default command line output for kursova
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes kursova wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function chooseImage_Callback(hObject, eventdata, handles)
    % Open a dialog box for selecting an image
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'}, 'Виберіть зображення');
    
    %Check if any image choosed
    if isequal(filename, 0) || isequal(pathname, 0)
        return;
    end
    
    %Loading imahe 
    fullImagePath = fullfile(pathname, filename);
    
    image = imread(fullImagePath);
    
    %Display image on axes
    axes(handles.axes1);
    imshow(image);




% --- Outputs from this function are returned to the command line.
function varargout = kursova_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function findObjects_Callback(hObject, eventdata, handles)
    % Get image from axes1 object
    image = getimage(handles.axes1);
    
    % Check if i,age exists
    if isempty(image)
        return;
    end
    
    % Delete previously found objects if there were any
    cla(handles.axes1);
    
    %Image processing for finding red objects
    B_diff = imsubtract(image(:,:,1), rgb2gray(image));
    B_diff = medfilt2(B_diff, [3 3]);
    B_diff = im2bw(B_diff, 0.18);
    B_diff = bwareaopen(B_diff, 300);
    bw = bwlabel(B_diff, 8);
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the found objects on the image
    imshow(image, 'Parent', handles.axes1);
    hold on;
    objectCount = length(stats); % Count number of obects
    
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position', bb, 'EdgeColor', 'r', 'LineWidth', 2);
        plot(bc(1), bc(2), '-m+');
        text(bc(1) + 15, bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))), 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'green');
    end
    
    text(10, 10, strcat('Number of objects: ', num2str(objectCount)), 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
    hold off;
    
    %Display image on axes1
    axes(handles.axes1);
 
