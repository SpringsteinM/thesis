#import "@preview/glossarium:0.4.0": gls, glspl 
#import "@preview/subpar:0.1.0"
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule


= Visual Narratives: Large-scale Hierarchical Classification of Art-historical Images

== Abstract

Iconography refers to the methodical study and interpretation of thematic content in the visual arts, distinguishing it, e.g., from purely formal or aesthetic considerations.
In iconographic studies, #gls("Iconclass") is a widely used taxonomy that encapsulates historical, biblical, and literary themes, among others.
However, given the hierarchical nature and inherent complexity of such a taxonomy, 
it is highly desirable to use 
automated methods for (#gls("Iconclass")-based) image classification.
Previous studies  
either focused narrowly on certain subsets of narratives or failed to exploit #glspl("Iconclass") hierarchical structure.
In this paper, we propose a novel approach for 
#gls("HMC") of iconographic concepts in images.
We present three strategies, including #glspl("LM"), for the generation of textual image descriptions using keywords extracted from #gls("Iconclass").
These descriptions are utilized to pre-train a #gls("VLM") based on a newly introduced data set of 477,569 images with more than 20,000 #gls("Iconclass") concepts, far more than considered in previous studies. Furthermore, we present five approaches to multi-label classification, including a novel transformer decoder that leverages hierarchical information from the #gls("Iconclass") taxonomy.
Experimental results show the superiority of this approach over reasonable baselines.

== Introduction
<chp:introduction>
Iconography, as established by Panofsky~@panofsky1939, entails
the systematic analysis of content or meaning in visual art,
distinguishing these elements from mere formal characteristics. For this
purpose, #gls("Iconclass"), short for #emph[], provides a widely used taxonomy
for annotating visual
content @vandewaal1973 @vanstraten1994.#footnote[#link("https://iconclass.org/")
(last accessed on 2024-05-20).] In particular, the system makes it
possible to convey semantically complex narratives, which are found
especially in historical, biblical, and literary themes; see
@fig:example-iconclass for an example.

#figure(
  image("../images/iconclass/hans_holbein-abendmahl-1501.png", width: 100%),
  caption: [
    Utilizing #gls("Iconclass"), Hans Holbein the Elder’s #emph[Last Supper]
    (1501) could be labeled with the notations `73D24` ("Last Supper
    \[…\]") and `41C3` ("laid table \[…\]").
  ]
)
<fig:example-iconclass>


Corpora labeled with #gls("Iconclass") are essential for text-based retrieval of
artworks with certain narratives~@brandhorst2017: they provide a
foundation for the digital exploitation of the collections. However,
despite obvious advantages, GLAM—known as the GLAM institutions—only
sporadically utilize #gls("Iconclass"). This is due, on the one hand, to limited
resources for (human) annotation, and on the other hand to the inherent
complexity of the system. It is therefore highly desirable to develop an
efficient indexing process via automated image classification methods.

To date, related work on visual art objects primarily considered
classification tasks of image-related metadata features, such as the
identification of artists, genres, or creation
dates~@rijksmuseum-challenge @art500k @omniart @multitaskpainting100k @artpedia @the-met @artbench-10 @CondeT21.
While these tasks are important, they do not take into account the
classification of semantic concepts represented in artworks. Previous
studies often focused narrowly on particular subsets of
narratives~@artdl @schneider2020. Furthermore, attempts to
comprehensively map the entire #gls("Iconclass") system failed to leverage its
hierarchical structure: Banar et al.~@banar2021 investigated the
feasibility of ascribing #gls("Iconclass") notations through cross-modal
retrieval, while Cetinic~@cetinic2021 created image-text pairs
that were used in an image captioning task. In addition, #glspl("VLM") have not
yet been exploited for the classification of iconographic concepts,
although they achieve impressive performance in many downstream
applications, including the classification of metadata in art-historical
images, e.g., the country of origin~@CondeT21.

In this paper, we propose a novel approach to extensively classify
hierarchical iconographic concepts in order to mitigate, or at least
minimize, the need for manual annotation. Our contributions can be
summarized as follows: (i)~We propose three strategies that use, for
example, #glspl("LM")~@radford2019language and
#glspl("VLM")~@abs-2301-12597 @abs-2305-06500
to automatically create image descriptions using keywords provided by
#gls("Iconclass"); (ii)~We apply contrastive pre-training with synthetic
image-text pairs and show an improved performance for rare concepts;
(iii)~We present five multi-label classification approaches, including a
novel transformer decoder that leverages hierarchical information from
the #gls("Iconclass") taxonomy and, to the best of our knowledge, is the first
decoder that can handle multi-label classification; (iv)~Compared to
previous studies~@schneider2020 @banar2021 @cetinic2021, we
expand the scope of classifiable iconographic concepts by introducing a
new data set of 477569 images with more than 20000 unique #gls("Iconclass")
concepts. The source code, models, and data set will be made publicly
available.#footnote[#link("https://github.com/TIBHannover/iconclass-classification")
(last accessed on 2024-05-20).]

The remainder of the paper is structured as follows. In @chp:iconclass:related-work, we review related work. @chp:method describes our proposed transformer model for #gls("HMC") of art-historical concepts, which uses contrastive pre-training with
synthesized image-text pairs. @chp:data-sets
introduces a novel data set, while
@chp:experimental-setup presents experimental results
for several benchmarks. We conclude with @chp:conclusion and outline areas for future work.

