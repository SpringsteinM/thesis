#import "@preview/glossarium:0.5.3": gls, glspl 
#import "@preview/subpar:0.2.2"
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": outline-text

== #outline-text([Semi-supervised Human Pose Estimation in Art-historical Images],[Semi-supervised Human Pose Estimation in Art])

=== Introduction
<sec:intro>
As 'language' of non-verbal communication, gesture has been
theoretically established since the 17th century @Knowlson1965.
Its relevance for the visual arts, however, has so far been expressed at
most sporadically @Barasch1987: e.g.,
symbolically-performatively on the basis of the medieval law-book
manuscript of the Heidelberg #emph[Sachsenspiegel]
@vonAmira1905, as the antiquity-receiving 'Pathosformel'
@Warburg1905 @Warburg1914, or as a status identifier
exemplified in Roman sculpture @Brilliant1963. This selectivity
may be primarily due to the sheer overwhelming amount of data that
traditionally had to be processed manually. Driven by the steady
progress of digitization, though, an increasing quantity of historical
artifacts has been indexed and made freely available to the public
online in recent decades. As a result, art historians can draw on ever
larger collections of art-historical imagery to demonstrate the
formulaic recapitulation of motifs with significant gesture or
pose;#footnote[For simplicity, we hereinafter do not distinguish between
the terms 'gesture,' 'posture,' and 'pose.' Instead, we use the term
'pose' for any kind of physical expression.] as exemplified by Christ’s
deposition from the cross in @fig:deposition. This is accompanied
by a need for search engines that retrieve human figures with similar
poses, facilitating the search for objects relevant to the individual
scholar. It would thus become feasible to examine dominant pose types or
time-dependent bodily phenomena on a large scale, as they were
characteristic in Mannerism through the overlengthening of limbs, e.g.,
in Jacopo da Pontormo’s work
(@fig:deposition_b). Intra- as well as
inter-iconographic recurrent motifs, whose radically altered semantics
are disconcerting, might be thoroughly discussed in this context. To
date, however, only few approaches exist for human pose estimation in
art-historical images, possibly due to the lack of a sufficiently large
domain-specific data set. To deal with this issue, one type of
approaches uses pre-trained models, but without adapting them to the new
domain~@MadhuMKBMC20 @JenicekC19,
while others apply style transfer to real-world data sets to obtain
domain-specific training
data~@abs-2012-05616"), or fine-tune
pre-trained models using small, keypoint-level annotated data
sets~@abs-2012-05616").

#subpar.grid(
  columns: 4,

  figure(
    image("../images/pose/pleydenwurff_kreuzabnahme.jpg", width: 100%),
    caption:[]
  ), <fig:deposition_a>,
  figure(
    image("../images/pose/pontormo_kreuzabnahme.jpg", width: 100%),
    caption:[]
  ), <fig:deposition_b>,
  figure(
    image("../images/pose/caravaggio_grablegung.jpg", width: 100%),
    caption:[]
  ), <fig:deposition_c>,
  figure(
    image("../images/pose/rubens_grablegung.jpg", width: 100%),
    caption:[]
  ), <fig:deposition_d>,
  caption: [The four depictions of Christ's deposition from the cross highlight slightly varying poses: (a) Hans Pleydenwurff, 1465; (b) Pontormo, 1525--1528; (c) Caravaggio, 1603--1604; (d) Peter Paul Rubens, ca. 1612. All images are in the public domain.],
  label: <fig:deposition>,
)


In this paper, we propose a novel approach to quantitatively systematize
the exploration of pose types in visual art utilizing semi-supervised
learning. We suggest a two-stage approach based on two Transformer
models: the first model detects bounding boxes of human figures, while
the second model predicts the keypoints of each box. We adapt a
semi-supervised learning technique to reduce the performance loss caused
by the shift between existing real-world data sets and the art domain,
and to reduce the amount of art-historical labeled data. Our main
contributions are as follows: (1) for object and keypoint detection, we
suggest to combine semi-supervised pipelines through a two-step approach
built on Transformer models with a teacher-student design; (2) to
properly test our approach, we introduce a sufficiently large
art-historical data set with both bounding box and keypoint annotations
of human figures in $22$ depiction styles; (3) in contrast to previous
work, we show that the synthetic generation of seemingly 'realistic' art
imagery inadequately reflects the stylistic diversity of historical
artifacts. For both detection steps, the incorporation of manually
labeled domain-specific material is performance-wise still required in
the training and test phases. The code and models are
available.#footnote[#link("https://github.com/TIBHannover/iart-semi-pose"),
all last accessed on 2024-05-20.]

The rest of the paper is structured as follows.
@sec:rw reviews related work on pose estimation and
semi-supervised learning. In @chp:pose-method, we describe
our pose estimator and its extension to a semi-supervised approach. In
@chp:exp, we introduce our data sets and report on
the ablation studies performed. @chp:study presents a
user study to evaluate retrieval results from a human perspective. We
conclude with @chp:conc and outline areas of future
work.

=== Related Work
<sec:rw>
As with many other computer vision tasks, there has been steady progress
in human pose estimation over recent years, particularly with the
continued development of increasingly advanced deep learning models and
self-supervised learning techniques.

