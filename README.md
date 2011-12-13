Here is some Processing code for tracking people moving through a building, given security camera footage of the elevators.

Run `sb_elevator_combined` on your secondary monitor while you run your security camera software on the primary monitor. It's currently set up to monitor 4 elevators with 2 seven-segment displays.

The app shows some debug information, notably which floor it thinks it sees (near the elevator display), and whether it sees movement.

You can calibrate everything via the keyboard.

To move around the viewport:
`WASD` - move the viewport left right up down
`+-` - zoom in/out

The digit detection is done using "pixel trackers". Each pixel tracker tracks a given pixel and determines if it's on or off (measured by it's green-ness being above a threshold, 200 currently).

To switch between pixel trackers and see what they're seeing:
`<>` - switch between pixel trackers

You'll be able to see it as a red square centered on the pixel (useful to zoom in here). You'll see the id of the tracker above it (there are 64 trackers, I will draw a picture of which "segment" each id is supposed to watch). And below it you'll see the color and the brightness (greenness) value.

To move a pixel tracker:
`JKLI` - move the currently selected pixel tracker
`C` - move the currently selected pixel tracker to the center of the viewport
`Z` - save the current positions to positions.txt (these will load automatically when you start the app)