== Related Work
<chp:iconclass:related-work>
The rapidly advancing field of #gls("CV"), fueled by sophisticated deep learning
models, is facilitating the in-depth analysis of complex data; a task
that, until recently, could only be performed by human experts. The
implications of this development are particularly significant when
applied to the field of visual art—which frequently encompasses
representations and abstract concepts that differ considerably from
real-world data. This section reviews related work in #gls("CV") for the visual
arts, as well as #gls("HMC"), which is crucial for leveraging the hierarchical
structure of the #gls("Iconclass") taxonomy.

=== CV for the Visual Arts:
<cv-for-the-visual-arts>
Research in #gls("CV") for the visual arts focuses on several key areas
including, but not limited to, aesthetic quality
assessment~@jenaesthetics, human pose
estimation~@impett2016 @springstein2022 @madhu2023,
sentiment analysis~@mart @wikiart-emotions, correspondence
matching~@brueghel @jenicek2019, and visual question
answering~@aqua. To date, however, research efforts have largely
been devoted to classification tasks of image-extrinsic features, such
as the identification of artists, genres, or creation
dates~@rijksmuseum-challenge @art500k @omniart @multitaskpainting100k @artpedia @the-met @artbench-10 @CondeT21.
While these tasks are significant, they only address tangible aspects of
the domain, leaving, e.g., content-based features relatively unexplored.
Indeed, the classification of intrinsic features, particularly those
related to iconographic elements, has been inadequately attended to:
prevailing studies have often focused narrowly on certain subsets of
narratives, such as the prediction of
saints~@artdl @schneider2020. A deviation from this tendency
is illustrated by Gupta et al.~@gupta2020, who applied image
captioning models based on an encoder-decoder architecture to
art-historical images spanning across nine iconographies. Moreover,
there have been attempts to comprehensively map the entire #gls("Iconclass")
system. Banar et al.~@banar2021 conducted an exploratory
investigation into the feasibility of ascribing #gls("Iconclass") notations,
with up to five levels of depth, through cross-modal retrieval.
Cetinic~@cetinic2021 transformed #glspl("Iconclass") textual correlates
into descriptions to create image-text pairs to fine-tune a transformer
model, morphing the classification into an image captioning task.
Compared to these works, we not only scale our approach to the entire
#emph[#gls("Iconclass")] system of over 20000 art-historical concepts, but fully
exploit its hierarchical structure.

=== #gls("HMC", long: true):
<hmc>
Approaches to #gls("HMC") can exploit the hierarchical structure of taxonomies
such as #gls("Iconclass"). They have been used for many tasks, e.g., event
classification~@Muller-BudackSH21 and geolocation
estimation~@abs-2303-04249 involving
real-world data like text~@huang2019 and
image~@ChenWLQ22. Hierarchical information
provides the opportunity to generate a chain of coarse-to-fine labels
describing an
object~@ChangPZMS021 @abs-2303-04249
or to unify data sets into a common annotation
scheme~@RedmonF17. Prior work on image
classification leverages hierarchical dependencies in several ways:
(i)~some work maps the hierarchical relationship between individual
classes in the #emph[embedding
space]~@ZhangXXR22 @GarnotL21 @AkataRWLS15 @BengioWG10;
(ii)~#emph[hierarchical loss functions] have been presented to take into
account the hierarchical information from the ontology during
optimization~@GiunchigliaL20 @Muller-BudackSH21 @ZhaoLX11 @BertinettoMTSL20 @DengBLF10 @GiunchigliaL20;
(iii)~#emph[hierarchical architectures] design the architecture of the
model so that it can solve a particular hierarchical
ontology~@YanZPJDDY15 @abs-1709-09890 @TaoufiqNB20.
Most of the papers investigate problems where each image has only one
annotation~@Muller-BudackSH21 @ChenWLQ22
or use structures that are difficult to transfer from several thousand
of classes~@GiunchigliaL20. Our proposed approach
scales to several thousand concepts and is suitable for multiple
annotations per sample.

== Hierarchical Multi-label Classification of Iconographic Concepts
<chp:method>
In this section, we introduce our approach to the #gls("HMC") of iconographic
concepts in images. First, we describe the #gls("Iconclass") notation scheme,
which provides a taxonomy of iconographic
concepts~(@chp:method-notation-scheme). In
@chp:method-contrastice-pre-training, we suggest
three approaches to synthesize textual descriptions based on keywords
for #gls("Iconclass") concepts that are used to pre-train #glspl("VLM") according to
@chp:method-constrastive-pretraining. Finally, we
use the image encoder of a pre-trained #gls("VLM") along with several approaches
for #gls("HMC"), including a novel transformer-based classification decoder that
incorporates structured information from the #gls("Iconclass")
taxonomy~(@chp:method-hierarchical-classification).

=== #gls("Iconclass") Notation Scheme
<chp:method-notation-scheme>
While #gls("Iconclass") is explicitly designed for the iconography of Western
fine art, it also encompasses universal definitions ranging from natural
phenomena to socio-economic aspects~@vanstraten1994. As shown in
@fig:clip_model_a, each definition
within the taxonomy is represented by a unique combination of
alphanumeric characters, referred to as the 'notation,' hereafter
denoted as #gls("Iconclass") concept~$C$, and an explanatory 'textual
correlate'~$T_C$, accompanied by a corresponding set of
keywords~$bb(K)_C$. A notation comprises at least one digit symbolizing
the first level of hierarchy or 'division.' This can be followed by
another digit at the secondary level, and one or two (identical) capital
letters at the tertiary level. This structure, referred to as the 'basic
notation,' can be further supplemented with auxiliary
components~@vandewaal1973 @vanstraten1994. Notations may be
linked using a colon to establish a relationship between two or more
notations, as in `79C52:42E3`.

