

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

import edu.stanford.math.primitivelib.algebraic.impl.ModularIntField;
import edu.stanford.math.primitivelib.autogen.formal_sum.IntAlgebraicFreeModule;
import edu.stanford.math.primitivelib.autogen.formal_sum.IntSparseFormalSum;
import edu.stanford.math.primitivelib.autogen.algebraic.IntAbstractField;
import edu.stanford.math.plex4.streams.impl.VietorisRipsStream;
import edu.stanford.math.plex4.homology.barcodes.BarcodeCollection;
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
    private List<Double[][]> datapoints = new ArrayList<Double[][]>();

    public final int maxDimension;
    public final double maxDistance;

    public VeitorisRipsTimeStrapper(int maxDimension, double maxDistance) {
        this.maxDimension = maxDimension;
        this.maxDistance = maxDistance;
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
        VietorisRipsStream<double[]> stream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(points), maxDistance, maxDimension + 1, points.length);
        this.datapoints.add(toDoubleArray(points));
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

        Double[][] zpoints = null;
        Set<Double[]> ZSet = null;

        for(int i = 1; i < this.streams.size() - 1; i++) {

            if (XTracker == null) {
                XTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
                XStream = this.streams.get(0);
                for (Simplex x: XStream) {
                    XTracker.add(x, XStream.getFiltrationIndex(x));
                }
            }

            YTracker = new SimpleHomologyBasisTracker<Simplex>(intField, SimplexComparator.getInstance(), 0, this.maxDimension);
            YStream = this.streams.get(i+1);
            for (Simplex y: YStream) {
                YTracker.add(y, YStream.getFiltrationIndex(y));
            }

            ZSet = new HashSet<Double[]>();
            for (Double[] points: this.datapoints.get(i)) {
                ZSet.add(points);
            }
            for (Double[] points: this.datapoints.get(i+1)) {
                ZSet.add(points);
            }
            zpoints = (Double[][]) ZSet.toArray();
            ZStream = new VietorisRipsStream<double[]>(new EuclideanMetricSpace(unboxDoubleArray(zpoints)), maxDistance, maxDimension + 1, zpoints.length);

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
}