#Predator/Prey in the Grid#

###Project Summary###
Create a predator and a prey for the predator/prey competition on 05/08/14.

###Project Guidelines###
You can only modify grid-get-next-robot.ss and grid-get-next-goal.ss. Rename them both with your
name in front of grid.

You have two new functions at your disposal (build and blast). You may modify them both with the
following restrictions:
- build can build an obstacle at any adjacent node, but only one during a turn, and the agent
cannot move during that turn
- blast can blast away any and all adjacent obstacles (change the obstacle nodes into a free nodes)
and the agent cannot move during that turn.

Any functions within your code, except get-next-robot and get-next-goal, must begin r if in the
robot file and g if in the goal file.

Other than build and blast, your program cannot alter the grid or your opponent. Your programs will
be graded on the speed (no excessive delays in movement), uniqueness, and effectiveness of your
controller.

This is not intended to be a repeat of the mini-max assignment, although you may use mini-max up to
3 plys. For the best grade, make use of other AI methods, such as NNs, CBR, or production systems.