#subpar.grid(
  columns: 2,
  column-gutter: 0em,
  figure(
    image("../images/iconclass/iconclass_clip_v6-1.svg", height:3.1cm),
    caption:[]
  ), <fig:clip_model_a>,
  figure(
    image("../images/iconclass/iconclass_clip_v6-2.svg", height:3.1cm),  
    caption:[]
  ), <fig:clip_model_b>,
  caption: [
    The proposed approach for #gls("VLM") pre-training based on images labeled according to the #gls("Iconclass") notation scheme: 
    (a)~Based on the keywords~$bb(K)_C$ from each annotated #gls("Iconclass") concept~$C in bb(C)$ of an image~$I$, three strategies are used~(`KW`, `GPT`, `BLIP`) to create image descriptions~(@chp:method-contrastice-pre-training); 
    (b)~They are used for contrastive pre-training of #emph("CLIP")~@RadfordKHRGASAM21~(@chp:method-constrastive-pretraining).
    ],
  label: <fig:clip_model>,
)


=== Image-Text Pairs for Contrastive Pre-Training
<chp:method-contrastice-pre-training>
Several recent methods have shown that #glspl("VLM") pre-trained with image-text
pairs from other domain-relevant~@CondeT21 @LiXWZ0Z0JC22
or large-scale data sets in general~@RadfordKHRGASAM21 @abs-2212-00794
can significantly improve the performance of many downstream
applications. As shown in @fig:clip_model_b, it is necessary
to provide textual descriptions for the corresponding images in order to
optimize a #gls("VLM") with contrastive
pre-training~(@chp:method-constrastive-pretraining).
However, these descriptions can be difficult to obtain, and in our case
they are only available for the #gls("Iconclass")
concepts~(@chp:method-notation-scheme) represented
in an image, but not for the image itself.

Similar to Conde and Turgutlu~@CondeT21, our goal
is to create a textual description~$D$ for an image~$I$ that has been
labeled with $k$~#gls("Iconclass")
concepts~$bb(C) eq brace.l C_1 comma C_2 comma dots.h comma C_k brace.r$.
For this purpose, we leverage the associated keywords~$bb(K)_C$ of each
#gls("Iconclass") concept~$C in bb(C)$. However, unlike the data set used by
Conde and Turgutlu~@CondeT21, these keywords do
not contain a subdivision into categories such as origin, material, or
dimension. Thus, we cannot use a generic free-form to create textual
descriptions. Instead, we consider the following three approaches to
generating pairs of images and textual descriptions for
language-supervised pre-training of #glspl("VLM"); examples are shown in
@fig:clip_model_a.

