#import "@preview/glossarium:0.4.0": gls, glspl 

#import "../helper/outline_text.typ": outline-text

= Foundations
<chp:fnd>
== Neural Networks
<sec:fnd_dl>
== Convolutional Neural Networks for Computer Vision
<sec:fnd_cv>
== Visual and Textual based Transformer Models
<sec:fnd_tr>
== Semi-supervised and Unsupervised based Deep Learning
<sec:fnd_lr>
== Evaluation Methods
<sec:fnd_method>

=== Classification and Retrieval Metrics
<sec:fnd_map>

In order to evaluate retrieval or classification methods, various metrics have been developed to measure different aspects of these methods and thus allow a comparison or selection of the method. In retrieval tasks, several documents are usually considered, as these methods are used for searches and the question arises as to how many documents were found (#emph[Recall]) and how many of these documents are relevant (#emph[Precision]) to the concept being searched for. This also results in a variety of different metrics, because depending on the scenario it is important, for example, that all relevant results are found or that all objects found are correct. The following four parameters are particularly important for the various metrics and must all be determined for the $n$ documents to be evaluated for a search query:

- $T P$: True positive is the number of all correctly recognized positive examples
- $T N$: True negative is the number of all correctly recognized negative examples
- $F P$: False positive is the number of all falsely recognized positive examples
- $F N$: False negative is the number of all falsely recognized negative examples


#figure([#image("../images/foundations/metric_eng.svg", width: 70%)],
  caption: outline-text([
    Representation of the entire set of all documents in a retrieval result and how it is divided into portions for false negatives $F N$, true negatives $T N$, true positives $T P$, and false positives $F P$.
  ],[Categorization of retrieval results]) //TODO
)
<fig:precision_recall>

Figure @fig:precision_recall shows how these values relate to the number of documents retrieved and the total number of documents. Based on these values, we can calculate the following metrics.

==== Recall
<sec:fnd_map>

Recall $R$ indicates how many of the found documents are relevant among the search results. The range of values for this metric is from zero to one, with one being the best possible outcome. However, recall alone is not sufficient for evaluating a retrieval system because if the system simply classifies all documents as positive, the metric would be one. Recall $R$ can be computed as follows:

$
R &= (T P) /(T P + F N)
$

==== Precision
<sec:fnd_map>

Precision $P$ indicates how many of the found documents match the sought concepts. The value range of this metric goes from zero to one, where one would be the best possible result. Precision $P$ can be calculated as follows:

$
P &= (T P) /(T P + F P)
$

As the number of documents to be evaluated can become quite large in current datasets and deployment scenarios, making evaluation with recall and precision difficult to compute, there are several other metrics that consider only a subset of the results. For example, Precision at k examines only the top k documents, or R-Precision.

==== Average Precision 
<sec:fnd_ap>

Average Precision is a combination of recall and precision, allowing one to evaluate a system with just one value. However, it is essential that the system returns a sortable list of results because we can then calculate a precision-recall curve. After each returned document $n$, precision and recall $P(R)$ are calculated for this documents, and subsequently, the area under the resulting curve corresponds to the Average Precision. In this process, instead of using the integral function over $P(R)$, only a finite sum is used, which can be calculated as follows:

$
A P &= sum_(n = 1)^N (R_n-R_(n-1))P_n 
$

For some benchmarks such as #gls("VOC") @everingham2010pascal @everingham2015pascal, an interpolated version of Average Precision is also calculated. In this process, precision is only determined at discrete recall values and their sum is computed as shown in the following equation:

$
A P &= 1/11 sum_(r in {0,0.1,dots,1.0}) P(R)
$

==== Mean Average Precision 
<sec:fnd_map>

Mean Average Precision (mAP) is the mean of the Average Precision $A P$ for different concepts $C$ for a concept classifier or different search queries $C$ in a retrieval system. The metric can be calculated as follows:

$
m A P &= 1/(|C|)sum_(c in C) A P_c
$


=== Intersection over Union
<sec:iou>

=== Krippendorff's Alpha
<sec:fnd_agreement>

Krippendorff's Alpha is a statistical measure of agreement between coders. This measure can be used, for example, to determine how uniformly different annotators annotate the same data set. The metric can be used with any number of annotators and data types (nominal, ordinal and interval) and also handles the missing annotation in the data corpus. The metric covers a value range between -1 and 1, where 1 means that all annotators are in agreement and their annotations match, 0 means that the annotators are randomly guessing and negative values indicate that annotators systematically disagree. The metric can be calculated in the following way:

$
alpha = 1 - D_o/D_e
$

Where $D_o$ is the observed disagreement and $D_e$ is the expected disagreement, which can be calculated as follows:

$
D_o &= 1/n sum_(c in R) sum_(k in R) w(c,k) sum_(u in U) n_(c k u)/(m_u-1) \
D_e &= 1/(n (n-1)) sum_(c in R) sum_(k in R) w(c,k) n_c n_k 
$

Where $R$ is the set of all possible answers (all possible labels in a classification task) and $U$ is the set of all units (documents or images in a classification task). Furthermore, the following values are required: $n$ is the number of all annotations, $n_c$ and $n_k$ are the number of annotations of a certain class in $R$, $n_(c k u)$ is the number of annotation pairs $(c,k)$ for a certain document $u$, and $m_u$ are the number of annotations for a specific document $u$. Finally, a metric function $w(c,k)$ is needed that defines a weighting depending on two classes. This function depends on whether a relationship can be defined between the individual concepts of the annotation, if it is #emph[nominal] data as in this work, the following weighting function is used:

$
w(c,k) = cases(
  0 "if" c = k,
  1 "if" c != k
)
$