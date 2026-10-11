#import "@preview/ctheorems:1.1.3": *
#import "@preview/glossarium:0.5.3": gls, glspl 
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": flex-heading, flex-figure, flex-super, flex-grid
#import "../helper/enviroments.typ": info_with_bib, info
#import "@preview/zero:0.7.0": num, format-table, zi, set-round


#let researchquestion = thmbox(
  "rq", 
  "Research Question", 
  fill: rgb("#eeeeee"),
  bodyfmt: body => ["#emph[#body]"]
)


= Conclusions and Future Work <chp:conclusion>

Recent advances in automatic content analysis and machine learning have made it increasingly feasible to apply complex and precise analytical methods to ever-larger datasets. Nevertheless, these methods are often neither optimized for specific domains nor readily accessible to domain experts who lack the technical expertise or infrastructure to deploy them. Art history, in particular, poses unique challenges: datasets are small and highly heterogeneous in style, ground-truth annotations are scarce, and the interpretive nature of the subject resists purely quantitative approaches.

Given these challenges, this thesis pursues two main objectives: (1) improving automatic analysis methods for art history, and (2) making these methods accessible to the art history community. A central challenge is that, for many tasks in art history, no sufficiently large annotated datasets exist to train modern machine learning models, necessitating alternative approaches. Furthermore, some research questions in art history do not admit a single unambiguous ground truth, raising the question of how best to evaluate model performance in such settings. Based on these challenges, we formulated three research questions, which are investigated throughout this work.

The remainder of this chapter is organised as follows. @chp:conclusion:summary addresses each of the research questions defined in @sec:int:challenges. @chp:conclusion:contribution summarises the contributions of this work, and @chp:conclusion:future_work outlines directions for future research.

== Summary <chp:conclusion:summary>

This section addresses the three research questions introduced in @sec:int:challenges. In order to answer these research question we reflect over the developed methodologies and findings from the work presented throughout this thesis. The following sections each focus on a research question and describes the main findings.

=== Benchmarking Machines Against Human Annotators
<chp:conclusion:summary:rq1>

Driven by the continuous development of #gls("AI") methods for visual content analysis and classification, the question increasingly arises whether machines can match or even surpass human performance @bailer2005joanneum @jiang2011consumer @kumar2009attribute @lake2015human @nowak2011eval @parikh2010role @taigman2014deepface @turnbull2008semantic @weyand2016planet @xiao2010sun. In recent years, several studies have reported that their approaches outperform human annotators @christiansen2025international @he2015delving. However, another crucial question, particularly relevant to the art domain, is how these methods behave when annotators fail to reach a high degree of agreement on a given task. How is model performance affected under such conditions?

#researchquestion(number: "1")[How does the performance of machines in multimedia annotation tasks compare to human performance and what methodologies can be used to determine if a recognition problem is solved at a human level?]

To answer this question, we analyzed existing literature and conducted an empirical annotation study in @chp:what. A total of #num("23") participants annotated #num("1159") images, and we compared their annotations against state-of-the-art results on this benchmark. The study evaluated two conditions: a group of #num("18") participants annotated the images without the official benchmark guidelines, while #num("5") participants annotated with the guidelines provided. The results indicate that the use of annotation guidelines did not yield a statistically significant improvement.  

To evaluate annotator consistency, intercoder agreement was measured using Krippendorff's $alpha$ and compared with the performance of two AI methods. We found that the category recognition performance of the AI methods correlates with the class level intercoder agreement of the annotators.  

=== Generative Methods for Training Material
<chp:conclusion:summary:rq2>

#researchquestion(number: "2")[How can generative methods be used to create training material for neural network optimization to enhance the performance of computer vision methods in the field of art?]

[How can generative methods be used to create training material for neural
network optimization to enhance the performance of computer vision methods
in the field of art?]

=== Semi- and Self-Supervised Learning for Art-Historical Analysis
<chp:conclusion:summary:rq3>

#researchquestion(number: "3")[How can we use alternative learning methods such as semi-supervised learning to further scale computer vision for art historical tasks without relying on more annotated training data?]

