import x10.util.Timer;
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
        val cfg = new ConfigurationGenerator(size, pawns);
        while(cfg.hasNext()){
           if(cfg.next().isSolution()) {
             numSolutions++;
           }
        }
     }

    private class ConfigurationGenerator
    {
        val availableSquares:Rail[Square];
        val pawns:Rail[Square];
        val n:Int;
        val fringe:ArrayList[ConfigurationNode] = new ArrayList[ConfigurationNode]();

        public def this(n:Int, pawns:Rail[Square])
        {
            this.n = n;
            this.pawns = pawns;
            this.availableSquares = invert(pawns, n);
            this.fringe.add(new ConfigurationNode(new Rail[Square](0), 0));
        }

        public def hasNext()
        {
            return !fringe.isEmpty();
        }

        public def next()
        {
            while (hasNext()) {
                if (fringe.getLast().queens.length == n) {
                  return fringe.removeLast().queens;
                } else {
                  generate();
                }
            }
        }
        
        public def generate()
        {
            val top = fringe.getLast();
            if (!top.leftExplored && top.depth < availableSquares.size) {
                fringe.add(new ConfigurationNode(top.queens), top.depth + 1);
                top.leftExplored = true;
            } else if (!top.rightExplored && top.depth < availableSquares.size) {
                val queens = new Rail(top.size + 1)
                Array.copy(top.queens, queens)
                queens(top.size) = availableSquares(depth - 1)
                fringe.add(new ConfigurationNode(queens), top.depth + 1);
                top.rightExplored = true;
            }

        }

        public static def invert(input:Rail[Square], n:Int)
        {
            val out = new Rail[Square](n * n - input.size);
            var i = 0;
            for (x in 0..(n - 1)) {
                for (y in 0..(n - 1)) {
                    if(!contains(input, x, y)) {
                        out(i) = new Square(x, y);
                        i++;
                    }
                }
            }
        }

        public static def contains(input:Rail[Square], x:Int, y:Int)
        {
            for (i in input) {
                if (input.x == x && input.y == y)
                    return true;
            }
            return false;
        }

        private struct ConfigurationNode
        {
            val queens:Rail[Square];
            val depth:Int;
            val leftExplored:Boolean;
            val rightExplored:Boolean;
            def this(queens:Rail[Square], depth:Int)
            {
                queens = queens;
                depth = depth;
                leftExplored = false;
                rightExplored = false;
            }
        }

    }

     /* *
     * 
     *
     */
     private struct Board
     {
         static val EMPTY = 0;
         static val QUEEN = 1;
         static val PAWN = 2;
         val n:Int;
         val configuration:Array[Int]{self.rank == 2};

         public def this(n:Int, queens:Rail[Square], pawns:Rail[Square])
         {
             this.n = n;
             this.configuration = new Array[Int](n, n);

             for (i in queens) {
                 val q = queens(i);
                 if (configuration(q.x, q.y) != EMPTY) {
                     throw new RuntimeException("bad board");
                 } else {
                     configuration(q.x, q.y) = QUEEN;
                 }
             }

             for (i in pawns) {
                 val p = pawns(i);
                 if (configuration(p.x, p.y) != EMPTY) {
                     throw new RuntimeException("bad board");
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

         private def checkMajorDiagonal(x:Int, y:Int)
         {
             for (var xx:Int = x + 1, yy:Int = y - 1;
                  xx < n && yy > 0; xx++, yy--) {
                  val cur = configuration(xx, yy);
                  if (cur == QUEEN)
                      return false;
                  else if (cur == PAWN)
                      break;
              }
              for (var xx:Int = x - 1, yy:Int = y + 1;
                   xx > 0 && yy < n; xx--, yy++) {
                   val cur = configuration(xx, yy);
                   if (cur == QUEEN)
                       return false;
                   else if (cur == PAWN)
                       break;
               }

               return true;
           }

           private def checkMinorDiagonal(x:Int, y:Int)
           {
               for (var xx:Int = x + 1, yy:Int = y + 1;
                    xx < n && yy < n; xx++, yy++) {
                    val cur = configuration(xx, yy);
                    if (cur == QUEEN)
                        return false;
                    else if (cur == PAWN)
                        break;
                }

                for (var xx:Int = x - 1, yy:Int = y - 1;
                     xx > 0 && yy > 0; xx--, yy--) {
                     val cur = configuration(xx, yy);
                     if (cur == QUEEN)
                         return false;
                     else if (cur == PAWN)
                         break;
                 }

                 return true;
             }

             private checkQueens(x:Int, y:Int)
             {
                 return checkVertical(x, y) && 
                 checkHorizontal(x, y) &&
                 checkMajorDiagonal(x, y) &&
                 checkMinorDiagonal(x, y);
             }
         }

         public def isSolution()
         {
             for (x in 0..(n - 1)) {
                 for (y in 0..(n - 1)) {
                     if(!(checkQueens(x, y)))
                         return false;
                 }
             }

             return true;
         }
     }
 }
