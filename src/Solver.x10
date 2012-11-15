import x10.util.Timer;
import x10.util.ArrayList;
import x10.io.Console;

/*
this.n = size;
if (size == 8)
    {
    return 92;
}
else if (size == 9)
    {
    return 108;
}
else if (size == 10)
    {
    return 524;
}

// for (i in pawns)
//     Console.OUT.println(pawns(i));
return 27;
*/

/**
* This is the class that provides the solve() method.
*
* The assignment is to replace the contents of the solve() method
* below with code that actually works :-)
*/
public class Solver
{
    /**
    * Solve a single 'N'-Queens with pawns problem.
    *     'size' is 'N'.
    *     'pawns' is an array of Squares with the locations of pawns.  The array may be of length zero.
    *
    * This function should return the number of solutions for the given configuration.
    */
    public def solve(size: int, pawns: Array[Square]{rank==1}) : int
    {
        var numSolutions:Int = 0;
        val cfg = new ConfigurationGenerator(size, pawns);
        while (cfg.fringe.size() < Runtime.NTHREADS && cfg.hasNext()) {
            Console.OUT.print("fringe size: " + cfg.fringe.size());
            if(cfg.generateDepthFirst()) {
                numSolutions++;
                Console.OUT.print("###################\n");
            }
        }
        if (cfg.hasNext()) {
            val solutions = new Rail[Int](cfg.fringe.size());
            finish for (i in 0..(cfg.fringe.size() - 1)) async {
                val partialcfg = new ConfigurationGenerator(size, pawns, cfg.fringe.get(i));
                while (partialcfg.hasNext()) {
                    if(partialcfg.generateDepthFirst()) {
                        solutions(i) = 1 + solutions(i);
                        Console.OUT.print("###################\n");
                    }
                }
            }
            numSolutions = solutions.reduce((a:Int, b:Int) => (a + b), numSolutions);
        }
        return numSolutions;
    }

    private class ConfigurationGenerator
    {
        val availableSquares:Array[Square]{self.rank == 1};
        val pawns:Array[Square]{self.rank == 1};
        val n:Int;
        val fringe:ArrayList[ConfigurationNode] = new ArrayList[ConfigurationNode]();
        var done:Boolean = false;

        public def this(n:Int, pawns:Array[Square]{self.rank == 1})
        {
            this.n = n;
            this.pawns = pawns;
            this.availableSquares = invert(pawns, n);

        }

        public def this(n:Int, pawns:Array[Square]{self.rank == 1}, startNode:ConfigurationNode)
        {
            this.n = n;
            this.pawns = pawns;
            this.availableSquares = invert(pawns, n);
            this.fringe.add(startNode);
        }

        public def hasNext()
        {
            return !done;
        }

        /*public def next()
        {
            while (hasNext()) {
                if (fringe.getLast().queens.length == n) {
                    return fringe.removeLast().queens;
                } else {
                    generate();
                }
            }
        }*/

        public def generateDepthFirst()
        {
            if(!done && fringe.isEmpty()) {
                fringe.add(new ConfigurationNode(new Array[Square](0), 0));
            }
            val top = fringe.removeLast();

            //check if top is a solution
            if(top.queens.size == n) {
                this.done = fringe.isEmpty();
                return top.check(n, pawns);
            } else if (top.depth < availableSquares.size) {
                //explore children, should do something with top.queens.size here to optimize
                //configuration with no queen in next square
                val x = new ConfigurationNode(top.queens, top.depth + 1);
                fringe.add(x);

                //configuration with queen in next square
                val queens = new Array[Square](top.queens.size + 1);
                Array.copy(top.queens, 0, queens, 0, top.queens.size);
                queens(top.queens.size) = availableSquares(top.depth);
                val y = new ConfigurationNode(queens, top.depth + 1);
                if (y.check(n, pawns))
                    fringe.add(y);

            }
            //didn't find a solution
            this.done = fringe.isEmpty();
            return false;
        }

        private def invert(input:Array[Square]{self.rank == 1}, n:Int)
        {
            val out = new Array[Square](n * n - input.size);
            var i:Int = 0;
            for (x in 0..(n - 1)) {
                for (y in 0..(n - 1)) {
                    if(!contains(input, x, y)) {
                        out(i) = new Square(x, y);
                        i++;
                    }
                }
            }
            return out;
        }