#strong[Human pose estimation] deals with the localization of a person’s
skeleton by detecting associated keypoints, i.e., #emph[skeleton
coordinates] that mostly correspond to joint points of elbows,
shoulders,
etc.~@0012WZXXT21 @0009XLW19 @KreissBA19 @ChengXWSH020 @CaoHSWS21 @XiaoWW18 @ZhangZD0Z20.
The problem can be solved in two ways. The #emph[top-down] approach
first detects persons, indexes them with bounding boxes, and then
determines keypoints for each
person~@0012WZXXT21 @0009XLW19 @KreissBA19;
while the #emph[bottom-up] approach first detects keypoints, and then
merges them to simultaneously identify persons and their basic
pose~@CaoHSWS21 @ChengXWSH020 @PapandreouZCGTM18.
Current work on the respective strategies shows that top-down methods
generally yield better results, but at the cost of computational
complexity~@ChengXWSH020. Two-stage estimation
makes the runtime linearly dependent on the number of detected persons
in a scene, as the individual instances are cropped, and thus more
forward steps are required for keypoint recognition. However, since
there is no real-time requirement for the domain considered here,
runtime is of secondary importance. Further differences result from the
prediction of the individual keypoints. Heatmap-based methods generate a
dense likelihood map for the individual
joints~@0009XLW19, whereas regression models
directly predict coordinates of the individual components and optimize
them~@0012WZXXT21. While heatmap-based methods
tend to perform better, the advantage of regression-based models is that
they require fewer pre- and post-processing
steps~@0012WZXXT21. Therefore, we also make use
of such models in our proposed method, as they are easier to integrate.

Few studies specifically address the estimation of human poses in
art-historical images. This may be due to the fact that domain-specific
data sets are usually only superficially
indexed~@painter @artigo @KarayevTHADHW14 and
rarely include fine-grained annotations at the level of concrete image
details~@GarciaV18 @MaoCS17 @abs-1906-00901 @StrezoskiW18.
A publicly accessible data set that contains poses of human figures in
artworks does not yet exist. Relevant previous work employs different
approaches to deal with the lack of annotated training data: they (1)
analyze only self-annotated data sets, without training models or
performing inference~@ImpettS16"); (2) use trained
pose estimators from another domain without adaptation
@MadhuMKBMC20 @JenicekC19; (3)
apply style transfer to real-world data sets to close the domain
gap~@abs-2012-05616"); or (4) leverage small,
keypoint-level annotated data sets to fine-tune pre-trained
models~@abs-2012-05616").

#strong[Semi-supervised learning] aims to exploit a (potentially large)
set of unlabeled data in addition to a (typically small) set of labeled
data to improve the resulting model. To use the rest of the material
during training, pseudo-labels are either
generated~@XieLHL20 @lee2013pseudo, or
integrated into the loss with consistency
regularization~@LaineA17 @MiyatoMKI19.
One type of state-of-the-art methods uses a teacher-student approach.
During training, an image is fed into a teacher model, which then
generates a label for a student model that is being trained. The teacher
model update can be iteratively selected from a previously trained
student model~@XieLHL20, or the teacher is an EMA
of the student~@TarvainenV17. Another type of
semi-supervised methods uses data augmentation to generate better
feedback signals for unlabeled data, or combines pseudo-label generation
and consistency
regularization~@BerthelotCGPOR19 @BerthelotCCKSZR20 @SohnBCZZRCKL20.
Similar to semi-supervised classification, localization methods are
based on consistency
regularization~@JeongLKK19 @TangRWXX21
and pseudo-label
generation~@Xu00WWWB021 @WangYZ0L18.
The challenge increases, however, since not only the respective concept
must be assigned, but also its position in the image must be detected.
#figure(
  image("../images/pose/pose_detr.svg", width: 100%),
  caption:[
    The two-stage human pose estimator uses two Transformers~@VaswaniSPUJGKP17 @CarionMSUKZ20 to predict human poses in an image. 
The input of the first model is the entire image, which, using a #gls("CNN") backend and appropriate positional encoding, serves as input to a Transformer that predicts a fixed set of person bounding boxes. 
After filtering irrelevant detections, the individual boxes are cropped and serve as input for the second stage. 
This second Transformer model computes a set of keypoints that serve as the final prediction after filtering background classes.
  ]
)
<fig:two_stages>

=== Semi-supervised Pose Estimation
<chp:pose-method>
In this section, we describe our method for automatic domain adaptation
for human pose estimation. First, we introduce the two-stage
Transformer-based detection model in
@sec:detection. We then use it in the common
approach of fine-tuning pre-trained models with stylized, approximately
domain-specific images. In @sec:semi, we
demonstrate how 'real' art-historical images can be used in the training
stages with the extension of a semi-supervised process.

==== Transformer-based Detection
<sec:detection>
The proposed approach is organized in two steps: first, persons are
detected in an input image and bounding boxes are computed; in a second
step, the individual boxes are scanned for keypoints. The initial system
is based on Li et al.’s method~@0012WZXXT21,
which is built on two Transformer models for object
detection~@VaswaniSPUJGKP17 @CarionMSUKZ20.
The overall architecture is shown in @fig:two_stages.

In the #strong[person detection phase], feature descriptors are computed
using a CNN backend combined with a two-dimensional position embedding.
After this input is flattened into a sequence of visual features, it is
passed to a Transformer encoder, which is later used in the
cross-attention modules of the decoder. The other input of the
Transformer decoder is a fixed set of trainable query embeddings, where
the size of the set represents the maximum number of objects to be
detected. The output is fed into two MLP heads. The first head acts as a
classifier and distinguishes between person $c_(b comma i)$ and
background $nothing$, while the second one performs a regression on four
outputs for the position and size of the corresponding box
$b_i in lr([0 comma 1])^4$. At the beginning of the #strong[keypoint
prediction stage], visual features for each bounding box are determined
using a CNN backend. The image features, combined with position encoding
and a new set of input query embeddings, are transformed to a fixed set
of keypoint predictions using the Transformer. The main difference
between the two models is that the prediction head predicts only the
coordinates of keypoints $k_i in lr([0 comma 1])^2$, and instead of
predicting only the person or background, classifies the type of
keypoint $c_(k comma i)$.

During the training phase, it is necessary to match the fixed set of
predictions with the variable number of ground-truth labels per image.
We thus need to find an optimal assignment $hat(sigma)$ between
prediction $hat(y)$ and ground-truth labels $y$ in the permutation of
$N$ elements $sigma in frak(S)_N$ with the lowest matching cost $L_m$:

