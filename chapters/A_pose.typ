#import "@preview/zero:0.7.0": num, format-table, zi, set-round
#import "/helper/table_helper.typ": bottomrule, toprule, midrule, cmidrule
#import "/helper/outline_text.typ": flex-heading, flex-figure, flex-grid

== Pose estimation with ground-truth bounding boxes
<chp:appendix:pose:estimation-with-ground-truth-bounding-boxes>

#set-round(precision:4)
#flex-figure(
  {
    show: format-table(none, none,none,auto,auto,auto,auto,auto,auto)
    table(
      columns: 9,
      toprule(),
table.header([Train set] , [Stylized] , [Semi] , $A P$ , $A P_50$ , $A P_75$ , $A P_M$ ,$A P_L$ , $A R$,),

      midrule(),
[COCO 2017] , [0~%] , [] , [0.6969] , [0.9024] , [0.7869] , [0.4612] , [0.702] , [0.7614],
[COCO 2017] , [0~%] , sym.checkmark ,[0.6724] , [0.8961] , [0.7343] , [0.4946] , [0.6764] , [0.7911],
[COCO 2017] , [50~%] , [] , [0.7058] , [0.9187] , [0.7691] , [0.494] , [0.7113] , [0.7868],
[COCO 2017] , [50~%] , sym.checkmark , [0.6943] , [0.9203] , [0.7594] , [0.4795] , [0.7031] , [0.8031],
[COCO 2017] , [100~%] , [] , [0.6981] , [0.9178] , [0.7776] , [0.54] , [0.7047] , [0.783],
[COCO 2017] , [100~%] , sym.checkmark , [0.7005] , [0.9254] , [0.7826] , [0.5449] , [0.7073] , [0.8016],

      midrule(),
[PoPArt] , [0~%] , [] , [0.7552] , $bold(#num[0.9474])$ , $bold(#num[0.8488])$ , $bold(#num[0.5941])$ , [0.7603] , [0.8297],
[PoPArt] , [0~%] , sym.checkmark, $bold(#num[0.7592])$ , [0.9362] , [0.8395] , [0.4884] , $bold(#num[0.7676])$ , $bold(#num[0.8459])$ ,
      bottomrule()
    )
  },
  [Keypoint detection results are reported on the PoPArt test set with annotated ground-truth bounding boxes. $A P_S$ is neglected as no test data is available for small human figures. The best performing approach is indicated in bold.],
  [Keypoint detection on ground-truth bounding boxes],
  label:<tab:appendix:pose:keypoints>
)

To evaluate only the keypoint detection stage, we assess the models'
performance based on the ground-truth bounding boxes from the PoPArt
test set. As the results are not affected by bounding box assignment, we
can thus estimate the best possible prediction outcome. @tab:appendix:pose:keypoints shows the results of each method. We observe
that the semi-supervised learning technique does not affect AP, or only
to a small extent; AR, on the other hand, increases for all methods.
Moreover, we notice that keypoint prediction performs significantly
better with ground truth boxes than with those from an upstream bounding
box detection; AP of the best model increases from #num[0.5258] to #num[0.7592] and
AR from #num[0.7464] to #num[0.8459]. This shows that especially person localization
has to be improved to achieve better results.

#set-round(precision:auto)

== Additional predictions from pose estimators
<additional-predictions-from-pose-estimators>



#flex-grid(
  figure(
    image("/images/pose/iart_pose_examples_app_a.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_a>,
  figure(
    image("/images/pose/iart_pose_examples_app_b.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_b>,
  figure(
    image("/images/pose/iart_pose_examples_app_c.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_c>,
  figure(
    image("/images/pose/iart_pose_examples_app_d.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_d>,
  figure(
    image("/images/pose/iart_pose_examples_app_e.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_e>,
  
  columns: 5,
  long: [Predictions of the different models are overlaid on examples from the PoPArt test data: (a) ground-truth annotations; (b) estimations of OpenPose; (c) predictions of the model trained with COCO 2017 without style transfer and without semi-supervised training; (d) predictions with style transfer; (e) PoPArt trained with semi-supervised learning.],
  short:[Comparison of ground-truth annotations and model predictions],
  label: <fig:examples>,
)


#flex-grid(
  figure(
    image("/images/pose/iart_pose_examples_app_2_a.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_a>,
  figure(
    image("/images/pose/iart_pose_examples_app_2_b.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_b>,
  figure(
    image("/images/pose/iart_pose_examples_app_2_c.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_c>,
  figure(
    image("/images/pose/iart_pose_examples_app_2_d.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_d>,
  figure(
    image("/images/pose/iart_pose_examples_app_2_e.pdf", width: 100%),
    caption:[]
  ), <fig:appendix:pose:examples_e>,
  
  columns: 5,
  long: [Predictions of the different models are overlaid on examples from the PoPArt test data: (a) ground-truth annotations; (b) estimations of OpenPose; (c) predictions of the model trained with COCO 2017 without style transfer and without semi-supervised training; (d) predictions with style transfer; (e) PoPArt trained with semi-supervised learning.],
  short:[Comparison of ground-truth annotations and model predictions],
  label: <fig:examples>,
)


// #figure([#block[
//   #figure(image("/images/pose/iart_pose_examples_app_a.pdf"),
//     caption: [
//       \(a)
//     ]
//   )
//   <fig:examples-gt>

//   #figure(image("/images/pose/iart_pose_examples_app_b.pdf"),
//     caption: [
//       \(b)
//     ]
//   )
//   <fig:examples-openpose>

//   #figure(image("/images/pose/iart_pose_examples_app_c.pdf"),
//     caption: [
//       \(c)
//     ]
//   )
//   <fig:examples-coco>

//   #figure(image("/images/pose/iart_pose_examples_app_d.pdf"),
//     caption: [
//       \(d)
//     ]
//   )
//   <fig:examples-our>

//   #figure(image("/images/pose/iart_pose_examples_app_e.pdf"),
//     caption: [
//       \(e)
//     ]
//   )
//   <fig:examples-our>

//   #figure(image("/images/pose/iart_pose_examples_app_2_a.pdf"),
//     caption: [
//       \(a)
//     ]
//   )
//   <fig:examples-gt>

//   #figure(image("/images/pose/iart_pose_examples_app_2_b.pdf"),
//     caption: [
//       \(b)
//     ]
//   )
//   <fig:examples-openpose>

//   #figure(image("/images/pose/iart_pose_examples_app_2_c.pdf"),
//     caption: [
//       \(c)
//     ]
//   )
//   <fig:examples-coco>

//   #figure(image("/images/pose/iart_pose_examples_app_2_d.pdf"),
//     caption: [
//       \(d)
//     ]
//   )
//   <fig:examples-our>

//   #figure(image("/images/pose/iart_pose_examples_app_2_e.pdf"),
//     caption: [
//       \(e)
//     ]
//   )
//   <fig:examples-our>

//   ]],
//   caption: [
//     Predictions of the different models are overlaid on examples from
//     the PoPArt test data: (a) ground-truth annotations; (b) estimations
//     of OpenPose; (c) predictions of the model trained with COCO 2017
//     without style transfer and without semi-supervised training; (d)
//     predictions with style transfer; (e) PoPArt trained with
//     semi-supervised learning.
//   ]
// )
// <fig:two_stages>