// Machine vs. human performance in image tagging was directly compared in a controlled setting rather than via crowdsourcing, using 23 student participants who manually annotated 1,159 images.
// Two experiments were conducted under different annotation protocols: one without formal guidelines (common-sense judgment, 18 participants), and one using the PASCAL VOC annotation guidelines (5 participants) — the study found that using formal guidelines did not significantly improve inter-coder agreement.
// Inter-coder reliability (Krippendorff's α) was introduced as the key evaluation metric, applied both between human annotators and between humans and machine-generated tags, allowing a direct, comparable measure of agreement across both groups.
// To formalize what "human-level" performance means, the paper proposes two novel indices:
// the Human-Level Performance Index (HLPI), and
// the Human-Level Performance Ranking Index (HLPRI)
// — together providing a systematic, quantifiable methodology to determine whether a machine's output has reached (or exceeded) human-level agreement on a given recognition task.
// This approach reframes the question "are machines better than humans?" as an empirical, measurable comparison rather than a subjective judgment — enabling a formal answer to whether a given recognition problem (e.g., visual concept/tag detection) can be considered solved at human level.
// The methodology is explicitly proposed as generalizable beyond image tagging — applicable to other visual recognition tasks where human and machine annotations can both be collected and compared via inter-coder agreement.
// Later work in the same research group builds on this human-vs-machine perspective in more specialized settings, e.g., small-scale user studies evaluating the retrieval quality of automatically predicted human poses in art, and qualitative validation of automatically predicted iconographic concepts with domain experts — extending the original methodology's spirit (systematic human comparison) into more complex, domain-specific recognition tasks rather than the general "level" indices themselves.

#researchquestion(number: "2")[How can generative methods be used to create training material for neural network optimization to enhance the performance of computer vision methods in the field of art?] <rq_2>

// Style transfer as data augmentation was used across multiple chapters to synthesize art-styled training images from non-art source data, closing the domain gap between natural-image datasets and the art-historical domain:
// In the saints/attribute-classification work, neural style transfer was applied to photographic attribute images (sourced via Google Image Search) to make them visually resemble art-historical depictions, alongside DeepLabv3-based segmentation/cropping to isolate relevant objects before stylization.
// In the pose-estimation work, the style-transfer method of Chen et al. was applied to bounding-box/keypoint-annotated data to generate additional artistically-styled training examples for the person detector and keypoint estimator.
// Semi-supervised (teacher-student) learning pipelines were used to combine a limited set of labeled art-historical data with larger amounts of unlabeled or weakly-labeled/generated data:
// The pose-estimation pipeline used a two-stage Transformer architecture trained semi-supervised, allowing it to bootstrap from labeled COCO-style data and generalize to the art domain without requiring large-scale manually annotated art data.
// The saints/attribute pipeline used a FixMatch-based semi-supervised approach to jointly learn saints and their associated iconographic attributes, again reducing dependence on manually labeled art-historical examples.
// Synthetic image–text pair generation for vision-language pretraining: for large-scale iconographic classification, three strategies (keyword-based, language-model-based, and vision-language-model-based) were used to automatically generate textual descriptions for art-historical images, creating synthetic image–text pairs that were then used to contrastively pretrain a CLIP-style vision-language model — addressing the lack of naturally occurring, high-quality art-specific captions.
// Rationale across all approaches: because large, manually annotated art-historical datasets are costly and difficult to produce, all three chapters converge on the same underlying strategy — using generative or semi-supervised techniques to expand or synthesize training material (images, labels, or captions) rather than relying solely on scarce, fully manually annotated art data.
// Observed effect on performance: applying style-transfer-generated data noticeably improved downstream performance in both the saints and pose-estimation tasks, with the performance gain being more pronounced for pose estimation than for the saints/attribute classification task — suggesting that the benefit of generative training data may depend on the specific recognition task and how much structural precision (e.g., keypoint accuracy) the task demands.
// Open limitation motivating future work: despite these gains, generated/stylized training data does not fully close the domain gap — motivating the thesis's proposed future direction of exploring more advanced generative techniques (e.g., diffusion-based models) as a next step beyond the feed-forward style-transfer methods used in this dissertation.

#researchquestion(number: "3")[How can we use alternative learning methods such as semi-supervised learning to further scale computer vision for art historical tasks without relying on more annotated training data?] <rq_3>