$
hat(sigma) = arg min_(sigma in frak(S)_N) sum_i^N L_m ( y_i,hat(y)_(sigma (i)))
// \\hat{\\sigma}&\= \\argmin\_{\\sigma \\in \\mathfrak{S}\_N}\\sum\_{i}^{N}L\_m\\left(y\_i,\\hat{y}\_{\\sigma\\left(i\\right)}\\right)
$ 

The optimal solution for this problem can be solved
using the Hungarian algorithm~@kuhn1955hungarian and yields the
assignment function $hat(sigma) lr((i))$. The assignment loss includes
both the class probability and the position of the predicted object
compared to the ground-truth annotation. For bounding box prediction
with index $sigma lr((i))$, we define the class probability
$c_(b comma i)$ as $hat(p)_(sigma lr((i))) lr((c_(b comma i)))$ and the
predicted box as $hat(b)_(sigma lr((i)))$. Similarly, for keypoint
prediction, we define the probability of class $c_(k comma i)$ as
$hat(p)_(sigma lr((c_(k comma i)))) lr((i))$ and the predicted keypoint
as $hat(k)_(sigma lr((i)))$. With these definitions, we establish the
following loss functions: 

$
L_(m,b)(y,hat(y))&=-bb(1)_({c_(b,i) eq.not nothing}) hat(p)_(sigma (i))(c_(b,i)) + bb(1)_({c_(b,i) eq.not nothing}) L_b (b_i, hat(b)_(sigma (i))) 
$

$
L_(m,k)(y,hat(y))&=-bb(1)_({c_(k,i) eq.not nothing}) hat(p)_(sigma (i))(c_(k,i)) + bb(1)_({c_(k,i) eq.not nothing}) L_k (k_i, hat(k)_(sigma (i)))
$

For bounding box prediction, the class probability
defined as the $L 1$-distance of the bounding box $b_i$, and the
GIoU~@RezatofighiTGS019
$L_(i o u) lr((dot.op comma dot.op))$ are chosen as the basis for cost
function $L_b$, where we follow Li et al.’s approach and implementation
@0012WZXXT21. For keypoints $k_i$, only the class
probability and the $L 1$-distance of the coordinates are considered:

$ L_b lr((b_i comma hat(b)_(sigma lr((i))))) & eq lambda_(i o u) L_(i o u) lr((b_i comma hat(b)_(sigma lr((i))))) plus lambda_(L 1) ∥b_i minus hat(b)_(sigma lr((i)))∥
$

$
L_k lr((k_i comma hat(k)_(sigma lr((i))))) & eq lambda_(L 1) ∥k_i minus hat(k)_(sigma lr((i)))∥ 
$

where hyperparameters $lambda_(i o u)$ and $lambda_(L 1)$ indicate the
weight of each loss component. Predictions that could not be assigned to
a ground-truth label are instead assigned to the background class
$nothing$ during optimization; their bounding boxes and keypoint
coordinates are not considered in the loss. After the best assignment is
found, the loss can be calculated as follows: 

$
L_(H,b)=sum_(i=1)^N [ - log hat(p)_(hat(sigma))(c_(b,i))+bb(1)_({ c_(b,i) eq.not nothing})L_b (b_i,hat(b)_hat(sigma) (i)) ]
$

$
// TODO check b -> k
L_(H,k)=sum_(i=1)^N [ - log hat(p)_(hat(sigma))(c_(k,i))+bb(1)_({ c_(k,i) eq.not nothing})L_k (k_i,hat(k)_hat(sigma) (i)) ]
$


During the inference of bounding box prediction, it
is sufficient to filter the predicted boxes using a threshold function.
However, during the inference step of keypoint prediction, it is
necessary to find an optimal assignment again because the Transformer
model predicts up to $N$ points, but the number is usually larger than
the maximum number of possible keypoints per person. Since no
ground-truth information is known during inference, the following cost
function is used:
$ L_(m comma k) lr((y comma hat(y))) & eq minus hat(p)_(sigma lr((i))) lr((c_(k comma i))) $
Compared to object detection methods such as Faster Region-based CNN
(R-CNN)~@RenHGS15 and YOLO (You Only Look
Once)~@RedmonF17, the approach does not predict
multiple bounding box candidates for each image region, but only a fixed
set of boxes for each image. This greatly simplifies post-processing, as
no overlapping bounding boxes are predicted for same-person instances,
and the imbalance between background and foreground classes is much
smaller.

#figure(
  image("../images/pose/detr_semi_v2.svg", width: 100%),
  caption: [
    In the semi-supervised training pipeline adapted from
    Xu et al. @Xu00WWWB021, each batch consists of labeled
    and unlabeled images with strong and weak augmentations generated
    for unlabeled ones. The teacher uses the weakly labeled data to
    generate pseudo bounding boxes (or pseudo keypoints) that are used
    to train the strongly augmented images. This involves thresholding
    the predictions and then transferring the corresponding boxes (or
    keypoints) to the coordinate system of the strongly augmented image.
  ]
)
<fig:semi>

