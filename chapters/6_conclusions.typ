 #import "@preview/ctheorems:1.1.3": *
#import "@preview/glossarium:0.5.3": gls, glspl 
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": flex-heading, flex-figure, flex-super, flex-grid
#import "../helper/enviroments.typ": info_with_bib, info
#import "@preview/zero:0.7.0": num, format-table, zi, set-round


= Conclusions and Future Work <chp:conclusion>

Recent advances in automatic content analysis and machine learning have made it increasingly feasible to apply complex and precise analytical methods to ever-larger datasets. Nevertheless, these methods are often neither optimized for specific domains nor readily accessible to domain experts who lack the technical expertise or infrastructure to deploy them. Art history, in particular, poses unique challenges: datasets are small and highly heterogeneous in style, ground-truth annotations are scarce, and the interpretive nature of the subject resists purely quantitative approaches.

Given these challenges, this thesis pursues two main objectives: (1) improving automatic analysis methods for art history, and (2) making these methods accessible to the art history community. A central challenge is that, for many tasks in art history, no sufficiently large annotated datasets exist to train modern machine learning models, necessitating alternative approaches. Furthermore, some research questions in art history do not admit a single unambiguous ground truth, raising the question of how best to evaluate model performance in such settings. Based on these challenges, we formulated three research questions, which are investigated throughout this work.

The remainder of this chapter is organised as follows. @chp:conclusion:summary addresses each of the research questions defined in @sec:int:challenges. @chp:conclusion:contribution summarises the contributions of this work, and @chp:conclusion:future_work outlines directions for future research.

== Summary <chp:conclusion:summary>


#let researchquestion = thmbox(
  "rq", 
  "Research Question", 
  fill: rgb("#eeeeee"),
  bodyfmt: body => ["#emph[#body]"]
)

// The rapid scaling of #gls("AI") systems across various domains over the last decade increasingly raises the question of whether and for which tasks, they already surpass human performance. Over the years, several comparisons and studies have demonstrated that #gls("AI")-powered automated systems can outperform human participants and even experts in their respective fields. Over the years, scientists have conducted various comparisons @bailer2005joanneum @jiang2011consumer @kumar2009attribute @lake2015human @nowak2011eval @parikh2010role @taigman2014deepface @turnbull2008semantic @weyand2016planet @xiao2010sun and some of these studies have demonstrated that certain #gls("AI")-powered automated systems can outperform human participants and even experts in their respective fields @christiansen2025international @he2015delving. However, it's not only overall performance that matters, but also the agreement among a group of human annotators. If the annotators do not consistently agree, what can we expect from an automated system trained on this data?

#researchquestion(number: "1")[How does the performance of machines in multimedia annotation tasks compare to human performance and what methodologies can be used to determine if a recognition problem is solved at a human level?] <rq_1>


// We utilize the insights gained from our user study, in which we measured the intercoder agreement, for the experiments in subsequent methods for art history. The question is particularly significant for the arts because many representations are at least partly open to interpretation and it can be difficult to reach consensus on some ground truth annotations.

// Research projects aimed at the exploration of art using computer-assisted image processing are significantly more data-limited compared to projects focused on the analysis of photographs. Some of the largest datasets, such as WikiArt @SalehE15, Met @METDataset, or Art500k @art500k, contain only a few hundred thousand images, which is considerably smaller than other commonly used datasets @RussakovskyDSKS15 @LinMBHPRDZ14 @abs-2111-02114 @SchuhmannBVGWCC22. Another factor is that the performance of deep learning classifiers scales with the number and variation of samples per class @HuhAE16. However, most art related datasets contain only a limited number of samples for each individual concept. 

// Although more and more art collections are being digitized and made accessible to the public @Marburg25 @DijkshoornJAOSW18 @Getty24, it remains considerably more challenging to create large-scale datasets of art-historical objects than to collect photographs from the internet. The number of artworks held in collections and museums is naturally limited, and it is inherently impossible to produce new works by artists who have already passed away, which places strict upper bounds on the potential size of such datasets. Another challenge is that the cataloging and analysis of these artworks are typically carried out by experts, making the process highly time-consuming and costly. 

