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

###Evolution Plan###
####Initilization####
Generate 10 random chromosomes, this the Knight Population.

Generate another 10 random chromsomes, this is the Grail Population.

####Loop####
	For every Grail
		Let Fitness be 0
	End For
	Generate a random seed
	For every Knight
		Let Knight's Fitness be 0
		For every Grail
			With Seed, create a Grid
			Run Knight and Grail on Grid
			Set Knight's fitness to be pastFitness + thisFitness
			Set Grail's fitness to be pastFitness + thisFitness
		End For
	End For
	Breed

####GA and NN Questions####
Should we ease the agents into the training scheme?

How often should we switch the random seed?

How many layers should we do?

How many neurons inbetween layers?

How many bits should the weights be?

####Outputs####
MN ME MS MW BN BE BS BE DN DE DS DW

The first letter stands for an action: M = Move, B = Build, D = Destroy

1 M can be High OR 1 B can be High OR 0 to 4 D can be High

The above constraint may be the first real thing we "teach" our network. It could be as simple as setting the fitness of any Chromosome that breaks this constraint to 0. 0 D High is the choice to not do anything.

####Inputs or Sensors####
The 4 states of the adjacent blocks (Binary).

The 4 distances to the Grail/Knight (Discrete, b/w 0 and 30).

The 4 distances to the walls (Discrete, b/w 0 and 30).

Adam and Justin say that we have limitless access to probe the grid. Ultimately, I think obstacles are no longer nearly as important as an agent's X Y location. Obstacles can change, walls cannot. It is in the Grail's best interest to find it's way to the center, and try to stay there. It is in the Knight's best interest to drive the Grail away from the center. This can be done by placing its self between the center and grail, as long as the Grail is not already there. I mention all of this because it allows us to think of what other sensors we may need. However, as it is, the distances from the walls provides an excellent measure of centerness. 

Right now, we have no sensors that detect obstacles unless they are adjacent. What if we had sensors that indicated how far we were from the nearest obstacle? Sensors that return the distance between an agent and the cloest obstacle in each cardinal direction. Technically speaking, we could even add a binary input for each block in the grid. Runtime wise, that may be more effective than figuring out the 4 cardinal directions. It would be 90 block-status-calls, each hard coded. Where as the other method's worst case scenario is 60 block-status-calls, and each would have to be dynamically generated (as in the calls have to be realtive to the Knight's realitive position), which would add run time. I have never made a network that learned on so many parameters, but I have read about many that do just that. We would then have 90 binary inputs, and 8 discrete inputs. We would have to have a huge hidden layer, but it may be a fun idea.

###Division of Labor###
To me (Tony), it would make sense if we divided the labor amoung the following lines. One person works on the Neural Network, another on the Sensors and Outputs, another works on GA, and another on the Fitness function.

##Git Process##

###To Start New Project###
Clone Project to your Eclipse Platform via going to the Git perspective, Clone a Repository

In that view, Click the Repository, and select import project, import as general project.

Click the Repository, go to switch to, New Branch, and create a new branch based on Master.

If you would like your new branch to track what is going on up top, you need to configure it to fetch from the remote HEAD.

###When Opening Eclipse###
Go to the main branch, and hit Pull.

Merge any changes that have happened mannually by editing the code, and then clicking on the files that were conflicted, and then Add. Once all files have been merged manually, click commit. Do this Often and things won't be crazy when you commit and push later.

###If you would like us to see your work###
Push the branch to git by hitting Push. Make sure Pull first, or have a reason not to.