==== Semi-supervised Domain Adaptation
<sec:semi>
To extend the available data sets for bounding box and keypoint
detection in art-historical images, we augment the training pipeline by
adapting the semi-supervised approach from
Xu et al. @Xu00WWWB021. Since we use a Transformer model
instead of a Faster R-CNN, the number of predicted bounding boxes and
keypoints is considerably smaller and simplifies certain steps. An
overview of the semi-supervised pipeline is shown in
@fig:semi. The basic principle is to use both labeled
and unlabeled examples to train a student model. Here, the teacher,
whose weights are based on the EMA of the student weights, serves as a
generator of pseudo-labels for bounding boxes and keypoints. For this
purpose, weakly augmented unlabeled images are used for person detection
and weakly augmented cropped bounding boxes for keypoint prediction.
Subsequently, the predicted objects are filtered with the threshold
$tau eq 0.9$ and projected onto the strongly augmented unlabeled images.
Contrary to Xu et al. @Xu00WWWB021, it is not possible to
determine target labels for the background class from the teacher,
because negative teacher predictions do not have to contain any valid
coordinates and therefore cannot be assigned to an output of the student
using the Hungarian algorithm. Therefore, we use the teacher prediction
for bounding boxes and keypoints only if it is not a background class.
To not distort the ratio between negative and positive boxes or
keypoints, we suggest to use the same threshold to filter negative
examples; but this time from the forward step of the student. This is
necessary because there is no relationship between the predicted
coordinates of the teacher’s negative classes and the student’s negative
predictions. The total loss now includes a supervised component $L_s$
and an unsupervised component $L_u$. It is calculated as follows:
$ L & eq L_s plus lambda_u L_u $ Depending on the current target, the
supervised loss is the same as for supervised learning,
$L_s in lr({L_(H comma b) comma L_(H comma k)})$. For the unsupervised
loss part, we use the prediction of the teacher model to detect bounding
boxes or keypoints. Therefore, for the prediction of the bounding box
with index $i$, we define the probability of class $c_(b comma i)$ as
$hat(p)^t lr((c_(b comma i)))$ and the predicted box as $hat(b)^t$.
Similarly, for the teacher keypoint prediction, we define the
probability of class $c_(k comma i)$ as $hat(p)^t lr((c_(k comma i)))$
and the predicted keypoint as $hat(k)^t$. With these definitions, we can
establish the loss functions: 

$
 L_(u,"reg",b) =sum_i^N bb(1)_({c_(b,i) eq.not nothing; hat(p)^t (c_(b,i)) gt.eq tau}) L_b (hat(b)^t_i,hat(b)_hat(sigma) (i))
$

$
 L_(u,"reg",k) =sum_i^N bb(1)_({c_(k,i) eq.not nothing; hat(p)^t (c_(k,i)) gt.eq tau}) L_k (hat(k)^t_i,hat(k)_hat(sigma) (i))
$

The classification loss of the unlabeled examples is
given by the positive classes resulting from the teacher’s probability
of exceeding threshold $tau$ and the negative examples from the
student’s prediction: 
$
L_(u, "cls", b) =& - sum_i^N bb(1)_({c_(b,i) eq.not nothing; hat(p)^t (c_(b,i)) gt.eq tau} ) log hat(p)_hat(sigma) (c_(b,i)) \
                 & - sum_i^N bb(1)_({c_(b,i) eq.not nothing; hat(p)_hat(sigma) (c_(b,i)) gt.eq tau} ) log hat(p)_hat(sigma) (c_(b,i))
$

$
L_(u, "cls", k) =& - sum_i^N bb(1)_({c_(k,i) eq.not nothing; hat(p)^t (c_(k,i)) gt.eq tau} ) log hat(p)_hat(sigma) (c_(k,i)) \
                 & - sum_i^N bb(1)_({c_(k,i) eq.not nothing; hat(p)_hat(sigma) (c_(k,i)) gt.eq tau} ) log hat(p)_hat(sigma) (c_(k,i))
$
    
=== Experimental Setup and Results
<chp:exp>
In this section, we introduce our data sets and discuss the quantitative
and qualitative studies. For the training and test phases of our
pipelines, we use various real-world, synthetically generated, and
art-historical data sets (@chp:datasets). To
evaluate the performance of each model and approach, we first conduct a
series of ablation studies (@chp:ablation) and then
qualitatively assess our method’s ability to provide reasonable
predictions (@chp:qualitative). To evaluate the
experiments, we use the metrics and tools from the COCO
API.#footnote[#link("https://github.com/cocodataset/cocoapi").]

// TODO
#figure(
  table(
    columns: (20%,20%,20%,20%,20%),
    align: (left,left,right,right,right,),

    toprule(),
    table.header([Data set], [Split], [Images], [Persons], [Keypoints],),
    midrule(),
    [COCO 2017], [Training], [118,287], [262,465], [1,642,283],
    [], [Validation], [5,000], [11,004], [68,215],
    [], [Test], [0], [0], [0],
    cmidrule(start: 1),
    [], [Total], [123,287], [273,469], [1,710,498],
    midrule(),
    [COCO 2017], [Training], [236,574], [524,930], [3,284,566],
    [(stylized)], [Validation], [10,000], [22,008], [136,430],
    [], [Test], [0], [0], [0],
    cmidrule(start: 1),
    [], [Total], [246,574], [546,938], [3,420,996],
    midrule(),
    [People-Art], [Training], [1,746], [1,330], [0],
    [], [Validation], [1,489], [1,080], [0],
    [], [Test], [1,616], [1,088], [0],
    cmidrule(start: 1),
    [], [Total], [4,851], [3,498], [0],
    midrule(),
    [PoPArt], [Training], [1,553], [2,069], [30,415],
    [], [Validation], [643], [704], [10,367],
    [], [Test], [663], [741], [10,863],
    cmidrule(start: 1),
    [], [Total], [2,859], [3,514], [51,645],
    midrule(),
    [ART500k], [Training], [318,869], [0], [0],
    [], [Validation], [0], [0], [0],
    [], [Test], [0], [0], [0],
    cmidrule(start: 1),
    [], [Total], [318,869], [0], [0],
    bottomrule(),
  ),
  caption: figure.caption([ An overview is given of the data sets used in our experiments. Persons are indicated by bounding boxes associated with them. Up to 17 keypoints are stored per person.
  ],
  position:top)
)
<tab:data>