// Therefore, it is crucial to identify ways to enhance the performance of #gls("AI")-based analytical methods for art without relying on more original training examples. One approach could involve using #gls("AI")-methods to generate new training examples, which we can subsequently use to train new models. In doing so, these methods can surpass simple data‑augmentation techniques @CubukZS020 @CubukZMVL19 that merely expand the training set, as they enable a substantially greater variability of the input data. This would enable us, for instance, to generate new artworks by artists who have long since passed away or to apply their style to new content. Another possibility could involve enriching existing datasets with additional labels or completing missing labels using generative #gls("AI").

#researchquestion(number: "2")[How can generative methods be used to create training material for neural network optimization to enhance the performance of computer vision methods in the field of art?] <rq_2>

// By expanding the training data, it becomes possible to train larger models and improve prediction performance @abs-2001-08361 @RosenfeldRBS20 @abs-2010-14701 @FanCKKIT24. However, this approach also has its limitations @FanCKKIT24. For instance, synthetic data generated with generative #gls("AI") may not faithfully represent the desired concept, thereby degrading the overall quality of the dataset. Moreover, automatically synthesizing labels is not always straightforward for every problem, especially for more complex tasks such as iconographic concept classification or pose estimation. To exploit the potential of these possibly error‑laden synthetic data and the unlabeled data, conventional supervised‑learning algorithms are not ideally suited and alternative approaches must be evaluated. Semi‑supervised learning techniques @SohnBCZZRCKL20 @BerthelotCCKSZR20 @BerthelotCGPOR19, which rely on only a small part of the training set being annotated, can play a particularly important role in this context.

#researchquestion(number: "3")[How can we use alternative learning methods such as semi-supervised learning to further scale computer vision for art historical tasks without relying on more annotated training data?] <rq_3>

== Contribution <chp:conclusion:contribution>

The contributions of this dissertation can be summarized as follows:

+ Analyze machine learning performance in comparison to human performance
  + Surveying and comparing human and machine performance in the task of visual concept detection
  + Conducting a comprehensive user study to evaluate image annotation performance between human annotator and machine learning methods
  + Introducing the concept of inter-coder reliability as an evaluation metric to directly compare human and machine agreement in art-historical concept recognition
  + Proposing an evaluation methodology that allows for the systematic evaluation of machine performance at a human level
+ Introducing novel methodologies for the visual analysis of art-historical objects
  + Introducing the `CAT` classifier #gls("HMC") approach based on a transformer architecture for classifying iconographic concepts using the #gls("Iconclass") taxonomy
  + A two-stage transformer pipeline for human pose estimation that leverages semi-supervised learning to adapt to the art-historical domain
  + Exploring style transfer for the generating training samples to close domain gap
  + Validate the use of #gls("LM") and #gls("VLM") for synthesizing image–text pairs for contrastive pre-training
  + An attribute-guided classification system utilizing semi-supervised learning to associate iconographic attributes with representations of saints
+ Creation of multiple datasets for training machine learning methods in art-historical analysis
  + A large-scale dataset for iconographic classification comprising #num[477569] images, #num[1328417] concept annotations, and more than #num[20000] unique #gls("Iconclass") concepts
  + A dataset for pose estimation comprising #num[2859] art-historical images annotated with #num[3514] persons and #num[51645] keypoints
  + A dataset of saint depictions comprising #num[21479] images depicting #num[239] different saints, annotated with #num[343] distinct attributes
+ Creation of a web platform for analyzing and searching art-historical images within a large-scale collection
  + Development of a plugin architecture to support various feature extractors and classifiers
  + Implementation of multiple visualizations for the retrieval results
  + Multi-feature indexing enabling free-text search via #gls("CLIP") alongside visual and structural feature representations
  + Crawling and indexing of large art-historical collections (e.g., Rijksmuseum, Wikidata) comprising roughly one million images
+ Public release of all developed methods, source code, model weights, and datasets


== Limitations and Future Work <chp:conclusion:future_work>

