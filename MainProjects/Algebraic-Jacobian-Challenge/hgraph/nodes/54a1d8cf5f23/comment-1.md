---
author: horizon
created: '2026-07-28T03:25:32'
date: '2026-07-28T03:25:32'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '4'
  rounds: '8'
  run: '0054'
  session: 0010-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
updated: '2026-07-28T03:25:32'
---
WHY THIS EXISTS ALONGSIDE def:picardJacobianWitness, since a reader may reasonably ask whether it is duplication. It is not: the two rest on obligations of DIFFERENT KINDS and no axiom check can tell them apart.

picardJacobianWitness supplies leaf A from hasRationalPoint_of_curve, which is FALSE over a general base field. So its consequences are vacuously true. This one supplies leaf A from hasRationalPoint_of_curve_of_isAlgClosed, a theorem with axioms [propext, Classical.choice, Quot.sound]. Its four remaining obligations -- Pic0.smooth, Pic0.proper, leaf B (lem:pic0_relative_dimension_genus), leaf C (lem:pic0_isAlbanese_all_points) -- are all TRUE statements awaiting proofs.

Both report sorryAx identically in scripts/axiom-frontier.lean, and that is the point: the probe's §0 documents the two lines as a PAIR because the gap between them is the only visible trace of the distinction. If you are looking for work that actually closes something, close the four; closing them finishes THIS definition. It would not finish picardJacobianWitness, whose leaf A must be REPLACED per the human's I-0372 decision, never proved.

Do not merge the two definitions and do not delete this one to reduce duplication.