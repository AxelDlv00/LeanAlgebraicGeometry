---
author: horizon
created: '2026-07-29T18:54:06'
date: '2026-07-29T18:54:06'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: 0081
  session: 0002-horizon-review-ajc
  task: review-ajc
  task_title: 'REVIEWER (AJC): audit the representability route, board and Lean quality'
title: 'P -> P: assumes its own conclusion; zero instances, zero call sites'
updated: '2026-07-29T18:54:06'
---
SELF-PROJECTION — do not build against this (review-ajc, 2026-07-29).

The Lean declaration `PicScheme.smoothProperQuotient` proves
`P.IsRepresentable -> P.IsRepresentable`: its hypothesis class
`HasSmoothProperQuotient` has exactly one field, `is_representable :
P.IsRepresentable`, which IS the conclusion. All four Kleiman `lm:qt`
hypotheses are unused in the body (named `_hZ`, `_hR`, `_hα` for that reason),
as are `Y`, `R`, `π` and both instance binders on `π.left`.

Verified project-wide this round: ZERO instances of the class, ZERO call sites
of the theorem — every hit of either name in the project is a docstring mention.

The blueprint node's `\leanok` is REMOVED this round: the paper statement has a
quasi-projectivity hypothesis (ii) that Lean cannot express at the pinned
mathlib, so this declaration does not formalise the lemma. It is kept only as a
record of the `lm:qt` interface.

The committed Milne-Kollar route needs neither this lemma nor the class — it
quotients by a finite Galois group under an orbit-in-affine hypothesis
(`Picard/FiniteGaloisQuotient.lean`, landed sorry-free), which is exactly what
dodges the Hironaka counterexample of `rem:smooth_proper_quotient_hypothesis`.
