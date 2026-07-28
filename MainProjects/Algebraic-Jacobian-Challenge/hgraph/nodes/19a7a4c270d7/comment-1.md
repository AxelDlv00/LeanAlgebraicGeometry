---
author: horizon
created: '2026-07-29T03:24:04'
date: '2026-07-29T03:24:04'
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
title: 'Retracted as a reduction: the hypothesis is unsatisfiable (r6)'
updated: '2026-07-29T03:24:04'
---
RETRACTED AS A REDUCTION (run 0067 r6, task ajc-pic0av). The theorem is TRUE; its hypothesis is
UNSATISFIABLE at PicScheme C, so it reduces nothing.

Kernel-checked: mathlib has instance (priority := 900) [UniversallyClosed f] : QuasiCompact f
(Morphisms/UniversallyClosed.lean:164 -- which is exactly why IsProper has three fields and no
quasi-compactness one), and Spec k is compact, so QuasiCompact.compactSpace_of_compactSpace gives
CompactSpace (PicScheme C).left. But Pic_{C/k} is a DISJOINT UNION over deg in Z -- the second
clause of Kleiman th:main(1), the very clause HasPicScheme bundles. An infinite disjoint cover by
nonempty opens has no finite subcover.

Generalised and landed sorry-free in Picard/AmbientPicNotProper.lean:
Scheme.not_universallyClosed_of_infinite_disjoint_open_cover and
Scheme.compactSpace_of_universallyClosed. NOT instantiated at PicScheme C -- that needs the degree
decomposition of the scheme into its Pic^d as a family of opens, which AJC lacks (it has
PicScheme.degree but not the splitting). So the retraction is of the ROUTE, argued from a general
theorem, not a formalised refutation of this hypothesis.

RETAINED, not deleted: the closed-immersion transport is correct and is the right lemma for a
FINITE ambient union (e.g. a single Pic^d).

USE INSTEAD: Pic0.proper_of_valuativeCriterion / Pic0.universallyClosed_of_valuativeCriterion,
about (Pic0Scheme C).hom, whose source IS quasi-compact (Pic0.quasiCompact, r0009). What the
roadmap called the fallback was the only route.

FOR THE NEXT SESSION: no sorry census and no axiom probe can detect this class of defect, because a
theorem with an unsatisfiable antecedent is still a theorem. Check that a reduction's hypothesis is
SATISFIABLE on the object it names.
