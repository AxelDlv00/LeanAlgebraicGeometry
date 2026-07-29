---
author: horizon
created: '2026-07-29T21:14:38'
date: '2026-07-29T21:14:38'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '1'
  rounds: '8'
  run: 0081
  session: 0004-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
updated: '2026-07-29T21:14:38'
---
ROUTE CORRECTION 2026-07-29 (review-ajc, kernel-verified): representability of picSharp over an ARBITRARY field is FALSE, not merely open -- and the campaign's last two milestones target it.

MEASURED. Three Lean lines composing ajc-p1's relPresheaf_isSheaf_of_representableBy (Picard/PicEtSubcanonical.lean:173, landed 2026-07-29) with the proved zariskiTopologyOver_le_etaleTopologyOver (Picard/PicEtSheaf.lean:118), via Presieve.isSheaf_of_le:

  representableBy (picSharp C) X  =>  Presieve.IsSheaf (zariskiTopology.over (Spec k)) (picSharp C)

lake env lean EXIT=0, zero diagnostics. Scratch file, deleted; both composed inputs are in-tree. The seam docstring (FGAPicRepresentability.lean:40-44) always asserted this consequence in prose -- it is now checked.

CONSEQUENCE. Kleiman s2 L1292-L1302: picSharp is NOT a Zariski sheaf over a general field. So the campaign's G3 conclusion ('J_r := J'_r/Gamma represents picSharpDeg C r OVER k') and G4's assembly of picSharpDeg contradict Kleiman. They are false as written, not hard.

WHAT SURVIVES: nearly all of it. The obstruction is absent over a separably closed field, where P1-P5, B0-B6, D1'-D4', J1-J5 and G2 all run. The break is exactly the descent step G1/G3 where the field returns to k.

THE REPAIR, no specification change needed: descend picEt, not picSharp. Over k' the two agree (section => Kleiman 2.5, or isIso_picEtComparison_of_isSheaf from representability over k'), so J5's output IS a picEt-representing scheme after base change; the sheaf property picEt HAS and picSharp lacks carries the descent. This reaches clause (1) of this node's theorem with no false intermediate, and prices roadmap AJC.picrep.etale-rep.

NOT MEASURED: whether Kleiman's non-sheaf example applies to a curve meeting this project's exact binders. If it does not, G3 as written is rescued. Full record: inbox I-0951, campaign G3 note, roadmap AJC.picrep.

SEPARATELY, this node's OWN statement is stale in two ways a reader should know: its tex says 'with a k-rational point' and is about Pic^sharp, while the Lean obligation fgaPicardRepresentability is about picEt with NO rational-point binder (protection I-0491). Its meta also reads lean_status=lean_ok, but the Lean body is a bare sorry (FGAPicRepresentability.lean:406).