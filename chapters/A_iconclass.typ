#import "@preview/glossarium:0.5.3": gls, glspl, gls-short
#import "@preview/zero:0.7.0": num, format-table, zi, set-round
#import "/helper/outline_text.typ": flex-heading, flex-figure

// <supplementary-material>
// This supplementary material further specifies the data sets used in the
// experiments (@chp:appendix:iconclass:data-sets), the network architecture and
// parameters (@chp:appendix:iconclass:network-parameters>), the performance of the
// pre-training with a smaller batch
// size~(@chp:appendix:iconclass:experimental-smaller-batch>), the performance of
// the hierarchical classification approaches
// (@chp:appendix:iconclass:experimental-results-hierarchy>), and details on the
// conducted qualitative
// analysis~(@chp:experimental-qualitative>).

== Iconclass Data Sets
<chp:appendix:iconclass:data-sets>
This section supplements the two data sets used in the experiments as
discussed in @chp:data-sets of the paper: (i)~#gls("ICAI")~@iconclass-ai-test-set. The majority of the #num[362561]
annotations have a depth of five, six, or seven levels, with #num[109701],
#num[93195], and #num[78244] images, respectively. In particular, concepts with high
granularity are rare; from level 10 onwards, only 1394 image examples
are included. (ii)~#gls("ICARUS"). Among the #num[19] publicly available
collections extracted by web-scraping, nine are from Germany (Artemis,
Bildindex der Kunst & Architektur, Corpus Vitrearum, Heartfield Online,
Hessen Kassel Heritage, Incunabulum Catalogue of the Bavarian State
Library, Museen Thüringen, Städel Museum, Virtuelles
Kupferstichkabinett),#footnote[#link("https://artemis.uni-muenchen.de/"),
#link("https://www.bildindex.de/"),
#link("https://corpusvitrearum.de/"),
#link("http://heartfield.adk.de/"),
#link("https://datenbank.museum-kassel.de/"),
#link("https://inkunabeln.digitale-sammlungen.de/"),
#link("http://www.museen.thueringen.de/"),
#link("https://sammlung.staedelmuseum.de/"),
#link("http://www.virtuelles-kupferstichkabinett.de/") (all last
accessed on 2026-10-07).] two from Austria (Belvedere,
REALonline),#footnote[#link("https://sammlung.belvedere.at/"),
#link("https://realonline.imareal.sbg.ac.at/") (all last accessed on
2026-10-07).] one from Switzerland
(Vitrosearch),#footnote[#link("https://vitrosearch.ch/") (last accessed
on 2026-10-07).] one from Poland (PAUart -- Polish Academy of Arts and
Sciences)#footnote[#link("http://pauart.pl/app") (last accessed on
2026-10-07).], three from the Netherlands (Medieval Illuminated
Manuscripts, Rijksmuseum, RKD -- Netherlands Institute for Art
History),#footnote[#link("http://manuscripts.kb.nl/"),
#link("https://www.rijksmuseum.nl/"), #link("https://rkd.nl/") (all last
accessed on 2026-10-07).] one from the United Kingdom (Broadside Ballads
Online),#footnote[#link("http://ballads.bodleian.ox.ac.uk/") (last
accessed on 2026-10-07).] and two from the United States (Emblematica
Online, National Gallery of
Art).#footnote[#link("http://emblematica.library.illinois.edu/"),
#link("https://www.nga.gov/") (all last accessed on 2026-10-07).] Again,
most of the #num[1328417] annotations have a depth of five, six, or seven
levels, with #num[480708], #num[410854] and #num[301731] images, respectively. However,
the number of annotations with a depth of more than #num[10] levels is
proportionally larger; here it is #num[9543] images.

Annotations from both #gls("ICAI")~@iconclass-ai-test-set and #gls("ICARUS") have been
unified: (i)~We remove 'keys' because many of them are redundant. This
is partly because they are declared in lists and apply to a fixed range
of concepts, often just repeating aspects of the corresponding 'keyless'
concept rather than differentiating it further (e.g., as in the
Iconclass concept $C =$ `11D(+12)` with description $T_C =$ "Christ (+
Christ)"). (ii)~We transfer Iconclass concepts with non-standardized
'bracketed text' to the next higher level of granularity in the
taxonomy; automatic standardization is usually not readily feasible. As
'non-standardized' we consider named entities that are not regularly
included in the Iconclass taxonomy, but can be added by the respective
institutions. We refer to the notation scheme in @fig:iconclass:clip_model:a to illustrate
the respective auxiliary components.

Many of the obtained images are scans containing extraneous noise or
supplemental information, e.g., artist's signatures or linear color
control charts; moreover, they may feature multiple artworks. To
normalize the data sets, we introduce a two-stage pre-processing
pipeline: (i)~The relevant image content is first detected using a
DeepLabv3 image segmentation
model~#cite(label("ChenPSA17")) with a ResNet-101
backbone~#cite(label("HeZRS16")). For training, we
annotated a small data set consisting of 101 images. (ii)~The identified
segments are then incorporated into a single rectangular segment by
employing a 2D packaging algorithm~@jylanki2010thousand. This is
necessary because Iconclass concepts were assigned for the entire image
and cannot be attributed to individual segments. An exemplary result of
this procedure is illustrated in @fig:appendix:iconclass:examples-gt.

#flex-figure(
  image("/images/iconclass/image_preprocessing_exp_1_s.pdf"),
  [Exemplary result of the two-stage pre-processing pipeline to normalize data sets.],
  [Pre-processing for the #gls-short("ICARUS") data set],
  label:<fig:appendix:iconclass:examples-gt>
)

