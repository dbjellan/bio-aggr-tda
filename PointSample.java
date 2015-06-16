//package edu.stanford.math.plex4.examples;

import java.util.Arrays;

import edu.stanford.math.plex4.utility.RandomUtility;
import edu.stanford.math.primitivelib.autogen.array.DoubleArrayMath;

/**
 * This static class contains various functions which produce 
 * examples of point cloud data sets.
 * 
 * based on Andrew Tausz's code in Javaplex examples
 *
 */
public class PointSample {
    
	/**
	 * Complex 1 = an unfilled square.
	 * 
	 * @return the requested point cloud
	 */
	public static double[][] getComplexOne() {
		double[][] points = new double[][]{new double[]{1, 0}, 
				new double[]{1, 0},
				new double[]{1, 1},
				new double[]{0, 1}};
		return points;
	}
	
	/**
	 * Complex 2 = an unfilled square topped by a filled triangle.
	 * 
	 * @return the requested point cloud
	 */
	public static double[][] getComplexTwo() {
		double[][] points = new double[][]{new double[]{0, 0}, 
				new double[]{0, 1},
				new double[]{1, 0},
        		new double[]{1/2, 2},
				new double[]{1, 1}};
		return points;
	}
    
    	
	/**
	 * Complex 3 = a filled square.
	 * 
	 * @return the requested point cloud
	 */
	public static double[][] getComplexThree() {
		double[][] points = new double[][]{new double[]{0, 0}, 
				new double[]{0, 1},
				new double[]{1, 0},
        		new double[]{1/2, 1/2},
				new double[]{1, 1}};
		return points;
	}

}
