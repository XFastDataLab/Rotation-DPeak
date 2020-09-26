# Rotation-DPeak
Density Peak (DPeak) is an effective clustering algorithm. It maps arbitrary dimensional data onto a 2-dimensional space, which yields cluster centers and outliers automatically
distribute on upper right and upper left corner, respectively. However, DPeak is not suitable for imbalanced data set with large difference in density, where sparse clusters are usually not
identified. Hence, an improved DPeak, namely Rotation-DPeak, is proposed to overcome this drawback according to an simple idea: the higher density of a point p, the larger δ it should have such that p can be picked as a density peak, where δ is the
distance from p to its nearest neighbor with higher density. Then, based on this idea, a new strategy for selecting density peaks is invented by a quadratic curve, instead of choosing points with the
largest γ, where γ = ρ×δ. Experiments shows that the proposed algorithm obtains better performance on imbalanced data set, which proves that it is promising.
