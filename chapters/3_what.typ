#import "@preview/glossarium:0.4.0": gls, glspl 
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": outline-text

= #outline-text(["Are Machines Better Than Humans in Image Tagging?" - A User Study Adds to the Puzzle],[Are Machines Better Than Humans in Image Tagging?]) <chp:what>

== Introduction
<introduction>
In the fields of multimedia analysis and retrieval, human performance in
recognition tasks was reported from time to time
@bailer2005joanneum @jiang2011consumer @kumar2009attribute @lake2015human @nowak2011eval @parikh2010role @taigman2014deepface @turnbull2008semantic @weyand2016planet @xiao2010sun,
but has not been evaluated in a consistent manner. As a consequence, the
quality of human performance is not exactly known and estimates exist
only for a number of recognition tasks. The design of the related human
experiments also varies noticeably in many respects. For example,
crowdsourcing was often utilized to employ annotators
@jiang2011consumer @kumar2009attribute @lake2015human @lin2014microsoft @nowak2011eval @parikh2010role @xiao2010sun,
which is coming along with some methodological issues. The number of
human participants varies from 1 to 40 in the studies considered in this
paper. The same is true for the experimental instructions and their
expertise, in particular for crowdworkers. This, for example, makes it
nearly unfeasible to evaluate and compare machine performance at human
level across different tasks. In fact, we know little #emph[in general]
about human performance in multimedia content analysis tasks. As a
consequence, the question when such a task can be considered as solved
cannot be answered easily. The related question is addressed by this
paper: How can we systematically set machine performance in relation to
human performance? If human ground truth data are the (only) baseline,
machine performance can basically never be better than (human) ground
truth data. But considering the impressive recent advances in deep
learning for pattern recognition tasks, it is desirable to set machine
performance in relation to human-level performance in a systematic
manner.

Another issue is related to ground truth data for retrieval tasks: The
relevance of multimedia documents at retrieval time for a certain user
is not known in advance and it depends on the user’s current search task
and context. The issue of evaluating multimedia analytics systems has
been recently also stressed by Zahálka et al.
@zahalka2015analytic. For example, a detective is interested in
every occurrence of a suspicious object (e.g., a car) in any size. On
the other hand, a TV journalist, who searches for material for re-use in
order to illustrate the topic mobility, might be interested only in
retrieval results showing a car in an "iconic" view, i.e., placed
clearly in the foreground.

In this paper, we review a number of papers reporting human performance
in visual and auditory recognition tasks. This aims at putting together
some parts of the puzzle: How well do machines perform in such tasks
compared to humans? To answer this question, the results are set in
relation to the current state of the art of automatic pattern
recognition systems. Furthermore, we present a comprehensive user study
that fills the gap of analyzing in detail human performance in
annotation tasks for realistic images, as they are used in the #gls("VOC") challenge
@everingham2010pascal @everingham2015pascal, for example. More
than 1000 images have been annotated by 23 participants in a
non-crowdsourcing setting. The number of images also allows us to draw
conclusions about rarely occurring concept categories such as "cow" or
"potted plant". It is suggested to evaluate the reliability of users’
annotations by Krippendorff’s $alpha$
@krip2004reliability @krip2011computing, which measures the
agreement among several coders. The results of the presented study are
discussed and conclusions are drawn for the evaluation of computer
vision and multimedia retrieval systems: A methodology is introduced
that enables researchers to formally compare machine performance at
human level in visual and auditory recognition tasks. To summarize, the
contributions of this paper are as follows:

- Surveying and comparing human and machine performance in a number of
  visual and auditory pattern recognition tasks,

- presenting a comprehensive user study regarding image annotation
  yielding insights into the relation of human and machine performance,

- introducing the concept of inter-coder reliability in the field of
  multimedia retrieval evaluation for comparing human and machine
  performance,

- proposing an evaluation methodology that allows us to evaluate machine
  performance at human level in a systematic manner, and

- suggesting two indices for measuring human-level performance of
  systems.

The remainder of the paper is structured as follows. @sec:what_human surveys studies that compared human and machine
performance for different visual and auditory recognition tasks. @sec:what_user deals with a comprehensive user study regarding
image annotation and related results are presented. A methodology to
evaluate machine performance at human level in a systematic way is
suggested in @sec:what_methodology. Finally, some
conclusions are drawn in @sec:what_conclusions.

== #outline-text([Human and Machine Performance in Visual and Auditory Recognition Tasks],[Human and Machine Performance in Recognition Tasks])
<sec:what_human>
In this section, we briefly survey related work which compared human and
machine performance for some multimedia analysis tasks. Yet, human
performance has been considered only in a small number of studies.