// Semi-supervised human pose estimation (@chp:pose): A two-stage Transformer pipeline (person detection → keypoint estimation) was trained using a teacher-student semi-supervised approach, allowing the model to leverage a small set of manually annotated art-historical pose data (PoPArt) alongside larger amounts of unlabeled or pseudo-labeled art images — reducing reliance on costly, fully manual keypoint annotation in the art domain.
// The person-detection stage initialized from a COCO-2017-pretrained DETR model, then adapted to the art domain via semi-supervised fine-tuning rather than requiring an art-specific labeled detection dataset from scratch.
// Semi-supervised attribute-guided classification (@chp:saints): A FixMatch-based semi-supervised method was used to jointly classify saints and associate them with iconographic attributes, combining a limited set of labeled saint depictions with larger amounts of weakly labeled or unlabeled attribute imagery (sourced via image search and adapted with segmentation and style transfer) — again scaling the approach without requiring exhaustive manual annotation of every saint/attribute combination.
// Self-supervised feature learning for retrieval (@chp:iart): The iART platform's domain-adapted feature extractor was trained using BYOL (Bootstrap Your Own Latent), a self-supervised method requiring no labels at all, on unlabeled Wikimedia art images — demonstrating that even fully unlabeled art data can be leveraged to produce useful, art-specific visual representations for search and retrieval, entirely independent of annotation effort.
// Common rationale across all three: each method addresses the same core constraint — art-historical annotation is expensive and requires domain expertise (e.g., iconographic knowledge, familiarity with saints' attributes), so scaling purely through more labeled data is impractical. Semi- and self-supervised learning instead let the models exploit the comparatively abundant unlabeled art imagery available from digitized museum collections.
// Proposed extensions in future work: the dissertation explicitly proposes extending this same semi-supervised strategy further:
// Using diffusion-generated (text-prompted) images as additional unlabeled input to the existing semi-supervised pipelines, e.g., for attribute learning in the saints task — treating generative models as a scalable source of unlabeled data rather than only labeled data.
// Using non-Eurocentric art data or extended taxonomies (e.g., the Chinese Iconography Thesaurus) as unlabeled data within the same semi-supervised pipelines, to improve robustness on underrepresented visual traditions without requiring newly annotated non-Western datasets.
// Overall picture: across classification, pose estimation, and retrieval, the dissertation treats semi-/self-supervised learning not as a one-off technique but as a reusable scaling strategy, applied consistently to reduce dependence on scarce annotated art data, and explicitly earmarked as the mechanism through which future extensions (generative data, non-Eurocentric traditions) are meant to be integrated as well.

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
The methods developed and trained in @chp:art rely on highly Eurocentric datasets. While it would be desirable to extend these methods to other artistic traditions, this is constrained by data availability, as most publicly accessible art datasets are Eurocentric. This is largely because they are derived from freely available museum collections, which are predominantly located in Europe or North America (e.g., the Met, the Rijksmuseum, or the Getty Collection). This creates a significant bias in both the training data and the resulting model capabilities @Hakopian24. Moreover, the absence of non-Eurocentric art is not merely a matter of visual variance, but also entails entirely different iconographic and symbolic concepts that are absent from Eurocentric taxonomies. A good example of this is #gls("Iconclass"), which served as the foundation for the methods in @chp:saints and @chp:iconclass. Developed in the Netherlands in the 1940s #footnote[#link("https://huggingface.co/datasets/biglam/brill_iconclass#discussion-of-biases"), accessed: 2026-08-16.], its scope is limited to Western art @couprie1983iconclass.

To mitigate this bias, we propose the following strategies for future work. (1) Leverage existing non-Eurocentric datasets, or create new ones, to capture more visually diverse cultural traditions. (2) Employ taxonomies that include concepts from non-Eurocentric traditions, complementing the Eurocentric taxonomies used in this thesis. A positive example is #gls("CIT"), which covers Chinese visual culture from the 8th to the 19th century #footnote[https://chineseiconography.org/]. Building on these two directions, future models could be trained on the resulting visual content and extended taxonomies, or use them as unlabeled data within our semi-supervised pipelines, to improve robustness on underrepresented visual traditions.


=== Advance Pre-Training Strategy
<chp:conclusion:future_work:pre_training>

During the development of the various methods in @chp:art, different pretraining strategies were employed. For image classification (@chp:saints), the models were pretrained on ImageNet @russakovsky2015imagenet, while for pose estimation (@chp:pose), COCO 2017 @LinMBHPRDZ14 served as the pretraining corpus. In @chp:iconclass, the original encoder used contrastive image-text pretraining with #gls("CLIP") @RadfordKHRGASAM21. A key limitation shared by all these strategies is that artworks were either entirely absent from the pretraining data or constituted only a negligible fraction of it. To advance research in art-historical analysis and to improve search in iART more broadly, it would be beneficial to develop a foundation model with a dedicated focus on art, which could then serve as a shared backbone for the methods presented in @chp:art and yield more meaningful art-specific embeddings for the iART image retrieval in @chp:iart.

