#import "@preview/glossarium:0.5.3": gls, glspl 
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": outline-text

== #outline-text([The Dissimilar in the Similar. An Attribute-guided Approach to the Subject-specific Classification of Art-historical Objects],[Attribute-guided Classification of Art-historical Objects])

=== Introduction
<introduction>
The category of similarity is fundamental in all areas of art-historical
description: in the history of style, the specification of formal
characteristics determines the assignment of artistic phenomena to
stylistic attitudes; in iconography, definitions of content are
constituted by the observation of comparable—or similar—conventions of
representation. Similarity also plays a central role in art-historical
practice. When Wölfflin compares a portrait of Albrecht Dürer with one
of Frans Hals–inter alia, in the form of the categories of the "linear"
and the "painterly"—, he is assuming that the two works were painted in
different ways while belonging to the same genre @Wölfflin1915.
Decisive for the persuasiveness of this procedure is the determination
of the 'dissimilar in the similar': for only (or especially) where a
common set of phenomena exists do possible differences become visible
and plausible.

Because of the increasingly unmanageable number of art-historical
inventories made available in digital form @Mensink2014, two
questions arise. Firstly, how can the manifold concepts of similarity be
considered to relate larger amounts of objects computationally?
Secondly, are existing methods suitable for such heterogeneous
inventories and, if so, to what extent can they be adopted and
optimized? Previous studies on the automatic detection, recognition, or
identification of objects relevant to image science focus either on
small visually distinctive sub-fields, e.g., ballad prints
@Takami2014 and tinted drawings @Yarlagadda2011, or
larger non-specialised data sets, e.g., WikiArt @Hentschel2016,
that predominantly feature well-known Western artists and art periods.
They thus do only partially account for the great diversity of
historical artefacts and lack the generalizability necessary for this
domain.

In this work, we concentrate on the broader category of iconographic
similarity and propose a generic approach to the subject-specific
classification of art-historical objects that utilizes expert-based
attributes of the classification system Iconclass, i.e., figurative
motifs significant from an art-historical point-of-view. This is the
first attempt to actively exploit Iconclass in automatic classification
tasks, to the best of our knowledge. We evaluate our procedure on a
concrete use case, representations of saints in the visual arts. This
example is advantageous because it is usually possible to clearly assign
the saint and the attributes identifying him or her: the attributes are
placed in a spatially comprehensible relationship to the person, i.e.,
they are positioned close to it, even if sometimes hidden. The latter is
especially true for phases of art history in which, as in 16th-century
Mannerism, the clear legibility of a picture’s content was not the main
focus. Since many art-historical narratives, especially those of
Christian religion and classical mythology, feature sufficiently
informative attributes (or attribute-like concepts), this approach is
widely applicable.

The contributions are as follows: #emph[(i)] collection of a
representative data set of saints, #emph[(ii)] a novel approach to
attribute-guided classification that utilizes Iconclass, and
#emph[(iii)] application of a semi-supervised learning technique to
enrich the data set with neural style transfer as well as to improve the
joint training of saints and their attributes.

=== Related Work
<sec:relatedwork>
Due to the recent growth in computerized analysis of cultural heritage,
we primarily discuss studies that address the categorization of
art-historical objects.

To classify art periods such as Baroque and Symbolism, Hentschel et al.
@Hentschel2016 contrast Fisher Vectors and a Support Vector
Machine with a Convolutional Neural Network (CNN) pre-trained on
ImageNet and fine-tuned on WikiArt. Anwer et al. @Anwer2016
extend on this methodology by also utilizing information about local
regions of interest with a Deformable Part Model. In earlier and less
relevant works, Gatys et al. @Gatys2015 train a CNN to capture,
separate, and reconstruct the content of an object, and its style,
whereas Saleh and Elgammal @Saleh2015 combine low-level and
high-level features to categorize style, genre, and artist. A CNN is
trained on top of the last layer of an ImageNet-trained network to
capture additional semantic features. More recently, Bianco et al.
@Bianco2019 propose a multitask-multibranch CNN to
simultaneously classify style, genre, and artist. In contrast, Yang et
al. @Yang2018 encode complementary material to assist visual
feature learning in CNNs for style classification. Sabatelli et al.
@Sabatelli2018 investigate the general effect of fine-tuned CNNs
in artist, material, and type classification tasks.

