# sample_spacexdata

SpaceXData Sample

The UI should specially have some more love. The images loading could be more efficient (fetching a smaller image, or at least scale it once he show it, since now it is consuming much memory for what we are using it) and a smooth transition can be shown when the image is loaded.

A common place to manage all routing is also lacking.

Normally I would use a "Page" to fetch all necessary data and create another object that would only deal with the UI. In this case, both are done in the same object.

I would cache the network requests so we don't make the same call again in one same app session.
