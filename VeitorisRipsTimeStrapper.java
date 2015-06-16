

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.util.Iterator;

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
import edu.stanford.math.plex4.utility.ArrayUtility;

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

    public void addComplex(double[][] points) {
        VietorisRipsStream<double[]> stream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(points), this.maxDistance, maxDimension + 1);
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
        double[][] xpoints = null;
        double[][] ypoints = null;
        int[] xyindxs = null;
        int[] xindxs = null;
        int[] yindxs = null;
        double[] arrPoint = null;
        int k = 0;

        for(int i = 1; i < this.streams.size(); i++) {
            ypoints = this.datapoints.get(i);
            xpoints = this.datapoints.get(i-1);
            yindxs = new int[ypoints.length];
            xindxs = new int[xpoints.length];

            points = new double[xpoints.length+ypoints.length][];
            int xi = 0;
            int yi = 0;
            for (int j = 0; j < points.length; j++) {
                if (j < xpoints.length) {
                    xindxs[xi] = j;
                    arrPoint = new double[2];
                    arrPoint[0] = xpoints[xi][0];
                    arrPoint[1] = xpoints[xi][1];
                    xi++;
                } else {
                    yindxs[yi] = j;
                    arrPoint = new double[2];
                    arrPoint[0] = ypoints[yi][0];
                    arrPoint[1] = ypoints[yi][1];
                    yi++;
                }
                points[j] = arrPoint;
            }

            xyindxs = ArrayUtility.union(xindxs, yindxs);

            XTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            XStream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(ArrayUtility.getSubset(points, xindxs)), maxDistance, maxDimension + 1, xindxs);
            XStream.finalizeStream();
            for (Simplex x: XStream) {
                XTracker.add(x, XStream.getFiltrationIndex(x));
            }

            YTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            YStream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(ArrayUtility.getSubset(points, yindxs)), maxDistance, maxDimension + 1, yindxs);
            YStream.finalizeStream();
            k = 0;
            for (Simplex y: YStream) {
                YTracker.add(y, YStream.getFiltrationIndex(y));
                k++;
            }

            System.out.println("simplices in y complex: " + k);


            /*zpoints = ZSet.toArray(new double[ZSet.size()][2]);
            for (int j = 0; j < zpoints.length; j++) {
                System.out.println("Z point: " + zpoints[i][0] + " " + zpoints[i][1]);
            }*/

            //System.out.println("Number of z points: " + zpoints.length);
            ZStream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(ArrayUtility.getSubset(points, xyindxs)), maxDistance, maxDimension + 1, xyindxs);
            ZStream.finalizeStream();

            ZTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            k = 0;
            for (Simplex z: ZStream) {
                ZTracker.add(z, ZStream.getFiltrationIndex(z));
                k++;
            }
            System.out.println("simplices in z complex: " + k);

            System.out.println("Barcodes for Z_" + (i-1) + "," + (i));
            AnnotatedBarcodeCollection<Integer, IntSparseFormalSum<Simplex>> ZBarcodes = ZTracker.getAnnotatedBarcodes();
            System.out.println(ZBarcodes.toString());
            System.out.println("Barcodes for X_" + (i));
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

    }
}