==== Data Sets
<chp:datasets>
An overview of the data sets used in our experiments with their
respective splits is shown in @tab:data. All
data sets are based on the COCO format, where each person instance is
labeled with up to $17$ keypoints.

The largest annotated data set results from the #strong[COCO 2017]
detection and keypoint challenge, which includes $118 comma 287$
training and $5 comma 000$ validation images with person
instances.#footnote[#link("https://www.kaggle.com/datasets/awsaf49/coco-2017-dataset").]
To evaluate the performance of the common scenario that uses style
transfer to close the domain gap between annotated real-world training
and art-historical inference data, we generate a stylized version of the
data set. For this purpose, we leverage the style transfer approach
from Chen et al. @chen2021artistic to create two style variants for each
COCO image, where the style images are randomly selected from the
Painter by Numbers data set~@painter. \
The models are grounded in two domain-specific, sufficiently large data
sets that recycle openly licensed subsets of the art-historical online
encyclopedia WikiArt#footnote[#link("https://www.wikiart.org/").]: the
2016 compiled People-Art data
set~@CaiWCH15 @WestlakeCH16,
in which human figures are marked with bounding boxes enclosing them.
The second data set, called PoPArt, is introduced here and identifies
$17$ limb points in addition to bounding boxes. Both data sets
approximately reflect the diversity of art-historical depictions of
human figures through time by featuring $43$ and $22$ different styles,
respectively; ranging from impressionistic to neo-figurative and
realistic variants. The pre-existing #strong[People-Art] data set is
enhanced on two levels. First, we integrate additional negative examples
of mammals that were frequently false positively classified as
humans~@WestlakeCH16"). Second, we use the largest
resolution of images provided by WikiArt to avoid further complicating
the detection of relatively small figures due to possible image
artifacts in low-resolution reproductions. After these preparatory
measures, People-Art features $1 comma 746$ training, $1 comma 489$
validation, and $1 comma 616$ test images. The annotation of the novel
#strong[PoPArt] data set was performed according to the following
principles (see @fig:examples_a) for some examples
with ground-truth annotations): (1)~the body of a human figure must be
recognizable, which implies that more than six keypoints are
annotatable, covering at least head and shoulder area; (2)~a maximum of
four figures are annotated per image; if more than four instances are
shown, those whose body permits to annotate as many limbs as possible
are selected; (3)~if an occluded body part can be sufficiently
approximated by another visible one, the respective associated keypoint
is annotated; (4)~in profile views, eyes and ears are usually annotated
on the non-visible side of the face as well. The data set includes
$1 comma 553$ training, $643$ validation, and $663$ test images, where
each split contains proportionally the same number of images per style.

With the #strong[ART500k] data set~@MaoCS17, we
moreover integrate an art-historical data set not annotated with person
instances into the training procedure. A 50~% split of all ART500k
images with a total of $318 comma 869$ examples is generated, which we
use in our semi-supervised learning approach as unlabeled data.

==== Ablation Study
<chp:ablation>
For #strong[person detection], we leverage the weights
of a DETR model~@CarionMSUKZ20") pre-trained on
COCO 2017 and reinitialize the classification head. An Adam
optimizer~@KingmaB14") with a learning rate of
$l r eq 5 e minus 6$ is used for the Transformer and with
$l r eq 1 e minus 7$ for the ResNet-50
backbone~@HeZRS16. Similar to Li et al. @0012WZXXT21, all classes except persons are
ignored; small bounding boxes are not considered. Models are trained for
$200 comma 000$ iterations with a batch size of four, with all images
randomly scaled to a maximum size of $1 comma 333$ pixels per side. When
training the semi-supervised models, the batch size is increased by four
additional unlabeled images. The weights of the different loss
hyperparameters are set to $lambda_(L 1) eq 5$, $lambda_(i o u) eq 2$,
and $lambda_u eq 0.5$.