To exclude very similar images, we perform a near duplicate check on our
proposed #gls("ICARUS") data set. We use a ResNet-50
model~#cite(label("HeZRS16")) trained on the ImageNet-1K
data set~#cite(label("RussakovskyDSKS15")) to extract
features for each image and compute the root mean square distance of the
embeddings between all image pairs. After that, image pairs with a value
below $0.5$ were detected as duplicates; we kept one of the images and
merged the annotations. Nevertheless, there are very similar images, as
can be seen in @fig:iconclass:samples:a of the thesis, either because different artists
reproduced the same subject or because preliminary drawings, sketches,
and copies of the respective image exist.

== Implementation Details
<chp:appendix:iconclass:network-parameters>
In addition to the parameters given in @chp:network-parameters, to stabilize the
training process, we use a linear ramp-up of the learning rate starting
at 500 iterations and reduce it to zero at #num[40000] iterations.
Furthermore, we use a weight decay of $0.1$ and prune the norm of all
gradients to $0.5$. For the `CAT` classification model~(Section~3.4.5),
the transformer decoder uses feature size~$d_(m o d e l) = 768$ and a
feed forward dimension of $d_(f f) = 2048$\; the same configuration is
employed by the vision transformer. Unless otherwise specified, we
optimize our models on four GPUs with 24GB RAM each.

During the training process, we use the following image augmentation
techniques: (i)~images are padded to a square shape; (ii)~random
horizontal flip is applied;
(iii)~RandAugment~@CubukZS020 is applied
with 2 operations and a size of 9; (iv)~a $224 times 224$ random section
of each image is extracted that contains at least 70~% of the image. For
testing, we padded the images and resized them to a dimension of
$224 times 224$.

== Contrastive Pre-training with Image-Text Pairs with Smaller Batch Size
<chp:appendix:iconclass:experimental-smaller-batch>

#flex-figure(
  table(
    columns: 5,
    align: (left,right,right,right,right,),
    [Strategy], table.cell(align: center, colspan: 4)[\# of Training
    Images per Iconclass Concept],
    [], [$> 0$], [$> 10$], [$> 100$], [$> 1000$],
    [`KW`], [0.0476], [0.0573], [0.1155], [0.2796],
    [`BLIP`], [0.0460], [0.0554], [0.1106], [0.2700],
    [`GPT`], [#strong[0.0560]], [#strong[0.0673]], [#strong[0.1314]], [#strong[0.3026]],
    [`LAION-400M`], [0.0426], [0.0514], [0.1049], [0.2670],
  ), 
  [Results of contrastive pre-training with image-text pairs
  on different text generation strategies on the ICARUS test set using
  the `CAT` classifier with a batch size of $32$. The results show the
  mAP for all concepts that have at least one image in the test set. The
  best-performing strategy per batch size is denoted in bold. ], 
  [Iconclass contrastive pre-training with a batch size of 32],
  label:<tab:appendix:iconclass:pre-training>
  )


In addition to the batch size of $256$ used in the other experiments, we
also wanted to evaluate how the methods behave with a smaller batch
size. To do this, we repeat the experiment from Section 5.3 with a batch
size of $32$. The results are shown in @tab:appendix:iconclass:pre-training.
While the descriptions generated by `GPT` perform best for a batch size
of~$32$, the `BLIP` approach benefits from a larger batch size of~$256$
and provides the best overall results. A possible reason could be that
the textual descriptions extracted with `BLIP` have less variance
compared to `GPT`. As a result, the variance of negative prompts, which
are important for training #emph[CLIP] as mentioned in several works
(e.g., @abs-2212-00794), may be too
low using a small batch size.

== Iconographic Concept Classification on Different Levels of Granularity
<chp:appendix:iconclass:experimental-results-hierarchy>
In these experiments, we compare our classification approaches presented
in Section 3.4 with respect to the level of granularity in the Iconclass
hierarchy. To do this, we average the mAP at each level on the #gls("ICARUS")
test data set, as shown in @fig:appendix:iconclass:ap_per_level.

#flex-figure(
  image("/images/iconclass/icarus_test_ap_fine_0.pdf"),
  [Results of the individual classification approaches on the #gls("ICARUS")
    test set. The results show the mAP for all concepts at each level of
    granularity in the taxonomy.],
  [#gls-short("ICARUS") classification results by granularity level],
  label:<fig:appendix:iconclass:ap_per_level>
)


As expected, performance drops considerably with higher levels of
granularity, as the number of Iconclass concepts increases, while the
number of training images per concept decreases. Interestingly,
performance improves at levels eight and nine, especially for `Flat-H`
and `CAT`. There are two reasons for this: firstly, the number of
Iconclass concepts in these stages decreases again, and secondly, both
models optimize only those concepts that have a valid parent during
training, thus reducing class imbalance. The higher performance of
`Flat-H` compared to `CAT` might indicate that `CAT` can be enhanced
with more iterations ($p = 30$), as the classifier might rarely reach
the highest level of granularity.

== Qualitative Evaluation
<chp:experimental-qualitative>
To qualitatively assess the `CAT` model's ability to make reasonable
predictions, we recruited a total of four subjects. These included three
art historians and one computer scientist proficient in relevant
art-historical concepts. For the evaluation, we identified a set of $24$
Iconclass concepts and filtered the top-10 classification results.
Specifically, we selected four concepts each from six divisions within
#emph[Iconclass], with the selected concepts within each division
varying in their level of granularity. In selecting the concepts, care
was taken to include as wide a range of art-historically significant
narratives as possible, incorporating not only biblical themes, but also
extending to narratives originating from, e.g., Greek mythology. For
each concept, participants were asked to vote on whether they thought it
was 'relevant' or 'irrelevant' to the concept in question, and to
provide a brief comment to explain their assessment.