#figure([#image("../images/saints/attr_sample.jpg", width: 100%)],
  caption: [
    Images of the attributes "baptismal cup", "book", and "lamb",
    retrieved from #emph[Google Image Search] respectively.
  ]
)
<fig:attr_example>

However, studies rarely incorporate concepts significant to iconography.
In one of the few exceptions, Gonthier et al. @Gonthier2018
propose a multiple instance learning (MIL) technique for the
weakly-supervised detection of art-historically specific objects.
However, as image-level annotations are only gathered for 7 classes, the
generalizability of the approach remains unclear, especially for
concepts with high in-class variability. In this work, we focus entirely
on a unified set of art-historically relevant classes that are of a
comparably high visual and narrative complexity: representations of
saints in the visual arts. Like Yang et al. @Yang2018, we
utilize historical context information—here expert-based attributes that
are linked to the respective class, i.e., the respective saint—to
improve the subject-specific classification of concepts with high
in-class variability.

=== Data
<data>
==== Data set collection
<sec:collection>
Our data set consists of two kinds of images: art-historical and
non-art-historical, i.e., real-world imagery.

A total of 19 publicly available inventories, collections, institutions,
and web portals are first harvested to gather depictions of saints in
the visual arts.#footnote[#link("artemis.uni-muenchen.de"),
#link("https://www.bildindex.de/"),
#link("http://ballads.bodleian.ox.ac.uk/"),
#link("https://corpusvitrearum.de/"),
#link("emblematica.library.illinois.edu"), #link("heartfield.adk.de"),
#link("https://inkunabeln.digitale-sammlungen.de/"),
#link("http://manuscripts.kb.nl/"),
#link("http://www.museen.thueringen.de/"),
#link("https://www.nga.gov/"),
#link("https://datenbank.museum-kassel.de/"),
#link("https://sammlung.belvedere.at/"), #link("http://pauart.pl/app"),
#link("https://realonline.imareal.sbg.ac.at/"),
#link("https://www.rijksmuseum.nl/en"), #link("https://rkd.nl/en/"),
#link("sammlung.staedelmuseum.de"),
#link("http://www.virtuelles-kupferstichkabinett.de/de/"), and
#link("https://vitrosearch.ch/de"), respectively (all accessed April 28,
2020).] The obtained reproductions are extremely varied and, e.g.,
include stained glass paintings of the Middle Ages, 16th-century emblems
as well as Polish folk woodcuts. Each source is at least partially
indexed by experts with the decimal classification system Iconclass that
was specially conceived for the Western motifs of the visual arts
@vandeWaal1973. It thus also contains definitions of male and
female saints, where each saint is provided with an explanatory textual
correlate including a list of possible attributes.#footnote[All other
notations are accompanied by a list of keywords, some of which can be
defined as attributes, or at least have attribute-like properties.] This
information is used to retrieve real images of the attributes from
#emph[Google Image Search], i.e., photographs taken in recent years. As
shown in @fig:attr_example, not all images include the
desired attribute in the narrow sense; e.g., a modern e-reader was found
as well as lamb meat. In so doing, we collect 21479 images of 239 saints
and 124133 images of 343 attributes for training and testing our
procedures.

#figure([#image("../images/saints/iart_preprocessing.svg", width: 100%)],
  caption: [
    Detection of bounding boxes (left) and application of style transfer
    to enrich the data set (right).
  ]
)
<fig:preprocessing>

==== Data set preprocessing
<sec:preprocessing>
Many of the previously harvested representations are scans and contain
background noise or further information, e.g., signatures of the artist
or linear color control charts of the institution responsible for the
reproduction. Two preprocessing steps are necessary to use these
representations for training a neural network. Relevant image content is
first detected using a DeepLabv3 image segmentation model trained on 100
examples from the afore-introduced saints data set
@ChenPSA17. The overlapping image regions
thus identified are then integrated into one rectangular region. If a
region has a width or height of less than 100 pixels, it is discarded.
An example prediction of the trained DeepLabv3 model is shown on the
left in @fig:preprocessing. As the images of the
saints and the images of the attributes originate from highly different
domains, we deploy neural style transfer to enrich the data set and
bridge the gap between domains
@GhiasiLKDS17.#footnote[Geirhos et al.
@GeirhosRMBWB19 also show that such techniques
increase the robustness of neural versus textural change.] Up to 5
variations of the original image are created, where we choose a random
image of a saint as a style image.

