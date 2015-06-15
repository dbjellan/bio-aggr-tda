

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.Iterator;

import org.apache.commons.lang3.builder.HashCodeBuilder;

import edu.stanford.math.primitivelib.algebraic.impl.ModularIntField;
import edu.stanford.math.primitivelib.autogen.formal_sum.IntAlgebraicFreeModule;
import edu.stanford.math.primitivelib.autogen.formal_sum.IntSparseFormalSum;
import edu.stanford.math.primitivelib.autogen.algebraic.IntAbstractField;
import edu.stanford.math.plex4.streams.impl.VietorisRipsStream;
import edu.stanford.math.plex4.homology.barcodes.BarcodeCollection;
import edu.stanford.math.plex4.homology.barcodes.AnnotatedBarcodeCollection;
import edu.stanford.math.plex4.homology.zigzag.SimpleHomologyBasisTracker;
import edu.stanford.math.plex4.homology.zigzag.IntervalTracker;
import edu.stanford.math.plex4.homology.chain_basis.Simplex;
import edu.stanford.math.plex4.metric.impl.EuclideanMetricSpace;
import edu.stanford.math.plex4.homology.chain_basis.SimplexComparator;
import edu.stanford.math.plex4.homology.zigzag.bootstrap.InducedHomologyMappingUtility;

public class VeitorisRipsTimeStrapper {

    private IntAbstractField intField = ModularIntField.getInstance(2);
    private final IntAlgebraicFreeModule<Simplex> chainModule = new IntAlgebraicFreeModule<Simplex>(this.intField);
    private List<VietorisRipsStream<double[]>> streams = new ArrayList<VietorisRipsStream<double[]>>();
    private List<double[][]> datapoints = new ArrayList<double[][]>();

    public final int maxDimension;
    public final double maxDistance;

    public VeitorisRipsTimeStrapper(int maxDimension, double maxDistance) {
        this.maxDimension = maxDimension;
        this.maxDistance = maxDistance;
    }

    static class Point {
        public double x;
        public double y;

        Point(double x, double y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (!(o instanceof Point))
                return false;

            Point b = (Point) o;
            //System.out.println("Comparing: " + this.x + " " + this.y + " " + b.x + " " + b.y);
            if (b.x == this.x && b.y == this.y)
                return true;
            else
                return false;
        }

        @Override
        public int hashCode() {
            return new HashCodeBuilder(17, 31).append(x).append(y).toHashCode();
    }
    }

    private Double[][] toDoubleArray(double[][] values) {
       Double[][] objArray = new Double[values.length][];

       for (int i = 0; i < values.length; i++)
       {
          objArray[i] = new Double[values[i].length];
          for (int j = 0; j < values[i].length; j++)
          {
             objArray[i][j] = values[i][j];
          }
       } 
       return objArray;
    }

    private Double[] boxDouble(double[] values) {
        Double[] arr = new Double[values.length];
        for (int i = 0; i < values.length; i++) {
            arr[i] = values[i];
        }
        return arr;
    }

    private double[] unboxDouble(Double[] values) {
        double[] arr = new double[values.length];
        for (int i = 0; i < values.length; i++) {
            arr[i] = values[i];
        }
        return arr;
    }    

    private double[][] unboxDoubleArray(Double[][] values) {
       double[][] objArray = new double[values.length][];
       for (int i = 0; i < values.length; i++) {
          objArray[i] = new double[values[i].length];
          for (int j = 0; j < values[i].length; j++)
          {
             objArray[i][j] = values[i][j];
          }
       } 
       return objArray;
    }

