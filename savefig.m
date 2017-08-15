function savefig(filename)

background = get(gcf, 'color'); % save the original bg color for later use

set(gcf,'InvertHardCopy','off');

% add .png extension if not already
[~,~,ext] = fileparts(filename);
if ~strcmp(ext,'.png'), filename = [filename,'.png']; end

% print file w/o transparency
print('-dpng',filename);

% read image data back in
cdata = imread(filename);

% write it back out - setting transparency info
imwrite(cdata,filename,'png','BitDepth',16,'transparency',background)

end