As depicted in @fig:preprocessing, not all images that
are generated in this way are recognizable. On the one hand, this is due
to the fact that style images are randomly selected and applied from all
available saints images. On the other hand, the segmentation introduces
errors; therefore, images are selected for style transfer that do not
show any saint. On the basis of these steps, the number of images
containing (representations of) saints increases to 25667; the
subsequent style transfer further increases the number to 120626. The
number of images depicting attributes increases to 403788.

#figure([#image("../images/saints/iart_saints_2.jpg", width: 100%)],
  caption: [
    Four representations of Saint John the Baptist with the exemplary
    selected attribute "lamb".
  ]
)
<fig:saints_with_attr>

=== Attribute-guided Classification
<attribute>
The idea behind our approach is as follows: generally, a saint cannot be
identified exclusively by his or her physiognomy, but by a set of
pictorial signs, #emph[attributes], that exemplify a special event in
his life or take up characteristics of her status or profession. A
distinction must be made between attributes characterizing a (larger)
group of saints and attributes that are narratively significant for a
particular saint. While, e.g., the staff serves as a general sign of
holy abbots, John the Baptist is often accompanied by a lamb to recall
the acclamation in which he refers to Christ as the "Lamb of God"
(@fig:saints_with_attr). Since most attributes act as
binding signifiers, they are often featured prominently in the fore- or
background of an image and can thus support the computer-aided
classification of saints. We assume that the joint appearance of even
relatively trivial appearing or art-historically unspecific attributes,
whose artistic depiction has hardly changed over time, is sufficient for
this purpose.#footnote[This is in stark contrast to Gonthier et al., who
state that "more specific objects or attributes such as ruins or nudity"
are needed to detect @Gonthier2018.]

#figure([#image("../images/saints/iart_semi_4.svg", width: 100%)],
  caption: [
    Visualization of the semi-supervised learning technique. During each
    iteration, the system predicts a probability distribution for
    attributes (#emph[blue]) and saints (#emph[red]) that is used to
    generate pseudo-labels. These labels are then used as optimization
    targets for the same image with a different augmentation strategy.
  ]
)
<fig:semi_supervised>

Two problems arise. On the one hand, a saint can be identified by more
than one attribute; however, not #emph[all] attributes need to be
present in the image of a saint. On the other hand, the images found via
#emph[Google Image Search] do not always show the desired attribute, or
solely modernized versions of it, as already illustrated in
@sec:collection. We thus propose a
semi-supervised learning technique based on FixMatch
@abs-2001-07685. The original objective of
FixMatch is to use unlabeled data for training an image classifier. In
doing so, unlabeled images for which the model predicts a high
probability are automatically assigned to a concept and used for the
training process. In our case, we use this technique to automatically
annotate attributes in images of saints that were #emph[not] originally
annotated.

The training process for a batch is shown in @fig:semi_supervised. During each iteration, the model
forwards two batches of labeled images, $B_(l comma s)$ for saints and
$B_(l comma a)$ for attributes, as well as two batches of unlabeled
images, $B_(u comma s)$ for saints and $B_(u comma a)$ for attributes.
It then determines the probability for the concept saints, $p_s$, and
for the concept attributes, $p_a$, independently for each input image of
the batch. The supervised loss $L_l$—applied to $B_(l comma s)$ and
$B_(l comma a)$, respectively—results from the cross-entropy
$H lr((dot.op))$ between the encoded label $hat(y_i)$ and the prediction
$p_(i comma i)$ for an input $x_(i comma b)$:

$ 
L_l & eq sum_(i in lr({s comma a})) 1 / B_(l comma i) sum_(b eq 1)^(B_(l comma i)) H lr((hat(y)_(i comma b) comma p_(i comma i) lr((y divides alpha lr((x_(i comma b))))))) 
$

For unlabeled data, we first compute the model’s predicted class
distribution for a #emph[weakly]-augmented $alpha$-version of the sample
$x_(i comma b)$ in each subset $B_(u comma s)$ and $B_(u comma a)$. To
create an artificial label, we assign a value of one for each prediction
of a concept that is greater than a threshold $tau$; all other concepts
are set to zero:

