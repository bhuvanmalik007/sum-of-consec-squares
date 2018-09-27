
### Size of the work unit ->

Let ‘ **N** ’ be the range of the first number of the sequence and ‘ **k** ’ be the number of terms in the
sequence such that the sum of squares (of the elements of the sequence) is itself a perfect square.
In our implementation, the number of workers is -> **k**
Each worker gets **N / k** sub problems in a single request from the boss which we call
‘Intervals’.
We accomplished this by creating a data structure called “intervalList” containing interval
number, start and end values.
e.g. : intervalList for (N = 10, k = 2) will be
intervalList =
[
interval1: %{start: 1, end: 5},
interval2: %{start: 6, end: 10}
]

### EXPLANATION :-

Upon testing the project with different number of workers (e.g: k/2 , 2k etc) , we concluded that
the program runs most efficiently when the number of workers is ‘k’. The number of workers
must not depend on N because for a case where N is very large ( e.g: 2,500,000,000), spawning
that many workers is not feasible.


## Result of ( 1,000,000 4 ) ->

**Command :-** mix run project.exs 1000000 4
**Result :-** No sequence found.

## The running time of ( 1,000,000 4 ) ->

Real time -> 0.401 Seconds
User time -> 0.778 Seconds (&) System time -> 0.104 Seconds
CPU time -> (User time + System time) -> ( 0.778 + 0.104 ) Seconds
= ( 0.882 ) Seconds
**=>** Ratio of CPU time to Real time = ( 0.882 / 0.401 ) = **2.**

## Largest problem solved -> ( 2,500,000,000 3000 )

The largest problem solved is :- mix run project.exs 2500000000 3000
**Result :-** First fifty results are [8396091, 24051285, 24200404, 32144731, 33666530,
38475358, 39544206, 40072654, 40954494, 42828359, 47732487, 48546277, 53870723,
54047228, 61795340, 61999512, 63153113, 64445914, 66069652, 67462034, 71434143,
76399164, 76791411, 77168909, 80782133, 81275792, 81754702, 83457397, 83742256,
83837209, 84757241, 86534164, 86990035, 88313401, 88779876, 89989395, 91405883,
94247632, 95033092, 96090976, 96312694, 97588151, 98107646, 98198454, 98380070,
98470878, 101894398, 102318940, 102768835, 103770037]
Real time -> 2 Minutes 34.186 Seconds
CPU time -> 20 Minutes 17.245 Seconds


# Bonus

Our project programmatically detects if nodes are connected to parent machine and
determines whether to run the program using the “mix run” command format or the “iex
ModuleName.run(N, k)” format.
If a node is connected to the parent machine, the program divides the workers equally
between the connected machines, thereby decreasing the execution time of the entire
program.
If no nodes are connected, we simply execute the program using “mix run project.exs
200000000 50”
**Instructions to run on 2+ Machines:-
Step 1:** Navigate to project folder containing the project.exs file on terminal
**Step 2:** Start iex by naming the nodes on all machines using —cookie
**e.g:** iex --name nodename@ipaddress --cookie CookieName
**Step 3:** Connect all machines to parent node using Node.connect and check for “true”
output. **e.g:** Node.connect :"parentnode@parentipaddress"
**Step 4:** Compile project.exs using c(“project.exs”) on all machines.
**Step 5:** Run the Supervisor Module in parent machine using the command
SupervisorModule.run( 200000000, 50)
**Result :-** First fifty results are [7, 28, 44, 67, 87, 124, 168, 287, 379, 512, 628, 843,
1099, 1792, 2328, 3103, 3779, 5032, 6524, 10563, 13687, 18204, 22144, 29447, 38143,
61684, 79892, 106219, 129183, 171748, 222432, 359639, 465763, 619208, 753052,
1001139, 1296547, 2096248, 2714784, 3609127, 4389227, 5835184, 7556948,
12217947, 15823039, 21035652, 25582408, 34010063, 41262024, 44045239]
**Time on 1 machine :-** 10.762 Seconds
**Time on 2 machines :-** 7.531 Seconds
**Time on 3 machines :-** 5.173 Seconds


## Number of machines :-

The code was successfully run on **3 machines** and the run time was noted (as seen in the
above section).
Current program has the code to run on **2 machines**. However, with a very small
modification (which we can demonstrate) there is **no limit to the number of machines**
the code can be run on.



