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

##Thursday, 5:00 AM Update##
TexasTony is going to crash. KatieBurke11, TexasTony, Tatwater, and Ren1us met in the Robotics lab at 6:00PM. KatieBurke11 left at midnight. Tatwater left at 4:30AM. TexasTony is leaving at 5:10AM. Ren1us is still working. We are so increadbly close...

"This is an impressive attempt at doing something somewhat intelligent." -- Famous last words.

###Evolution Plan###

####GA and NN Questions For Parker and Ansers####
Should we ease the agents into the training scheme?
	PARKER: Yes

How often should we switch the random seed?
	PARKER (hinted at, not explicit): Wait until you know it is learning. Then randomize it every so often, or once the fitness gets to a certain level.

How many layers should we do?
	PARKER: Both, train 2 different set ups

How many neurons inbetween layers?
	PARKER: At least 5, but less than the number of inputs or outputs, which ever is less.

How many bits should the weights be?
	PARKER: Around 6. The GA will not train chromosomes that are too big, so this is a limit on how many neurons we can have, and the primary reason we are doing multiple neural networks.
	
After a long discussion, it was advised that we create 4 neural networks: a neural network that predicts the behavior (M, B, D, or do-nothing), and a neural network for each of the decsions (B, D, M). The networks can first be trained individually, and then together in parallel. 

####Outputs####
MN ME MS MW BN BE BS BE DN DE DS DW

The first letter stands for an action: M = Move, B = Build, D = Destroy

1 M can be High OR 1 B can be High OR 0 to 4 D can be High

The above constraint may be the first real thing we "teach" our network. It could be as simple as setting the fitness of any Chromosome that breaks this constraint to 0. 0 D High is the choice to not do anything.

####Inputs or Sensors####
The 4 states of the adjacent blocks. (Free: 0, Blocked: 10000, Off the map: 20000)

The Agent's X and Y coordinate, and the Openet's X and Y (Discrete between 0 and 29).


###Division of Labor###
To me (TexasTony), it would make sense if we divided the labor amoung the following lines. One person works on the Neural Network, another on the Sensors and Outputs, another works on GA, and another on the Fitness function.

##Git Process##

###To Start New Project###
Clone Project to your Eclipse Platform via going to the Git perspective, Clone a Repository

In that view, Click the Repository, and select import project, import as general project.

Click the Repository, go to switch to, New Branch, and create a new branch. As your source, select Remote Tracking: GitHub/master. Now, if anyone updates that branch, you can pull those updates.

###When Opening Eclipse###
Go to the main branch, and hit Pull.

Merge any changes that have happened mannually by editing the code, and then clicking on the files that were conflicted, and then Add. Once all files have been merged manually, click commit. Do this Often and things won't be crazy when you commit and push later.

###If you would like us to see your work###
Push the branch to git by hitting Push. Make sure Pull first, or have a reason not to.

