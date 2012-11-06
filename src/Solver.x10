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
        // The code below is *totally* bogus!
        //
        // It only exists so that the Main method driver code can be executed to show
        // how things are supposed to work.
        //
        // The sleep statements are to avoid a zero ms. runtime (which the driver code
        // does handle correctly) ...
        
        if (size == 8)
        {
            return 92;
        }
        else if (size == 9)
        {
            my_sleep(1212);
            return 108;
        }
        else if (size == 10)
        {
            my_sleep(1999);
            return 524;
        }

        // for (i in pawns)
        //     Console.OUT.println(pawns(i));
        return 27;
    }

    // The X10 System.sleep() method is broken, so we busy wait...
    //
    // This function won't be needed in the "real" implementation of solve().
    //
    public static def my_sleep(ms: int)
    {
        val start = Timer.milliTime();
        val target_end = start + ms;
        while (Timer.milliTime() < target_end)
            ;
    }
}
