= Computer Vision Methods for Art Recognition <chp:art>

The general objective of this thesis is to support art-historical analysis through the use of computer-aided methods. Art historians utilize diverse methodologies to analyze works of art, ranging from formal analysis of visual qualities @Wölfflin1915 to iconographic and iconological interpretations that uncover intended symbolic meanings and the work’s broader social, historical, and cultural significance @panofsky1939. The time-consuming nature of manual annotation by art historians hinders the analysis of larger datasets, particularly given the exponential growth of images within digital collections.

This chapter presents several computational methods designed to address distinct facets of art-historical inquiry. The focus is exclusively on formalist and iconographic approaches that utilize the visual properties of an artwork, excluding analytical methods that require extrinsic data, such as the artist’s biographical background. The methods proposed here evaluate various strategies to enhance performance through semi-supervised or weakly-supervised training techniques. These approaches are necessitated by the limited amount of training data available for each specific task. The structure of this chapter is as follows: it first introduces a framework for the identification of hagiographic depictions based on visual attributes (@chp:saints). Subsequently, it delineates a system for automated pose estimation in artworks (@chp:pose). The chapter concludes with the proposal of a robust system for iconographic concept recognition (@chp:iconclass). Finally, these methods are integrated into an AI-supported platform, enabling art historians to search and evaluate vast selections of artworks efficiently (@chp:iart).

#include "4_1_saints.typ"

#pagebreak(to:"odd")
#include "4_2_pose.typ"

#pagebreak(to:"odd")
#include "4_3_iconclass.typ"