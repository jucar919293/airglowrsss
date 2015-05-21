function output = ge_sami3(lon,lat,alt,data,clim,timestamp_0, timestamp_1,filename)
%
% Saves a CNFI image a format acceptable to Google Earth.
%
% INPUTS
%   lon - an array containing the longitude of each pixel in the image
%   [0...360]
%   lat - an array containing the latitude of each pixel in the image
%   [-90...90]
%   alt - the altitude to use for the projection, in meters
%   data - the data to be ploted
%   clim - the colorscale limits to use
%   timestamp_0 - the timestamp of the beginning of the data in 
%   yyyy-mm-ddThh:mm:sszzzzzz format.  This is a string.
%   timestamp_1 - the timestamp of the end of the data in 
%   yyyy-mm-ddThh:mm:sszzzzzz format.  This is a string.
%   filename - the filename for the png image created.  This is a string.
%
% OUTPUTS
%   output - the kml data for the image.  Call ge_output to write this to a
%   file.

% Need to get the data into lon = -180:180;

i = find(lon > 180);
j = find(lon <= 180);
lon(i) = lon(i)-360;
lon = lon([i,j]);
data = data(:,[i,j]);

% First we need to plot the data using pcolor
pcolor(lon,lat,data);
shading('interp');
caxis(clim);
axis off
set(gcf,'Color','k');

% Grab the frame data
d = getframe;
da = d.cdata;

% Grab the coordinate limits
x = get(gca,'XLim');
east = x(2);
west = x(1);
y = get(gca,'YLim');
south = y(1);
north = y(2);

% Make the alpha channel for transparency
alpha = ones(size(da)).*0.85;

% Write the transparent png
imwrite(da, filename, 'PNG', 'Alpha', alpha);

% Create the output to be written to a kml file

output = ['<GroundOverlay>\n',...
          '  <name>CASI Image</name>\n',...
          '  <Region>\n',...
          '    <LatLonAltBox>\n',...
          '      <north>',sprintf('%5.2f',north),'</north>\n',...
          '      <south>',sprintf('%5.2f',south),'</south>\n',...
          '      <east>',sprintf('%5.2f',east),'</east>\n',...
          '      <west>',sprintf('%5.2f',west),'</west>\n',...
          '      <minAltitude>',sprintf('%d',alt),'</minAltitude>\n',...
          '      <maxAltitude>',sprintf('%d',alt),'</maxAltitude>\n',...
          '      <altitudeMode>absolute</altitudeMode>\n',...
          '    </LatLonAltBox>\n',...
          '    <Lod>\n',...
          '      <minLodPixels>128</minLodPixels>\n',...
          '    </Lod>\n',...
          '  </Region>\n',...
          '  <TimeSpan>\n',...
          '    <begin>',timestamp_0,'</begin>\n',...
          '    <end>',timestamp_1,'</end>\n',...
          '  </TimeSpan>\n',...
          '  <Icon>\n',...
          '    <href>',filename,'</href>\n',...
          '  </Icon>\n',...
          '  <altitude>',sprintf('%d',alt),'</altitude>\n',...
          '  <altitudeMode>absolute</altitudeMode>\n',...
          '  <LatLonBox>\n',...
          '    <north>',sprintf('%5.2f',north),'</north>\n',...
          '    <south>',sprintf('%5.2f',south),'</south>\n',...
          '    <east>',sprintf('%5.2f',east),'</east>\n',...
          '    <west>',sprintf('%5.2f',west),'</west>\n',...
          '  </LatLonBox>\n',...
          '</GroundOverlay>\n'];

end