==== Descriptions based on #gls("Iconclass") Keywords (`KW`)
<descriptions-based-on-iconclass-keywords-kw>
In this baseline strategy, a textual description~$D$ is created by
comma-separating all unique keywords~$bb(K)_C$ from each annotated
#gls("Iconclass") concept~$C in bb(C)$ of an image~$I$. However,
comma-separating keywords leads (i)~to a loss of information when
projected into a textual description space, and (ii)~to
redundancies~(e.g., #emph[stained glass], #emph[glass]) that should be
avoided given #emph[CLIP’s] limited textual context length. Furthermore,
the resulting descriptions are different from those typically used to
train CLIP~(e.g.,LAION-400M~@abs-2111-02114), which may increase the optimization time.

==== Descriptions based on Large Language Models (`GPT`)
<descriptions-based-on-large-language-models-gpt>
To address the issues with the aforementioned `KW`~approach, we use a #gls("LM")
to generate descriptions based on a set of keywords provided by
#gls("Iconclass"). The intention behind this idea is that #glspl("LM") can generate
shorter and more natural image descriptions compared to simply chaining
keywords together. To this end, we first fine-tune a GPT-2
model~@radford2019language for the task of image captioning,
using a set of keywords as input. To train such a model, we extract
named entities as keywords from ground-truth image captions provided by
#emph[MS COCO]~@LinMBHPRDZ14 using
#emph[Wikifier]~@brank2017annotating. The goal of the #gls("LM") is to
reproduce the ground-truth caption from #emph[MS COCO] using this set of
named entities as input. During inference, we use the trained model to
generate captions that serve as textual description~$D$ for an image~$I$
based on a set of keywords~$bb(K)_C$ for each #gls("Iconclass")
concept~$C in bb(C)$. In doing so, we often found it helpful to provide
the GPT-2 model with the start of the caption, such as "A photo of …" or
"A drawing of …", along with the keywords.

==== Descriptions based on Vision-language Models (`BLIP`)
<descriptions-based-on-vision-language-models-blip>
The introduction of instruction-based fine-tuning of #glspl("LLM") allows
descriptions to be created without the need to optimize the #gls("LLM") itself
for that specific task. Another difference to the previous `KW` and
`GPT` approaches is that in addition to the #gls("Iconclass") keywords, the
corresponding image is also used as input. We use the #emph[BLIP2]
model~@abs-2301-12597 fine-tuned to
instructions~@abs-2305-06500, which in turn
consists of a #emph[CLIP] vision
encoder~@RadfordKHRGASAM21 and a #emph[FlanT5]
language model~@abs-2210-11416. To create a
textual description~$D$, we use the corresponding image~$I$, all
$n$~associated keywords~$K in bb(K)_C$ for each #gls("Iconclass")
concept~$C in bb(C)$, and the following instruction as input: "Create a
description of up to three sentences for this image and try to include
the terms
$angle.l K_1 angle.r comma angle.l K_2 angle.r comma dots.h comma angle.l K_n angle.r$."

=== Constrastive Pre-Training
<chp:method-constrastive-pretraining>
Given a data set containing a set of images and associated annotations
according to the #gls("Iconclass") notation scheme, we create textual
descriptions based on the associated keywords using #emph[one] of the
methods presented in the previous section. As shown in
@fig:clip_model_b, the #gls("InfoNCE")
contrastive loss~@abs-1807-03748 is used to
optimize the #gls("VLM") model
#emph[CLIP]~@RadfordKHRGASAM21 based on these
image-text pairs. We refer to
@chp:network-parameters for more details on
optimization. After pre-training, the weights of the vision transformer
are further optimized during classifier training for the hierarchical
classification of iconographic concepts, as explained in
@chp:method-hierarchical-classification.

=== Iconographic Concept Classification
<chp:method-hierarchical-classification>
Based on the pre-trained image encoder of the #gls("VLM"), we aim to train an
image classifier that predicts the corresponding iconographic concepts.
Please note that we do not use the text encoder for classification as
there is no textual information available for the images during testing.
The #gls("Iconclass") taxonomy consists of $L$~levels of granularity, each with
its own set of concepts~$bb(C)_l$, $l in lr([0 comma L minus 1])$. An
image is labeled with a set of #gls("Iconclass") concepts~$C in bb(C)$ based on
the #gls("Iconclass") notation
scheme~(@chp:method-notation-scheme). Note that the
annotated concept can be at any level of granularity in the taxonomy.
The goal of the classifier is to predict the set of ground-truth
#gls("Iconclass") concepts for a given image.

For the prediction, we use the embedding from the classification token
of the vision transformer~@dosovitskiy2021 as input. This token
is also used during the #emph[CLIP]
pre-training~(@chp:method-constrastive-pretraining).
Subsequently, a fully-connected layer with neurons corresponding to the
amount of classes~(i.e., iconographic concepts) is added as the
classification head. In the remainder of this section, we propose one
zero-shot classification
approach~(@chp:method-clip) and four supervised
classifiers~(@chp:method-flat to
@chp:method-cat).

#figure(image("../images/iconclass/iconclass_yolo_2.svg", width:100%),
  caption: [
Workflow of the Hierarchical Flattened Classification (`Flat-H`).
A vision transformer~@dosovitskiy2021 is used to create a semantic representation of the images. 
The classification head is used as input for a fully-connected feed-forward layer with #emph("sigmoid") activation that flattens the #gls("Iconclass") taxonomy using as many neurons as iconographic concepts in the whole taxonomy. The colors in the flattened prediction represent all concepts $bb(C)_l$ in a given taxonomy level $l$;
the blocks within the colors have the same parental notation.
  ]
)
<fig:flat-model>


#figure(image("../images/iconclass/iconclass_onto_2.svg", width:100%),
  caption: [
Workflow of the Hierarchical Cross-Attention Transformer~(`CAT`) based on a vision transformer~@dosovitskiy2021 as encoder and an hierarchical decoder extended from Vaswani et al.~@VaswaniSPUJGKP17.
The hierarchical decoder applies cross-attention to include features from all image regions and learns individual class embedding for all #gls("Iconclass") concepts~$|bb(C)_l|$ in a particular level~$l in [0, L-1]$ of the taxonomy. 
The `CAT` model predicts in each iteration the concepts of a level~(illustrated with different colors) based on the input embedding from the previous level~(parent #gls("Iconclass") concept). Thus, in each step, only one of the blocks in the concepts $bb(C)_l$ is predicted. 
The details for the optimization of the classifier are visualized in @fig:decoder-model.
  ]
)
<fig:hierarchical-model>

#figure(image("../images/iconclass/transformer_decoder_5.svg", width:50%),
  caption: [
Optimization of the multi-label `CAT` classification. Using two notations, `41C3` and `73D24` from @fig:example-iconclass, we apply the `CAT` model twice.
First, the input of the transformer is the sequence `#s`~(#emph(`start`)), `4`, `1`, where the ground-truth annotation is highlighted in orange.
Second, the cross-entropy $C E_l$ loss between the respective ground-truth and the prediction is calculated for each level~$l in [0, L-1]$ considering only the valid parent.
  ]
)
<fig:decoder-model>

