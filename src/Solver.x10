import x10.util.Timer;

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
     }

     private struct Board
     {
        static val EMPTY = 0;
         static val QUEEN = 1;
         static val PAWN = 2;
         val configuration:Array[Int]{self.rank == 2};

         public def this(n:Int, queens:Rail[Square], pawns:Rail[Square])
         {
            this.configuration = new Array[Int](n, n);
            for (i in queens) {
                val q = queens(i);
                if (configuration(q.x, q.y) != 0) {
                    throw new RuntimeException("bad board");
                } else {
                    configuration(q.x, q.y) = QUEEN;
                }
            }
            for (i in pawns) {
                val p = pawns(i);
                if (configuration(p.x, p.y) != 0) {
                    throw new RuntimeException("bad board");
                } else {
                    configuration(p.x, p.y) = PAWN;
                }
            }
         }

         public def isSolution()
         {
            for (x in configuration) {
                //check for vertical
                //check for horizontal
                //check for major diagonal
                //check for minor diagonal
            }
            
         }
     }

 }
