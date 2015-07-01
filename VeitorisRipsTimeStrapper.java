

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
import edu.stanford.math.plex4.streams.impl.FlexibleVietorisRipsStream;
import edu.stanford.math.plex4.homology.barcodes.BarcodeCollection;
import edu.stanford.math.plex4.homology.barcodes.AnnotatedBarcodeCollection;
import edu.stanford.math.plex4.homology.zigzag.SimpleHomologyBasisTracker;
import edu.stanford.math.plex4.homology.zigzag.IntervalTracker;
import edu.stanford.math.plex4.homology.chain_basis.Simplex;
import edu.stanford.math.plex4.metric.impl.EuclideanMetricSpace;
import edu.stanford.math.plex4.metric.impl.ExplicitMetricSpace;
import edu.stanford.math.plex4.homology.chain_basis.SimplexComparator;
import edu.stanford.math.plex4.homology.zigzag.bootstrap.InducedHomologyMappingUtility;
import edu.stanford.math.plex4.utility.ArrayUtility;
import edu.stanford.math.plex4.metric.interfaces.AbstractSearchableMetricSpace;
import edu.stanford.math.plex4.homology.filtration.IncreasingLinearConverter;
import edu.stanford.math.plex4.streams.impl.FlagComplexStream;

public class VeitorisRipsTimeStrapper {

    private IntAbstractField intField = ModularIntField.getInstance(2);
    private final IntAlgebraicFreeModule<Simplex> chainModule = new IntAlgebraicFreeModule<Simplex>(this.intField);
    //private List<VietorisRipsStream<double[]>> streams = new ArrayList<VietorisRipsStream<double[]>>();
    private List<double[][]> datapoints = new ArrayList<double[][]>();

    public final int maxDimension;
    public final double maxDistance;
    public final boolean use3TorusDistance;

    public VeitorisRipsTimeStrapper(int maxDimension, double maxDistance, boolean use3TorusDistance) {
        this.maxDimension = maxDimension;
        this.maxDistance = maxDistance;
        this.use3TorusDistance = use3TorusDistance;
    }

    public static double[][] makeVicsekDistanceMatrix(double[][] points) {
        double[][] distances = new double[points.length][];
        double length = Math.PI * 2;
        double xdiff;
        double ydiff;
        double thetadiff;
        for (int i = 0; i < points.length; i++) {
            distances[i] = new double[points.length];
            for (int j = 0; j < points.length; j++) {
                xdiff = Math.abs(points[i][0] - points[j][0]);
                ydiff = Math.abs(points[i][1] - points[j][1]);
                if (points[i].length == 3) {
                    thetadiff = Math.abs(points[i][2]-points[j][2]);
                    distances[i][j] = Math.sqrt(Math.pow(Math.min(xdiff, length-xdiff),2)+Math.pow(Math.min(ydiff, length-ydiff),2)+ Math.pow(Math.min(thetadiff, length-thetadiff),2));
                } else {
                    distances[i][j] = Math.sqrt(Math.pow(Math.min(xdiff, length-xdiff),2)+Math.pow(Math.min(ydiff, length-ydiff),2));
                }
            }
        }

        return distances;

    }

    public void addComplex(double[][] points) {
        this.datapoints.add(points);
    }


    public BarcodeCollection<Integer> performTimeStrap() {
        SimpleHomologyBasisTracker<Simplex> ZTracker = null;
        SimpleHomologyBasisTracker<Simplex> XTracker = null;
        SimpleHomologyBasisTracker<Simplex> YTracker = null;

        FlagComplexStream XStream = null;
        FlagComplexStream YStream = null;
        FlagComplexStream ZStream = null;

        IntervalTracker<Integer, Integer, IntSparseFormalSum<Simplex>> result = null;

        double[][] points;
        double[][] xpoints = null;
        double[][] ypoints = null;
        int[] xyindxs = null;
        int[] xindxs = null;
        int[] yindxs = null;
        double[] arrPoint = null;
        int k = 0;
        int indxoffset = 0;

        int[] xoindxs = null;
        int[] yoindxs = null;
        int[] xyoindxs = null;

        for(int i = 1; i < this.datapoints.size(); i++) {
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
                    arrPoint = new double[xpoints[xi].length];
                    for (int n = 0; n < xpoints[xi].length; n++ )
                        arrPoint[n] = xpoints[xi][n];
                    xi++;
                } else {
                    yindxs[yi] = j;
                    arrPoint = new double[ypoints[yi].length];
                    for (int n = 0; n < ypoints[yi].length; n++ )
                        arrPoint[n] = ypoints[yi][n];
                    yi++;
                }
                points[j] = arrPoint;
            }

            xyindxs = ArrayUtility.union(xindxs, yindxs);
            xoindxs = new int[xindxs.length];
            for (int j= 0; j < xindxs.length; j++) {
                xoindxs[j] = xindxs[j]+indxoffset;
            }
            yoindxs = new int[yindxs.length];
            for (int j= 0; j < yindxs.length; j++) {
                yoindxs[j] = yindxs[j]+indxoffset;
            }
            xyoindxs = new int[xyindxs.length];
            for (int j= 0; j < xyindxs.length; j++) {
                xyoindxs[j] = xyindxs[j]+indxoffset;
            }

            XTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            XStream = new FlexibleVietorisRipsStream<Integer>(new ExplicitMetricSpace(makeVicsekDistanceMatrix(ArrayUtility.getSubset(points, xindxs))), this.maxDistance, maxDimension + 1, new IncreasingLinearConverter(1, maxDistance, maxDistance), xoindxs);
            XStream.finalizeStream();
            for (Simplex x: XStream) {
                XTracker.add(x, XStream.getFiltrationIndex(x));
            }

            YTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            YStream = new FlexibleVietorisRipsStream<Integer>(new ExplicitMetricSpace(makeVicsekDistanceMatrix(ArrayUtility.getSubset(points, yindxs))), this.maxDistance, maxDimension + 1, new IncreasingLinearConverter(1, maxDistance, maxDistance), yoindxs);    
            YStream.finalizeStream();
            k = 0;
            for (Simplex y: YStream) {
                YTracker.add(y, YStream.getFiltrationIndex(y));
                k++;
            }

            System.out.println("simplices in y complex: " + k);

            ZStream = new FlexibleVietorisRipsStream<Integer>(new ExplicitMetricSpace(makeVicsekDistanceMatrix(ArrayUtility.getSubset(points, xyindxs))), this.maxDistance, maxDimension + 1, new IncreasingLinearConverter(1, maxDistance, maxDistance), xyoindxs);
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
            indxoffset += points.length;
        }

        result.endAllIntervals(this.datapoints.size() - 1);
        System.out.println("Zigzag persistence: ");
        System.out.println(result.getAnnotatedBarcodes().toString());
        return BarcodeCollection.forgetGeneratorType(result.getAnnotatedBarcodes().filterByMaxDimension(maxDimension));
    }

    public static void main(String[] args) {

    }
}