==== Zero-shot CLIP-based Classification (`CLIP`)
<chp:method-clip>
For zero-shot classification, we measure the similarity between an image
and the textual descriptions for all #gls("Iconclass") concepts~(as shown in
@fig:clip_model_b) using a
#emph[CLIP] model pre-trained according to one of the strategies in
@chp:method-constrastive-pretraining. Unlike the
following supervised classifiers, this method does not require a
classification head and further optimization. More specifically, for
each #gls("Iconclass") concept~$C in bb(C)$, we create a textual description
based on the associated keywords~$bb(K)_C$. To make this procedure more
robust, we follow Radford et
al.~@RadfordKHRGASAM21 and combine the
keywords~$bb(K)_C$ with a set of pre-defined templates to create
#emph[hard prompts]~(e.g., "This is a photo of
\<class\>", "A drawing of
\<class\>"). These #emph[hard prompts]
serve as input to the text encoder from
@chp:method-contrastice-pre-training to create
textual embeddings for the given #gls("Iconclass") concept. Finally, we compute
the dot product between the average textual embeddings of all
$n$~concepts and the image embeddings produced by the vision
transformer, resulting in a similarity vector~$hat(bold(y)) in bb(R)^n$.
Unlike for following classification methods that aim for a binary
decision, this approach uses the similarity vector as a ranking to
calculate the mean #gls("AP") for #gls("HMC") according to
@chp:evaluation-metrics.

==== Flattened Classification (`Flat`)
<chp:method-flat>
To create a baseline classifier, we 'flatten' the concepts~$bb(C)_h$ of
all hierarchy levels in #gls("Iconclass")~(similar to
@fig:flat-model). We use a
fully-connected layer with as many neurons~$n$ as there are concepts at
all levels of the hierarchy. A multi-hot encoded target
vector~$bold(y) in brace.l 0 comma 1 brace.r^n$ is created that
indicates only the annotated #gls("Iconclass") concepts of an image,
disregarding the corresponding parent nodes of those concepts according
to the #gls("Iconclass") taxonomy. A #emph[sigmoid] function is used as
activation in the classification layer to predict a probability
vector~$bold(hat(y)) in bb(R)^n$. The cross-entropy loss between the
predicted and target vectors is used for optimization.

==== Hierarchical Flattened Classification (`Flat-H`)
<chp:method-flath>
This classifier extends `Flat` with a 'flattened,' multi-hot encoded
target vector~$bold(y) in brace.l 0 comma 1 brace.r^n$ that encodes not
only the annotated concepts of an image, but also their corresponding
parents according to the #gls("Iconclass") taxonomy. The structure of this
approach is shown in @fig:flat-model.
For optimization, we follow the approach of
#emph[YOLO9000]~@RedmonF17 and compute the
cross-entropy loss between the ground-truth
vector~$bold(y) in brace.l 0 comma 1 brace.r^n$ and the predicted
probabilities~$hat(bold(y)) in bb(R)^n$ at each level of the taxonomy.
For this purpose, we apply the #emph[sigmoid] activation function only
to concepts at taxonomy level~$l in lr([0 comma L minus 1])$ that are
related~(i.e., synsets) to the most likely parent class(es) at
level~$l minus 1$. Concepts with other parents are not considered in the
loss term. This allows the classifier to learn from structured
hierarchical information. It also alleviates the problem of class
imbalance, as the number of concepts to be classified as negative
classes is significantly reduced. During inference, the probability of a
concept can be refined by considering the probabilities of its
parents~(e.g., by multiplication).

==== Weighted Flattened Classification (`Flat-W`)
<chp:method-cos_cel>
To integrate ontology information, we use a weighting scheme similar to
that presented by Müller-Budack et
al.~@Muller-BudackSH21 for ontology-driven event
classification. As for `Flat-H`, we first create a multi-hot encoded
target vector~$bold(y) in brace.l 0 comma 1 brace.r^n$ that encodes the
annotated concepts of an image and its parents in the #gls("Iconclass")
taxonomy. To put more emphasis on annotated iconographic concepts, we
assign a weight of~$w eq 1$ to all concepts that have been labeled for
at least one training image, while concepts that have no annotations are
weighted with~$w eq 0.5$. Subsequently, the target vector and the
predicted probabilities~(using #emph[sigmoid] activation), are
multiplied by the corresponding weights. The cosine similarity between
the weighted vectors is optimized during training. Unlike Müller-Budack
et al.~@Muller-BudackSH21 we (i)~consider a #gls("HMC")
task where samples can contain more than one annotation, and (ii)~the
fraction of nodes assigned with a maximum weight is much higher for our
data set~(19,829 / 23,113; see @chp:data-sets)
compared to the #emph[Visual Event Classification Data set]~(148 / 409;
@Muller-BudackSH21). As a result, the weighting
of concepts may be less significant.

==== Hierarchical Cross-Attention Transformer (`CAT`)
<chp:method-cat>
To better represent the #gls("Iconclass") taxonomy, we introduce a novel
approach that does not compute all #gls("Iconclass") concepts in one step, but
in an iterative fashion. The general idea behind this approach is
similar to the recurrent hierarchical classification approach
#emph[HMCN-R]~@WehrmannCB18 or image
captioning~@KarpathyL15, where in each iteration,
a level of the hierarchy, or a token of the #gls("Iconclass")
concept $C$ (@fig:clip_model_a), is
predicted. In contrast to related work, we use an encoder-decoder
structure based on recent transformer architectures. The entire
architecture is shown in
@fig:hierarchical-model. The
vision encoder is the vision transformer, pre-trained according to
@chp:method-constrastive-pretraining. We use the
original transformer decoder proposed by Vaswani et
al.~@VaswaniSPUJGKP17 that applies
cross-attention to the vision encoder. Cross-attention allows all
regions of the image, i.e., the heads of all regions that carry the
embeddings, to be considered by the decoder in each iteration of token
prediction. This is the main difference to the variants of the `Flat`
classifier that use only the classification head.


