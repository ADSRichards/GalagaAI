# Self-Learning Galaga Script

Lua script that plays the classic arcade game Galaga for 2000 frames. The script is given random instructions on which buttons to press at each frame. Before each iteration of gameplay, the scrichanges its instructions slightly and accepts the change if it leads to an increased score. The script can beat the first level in about 80 iterations.

![](./img/rd_iter3.gif)

1. Get FCEUX and a Galaga ROM.
2. Run FCEUX and go to file -> new Lua script window and run the script.

The script learns galaga through random updates. The inputs that produce the greatest score are saved and random deviations are accepted if they result in a greater score.