Some studies evaluated human performance in the task of visual concept
classification. Nowak and Rüger @kumar2009attribute as well as
Lin et al. @lin2014microsoft measured the human inter-coder
agreement and compared experts against crowdsourcing annotators. Other
papers reported the performance of humans and machine systems on some
benchmark datasets. Jiang et al. @jiang2011consumer presented a
dataset for consumer video understanding. For this dataset, the human
annotations were significantly better than the machine results. Parikh
and Zitnick @parikh2010role investigated the role of data,
features, and algorithms for visual recognition tasks. An accuracy of
nearly 100~% is reported for humans on two #gls("VOC") datasets, whereas
machine performance was around 50~% on both datasets in 2008. Xiao et
al. @xiao2010sun presented the dataset SUN (Scene Understanding)
for scene recognition consisting of 899 categories and 130519 images.
Scene categories are grouped in an overcomplete three-level tree. Human
performance reached 95~% accuracy at the (easy) first level and 68.5~%
at the third level of the hierarchy. Despite this, the machine
performance of 38~% accuracy was significantly below human accuracy in
this study. Russakovsky et al. @russakovsky2015imagenet surveyed
the advances in the field of the ImageNet challenge
@deng2009imagenet from 2010 to 2014. The best result in 2014 was
submitted by Szegedy et al. @szegedy2015going (GoogLeNet) and
achieved an error rate of 6.66~%. Russakovsky et al. compared this
submission with two human annotators and discovered that the neuronal
network outperforms one of them. He et al. @he2015delving
claimed their system to be the first one that surpassed human-level
performance (5.1~%) on ImageNet data by achieving an error rate of
4.94~%.

Phillips et al.~@phillips2007frvt conducted one of the first
comparisons of face identification capabilities of humans and machines.
Interestingly, at that time the top three algorithms were already able
to match or to do even better face identification compared with human
performance on unfamiliar faces under illumination changes. Taigman et
al. @taigman2014deepface presented a deep learning system for
face verification that improves face alignment based on explicit 3D
modelling of faces. A human-level performance of 97.35~% accuracy is
reported for the benchmark "Faces in the Wild" (humans: 97.53~%
accuracy).

Other interesting comparisons between humans and machine systems include
camera motion estimation (Bailer et al. @bailer2005joanneum),
music retrieval (Turnbull et al. @taigman2014deepface), and the
geolocation estimation of images (Weyand et al.
@weyand2016planet). These studies also demonstrated that
machines can reach or outperform humans.

While the experiments of Parikh and Zitnick @parikh2010role with
respect to re-engineering the recognition process do not provide
evidence that humans are superior to machines, other reported results on
#gls("VOC") and other data sets show that humans perform significantly
better on classifying natural scene categories. The reported results for
visual concept classification
@jiang2011consumer @kumar2009attribute @nowak2011eval @xiao2010sun
indicate that human performance is (far) better than the respective
state of the art for automated visual concept classification at that
time. Although He et al. claimed in 2015 that human-level performance
has been surpassed by their approach @he2015delving, this claim
remains questionable since only two human annotators were involved in
the underlying study of Russakovsky et al. @russakovsky2015imagenet. There are also some methodological
issues in the reported experiments of the other studies, for example,
experimental settings are not well defined, the employment of
crowdsourcing is critical, or the number of images is too small which
prevents drawing conclusions for rare classes. Hence, stronger empirical
evidence still has to be provided for a meaningful comparison of human
and machine performance. Therfore, in the remainder of this paper we
address these issues by a comprehensive user study and derive a
methodology to measure machine performance at human level.

== User Study: Human Performance in Image Annotation
<sec:what_user>
The previous section shows that the settings of the majority of studies
do not allow us to compare human performance against machines learning
approaches for image classification tasks. In this section, we present
two user studies measuring human performance in annotating common image
categories of daily life in a realistic photo collection (#gls("VOC")
@everingham2010pascal @everingham2015pascal). The design of
this study is described in @sec:what_exp_des. The
inter-coder agreement of the two experiments is evaluated using
Krippendorff’s $alpha$ (@sec:what_measuring).
Furthermore, the results of the best machine systems submitted to #gls("VOC")'s leaderboard are set in relation to the human agreement (@sec:what_result_inter). Finally, the results are made
comparable in a systematic manner (@sec:what_human_machine).