For each level~$l in lr([0 comma L minus 1])$ in the taxonomy, we learn
an individual class embedding representing all #gls("Iconclass")
concepts~$lr(|bb(C)_l|)$ in that level, and an additional #emph[start]
and #emph[stop] token, for the initial input and to end the prediction.
These $L$~class embeddings are used as input to the decoder.

In the classification layer, we use $L$~separate dense layers with
#emph[sigmoid] activation for each level of the hierarchy. Each dense
layer consists of $lr(|bb(C)_l|) plus 1$~neurons outputting the
probabilities~$hat(bold(y))_l in bb(R)^(lr(|bb(C)_l|) plus 1)$ of the
$lr(|bb(C)_l|)$~concepts in the taxonomy level~$l$ and an additional
neuron indicating the probability for the #emph[stop token]. To handle
multiple #gls("Iconclass") concepts per image, we repeat this process~$m$ times
to predict a total of up to $m$~notations. In each case, we use one of
the #gls("Iconclass") concepts as the input sequence to the transformer (teacher
forcing) and then optimize the respective valid part of
$hat(bold(y))_l in bb(R)^(lr(|bb(C)_l|) plus 1)$ with the matching
ground-truth
vector~$bold(y)_l in brace.l 0 comma 1 brace.r^(lr(|bb(C)_l|) plus 1)$
using the cross-entropy loss $C E_l$:
$ cal(L)_(mono("CAT")) & eq sum_(l eq 0)^(L minus 1) C E_l lr((bold(y)_l comma hat(bold(y))_l)) eq minus sum_(l eq 0)^(L minus 1) sum_(c eq 0)^(bb(C)_l) bold(y)_(l comma c) log lr((bold(hat(y))_(l comma c))) $
The optimization process is summarized in
@fig:decoder-model.

To predict more than one path through the taxonomy during inference, we
cannot use a greedy decoder or beam search
procedure~@WuSCLNMKCGMKSJL16, as is common in
image captioning, since this would result in only one prediction.
Instead, we use a simple solution of repeatedly running the decoder with
the current most likely concept as input, which still has child
#gls("Iconclass") concepts that have not been predicted yet. To avoid having to
repeat the process for each classifier, we can define two termination
criteria: (i)~we can limit the maximum number of iterations~$p$; (ii)~we
can stop the process if no concept has a probability above a certain
threshold~$t$.

== Data Sets
<chp:data-sets>
Despite increasing efforts to digitize art-historical material, the
amount of collections available online utilizing #gls("Iconclass") remains
disproportionately low. We are relying on two data sets that unite
several institutions and entail a wide range of art-historical objects,
such as paintings, emblems, drawings, engravings, and manuscripts:
(i)~#emph[]~@iconclass-ai-test-set, in the following abbreviated
to #gls("ICAI"). The data set contains 87744 images sampled from the Arkyves
database.#footnote[#link("https://www.arkyves.org/") (last accessed on
2024-05-20).] These images are labeled with a total of 362561 #gls("Iconclass")
concepts, 12488 of which are unique. (ii)~#gls("ICARUS"). In addition,
we introduce a novel data set that comprises 477569 images, providing
1328417 annotations for 20596 unique #gls("Iconclass") concepts. To compile this
data set, a total of 19 publicly available collections were harvested
from a variety of countries; further details are given in the SM. For
machine learning purposes, we divided #gls("ICARUS") into training, validation,
and testing sets, with approximate split ratios of $80$ %, $10$ %, and
$10$ %, respectively. Details of image pre-processing and duplicate
removal are explained in SM, as is the unification of the annotations of
#gls("ICAI") and #gls("ICARUS").

== Experimental Setup and Results
<chp:experimental-setup>
In this section, we present the network architecture and
parameters~(@chp:network-parameters), the
evaluation metrics~(@chp:evaluation-metrics), the
experimental results of the pre-training of the #gls("VLM")
models~(@chp:experimental-results-pretraining), as
well as the performance of the hierarchical classification
approaches~(@chp:experimental-results-hierarchy).

=== Implementation Details
<chp:network-parameters>
For #emph[CLIP], we use the vision transformer
variant~#emph[ViT-B/16]~@dosovitskiy2021 as vision encoder and a
transformer model~@VaswaniSPUJGKP17 with twelve
layers and eight attention heads as text encoder. For the `CAT`
classification model~(@chp:method-cat), we use
the transformer presented by Vaswani et
al.~@VaswaniSPUJGKP17 with three decoder layers
and eight attention heads. During training, we use $m eq 5$ to achieve a
good trade-off between performance and speed. During inference of the
`CAT` classifier, we use $p eq 30$~iterations as stopping criterion.
Unless otherwise specified, we optimize our models for 40000 iterations
using the #emph[AdamW] optimizer~@LoshchilovH19
with a batch size of $256$ and a learning rate of $1 e minus 4$. More
experiments and details on the hyperparameters as well as their
selection are included in the SM.

=== Evaluation Metrics
<chp:evaluation-metrics>

Since we consider a #gls("HMC") problem for more than 20000 concepts and
significant class imbalance due to the hierarchical structure, typical
classification metrics are not suitable. Therefore, we calculate the #gls("AP")
for each #gls("Iconclass") concept and average it over all concepts that have at
least a certain number of training images. Setting the number of images
to larger thresholds provides insights into the model performance for
lower levels~(i.e., coarser iconographic concepts) of the taxonomy.