$ 
hat(q)_(i comma j comma b) = cases(
  1 quad upright("if ") p_(i comma j) lr((y divides alpha lr((x_(i comma b))))) gt.eq tau,
  0 quad upright("if ") p_(i comma j) lr((y divides alpha lr((x_(i comma b))))) lt tau 
) 
$

The unsupervised loss $L_u$ results from the #emph[strongly]-augmented
version $A$ of the image $x_(i comma b)$ and the pseudo-label
$hat(q)_(i comma j comma b)$, as long as there is at least one
prediction above the threshold $tau$:

// TODO
$ 
f_(i,j,b)&= bb(1) (max (p_(i , j) (y divides alpha (x_(i , b)))) gt.eq tau) \
L_u &= sum_(j in {s , a}) sum_(i in { s , a }) 1 / B_(u , i) sum_(b = 1)^(B_(u , i)) f_(i,j,b) dot H (hat(q)_(i , j , b) , p_(i , j) (y divides A (x_(i , b)))) 
$

The final loss $L$ is simply the sum $L eq L_l plus L_u$. Since all
images that contain neither a saint nor an attribute have a low
probability of showing any relevant concept, they are automatically
excluded during training. This procedure offers two advantages. When an
attribute is recognized in the image of a saint, it is automatically
annotated; in this way, there is feedback from attributes in images that
were #emph[not] originally annotated. Second, images that are not
recognizable by the model after style transfer are excluded from
training.

=== Experiments
<experiments>
We employ a ResNet-50 architecture pre-trained on ImageNet
@HeZRS16. The optimization is carried out using
#gls("SGD") with Nesterov momentum of 0.9
@SutskeverMDH13. The initial learning rate is set
to 0.01. The data set is split into training, validation, and test with
a splitting ratio of 3:1:1. We evaluate the model with the highest
accuracy on the validation set on the test set, respectively. #gls("mAP", long: true) is used to measure the retrieval performance of
our system for the entire test set.

#figure(
  grid(
    columns: 2,
    column-gutter: 2em,
    table(
      columns: 4,
      align: (col, row) => (left,right,left,right,).at(col),
      inset: 6pt,
      toprule(),
      [Attribute], [AP], [Attribute], [AP],
      midrule(),
      [peacock feather],
      [0.871],
      [tablet],
      [0.859],
      [scissors],
      [0.870],
      [hackle],
      [0.845],
      [monstrance],
      [0.867],
      [tiara],
      [0.844],
      [staircase],
      [0.866],
      [broom],
      [0.840],
      [clog],
      [0.865],
      [wreath],
      [0.837],
      bottomrule(),
    ),
    table(
      columns: 4,
      align: (col, row) => (left,right,left,right,).at(col),
      inset: 6pt,
      toprule(),
      [Attribute], [AP], [Attribute], [AP],
      midrule(),
      [ducal hat],
      [0.030],
      [cope],
      [0.016],
      [net],
      [0.026],
      [stake],
      [0.015],
      [Spes],
      [0.026],
      [Turk],
      [0.014],
      [head],
      [0.019],
      [three],
      [0.011],
      [mitre],
      [0.017],
      [two],
      [0.007],
      bottomrule(),
    )
  ),
  caption: figure.caption([ 
    Best and worst classification results based on the data
    set with 343 attributes retrieved from #emph[Google Image Search].
    #gls("AP") is used to measure the retrieval performance.
  ],
  position:top)
) <tab:attribute_results>

#align(center, [Best and worst classification results based on the data
set with 343 attributes retrieved from #emph[Google Image Search].
Average Precision (AP) is used to measure the retrieval performance.])
 
==== Attribute classification
<attribute-classification>
We first evaluate whether the attributes data set is generally suitable
for the prediction of saints. The model achieves a performance of 0.354
mAP. As shown in @tab:attribute_results, attributes
that are difficult to define ("three") or cannot be found by
#emph[Google Image Search] ("mitre") lead to poor classification
performance, whereas objects still common in modern everyday life
("scissors") naturally show more promising results.

