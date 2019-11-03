require(raster)
require(sf)
require(viridis)
require(units)
require(rgeos)
require(lwgeom)

pop_dens <- data.frame(n_km2 = c(260, 67, 151, 4500, 133), 
    country = c('England', 'Scotland', 'Wales', 'London', 'Northern Ireland'))
print(pop_dens)

##############################################
# Create coordinates  for each country 
##############################################

# -  this is a list of sets of coordinates forming the edge of the polygon. 
# - note that they have to _close_ (have the same coordinate at either end)
scotland <- rbind(c(-5, 58.6), c(-3, 58.6), c(-4, 57.6), 
                  c(-1.5, 57.6), c(-2, 55.8), c(-3, 55), 
                  c(-5, 55), c(-6, 56), c(-5, 58.6))
england <- rbind(c(-2,55.8),c(0.5, 52.8), c(1.6, 52.8), 
                  c(0.7, 50.7), c(-5.7,50), c(-2.7, 51.5), 
                  c(-3, 53.4),c(-3, 55), c(-2,55.8))
wales <- rbind(c(-2.5, 51.3), c(-5.3,51.8), c(-4.5, 53.4),
                  c(-2.8, 53.4),  c(-2.5, 51.3))
ireland <- rbind(c(-10,51.5), c(-10, 54.2), c(-7.5, 55.3),
                  c(-5.9, 55.3), c(-5.9, 52.2), c(-10,51.5))

# Convert these coordinates into feature geometries
# - these are simple coordinate sets with no projection information
scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

# Create polygons roughly in the shape of the UK
uk_eire <- st_sfc(wales, england, scotland, ireland, crs=4326)
plot(uk_eire, asp=1)

###########################################
# Set up capitals
###########################################

#Set capital coordinates 
uk_eire_capitals <- data.frame(long = c(-0.1, -3.2, -3.2, -6.0, -6.25), 
    lat = c(51.5, 51.5, 55.8, 54.6, 53.30), 
    name = c('London', 'Cardiff', 'Edinburgh', 'Belfast', 'Dublin'))
#converting the capitals foreign object to an sf object
uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords=c('long','lat'), crs=4326)

###########################################
# Remove overlapping areas on map
###########################################

#Use the buffer operation to create a polygon for London (defined as anywhere within a quater degree of St. Pauls Cathedral)
st_pauls <- st_point(x=c(-0.098056, 51.513611))
london <- st_buffer(st_pauls,0.25)

# Remove London from the England polygon so that we can set different population densities for the two regions 
# Uses difference operation, order is important here 
england_no_london <- st_difference(england, london)

# Count the points and show the number of rings within the polygon features
lengths(scotland)
lengths(england_no_london)

# use same approach to tidy up wales 
wales <- st_difference(wales, england)

# Use "intersection" function to separate Northern Ireland from the island of Ireland. 
# Create a rough polygon that includes Northern Ireland and sticks out into the sea
# Find the intersrctin and difference of that with the Ireland polygon to get Northern Ireland nad Eire 

# A rough polygon that includes Northern Ireland and surrounding sea.
# - not the alternative way of providing the coordinates
ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1), y=c(54.4, 56, 55, 54, 54.4))))

northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

#combine the final geometries
uk_eire <- st_sfc(wales, england_no_london, scotland, london, northern_ireland, eire, crs=4326)

####################################
# Make the UK into a single feature
####################################

# uk_eire object now contains 6 features
# feature is a set GIS geometries that represent a spatial unit we are interested in 
# uk_eire holds 6 features - each represents a separate single polygon
# we want to combine uk_eire into a single feature that contains all of those geometries into a single "Multipolygon" geometry 
# We use the union operation for this 

uk_country <- st_union(uk_eire[-6])
#compare six Polygon features with one Multipolygon feature
print(uk_eire)
print(uk_country)

# Plot the side-by-side comparisons of 6 feature polygons vs. multipolygon 
par (mfrow = c(1,2), mar = c(3,3,1,1))
plot(uk_eire, asp=1, col= rainbow(6))
plot(st_geometry(uk_eire_capitals), add = TRUE)
plot(uk_country, asp=1, col='lightblue')

