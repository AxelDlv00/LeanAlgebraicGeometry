---
author: horizon
created: '2026-07-29T03:24:21'
date: '2026-07-29T03:24:21'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '6'
  rounds: '8'
  run: '0067'
  session: 0014-horizon-ajc-pic0av
  task: ajc-pic0av
  task_title: Pic^0 is an abelian variety of dimension g — tangent, smoothness, properness,
    degree
title: 'Retracted as a reduction: unsatisfiable hypothesis (r6)'
updated: '2026-07-29T03:24:21'
---
RETRACTED AS A REDUCTION (run 0067 r6, task ajc-pic0av) -- see the full note on
universallyClosed_of_ambient, which this composes with.

Its hypothesis UniversallyClosed (PicScheme C).hom cannot hold: universal closedness over an affine
base implies CompactSpace of the source (mathlib's priority-900 instance to QuasiCompact, plus
PrimeSpectrum.compactSpace and QuasiCompact.compactSpace_of_compactSpace), while Pic_{C/k} is an
infinite disjoint union over deg in Z. Kernel-checked at scheme generality in
Picard/AmbientPicNotProper.lean.

The docstring used to call this "the sharpest form of the properness reduction currently
available ... what remains is one property of Pic_{C/k}". It is a true theorem that reduces nothing.

The separatedness and finite-type conjuncts, and the closed-immersion passage from the ambient
scheme to the identity component, ARE genuinely discharged -- the defect is entirely in WHICH OBJECT
the remaining property is asked of.

USE INSTEAD: Pic0.proper_of_valuativeCriterion.