    public void addComplex(double[][] points) {
        VietorisRipsStream<double[]> stream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(points), this.maxDistance, maxDimension + 1, points.length);
        stream.finalizeStream();
        this.datapoints.add(points);
        this.streams.add(stream);
    }

    public BarcodeCollection<Integer> performTimeStrap() {
        SimpleHomologyBasisTracker<Simplex> ZTracker = null;
        SimpleHomologyBasisTracker<Simplex> XTracker = null;
        SimpleHomologyBasisTracker<Simplex> YTracker = null;

        VietorisRipsStream<double[]> XStream = null;
        VietorisRipsStream<double[]> YStream = null;
        VietorisRipsStream<double[]> ZStream = null;

        IntervalTracker<Integer, Integer, IntSparseFormalSum<Simplex>> result = null;

        double[][] points;
        double[][] zpoints = null;
        Set<Point> ZSet = null;
        double[] arrPoint = new double[2];
        Point point = null;
        int k = 0;

        for(int i = 1; i < this.streams.size(); i++) {

            if (XTracker == null) {
                XTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
                XStream = this.streams.get(0);
                for (Simplex x: XStream) {
                    XTracker.add(x, XStream.getFiltrationIndex(x));
                }
            }

            YTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            YStream = this.streams.get(i);
            k = 0;
            for (Simplex y: YStream) {
                YTracker.add(y, YStream.getFiltrationIndex(y));
                k++;
            }
            System.out.println("simplices in y complex: " + k);

            ZSet = new HashSet<Point>();
            points = this.datapoints.get(i-1);
            for (int j = 0; j < points.length; j++) {
                point = new Point(points[j][0], points[j][1]);
                ZSet.add(point);
                //System.out.println("Adding to z complex: " + point.x + " " + point.y);
            }

            points = this.datapoints.get(i);
            System.out.println("Number of y points: " + points.length);
            for (int j = 0; j < points.length; j++) {
                point = new Point(points[j][0], points[j][1]);
                //System.out.println("Adding to z complex: " + point.x + " " + point.y);
                //System.out.println("This is already contained: " + ZSet.contains(point));
                ZSet.add(point);
            }

            /*zpoints = ZSet.toArray(new double[ZSet.size()][2]);
            for (int j = 0; j < zpoints.length; j++) {
                System.out.println("Z point: " + zpoints[i][0] + " " + zpoints[i][1]);
            }*/
            zpoints = new double[ZSet.size()][2];
            int indx = 0;
            Iterator<Point> iterator = ZSet.iterator();

            while (iterator.hasNext()) {
                point = iterator.next();
                arrPoint[0] = point.x;
                arrPoint[1] = point.y;
                zpoints[indx] = arrPoint;
                System.out.println("Z point: " + zpoints[indx][0] + " " + zpoints[indx][1]);
                indx++;
            }
            System.out.println("Number of z points: " + zpoints.length);
            ZStream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(zpoints), this.maxDistance, maxDimension + 1, zpoints.length);
            ZStream.finalizeStream();
            ZTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            k = 0;
            for (Simplex z: ZStream) {
                ZTracker.add(z, ZStream.getFiltrationIndex(z));
                k++;
            }
            System.out.println("simplices in z complex: " + k);

            System.out.println("Barcodes for X_" + (i-1) + "," + (i));
            AnnotatedBarcodeCollection<Integer, IntSparseFormalSum<Simplex>> ZBarcodes = ZTracker.getAnnotatedBarcodes();
            System.out.println(ZBarcodes.toString());
            System.out.println("Barcodes for Z_" + (i));
            AnnotatedBarcodeCollection<Integer, IntSparseFormalSum<Simplex>> YBarcodes = YTracker.getAnnotatedBarcodes();
            System.out.println(YBarcodes.toString());

            if (result == null) {
                result = XTracker.getStateWithoutFiniteBarcodes(i - 1);
                result.setUseLeftClosedIntervals(true);
                result.setUseRightClosedIntervals(true);                
            }

            result = InducedHomologyMappingUtility.include(XTracker, ZTracker, YTracker, result, chainModule, (i - 1), i);
            XStream = YStream;
            XTracker = YTracker;
        }

        result.endAllIntervals(this.streams.size() - 1);
        return BarcodeCollection.forgetGeneratorType(result.getAnnotatedBarcodes().filterByMaxDimension(maxDimension));
    }

    public static void main(String[] args) {
        Point aa = new Point(0.0, 1.0);
        Point bb = new Point(0.0, 1.0);
        System.out.println(aa.equals(bb));
    }
}