# Convert into an sf frame
uk_eire <- st_sf(name=c('Wales', 'England','Scotland', 'London', 
                        'Northern Ireland', 'Eire'),
                 geometry=uk_eire)

plot(uk_eire, asp=1)

# make the whole country prettier 
uk_eire$capital <- c('London', 'Edinburgh', 'Cardiff', NA, 'Belfast', 'Dublin')

# Use the merge command to match data in
# NB: need to use by.x and by.y to say which columns we expect to match
# We also use all.x=TRUE other
uk_eire <- merge(uk_eire, pop_dens, by.x='name', by.y='country', all.x=TRUE)
print(uk_eire)

###################################
# Finding geometries of the figure
###################################

# Centroids = central point of a figure also called the geometric center
uk_eire_centroids <- st_centroid(uk_eire) # returns warning messages because there isn't a good way to calculate a true centroid for geographical coordinates 
st_coordinates(uk_eire_centroids)

# Length and Areas 
uk_eire$area <- st_area(uk_eire)
# The length of a polygon is the perimeter length 
# note that this includes the length of internal holes 
uk_eire$length <- st_length(uk_eire)
print(uk_eire)

#####################################
# Changing units
#####################################

#you can change units in a neat way
uk_eire$area <- set_units(uk_eire$area, 'km^2')
uk_eire$length <- set_units(uk_eire$length, 'km')
# And which won't let you make silly areas like turning length into weight 
uk_eire$area <- set_units(uk_eire$area, 'kg') #returns an error
# Or you can simply convert the 'units' version to simple numbers
uk_eire$length <- as.numeric(uk_eire$length)
print(uk_eire)

#######################################
# Finding distance between objects
#######################################

# sf gives us the closest distance between geometries
# sf will return zero if two features are touching 
st_distance(uk_eire)
st_distance(uk_eire_centroids)

########################################
# Plotting sf objects 
########################################

# the default if you plot sf is to plot a map for every attribute, you can pick a column to show using square brackets 
plot(uk_eire['n_km2'], asp=1, key.length = 1, key.pos = 1)
# the st_geometry function can be used to temporarily strip off attributes
# adjusting the scale of the legend
# ??????????????????????

########################################
# Reprojecting Vector Data
########################################

# we have thusfar been asserting that we have data with the projection 4326 - a numeric code in the EPSG database of spatial coordinate systems
# the code acts as a shortcut for often complicated sets of parameters and transformations that define a particular projection 
# Here 4326 is the WGS84 geographic coordinate system which is extremely widely used, most GPS data is collected in WGS84

# Reproject our UK and Eire map onto the British National Grid - good choice, and UTM 50N - bad choice

# British National Grid (EPSG:27700)
uk_eire_BNG <- st_transform(uk_eire, 27700)
# The bounding box of the data shows the change in units
st_bbox(uk_eire)
st_bbox(uk_eire_BNG)

# UTM50N (EPSG:32650)
uk_eire_UTM50N <- st_transform(uk_eire, 32650)
# Plot the results
par(mfrow=c(1, 3), mar=c(3,3,1,1))
plot(st_geometry(uk_eire), asp=1, axes=TRUE, main='WGS 84')
plot(st_geometry(uk_eire_BNG), axes=TRUE, main='OSGB 1936 / BNG')
plot(st_geometry(uk_eire_UTM50N), axes=TRUE, main='UTM 50N')

# Those EPSG ID codes save us from proj4 strings 

# Set up some points separated by 1 degree latitude and longitude from St. Pauls
st_pauls <- st_sfc(st_pauls, crs=4326)
one_deg_west_pt <- st_sfc(st_pauls - c(1, 0), crs=4326) # near Goring
one_deg_north_pt <-  st_sfc(st_pauls + c(0, 1), crs=4326) # near Peterborough

# Calculate the distance between St Pauls and each point
st_distance(st_pauls, one_deg_west_pt)

st_distance(st_pauls, one_deg_north_pt)


# the great circle distance between London and Goring accounts for the curvature of the earth - roughly 17 metres longer than the distance between the same coordinates projected onto the British National Grid 

st_distance(st_transform(st_pauls, 27700), st_transform(one_deg_west_pt, 27700))

#???????????? Improve london feature