#figure(
  table(
    columns: 7,
    align: (col, row) => (left,right,right,right,right,right,right,).at(col),
    inset: 6pt,
    toprule(),
    [Method], [$B_(l comma s)$], [$B_(u comma s)$], [$B_(l comma a)$],
    midrule(),
    [$B_(u comma a)$], [mAP], [Accuracy],
    [Random],
    [],
    [],
    [],
    [],
    [0.021],
    [0.054],
    cmidrule(),
    [Saints (without Style Transfer)],
    [16],
    [0],
    [0],
    [0],
    [0.131],
    [0.250],
    [Saints (with Style Transfer)],
    [16],
    [0],
    [0],
    [0],
    [0.118],
    [0.246],
    [Saints and Attributes (without Style Transfer)],
    [8],
    [0],
    [8],
    [0],
    [0.120],
    [0.241],
    [Saints and Attributes (with Style Transfer)],
    [8],
    [0],
    [8],
    [0],
    [0.128],
    [0.252],
    cmidrule(),
    [FixMatch ($tau eq 0.4$)],
    [8],
    [8],
    [8],
    [8],
    [0.093],
    [0.210],
    [FixMatch ($tau eq 0.5$)],
    [8],
    [8],
    [8],
    [8],
    [#strong[0.136]],
    [#strong[0.260]],
    [FixMatch ($tau eq 0.6$)],
    [8],
    [8],
    [8],
    [8],
    [0.134],
    [0.245],
    bottomrule(),
  ),
  caption: figure.caption([ 
Scores of the classification methods based on the data
  set with 49 saints. $B_(l comma s)$ and $B_(l comma a)$ denote the batch
  sizes of labeled images for saints and attributes, respectively,
  $B_(u comma s)$ and $B_(u comma a)$ the batch sizes of unlabeled images
  for saints and attributes, respectively. The best performing approach is
  bold.
  ],
  position:top)
 )
  <tab:saints_result>

==== Joint training of saints and attributes
<joint-training-of-saints-and-attributes>
Our approach to jointly train saints and attributes is compared to two
baseline strategies, with and without style transfer, respectively.
Thus, both saints classifiers do not use explicitly defined visual
attributes during training. Random horizontal flip is used as
augmentation step. In addition, we use #emph[RandAugment] for the
FixMatch approach, which applies a random transformation with a defined
strength from a fixed set @abs-1909-13719. We
moreover use style-transferred images from the saints and attributes
data set, respectively, as unlabeled input for FixMatch. The performance
of the procedure is reported for the 49 saints with the most images, and
only for images after the bounding box detection (see
@sec:preprocessing>). As shown in
@tab:saints_result, the proposed system performs best,
$ gls("mAP") eq 0.136$, when a threshold of $tau eq 0.5$ is chosen.
If the threshold is set too high, not enough images are selected for
training or not all concepts in an image are selected. If the threshold
is set too low, however, too many concepts are selected. We chose 0.5 as
a starting point because it is commonly used to generate binary
decisions after a sigmoid activation.

A closer look at the results shows that saints are more accurately
classified if their depictions are limited to few narratives, or a
certain stage of life is primarily illustrated, e.g., in the case of
Jerome ($ gls("AP") eq 0.432$), even if differing materials or
techniques are used. If, on the other hand, a saint can be represented
in many strongly varying ways that are not related to any specific
constellation of attributes, such as Bernard ($ gls("AP") eq 0.036$),
classification results drop immensely. This is especially true for
saints, like Helena ($ gls("AP") eq 0.020$), for whom there are few
examples or many visually distinctive ones, e.g., engravings, stained
glass paintings, or early preparatory drawings. These findings
illustrate that the enormous complexity of the domain, in which an
object can be depicted in various ways, is often only insufficiently
manageable—even with common augmentation techniques and fine-tuned
networks. The underlying phenomenon, referred to as the "cross-depiction
problem" @Westlake2016, might possibly be weakened by more
sophisticated domain adaptation techniques @Thomas2018.
Moreover, to mitigate the dependency on non-art-historical imagery and
further improve classification, the harvested collections could be
exploited more extensively, since many attributes are listed in
Iconclass as separate notations.

=== Conclusion <sec:saints_conclusion>
In this work, we introduced a new data set and task for the
identification of saints in the visual arts. We suggested a novel
deep-learning approach that utilizes expert-based attributes to support
the subject-specific classification especially of concepts with high
in-class variability. The proposed semi-supervised joint training
technique increases the performance compared to multiple baselines. In
the future, we will apply this procedure to the classification of other
art-historically relevant narratives and motifs that can possibly also
be improved by the use of visual attributes. To further improve the
discrimination of saints (or other individuals relevant to art history),
we plan to explore different loss functions, e.g., contrastive or
triplet loss, as they are successfully used in face recognition tasks.