#figure(
  table(
    columns: 10,

    toprule(),
        table.header([Train
      set], [Stylized], [Semi], [$A P$], [$A P_50$], [$A P_75$], [$A P_S$], [$A P_M$], [$A P_L$], [$A R$],),
    midrule(),
     [COCO
    2017], [0~%], [], [0.3118], [0.5106], [0.3175], [0.0075], [0.2118], [0.3294], [0.6728],
    [COCO
    2017], [0~%], sym.checkmark, [0.3696], [0.597], [0.3885], [0.0007], [0.2115], [0.395], [#strong[0.7351];],
    [COCO
    2017], [50~%], [], [0.3686], [0.6113], [0.3871], [0.0045], [0.2386], [0.3941], [0.7257],
    [COCO
    2017], [50~%], sym.checkmark, [0.3744], [0.6277], [0.3792], [0.0024], [0.2193], [0.4011], [0.7296],
    [COCO
    2017], [100~%], [], [0.3727], [0.6256], [0.3922], [0.024], [0.2406], [0.3981], [0.7165],
    [COCO
    2017], [100~%], sym.checkmark, [0.3846], [0.6333], [0.4047], [0.0115], [0.2313], [0.4108], [0.7221],
    [People-Art], [0~%], [], [0.428], [0.7279], [0.435], [#strong[0.0676];], [0.2123], [0.4636], [0.7041],
    [People-Art], [0~%], sym.checkmark, [#strong[0.4428];], [#strong[0.7381];], [#strong[0.459];], [0.0509], [#strong[0.2412];], [#strong[0.4769];], [0.7291],
    bottomrule()
  ),
  caption: figure.caption(
    [Person detection results are reported for the People-Art test set. Entries without style transfer and without semi-supervised learning correspond to the state-of-the-art method of Li et al. @0012WZXXT21 with fine-tuning to the respective training data set. The best performing approach per test set is indicated in bold.],
    position:top
  )
)
<tab:exp_boxes_people>


#figure(
  table(
    columns: 10,

    toprule(),
    table.header([Train
      set], [Stylized], [Semi], [$A P$], [$A P_50$], [$A P_75$], [$A P_S$], [$A P_M$], [$A P_L$], [$A R$],),
    midrule(),
    [COCO    2017], [0~%], [], [0.2287], [0.3041], [0.2433], [], [0.1096], [0.2336], [0.7997],
    [COCO
    2017], [0~%], sym.checkmark, [0.2422], [0.3353], [0.2612], [], [0.0324], [0.2469], [0.8377],
    [COCO
    2017], [50~%], [], [0.2322], [0.3168], [0.248], [], [0.04], [0.2397], [0.8365],
    [COCO
    2017], [50~%], sym.checkmark, [0.2261], [0.3125], [0.2452], [], [0.0347], [0.2324], [0.8277],
    [COCO
    2017], [100~%], [], [0.2542], [0.354], [0.273], [], [0.036], [0.2624], [0.8128],
    [COCO
    2017], [100~%], sym.checkmark, [0.2359], [0.331], [0.2516], [], [0.048], [0.2423], [0.8284],
    [PoPArt], [0~%], [], [0.4898], [0.6566], [0.5279], [], [#strong[0.2639];], [0.4945], [0.8468],
    [PoPArt], [0~%], sym.checkmark, [#strong[0.5073];], [#strong[0.6728];], [#strong[0.5302];], [], [0.2132], [#strong[0.5119];], [#strong[0.8561];],
    bottomrule()
  
  ),
  caption: figure.caption(
    [Person detection results are reported for the PoPArt test set. For PoPArt, $A P_S$ is neglected as no test data is available for small human figures, most of which have no annotatable pose due to their size. Entries without style transfer and without semi-supervised learning correspond to the state-of-the-art method of Li et al. @0012WZXXT21 with fine-tuning to the respective training data set. The best performing approach per test set is indicated in bold.],
    position:top
  )
)
<tab:exp_boxes_popart>

The results for the respective test sets are shown in
Table~@tab:exp_boxes_people and Table~@tab:exp_boxes_popart, including a comparison
with the best state-of-the-art method to date
@0012WZXXT21. We notice that our semi-supervised
learning technique on People-Art always results in an improvement of AP
and AR. Moreover, AP maintains this advantage as the proportion of
style-transferred material increases, but becomes successively smaller.
The domain-specific data further increases the performance
significantly, such that AP rises from 0.428 to 0.4428 and AR from
0.7041 to 0.7291. With $A P_50 eq 0.7381$, the performance of our
approach is considerably above the best results of $A P_50 eq 0.68$ and
$A P_50 eq 0.583$ reported so far by Kadish et al. @KadishRL21
and Gonthier et al. @GonthierLG22 for the data set,
respectively. For PoPArt, we find that semi-supervised learning with
art-historical images enhances AP less; thus, our proposed method with
COCO 2017 annotations has similar performance to using style transfer.
The comparison between training with COCO 2017 data and training on
PoPArt indicates a larger improvement especially in AP. This deviation
can be explained by the different types of annotations, as PoPArt was
annotated exclusively for pose estimation and contains fundamentally
fewer ground-truth bounding boxes of human figures. Nevertheless, our
proposed semi-supervised learning approach is beneficial: the
performance increases from 0.4898 to 0.5073 for AP and from 0.8468 to
0.8561 for AR.


<chp:exp_keypoint> In the #strong[keypoint prediction] stage, we use the
HRNet with 32 feature channels (HRNet-W32) as backbone with an input
resolution of $384 times 288$ pixels~@0009XLW19.
Again, we leverage the pre-trained weights on COCO 2017 from
Li et al. @0012WZXXT21 and reinitialize the classification
layer. The model is trained for $150 comma 000$ iterations with a batch
size of $16$; the learning rates are set to $l r eq 1 e minus 5$ for the
Transformer and $l r eq 1 e minus 6$ for the HRNet. We divide both rates
by $10$ and train for another $50 comma 000$ iterations with Adam. For
the semi-supervised methods, we add to the batch $16$ unlabeled images
generated from the models’ predictions from
Table~@tab:exp_boxes_people and Table~@tab:exp_boxes_popart on ART500k. Predicted
bounding boxes whose confidence level is above $0.5$ are used for this
purpose. The effects of keypoint prediction are similar to those of
person detection: we observe that AR can be significantly improved by
our semi-supervised learning technique. Models not only trained with
style-transferred images show an increase in AP. In particular, for
those using PoPArt, AP rises from 0.4844 to 0.5258 and AR from 0.7078 to
0.7464. Results for the PoPArt test set are summarized in
@tab:exp_keypoints. Unlike Jenícek and Chum @JenicekC19, we find that
OpenPose~@CaoHSWS21 with $A P eq 0.1388$ and
$A R eq 0.4382$ is not competitive to approaches that are specifically
trained for the given task.

#figure(
  table(
    columns: 9,
    align: (left,right,right,right,right,right,right,right,right,),
    toprule(),
    table.header([Train
      set], [Stylized], [Semi], [$A P$], [$A P_50$], [$A P_75$], [$A P_M$], [$A P_L$], [$A R$],),
    midrule(),
    [COCO
    2017], [0~%], [], [0.2285], [0.2811], [0.2545], [0.0236], [0.2367], [0.554],
    [COCO
    2017], [0~%], sym.checkmark, [0.2525], [0.3173], [0.281], [0.0122], [0.2639], [0.7009],
    [COCO
    2017], [50~%], [], [0.2401], [0.3072], [0.2672], [0.0215], [0.2531], [0.6672],
    [COCO
    2017], [50~%], sym.checkmark, [0.2413], [0.3052], [0.2665], [0.018], [0.2554], [0.688],
    [COCO
    2017], [100~%], [], [0.2657], [0.3426], [0.2932], [0.0153], [0.2845], [0.6765],
    [COCO
    2017], [100~%], sym.checkmark, [0.2518], [0.3167], [0.2813], [0.0169], [0.2653], [0.6896],
    midrule(),
    [People-Art/PoPArt], [0~%], [], [0.2841], [0.3622], [0.3073], [0.0378], [0.2916], [0.7185],
    [People-Art/PoPArt], [0~%], sym.checkmark, [0.2971], [0.3637], [0.3272], [0.0204], [0.3118], [#strong[0.7583];],
    midrule(),
    [PoPArt/PoPArt], [0~%], [], [0.4844], [0.606], [0.5319], [#strong[0.0771];], [0.492], [0.7078],
    [PoPArt/PoPArt], [0~%], sym.checkmark, [#strong[0.5258];], [#strong[0.6392];], [#strong[0.5735];], [0.0308], [#strong[0.535];], [0.7464],
    bottomrule()
  ),
  caption: figure.caption(
    [Keypoint detection results are reported for the PoPArt test set with predicted bounding boxes of the model with the same strategy. 
$A P_S$ is neglected as no test data is available for small human figures, most of which have no annotatable pose due to their size. 
For PoPArt train sets, the first entry refers to the training data set used for bounding box detection and the second to the training data set used for keypoint prediction. 
The best performing approach is indicated in bold.],
    position:top
  )
)
<tab:exp_keypoints>


#subpar.grid(
  columns: 2,

  figure(
    image("../images/pose/boxes_fraction_v2.svg", width: 100%),
    caption:[]
  ), <fig:distribution_a>,
  figure(
    image("../images/pose/poses_fraction_v3.svg", width: 100%),
    caption:[]
  ), <fig:distribution_b>,
  caption: [
    The distribution of positive and negative classes on PoPArt (orange)
    and the teacher’s predicted distribution for unlabeled data on
    ART500k (blue) are shown. It is evident that the teacher recognizes
    fewer bounding boxes in the person detection phase (a) and estimates
    more points in the keypoint prediction phase (b) in comparison.
  ],
  label: <fig:distribution>,
)

#subpar.grid(
  columns: 4,

  figure(
    image("../images/pose/examples_gt_v3.jpg", width: 100%),
    caption:[]
  ), <fig:examples_a>,
  figure(
    image("../images/pose/examples_open_v3.jpg", width: 100%),
    caption:[]
  ), <fig:examples_b>,
  figure(
    image("../images/pose/examples_coco_v3.jpg", width: 100%),
    caption:[]
  ), <fig:examples_c>,
  figure(
    image("../images/pose/examples_popart_semi_v3.jpg", width: 100%),
    caption:[]
  ), <fig:examples_d>,
  caption: [
    Ground-truth annotations (a), as well as predictions of
    OpenPose~@CaoHSWS21~(b), the model
    trained without style transfer and without semi-supervised
    learning~(c), and PoPArt~(d) overlaid on test examples from PoPArt.
  ],
  label: <fig:examples>,
)



To evaluate the behavior of our #strong[semi-supervised approach], we
examine the number of positive and negative teacher predictions during
training. To this end, we illustrate the ratios between negative and
positive bounding boxes (@fig:distribution_a) and
keypoints (@fig:distribution_b) of the labeled
and unlabeled parts of a batch. As we compute the target labels for the
background class directly from the student’s predictions, we can see in
both cases that the ratio of the background increases sharply until it
reaches the maximum at about $10 comma 000$ iterations. After that, it
starts to decrease in favor of positive classes as the confidence score
of the teacher’s predictions starts to exceed threshold~$tau$. In case
of keypoints, it becomes apparent that the ratio between supervised
(PoPArt) and unsupervised components (ART500k) per batch is equalized,
and later on average more keypoints are detected in ART500k than in
PoPArt.

==== Qualitative Analysis
<chp:qualitative>
To qualitatively assess our method’s ability to provide reasonable
predictions, we visually compare it to ground-truth annotations and two
of the other models. @fig:examples_b
illustrates that OpenPose almost consistently tends to estimate only
parts of the face and some points of the torso; holistically correct
predictions are rare. Bodies in non-realistic settings are often not
captured, exemplified by Henri Edmond Cross’s Neo-Impressionist example
from the early 20th century (@fig:examples_b,
#emph[first row]). This is also noticeable in the model trained on COCO
2017 without style transfer and unsupervised learning
(@fig:examples_c). However, more suitable
approximations of the lower body are identified, at least for
Jean-Baptiste Camille Corot’s #emph[Knight] (1868;
@fig:examples_c, #emph[third row]) and Fra
Angelico’s religious drawing of King David (ca. 1430; #emph[fourth
row]). Highly problematic, though, are hidden limbs or bodies not
depicted from usual perspectives, illustrated by the detail of
Michelangelo’s Sistine Chapel ceiling painting in
@fig:examples_c (#emph[second row]). Our proposed
model, trained on PoPArt and with semi-supervised learning, even manages
predominantly complex scenarios (@fig:examples_d).
Minor errors result from limbs assigned to the wrong side of the body
(#emph[first row]), poorly contrasting or rather abstractly drawn body
parts—or overlaps with limbs of other persons, which in PoPArt were
primarily due to Aubrey Beardsley’s works. This is especially true for
styles that introduce complications even when manually labeled, e.g., in
case of the Japanese genre Ukiyo-e, since expressive poses with strongly
flowing robes often lack clear assignment of joint points. In addition,
the correct assignment of points can be disturbed if the image shows a
person and his or her mirror image.


#figure(
  table(
    columns: 6,
    align: (center,center,center,center,center,center,),
    toprule(),
    table.header([Train set], [Stylized], [Semi], [\@5], [\@10], [\@15],),
    midrule(),
    [COCO
    2017], [0~%], [], [0.5626065045880496], [0.5929046028791711], [0.6309289755365093],
    [COCO
    2017], [0~%], [], [0.5702222757416806], [0.567596068630933], [0.5956858383439985],
    [COCO
    2017], [50~%], [], [0.6123574441937504], [0.6053535386709639], [0.6233609099435142],
    [COCO
    2017], [50~%], [], [0.571346217004936], [0.5900424185793351], [0.6093549589887899],
    [COCO
    2017], [100~%], [], [0.5727648495910804], [0.595849882336127], [0.6131130345488688],
    [COCO
    2017], [100~%], [], [0.5844929687342831], [0.606948907593188], [0.6303804494689661],
    midrule(),
    [PoPArt], [0~%], [], [0.5674734449562145], [0.5722388642863352], [0.5942983606417748],
    [PoPArt], [0~%], [], [#strong[0.6413402576973029];], [#strong[0.6204677429158516];], [#strong[0.6343858477271396];],
    bottomrule()
  ),
  caption: figure.caption(
    [Results of the user study are reported on the retrieval of similar poses with #gls("NDCG") as the ranking metric.],
    position:top
  )
)
<tab:userstudy>

#figure([#image("../images/pose/pose_query.jpg", width: 100%)],
  caption: [
    Query images for the user study include art-historical poses such as
    'Adlocutio' and 'Venus pudica.'
  ]
)
<fig:pose-query>

=== User Study on Retrieval Results
<chp:study>
In this section, we report the results of a user study that aimed to
evaluate the quality of the automatically generated keypoints from a
human perspective in a retrieval scenario. We first describe the
generation of keypoint descriptors and the experimental setup of the
user study before discussing the results.

#strong[Keypoint descriptors.] For the retrieval task, we convert
keypoints into a consistent feature vector representation. In doing so,
descriptors for the same pose should be nearly identical regardless of
position or scale. As pose discrimination depends heavily on the
relational configuration between body parts
@HoK09, we do not leverage joint coordinates
directly
@HaradaTMS04.
Instead, we build on Chen et al. @ChenZNYWX11 and employ
a $52$-dimensional feature descriptor that uses the orientation between
two keypoints. We obtain $1 comma 515$ images from the ART500k data set
not used for training in @chp:ablation, to which bounding
box and keypoint models are applied. For each pose, the descriptor from
Chen et al. @ChenZNYWX11 is calculated. In addition, we
selected $10$ poses with varying art-historical specificity and utilized
them as query images (@fig:pose-query). The small
number of examples naturally can only inadequately cover the large
variability of relevant body constellations; it is, nonetheless,
sufficient to ascertain the models’ basic suitability for retrieval
tasks.

#strong[Experimental setup.] For our study, we developed a web interface
with detailed instructions for annotation. A total of $12$ subjects were
recruited, personally invited by the participating departments of
computer science and art history. These included seven computer
scientists, two art historians, and three persons from other
professions. In the study, several pages were shown, consisting of a
query image and the corresponding top-20 retrieval results. For each
displayed image, participants were asked to vote on whether they thought
it was 'relevant,' 'irrelevant,' or 'indifferent' to the query. After
the questioning, the individual results were ranked in this order:
'relevant,' 'indifferent,' and 'irrelevant.' We used Euclidean distance
to compute a ranking based on the automatically computed descriptors and
compared it to the user-generated ranking. The results of the user study
are reported in @tab:userstudy and show
that our proposed approach also outperforms competing models in
retrieval, nevertheless, with decreasing variations between models. This
can possibly be explained by the fact that it is not necessarily
relevant for a user if the alignment of individual keypoints changes as
long as the basic pose has very similar meaning. However, it may also be
that the number of subjects is too small for such conclusions, or that
the participants’ art-historical knowledge was insufficient to interpret
certain details of the poses. In this context, the degree of similarity
at which subjects consider poses to be similar is relevant. For
instance, one participant excluded crucifixion scenes in which Christ
looked to the left rather than downward with his head bowed, as in the
query image.

=== Conclusions and Future Work
<chp:conc>
In this paper, we have investigated domain adaption techniques to
estimate human poses in art-historical images. To this end, we have
suggested a two-stage approach based on two Transformer models that
utilizes a semi-supervised teacher-student design. To reduce the gap
between photographs of real-world objects and the art domain, we
augmented images depicting real-world scenes with unlabeled,
domain-specific data. Moreover, we introduced a reasonably large
art-historical data set called PoPArt to systematically test the
validity of human pose estimators. Comparisons with more common
approaches that use pre-trained models or adapt existing data sets with
style transfer indicated that performance can be further improved with
unlabeled data. While it is not necessary to annotate large amounts of
art-historical data, it is essential to include at least smaller,
domain-specific labeled data in the training procedure, rather than
relying solely on synthetically generated imagery. Depending on the test
set, models trained entirely or partially with style transfer
underperform in #gls("AP") by between $7.32$ to $28.12$ % for person detection
and between $27.33$ to $28.15$ % for keypoint prediction, even with
semi-supervised learning. Furthermore, a user study confirmed the
feasibility of the proposed approach for retrieval tasks, thus also
enabling the search for resembling poses of human figures; however, in
this case the difference with other models performance-wise is smaller.
Our method enables the engagement of humanities scholars by providing
them with state-of-the-art methods for indexing human poses in large art
image databases. Although our approach specifically targets the curation
of art and cultural objects, it is likely applicable to other domains
with few labeled training data.

In the future, we intend to analyze the potential of recently introduced
Transformer models, such as the Pyramid Vision Transformer presented by Wang et al. @abs-2106-13797. Further improvement of the
training process could be achieved by applying style transfer to
unlabeled instead of only labeled data. We also plan to extend the
PoPArt data set with additional bounding boxes, enhancing its usefulness
for training person detection models.