        private def contains(input:Array[Square]{self.rank == 1}, x:Int, y:Int)
        {
            for (i in input) {
                if (input(i).x == x && input(i).y == y)
                    return true;
            }
            return false;
        }

        private class ConfigurationNode
        {
            val queens:Array[Square]{self.rank == 1};
            val depth:Int;
            def this(queens:Array[Square]{self.rank == 1}, depth:Int)
                {
                this.queens = queens;
                this.depth = depth;
            }

            def check(n:Int, pawns:Array[Square]{self.rank == 1})
                {
                return new Board(n, queens, pawns).isSolution();
            }
        }
    }


    /* *
    * 
    *
    */
    private class Board
    {
        static val EMPTY = 0;
        static val QUEEN = 1;
        static val PAWN = 2;
        val n:Int;
        val configuration:Array[Int]{self.rank == 2};
        val queens:Array[Square]{self.rank == 1};

        public def this(n:Int, queens:Array[Square]{self.rank == 1}, pawns:Array[Square]{self.rank == 1})
        {
            this.n = n;
            this.queens = queens;
            this.configuration = new Array[Int]((0..(n-1)) * (0..(n - 1)));

            for (i in queens) {
                val q = queens(i);
                if (configuration(q.x, q.y) != EMPTY) {
                    throw new Exception("bad board");
                } else {
                    configuration(q.x, q.y) = QUEEN;
                }
            }

            for (i in pawns) {
                val p = pawns(i);
                if (configuration(p.x, p.y) != EMPTY) {
                    throw new Exception("bad board");
                } else {
                    configuration(p.x, p.y) = PAWN;
                }
            }
        }

        private def checkVertical(x:Int, y:Int)
        {
            //traverse upwards
            for (var yy:Int = y + 1; yy < n; yy++) {
                val cur = configuration(x, yy);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }

            //traverse downwards
            for (var yy:Int = y - 1; yy > 0; yy--) {
                val cur = configuration(x, yy);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }

            return true;
        }

        private def checkHorizontal(x:Int, y:Int)
        {
            //traverse rightwards
            for (var xx:Int = x + 1; xx < n; xx++) {
                val cur = configuration(xx, y);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }

            //traverse leftwards 
            for (var xx:Int = x - 1; xx > 0; xx--) {
                val cur = configuration(xx, y);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }

            return true;
        }

        private def checkMinorDiagonal(x:Int, y:Int)
        {
            for (var xx:Int = x + 1, yy:Int = y - 1; xx < n && yy >= 0; xx++, yy--) {
                val cur = configuration(xx, yy);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }
            for (var xx:Int = x - 1, yy:Int = y + 1; xx >= 0 && yy < n; xx--, yy++) {
                val cur = configuration(xx, yy);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }

            return true;
        }

        private def checkMajorDiagonal(x:Int, y:Int)
        {
            for (var xx:Int = x + 1, yy:Int = y + 1; xx < n && yy < n; xx++, yy++) {
                val cur = configuration(xx, yy);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;
            }

            for (var xx:Int = x - 1, yy:Int = y - 1; xx >= 0 && yy >= 0; xx--, yy--) {
                val cur = configuration(xx, yy);
                if (cur == QUEEN)
                    return false;
                else if (cur == PAWN)
                    break;

            }

            return true;
        }

        private def checkQueens(x:Int, y:Int)
        {
            return checkVertical(x, y) && 
            checkHorizontal(x, y) &&
            checkMajorDiagonal(x, y) &&
            checkMinorDiagonal(x, y);
        }

        public def isSolution()
        {
            print();
            for (i in queens) {
                if(!(checkQueens(queens(i).x, queens(i).y)))
                    return false;
            }

            return true;
        }

        public def print(){
            for (y in 0..(n - 1)) {
                for (x in 0..(n - 1)) {
                    Console.OUT.print("|" + configuration(x, y));
                }
                Console.OUT.print("|\n");
            }
            Console.OUT.print("\n");
        }
    }
}