=== Contrastive Pre-training with Image-Text Pairs
<chp:experimental-results-pretraining>

In this experiment, we evaluate the efficacy of different strategies for
creating image
descriptions~(@chp:method-contrastice-pre-training)
for contrastive pre-training of #glspl("VLM"). For this purpose, we generate a
data set using the proposed `KW`, `BLIP`, and `GPT` methods for
text-synthesis and train
#emph[CLIP]~@RadfordKHRGASAM21 for 40000
iterations on the #gls("ICARUS") training set. We then fine-tune our `CAT`
approach from
@chp:method-hierarchical-classification to classify
the #gls("Iconclass") taxonomy for another 40000 iterations and compare the
results. To investigate the performance of our pre-training on #gls("ICARUS"),
we also fine-tune the `CAT` classifier on the original #emph[CLIP] model
trained on the #emph[LAION-400M] data
set~@abs-2111-02114. Therefore, no
pre-training takes place in this experiment. The results of this
experiment are shown in Table~@tab:pre-training.

#figure(
table(
  columns: (30%, 15%,15%,15%, 15%),
  align: (col, row) => (left,right,right,right,right,).at(col),
  inset: 6pt,
  table.hline(start: 0, stroke: 0.5pt),
  table.header(
    [Strategy], table.cell(colspan: 4)[\# of Training Images per #gls("Iconclass") Concept],
    [],[$gt 0$], [$gt 10$], [$gt 100$], [$gt 1000$],
  ),
  table.hline(start: 0, stroke: 0.5pt),
  [`KW`], [0.1862], [0.2025], [0.2545], [0.3953],
  [`BLIP`], [#strong[0.1922]], [#strong[0.2106]], [#strong[0.2596]], [#strong[0.3961]],
  [`GPT`], [0.1902], [0.2063], [0.2583], [0.3916], 
  [`LAION-400M`], [0.1845], [0.2017], [0.2540], [0.3936],
  table.hline(start: 0, stroke: 0.5pt),
),
  caption: figure.caption([ 
    Results of contrastive pre-training with image-text
    pairs on different text generation strategies on the #gls("ICARUS") test set
    using the `CAT` classifier. The results show the #gls("mAP") for all concepts
    that have at least one image in the test set. The best-performing
    strategy is denoted in bold. 
  ],
  position:top)

) 
<tab:pre-training>
Models that were first pre-trained on one of the synthesized image-text
pairs generally outperform the original #emph[CLIP] model trained on
#emph[LAION-400M]. In particular, the results improve for concepts that
have few training examples in the corpus. This proves that pre-tuning
with art-historical images does indeed improve performance for
iconographic concept classification. As expected, our novel, more
sophisticated strategies for description synthesis, i.e., `GPT` and
`BLIP`, outperform the `KW` baseline; the results for `BLIP` are
slightly better than for `GPT`. Thus, we choose `BLIP` for all
subsequent experiments.

=== Iconographic Concept Classification
<chp:experimental-results-hierarchy>
In these experiments, we compare our proposed image classification
approach `CAT` presented in @chp:method-cat with
several state-of-the-art baseline methods: `FLAT` is consistent with a
common solution for multi-label classification
@ridnik2021asymmetric, which uses a #emph[sigmoid] activation
together with a cross-entropy loss; `FLAT-H` is a widely applied
technique~@RedmonF17 to exploit hierarchical
information; and `FLAT-W` mimics a state-of-the-art
approach~@Muller-BudackSH21 that uses ontology
information. We have also considered the applicability of other
state-of-the-art approaches to #gls("HMC"). However, they are not applicable,
either because they cannot handle multiple classes at the same level of
the hierarchy~@ChenWLQ22, or because they cannot
handle the large number of over 20000 classes considered in our
task~@GiunchigliaL20. As mentioned in
@chp:experimental-results-pretraining, our proposed
approaches use the image encoder of the #gls("VLM") model pre-trained with
`BLIP` descriptions optimized on the #gls("ICARUS") training set. The results
are shown in Table~@tab:result-data-sets.

#figure(
  table(
    columns: (15%,15%, 15%,15%,15%, 15%),
    align: (col, row) => (left,left,right,right,right,right,).at(col),
    inset: 6pt,
  table.hline(start: 0, stroke: 0.5pt),
    table.header(
      [Test Set], [Strategy], table.cell(colspan: 4)[\# of Training Images per #gls("Iconclass") Concept],
      [], [],[$gt 0$], [$gt 10$], [$gt 100$], [$gt 1000$],
    ),
  table.hline(start: 0, stroke: 0.5pt),
    [#gls("ICAI")],
    [`CLIP`],
    [0.0033],
    [0.0040],
    [0.0088],
    [0.0323],
    [],
    [`Flat`],
    [0.0294],
    [0.0378],
    [0.0688],
    [0.1639],
    [],
    [`Flat-H`],
    [0.0638],
    [0.0777],
    [0.1148],
    [0.2107],
    [],
    [`Flat-W`],
    [0.0105],
    [0.0134],
    [0.0286],
    [0.0970],
    [],
    [`CAT`],
    [#strong[0.1715]],
    [#strong[0.1803]],
    [#strong[0.2012]],
    [#strong[0.2737]],
  table.hline(start: 0, stroke: 0.5pt),
    [#gls("ICARUS")],
    [`CLIP`],
    [0.0035],
    [0.0038],
    [0.0080],
    [0.0245],
    [],
    [`Flat`],
    [0.0394],
    [0.0484],
    [0.0942],
    [0.2265],
    [],
    [`Flat-H`],
    [0.0789],
    [0.0946],
    [0.1507],
    [0.2935],
    [],
    [`Flat-W`],
    [0.0134],
    [0.0172],
    [0.0382],
    [0.1294],
    [],
    [`CAT`],
    [#strong[0.1714]],
    [#strong[0.1889]],
    [#strong[0.2407]],
    [#strong[0.3716]],
  table.hline(start: 0, stroke: 0.5pt),
  ),
  caption: figure.caption([ Results of the individual classification approaches on
the #gls("ICAI") and #gls("ICARUS") test sets using the `BLIP` text generation. The
results show the #gls("mAP") for all concepts that have at least one example in
the test data set. The best-performing classifier per test set is
denoted in bold. ],
position: top
)
) <tab:result-data-sets>


#figure(
  grid(
    columns: 1, 
    row-gutter:0.5em,
    image("../images/iconclass/iconclass_samples_3_exp_1_s.svg", width:100%),
    [(a) `11HH(THERESA)` (#quote[the foundress of the reformed (Discalced) Carmelites, T(h)eres(i)a of Avila ...])],
    image("../images/iconclass/iconclass_samples_3_exp_5_s.svg", width:100%),
    [(b) `71B4` (#quote[ story of the Tower of Babel (Genesis 11:1--9)])],
    image("../images/iconclass/iconclass_samples_3_exp_2_s.svg", width:100%),
    [(c) `92D19217` (#quote[Psyche performing various tasks set to her by Venus])]),
  caption: [
    Results of the `CAT` model on the #gls("ICARUS") test set.
For visualization, we randomly selected three #gls("Iconclass") concepts with $"AP" > 0.5$ and at least five images in the test set.
The images are arranged in descending order of prediction probability.
Green borders indicate correctly classified images;
red bordered images do not include the selected concept in their ground-truth annotations. 
  ]
)
<fig:iconclass-samples>

On both test data sets we can see that the `CAT` approach performs
significantly better than all other baseline classification methods.
Furthermore, the two best performing approaches, `Flat-H` and `CAT`, are
those that use masking to optimize only the relevant parts of the
#gls("Iconclass") taxonomy. This can probably be explained by the fact that some
of the images in the training set are not thoroughly labeled and thus
also show unlabeled concepts, leading to a worse optimization for the
other methods. We achieve promising results given the complexity of the
task and the limited amount of training data for some concepts. A
qualitative evaluation conducted with domain experts also showed that
our approach can be usefully applied in practice due to its hierarchical
architecture, since not only the prediction of the finest level of
hierarchical is relevant, but also the prediction of concepts that are
superordinate to this level. We see particular value in semi-automated
use cases, where potentially relevant concepts can be automatically
recommended for an image and then manually confirmed or refined by an
expert. @fig:iconclass-samples
illustrates some of the art-historical concepts that were qualitatively
analyzed: in addition to the narratives of primarily Christian religion
illustrated in
Figure~@fig:iconclass-samples[(a)] and
Figure~@fig:iconclass-samples[(b)],
there are also those of classical mythology
(Figure~@fig:iconclass-samples[(c)]).
Visually striking iconographies, such as the story of the #emph[Tower of
Babel]
(Figure~@fig:iconclass-samples[(b)]),
are reliably classified by the `CAT` model with the corresponding
#gls("Iconclass") concepts, regardless of the painting or printing technique
used; this is true for copper engravings as well as for illuminated
manuscripts. As shown in
Figure~@fig:iconclass-samples[(a)], the
model occasionally detects similarly predisposed compositions, even if
they are false positives. Further information about the qualitative
evaluation is given in the supplementary material.

== Conclusions
<chp:conclusion>
In this paper, we have presented a novel approach for #gls("HMC") of
iconographic concepts. We have introduced three strategies for
automatically creating image descriptions to pre-train a
state-of-the-art #gls("VLM") based on a novel data set comprising 477569 images
for more than 20000 unique iconographic concepts. Furthermore, we
proposed five classification approaches, including a novel transformer
decoder that leverages hierarchical knowledge from the #gls("Iconclass")
taxonomy, which is the first decoder adopted to the problem of
multi-label classification. We have demonstrated that our proposed
solution benefits significantly from the adoption of #glspl("Iconclass")
structure: if a concept situated at a lower hierarchy level is not
detected, the taxonomy allows for an upward traversal, facilitating the
identification of a related concept. This decisively increases the
potential usefulness of digital collections for research and education
in the visual arts.

In the future, we aim to extend our approach to other, particularly
non-western, taxonomies such as the #gls("CIT"), as well as other hierarchical
multi-label classification tasks in #gls("CV"). It would also be interesting to
explore how simultaneous optimization of a #gls("VLM") and a classifier, which
are currently trained separately in two stages, affects the performance.
Pre-training #glspl("LLM") on captions for art-historical documents for
description generation is also worth investigating.

== Acknowledgements
<acknowledgements>
This work was partly funded by the German Research Foundation (DFG)
under project numbers 415796915 and 510048106.