=== Experimental Design
<sec:what_exp_des>
We have randomly selected 1159 images from the #gls("VOC") test set. The
relatively high number of images - compared to other studies - allows us
to also obtain statistically relevant insights into human performance
for less frequent concepts. For example, the concept cow is visible only
in 34 out of 1159 images , whereas the concept "person" occurs in 420
images However, using #gls("VOC")’s test set comes along with the
disadvantage that the ground truth data are not available, in contrast
for training and validation data. On the other hand, submission results
are available only for the test set at #gls("VOC")’s homepage. Therefore,
we created ground truth for this test data subset by ourselves.

In total, twenty-three students (3rd and 4th year) were asked to
annotate images of the test set with respect to 20 concept categories
(see also @tab:what_krip_compare), 18
students participated in the first and five other students participated
in the second experiment. They were rewarded
25€/\$30 for participating in the experiment. All students were members of the Department Electrical Engineering and Information Technology at the University of Applied Sciences Jena. The participants were instructed to label images with respect to the presence of objects of 20 categories but without localizing them. Multiple objects classes can be visible in an image, i. e., it is a multi-labeling task. This task corresponds to the classification task of the VOC challenge 2012. The study was further divided in two experiments In the first experiment, they were not instructed to use the #gls("VOC") annotation guidelines @pascal2011guide, since we aimed at measuring human performance based on common sense and existing knowledge about categories of daily life. In the second experiment, the participants were asked to annotate the images according to the #gls("VOC") guidelines. The annotation process was divided in four batches that consisted of a slightly decreasing number of images. After each batch, the participants were allowed to make a break of 10-15 minutes. The annotation process had to be completed within four hours. The images were presented to all participants in the same order. They had to mark the correct object categories via corresponding checkboxes. When a user has finished annotating an image, he proceeded with the next image. The software did not allow users to return to a previously annotated image. All users completed the task within the given time limit.

=== Measuring Inter-Coder Agreement: Krippendorff’s $alpha$
<sec:what_measuring>
Krippendorff’s $alpha$ (K’s $alpha$) @krip2004reliability @krip2011computing measures the
agreement among annotators and is widely used in the social sciences to
evaluate content analysis tasks. K’s $alpha$ is a generalization of
several known reliability measures and has some desirable properties
@krip2011computing, it is 1.) computable for more than two
coders, 2.) applicable to any level of measurement (ordinal, etc.) and
any number of categories, 3.) able to deal with incomplete and missing
data, and 4.) it is not affected by the number of units. In its general
form K’s $alpha$ is equal to other agreement coefficients:
$ alpha & eq 1 minus D_o / D_e comma quad upright("where") $ $D_o$ is
the observed disagreement and $D_e$ is the expected disagreement due to
chance. Krippendorff discusses differences of K’s $alpha$ with respect
to other agreement coefficients @krip2004reliability as well as
explains its computation for various situations (depending on the number
of coders, missing data, level of measurement, etc.)
@krip2011computing. Hayes and Krippendorff provided a software
that computes K’s $alpha$ @hayes2007answering.

=== Results for Inter-Coder Agreement
<sec:what_result_inter>
==== Agreement when not using VOC guidelines.
<agreement-when-not-using-voc-guidelines.>
The experimental results are displayed in @tab:what_krip_compare for the 1159 images of
the #gls("VOC") test set. They show the inter-rater agreement among the
18 coders by means of K’s $alpha$. Across all concept categories and
users, K’s $alpha$ is 0.913. The largest agreement among the annotators
is observable for the five categories airplane, cat, bird, and airplane,
whereas the categories sofa, bottle, and dining table yield the lowest
agreement.