We have already begun preliminary experiments toward training an art-specific foundation model. In @chp:iconclass, we generated a synthetic image-text data set for #gls("Iconclass") and trained a model using contrastive learning. In @chp:iart, we trained a model using the #gls("BYOL") @GrillSATRBDPGAP20 self-supervised learning method on unlabeled art data. Building on these initial experiments, a natural next step would be to consolidate the efforts: either evaluate existing state-of-the-art foundation models for their suitability to the task or train a dedicated art-specific foundation model. To this end, we would consider both self-supervised learning on unlabeled artworks (e.g., #gls("DINO") @SimeoniVSBOJKSYRMHWWDMS26 @OquabDMVSKFHMEA24 @CaronTMJMBJ21, #gls("BYOL") @GrillSATRBDPGAP20, #gls("JEPA") @AssranDMBVRLB23) and weakly supervised learning using a contrastive loss on image–text pairs (e.g., #gls("CLIP") @RadfordKHRGASAM21, #gls("SigLIP") @abs-2502-14786 @ZhaiM0B23). In doing so, we can draw on the datasets collected in our respective approaches and combine them for joint training. Subsequently, we would use the resulting encoder and apply the methods presented in @chp:art to evaluate whether it outperforms the current baselines.


=== Exploring Advanced Generative Methods
<chp:conclusion:future_work:generate_method>

All methods in @chp:art employ generative models to produce synthetic training data. When we applied the style-transfer method of Ghiasi et al. @GhiasiLKDS17 in @chp:saints and the style-transfer method of Chen et al. @chen2021artistic in @chp:pose, we observed that the quality of the generated images increased substantially, and the resulting performance gains were more significant in @chp:pose than in @chp:saints. These positive developments motivate us to explore more advanced approaches to generating both training images and their annotations.

A first direction is the use of diffusion-based models @RombachBLEO22 for the synthesis. We see two complementary ways in which we could apply this image generation technique: (1) Images generated solely on a text prompt could be used as unlabeled input to our semi-supervised learning pipelines, e.g., generating additional images for attribute learning in the saints classification task (@chp:saints). (2) Using a conditional generative approach @ZhangRA23, where we could specify additional parameters, e.g., individual joint positions for pose estimation, and use these resulting images directly for supervised learning @WengSY24 @abs-2403-08650 (@chp:pose).

A second, complementary direction concerns the annotations themselves rather than the images. The datasets used and created in this thesis were built from museum collections, each annotated according to a different metadata schema. Some of the museum samples are also accompanied by more or less detailed textual descriptions. However, not all of this informations is used for the training and some describe properties that are not visually apparent in the artwork itself, e.g., place of origin, time of creation, artist, or physical dimensions. Building on the work of Conde and Turgutlu @CondeT21 and our own approach in @chp:iconclass, it would be worth extending the use of #gls("VLM")s to automatically generate annotations that more accurately capture an artwork's visual content, e.g., for use in contrastive pretraining (@chp:conclusion:future_work:pre_training).

=== Extending iART
<chp:conclusion:future_work:iart>

The iART web platform, which was introduced in @chp:iart, has been under development for several years and is actively used by the community for research and teaching. The further development of iART can be summarized as follows:

#strong[Increase Collection] The corpus currently indexed in iART contains over one million images drawn from five collections, along with their associated metadata. This corpus should be expanded in the near term with additional collections, e.g., the Met#footnote[#link("https://www.metmuseum.org"), accessed: 2026-08-16.], Europeana#footnote[#link("https://www.europeana.eu"), accessed: 2026-08-16.], the Getty#footnote[#link("https://www.getty.edu"), accessed: 2026-08-16.], and the Städel#footnote[#link("https://www.staedelmuseum.de/"), accessed: 2026-08-16.]. As mentioned in @chp:conclusion:future_work:non_europe, we will also place increased emphasis on incorporating non-Western art traditions when expanding the collection.

#strong[Extension of the Analysis Methods] In the version of iART described in @chp:iart, only feature extraction and image classification are currently supported. We plan to extend the analysis capabilities of the tool in different ways. (1) Handling more complex analysis approaches where the output is not just a label or a single vector, e.g., pose estimation, object localization, scene graph generation, or caption generation. Another important point is the integration of #gls("LLM") and #gls("VLM") into the tool to allow researchers a more interactive analysis of the results.

#strong[Improve User Experience] The iART tool already provides a clean search interface with multiple ways to execute a search, as well as basic result visualization. However, building on the discussion above, more advanced visualization methods are needed to effectively display poses, bounding boxes, and generated captions for the search results. These new visualizations, along with the additional information they provide, should also enhance the explainability of the result list. Additionally, we plan to extend iART to support user feedback collection and to serve as an evaluation platform for the new analysis methods and visualizations we intend to integrate into the platform.