This thesis focuses on methods that improve the automatic analysis of artworks, on evaluating these methods, and on making them available to researchers. In doing so, several research questions arise, not all of which could be addressed in this dissertation, as the field and its associated tasks and questions are too extensive. Some limitations and future extensions are listed in the following sections.

=== Non-Eurocentric Art
<chp:conclusion:future_work:non_europe>
The methods developed and trained in @chp:art rely on highly Eurocentric datasets. While it would be desirable to extend these methods to other artistic traditions, this is constrained by data availability, as most publicly accessible art datasets are Eurocentric. This is largely because they are derived from freely available museum collections, which are predominantly located in Europe or North America (e.g., the Met, the Rijksmuseum, or the Getty Collection). This creates a significant bias in both the training data and the resulting model capabilities @Hakopian24. Moreover, the absence of non-Eurocentric art is not merely a matter of visual variance, but also entails entirely different iconographic and symbolic concepts that are absent from Eurocentric taxonomies. A good example of this is #gls("Iconclass"), which served as the foundation for the methods in @chp:saints and @chp:iconclass. Developed in the Netherlands in the 1940s #footnote[https://huggingface.co/datasets/biglam/brill_iconclass#discussion-of-biases], its scope is limited to Western art @couprie1983iconclass.

To mitigate this bias, we propose the following strategies for future work. (1) Leverage existing non-Eurocentric datasets, or create new ones, to capture more visually diverse cultural traditions. (2) Employ taxonomies that include concepts from non-Eurocentric traditions, complementing the Eurocentric taxonomies used in this thesis. A positive example is #gls("CIT"), which covers Chinese visual culture from the 8th to the 19th century #footnote[https://chineseiconography.org/]. Building on these two directions, future models could be trained on the resulting visual content and extended taxonomies, or use them as unlabeled data within our semi-supervised pipelines, to improve robustness on underrepresented visual traditions.

=== Advance Pre-Training Strategy
<chp:conclusion:future_work:pre_training>

During the development of the various methods in @chp:art, different pretraining strategies were employed. For image classification (@chp:saints), the models were pretrained on ImageNet @russakovsky2015imagenet, while for pose estimation (@chp:pose), COCO 2017 @LinMBHPRDZ14 served as the pretraining corpus. In @chp:iconclass, the original encoder used contrastive image-text pretraining with #gls("CLIP") @RadfordKHRGASAM21. A key limitation shared by all these strategies is that artworks were either entirely absent from the pretraining data or constituted only a negligible fraction of it. To advance research in art-historical analysis and to improve search in iART more broadly, it would be beneficial to develop a foundation model with a dedicated focus on art, which could then serve as a shared backbone for the methods presented in @chp:art and yield more meaningful art-specific embeddings for retrieval (@chp:iart).

We have already begun preliminary experiments toward training an art-specific foundation model. In @chp:iconclass, we generated a synthetic image-text dataset for #gls("Iconclass") and trained a model using contrastive learning. In @chp:iart, we trained a model using the #gls("BYOL") @GrillSATRBDPGAP20 self-supervised learning method on unlabeled art data. Building on these initial experiments, a natural next step would be to consolidate the efforts: either evaluate existing state-of-the-art foundation models for their suitability to the task or train a dedicated art-specific foundation model. To this end, we would consider both self-supervised learning on unlabeled artworks (e.g., #gls("DINO") @SimeoniVSBOJKSYRMHWWDMS26 @OquabDMVSKFHMEA24 @CaronTMJMBJ21, #gls("BYOL") @GrillSATRBDPGAP20, #gls("JEPA") @AssranDMBVRLB23) and weakly supervised learning using a contrastive loss on image–text pairs (e.g., #gls("CLIP") @RadfordKHRGASAM21, #gls("SigLIP") @abs-2502-14786 @ZhaiM0B23). In doing so, we can draw on the datasets collected in our respective approaches and combine them for joint training. Subsequently, we would use the resulting encoder and apply the methods presented in @chp:art to evaluate whether it outperforms the current baselines.


=== Extending iART
<chp:conclusion:future_work:iart>


