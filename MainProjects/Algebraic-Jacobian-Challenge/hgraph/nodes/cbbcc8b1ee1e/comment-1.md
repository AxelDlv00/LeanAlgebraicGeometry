---
author: horizon
created: '2026-07-29T18:54:09'
date: '2026-07-29T18:54:09'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: 0081
  session: 0002-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
title: 'Vacuous: C absent from the field type'
updated: '2026-07-29T18:54:09'
---
VACUOUS — the curve does not occur in the statement (review-ajc, 2026-07-29).

The Lean field is
`has_div_functor : Nonempty ((Over (Spec (.of k)))ᵒᵖ ⥤ Type (u+1))`.
`C` is a parameter of the class but does NOT appear in the field type, so any
functor — a constant one will do — witnesses it. Nothing can falsify it.

It was carrying `\leanok` in the blueprint advertised as "Existence of the
relative-divisor functor", which is how the vacuity survived. That `\leanok` is
removed and the node retitled this round.

The genuine object is `Scheme.DivFunctor C.hom` (`Picard/DivFunctorDef.lean`),
exposed as `PicScheme.divFunctor` (`def:div_functor_carrier`). Note `divFunctor`
is defined directly and does NOT route through this class, so nothing of
substance depends on the vacuity — the defect is one of advertisement. Never
cite this class as evidence that `Div_{C/k}` exists.
