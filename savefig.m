function savefig(filename, fig)
if nargin < 2, fig = gcf; end

% add .png extension if not already
[~,~,ext] = fileparts(filename);

switch ext
    case '.png'
        background = get(gcf, 'color'); % save the original bg color for later use
        set(fig, 'InvertHardCopy','off');

        % print file w/o transparency
        print(fig, '-dpng',filename);

        % read image data back in
        cdata = imread(filename);

        % write it back out - setting transparency info
        imwrite(cdata,filename,'png','BitDepth',16,'transparency',background)

    case '.eps'
        print(fig, '-depsc',filename);

end
end