// TODO
#figure(
  grid(
    columns: 2,
    column-gutter: 1em,
    table(
      columns: 4,
      align: (center,center,center,center,),
      toprule(),
      [Concept], [Human (K's $alpha$)], [AI-1], [AI-2],
      midrule(),
      [Airplane], [0.980], [0.986], [0.998],
      [Cat], [0.978], [0.955], [0.990],
      [Bird], [0.976], [0.934], [0.976],
      [Dog], [0.974], [0.947], [0.989],
      [Sheep], [0.970], [0.874], [0.950],
      [Cow], [0.960], [0.821], [0.943],
      [Horse], [0.959], [0.929], [0.985],
      [Bus], [0.956], [0.910], [0.959],
      [Train], [0.953], [0.960], [0.987],
      [Boat], [0.940], [0.922], [0.964],
      midrule(),
      [Overall/MAP], [0.913], [0.854], [0.940],
      bottomrule(),
    ),

    table(
      columns: 4,
      align: (center,center,center,center,),
      toprule(),
      [Concept], [Human (K's $alpha$)], [AI-1], [AI-2],
      midrule(),
      [Motorbike], [0.938], [0.921], [0.972],
      [Bicycle], [0.909], [0.860], [0.947],
      [TV monitor], [0.898], [0.827], [0.942],
      [Person], [0.895], [0.950], [0.988],
      [Car], [0.848], [0.836], [0.948],
      [Sofa], [0.796], [0.678], [0.868],
      [Bottle], [0.761], [0.654], [0.836],
      [Dining table], [0.737], [0.796], [0.881],
      [Chair], [0.716], [0.734], [0.904],
      [Potted plant], [0.668], [0.594], [0.768],

      midrule(),
      [Overall/MAP], [0.913], [0.854], [0.940],
      bottomrule(),
    )
  ),
  caption: figure.caption([ 
    User agreement (K's $alpha$) on a subset of #gls("VOC") test set and best machine-generated results (AI-1 and AI-2, avg. precision) on the whole test set.
  ],
  position:top)
)<tab:what_krip_compare>

Some interesting observations can be made. First, larger deviations of
inter-coder agreement are observable for the different categories.
Applying the rule of thumb that $alpha gt 0.8$ corresponds to a
"reliable" content analysis @krip2004reliability, it turns out
that the users’ annotations cannot be considered as such for five
categories: sofa, bottle, dining table, chair, and potted plant (K’s
$alpha$ even only 0.67).

@tab:what_krip_compare shows also the
results AI-1 and AI-2, which are the best submissions at #gls("VOC")’s
leaderboard
website#footnote[#link("http://host.robots.ox.ac.uk:8080/leaderboard/main_bootstrap.php")]
for the competitions comp1 and comp2, respectively, by means of average
precision ($A P$). The difference between the two is that comp2 is not
restricted to the train set. Please note, that these results of the user
study and the VOC submissions are not directly comparable at this stage
due to two reasons. First, the users annotated only a subset of the
original test set. Second, different evaluation measures are used. In
particular, the measures differ in the way how agreement by chance is
considered. A more fair comparison resolving these issues is conducted
in the subsequent section.

Anyway, when we set the inter-rater agreement in relation to the
performance of the currently best machine results, we find that the
correlation of K’s $alpha$ and $A P$ with respect to the categories is
0.88 (AI-1) and 0.89 (AI-2), respectively. In particular, it is
observable that the machine learning approaches perform worst for the
same five categories as humans do.

==== Agreement when using VOC guidelines.
<agreement-when-using-voc-guidelines.>
In this experiment, it is investigated whether the inter-coder agreement
is improved when more precise definitions are provided to the users. For
this purpose, we have asked five other students (from the same
department) to annotate the same 1159 images – this time based on the
#gls("VOC") annotation guidelines @pascal2011guide. The
guidelines give some hints how the annotator should handle occlusion,
transparency, etc.

Interestingly, the inter-coder agreement was not improved by using the
guidelines. The inter-coder agreement in this experiment (measured again
by K’s $alpha$) is 0.904, in contrast to 0.913 without guidelines. The
difference between the mean values of K’s $alpha$ with respect to all 20
categories is not statistically relevant (student’s t-test), i.e., the
reliability of human annotations is equal in both experiments. Although
the participants used the annotation guidelines, the annotators did not
achieve a better agreement in this experiment.

=== Comparing Human and Machine Performance
<sec:what_human_machine>
Since ground truth data for #gls("VOC") 2012 test set are not publicly
available, we have created ground truth data for the related subset on
our own. The ground truth data have been created according to #gls("VOC")
annotation guidelines (see above). Critical examples were discussed by
three group members (experts), two of them being authors of the paper.
If a consistent agreement could not be achieved, then the example was
removed for the related category.

In addition, we have trained a convolutional neural network (called AI-3
from now on) and evaluated its performance on the 1159 images. This
allows us to apply AI-3 on the whole #gls("VOC") test set as well as on the
subset used in the human annotation study. Finally, this link enables us
to compare human and machine performance for visual concept
classification on #gls("VOC") test set data. We use the convolutional
neural network of He et al. @he2015deep consisting of 152
layers, which we fine-tuned on the #gls("VOC") training dataset. The
network was originally trained on the ImageNet 2012
dataset @russakovsky2015imagenet. Furthermore, we have reduced
the number of output neurons to the number of classes (in this case 20)
and used a sigmoid transfer function to solve the multi-class labeling
task of #gls("VOC"). Seven additional regions are cropped and evaluated
per test image in the classification step to achieve better results. The
mean average precision (MAP) for AI-3 is very similar for both datasets
(0.871 vs. 0.867 on subset), although the difference of $A P$ (for the
subset and the whole test set) is larger for some classes, e.g., chair
and train. The system AI-3 performs slightly better than AI-1. The
results on both sets are depicted in @fig:what_plot_1.

#figure([#image("../images/what/plot_line.svg", width: 100%)],
  caption: [
    Results (average precision in %) of the best and the worst human
    annotator, as well as of the best #gls("VOC") leaderboard submissions
    for comp1 and comp2.
  ]
)
<fig:what_plot_1>

Now, based on this analysis, the ground truth data allow us to compare
human and machine performance using the same evaluation measure (average
precision). But one issue still needs to be resolved. The annotators
label the relevance of images only with "0" or "1" (in contrast to the
real-values system scores). The (random) order of images labeled with
"1" affects the measure of average precision. Due to this, we have
calculated the "best case" (oracle) and the "worst case" possible
retrieval results based on the human annotations.

Regarding the "best case" in the first experiment, there are three human
annotators that are significantly better than AI-2 (paired student’s
t-test, one-sided, significance level of 0.05). These annotators achieve
a mean average precision of 96.5~%, 96.3~%, and 95.3~%, respectively.
However, regarding the "worst case" ordering, all human annotation
results are significantly worse than AI-2, the best result (of the worst
cases) achieves a mean average precision of 91.6~%. In other words, the
results are sensitive to the ranking order of the images which are
labeled as "relevant".

The results for the best annotator of our second experiment (using VOC
guidelines) are similar. The best "best case" mean average precision is
96.9~%,this is the only human result of experiment 2 that is
significantly better than AI-2. Again, in case of "worst case" ordering,
AI-2 is significantly better than all human annotation results.

Regarding both experiments, we have also estimated the best annotator
(coming from experiment 2) and the worst annotator (coming from
experiment 1) with respect to our ground truth data. The results are
displayed in @fig:what_plot_1. Again, the best results of
the machine vision systems are presented as well. Regarding oracle
results of the best human annotator, the automatic AI-2 system is only
better for the two categories horse and cat. The AI-2 system achieved
better results than AI-3. This can be explained by the fact that AI-3
relies only on the official training set, whereas AI-2 used additional
data. However, the AI-3 system outperforms the worst human annotator in
the most cases.

Overall, the results indicate that the automatic system AI-2 indeed
reaches performance comparable or even superior to humans. To be more
precise, even when (artificially) optimizing the ranking of the human
annotations with respect to ground truth data, the system AI-2 still was
better than 9 participants and was on a par with 6 participants (only 3
human "best case" results were better than AI-2) in experiment 1 (all
results based on a paired student’s t-test, one-sided, significance
level of 0.05). It is similar for experiment 2: AI-2 is better than 2
human "best case" results (both experiments: 11), on a par with another
2 results (both experiments: 8), and a single human annotator performed
better (both experiments: 4). In other words, the system AI-2 is at
least on a par with (or better) than 83~% (48~%) of the human
participants in our study.

== Measuring Machine Performance at Human Level
<sec:what_methodology>

=== Issues of Measuring Human-level Performance
<issues-of-measuring-human-level-performance>

The performance of multimedia retrieval systems is often measured by
average precision ($A P$). However, this measure has some drawbacks.
First, the measure depends on the frequency of a concept. Considering
the definition of average precision, it is clear that the lower bound is
not zero but determined by the frequency of relevant images in the
collection. When randomly retrieving images, the average precision will
be equal to a concept’s frequency on average. This has been stressed,
e.g., by Yang and Hauptmann who suggested the measure $Delta A P$ (delta
average precision) to address this issue @yang2008reliability.
Second, the upper bound of 1.0 is also not reasonable. If we consider
that the agreement in our user study is below 0.8 for five categories
and is even only 0.67 for potted plant, the question arises how we have
to interpret an average precision of, for example 67~% and 100~%,
respectively. If two raters agree with K’s $alpha$ only with 0.67, and
one rater corresponds to ground truth, it is basically possible that the
67~%-result has the same quality as the 100~%-result (from another
perspective, in another context). Hence, the question remains: how can
we formally measure whether a machine-based result is comparable to or
even better than a human result? This question is addressed in the
subsequent section.

=== #outline-text([An Experimental Methodology and Two Indices for Comparisons with Human-level Performance],[Two Indices for Comparisons with Human-level Performance])

In this section, we propose an experimental methodology and two novel
easy-to-use measures, called human-level performance index ($H L P I$)
and human-level performance ranking index ($H L P R I$). The proposed
methodology is aimed at providing a systematic guidance to measure
human-level performance in multimedia retrieval tasks. It is assumed
that a visual or auditory concept is either present or not in a
multimedia document. Furthermore, it is assumed that a standard
benchmark dataset is available. First, ground truth data $G$ should be
created by knowledgeable experts E of the related domain. If possible,
the reliability of these expert annotations should be measured as well
(K’s $alpha$ should exceed at least 0.8 as a rule of thumb) in order to
ensure that the relevance of categories is well-defined. Critical
examples should be subsequently discussed among the group of experts E.
If no consistent decision is possible, then such examples should be
appropriately marked or discarded from the dataset.

The group of human participants $H$ should consist of at least five
annotators/coders, who share a similar knowledge level regarding the
target domain (e.g., experts, if performance is to be measured at expert
level). The annotations of the group $H$ are used to evaluate human
performance in the given task. The annotation process should be
conducted in a well-defined setting. The latter two criteria (same
knowledge level, well-defined setting) normally preclude a crowdsourcing
approach. Apart from other measures, the inter-rater agreement among the
annotators should be also estimated by Krippendorff’s $alpha$. K’s
$alpha$ is suggested since it can potentially also deal with other
levels of measurement (than binary). Then, the agreement (accuracy)
$a_(upright("human"))$ is the median of the agreement scores (e.g.,
measured by K’s $alpha$ or $A P$) of the coders $H$ with respect to $G$.
The machine-generated result is also compared to $G$, yielding the
agreement $a_(upright("machine"))$. Often, several instances of a
machine system, e.g., caused by different parametrizations or training
data, exist. In this case, it is also reasonable to test all these
instances with respect to $G$ and use the median as
$a_(upright("machine"))$. In this way, it can be prevented that a system
is better only due to fine-tuning or by chance. Then, the human-level
performance index is defined as

$ H L P I & eq a_(upright("machine")) / a_(upright("human")) comma $
assuming that human inter-coder agreement is better than chance, i.e.,
$A_(upright("human")) gt 0$. If $H L P I gt 1.0$, then machine
performance is possibly better. However, this has to be verified and
ensured by an appropriate statistical significance test.

A second measure the human-level performance ranking index ($H L P R I$)
is suggested. This index is based on a sorted list in descending order
according to the agreement measurements of the $n$ human annotators with
respect to ground truth data $G$. Let $b$ be the number of machine
results to be evaluated that are better than human annotation results,
and let $w$ be the number of machine annotation results that are worse
(in the sense of statistical relevance). Then, the human-level
performance ranking index is defined by
$ H L P R I & eq frac(b plus 1, w plus 1) $

$H L P R I$ of AI-2 is 2.4 and 1.5 in our experiments 1 and 2,
respectively.

== Conclusions
<sec:what_conclusions>
In this paper, we have investigated the question, whether today’s
automatic indexing systems can achieve human-level performance in
multimedia retrieval applications. First, we have presented a brief
survey comparing human and machine performance in a number of visual and
auditory recognition tasks. The survey has been complemented by two
extensive user studies which investigated human performance in an image
annotation task with respect to a realistic photo collection with 20
common categories of daily life. For this purpose, the well-knwon #gls("VOC")
benchmark has been used. We have measured the human inter-coder
agreement by Krippendorff’s $alpha$ and observed that the annotation
reliability noticeably varies for the concepts. Krippendorff’s $alpha$
was below 0.8 for 5 out of 20 categories, which indicates that these
categories are not well-defined and are prone to inconsistent
annotation. This is an issue for the creation of ground truth data and
subsequent evaluation as well.

In addition, we have carefully compared human and machine performance.
It turned out that the best submission at #gls("VOC")’s leaderboard is
better than 11 or at least on a par with 19 out of 23 participants of
our study. This indicates that the submission has indeed reached
above-average human-level performance for the annotation of the
considered visual concepts.

We have also addressed the issue of measuring human-level performance of
multimedia analysis and retrieval systems in general. For this purpose,
we have suggested an experimental methodology that integrates the
assessment of human-level performance in a well-defined manner. Finally,
we have derived two easy-to-use indices for measuring and
differentiating human-level performance.
