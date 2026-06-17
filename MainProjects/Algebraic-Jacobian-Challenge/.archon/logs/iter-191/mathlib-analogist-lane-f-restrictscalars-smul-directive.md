# Mathlib analogist — Lane F `restrictScalars` smul-unfold chaining

## Mode: api-alignment

The Lane F route (`Picard/QuotScheme.lean`) is CHURNING per the
progress-critic iter-191 verdict: 5 consecutive flat iters at 13
sorries; PARTIAL prover status in the last 2 iters; the iter-190
prover correctly identified the residual gap as
`ModuleCat.restrictScalars` smul unfolding + Stacks 01HH-style
structure-sheaf compatibility, with all ingredients present in
Mathlib b80f227. The diagnostic is precise: the gap is "careful
chaining" of existing lemmas, not missing infrastructure.

Per the progress-critic primary corrective:

> **Mathlib analogy consult** — The iter-190 prover correctly
> identified that the Step 3 failure is in `ModuleCat.restrictScalars`
> smul unfolding + Stacks 01HH-style structure-sheaf compatibility,
> and that both ingredients exist in Mathlib b80f227. The gap is
> "careful chaining," not missing lemmas.

## The specific question

In `Picard/QuotScheme.lean` L650, the theorem
`pullback_of_openImmersion_iso_restrict` builds a `LinearEquiv`
between the section-level pullback of a sheaf-of-modules and its
restrict-along-open-immersion. The AddEquiv part of this LinearEquiv
is fully built (iter-190 prover SUCCESS). The smul-compatibility leg
is what remains.

Concretely: starting from a section `r : Γ(Spec(Γ(Y, U)), ⊤)` and
the scheme-level pullback structure, prove the identity

```
Y.presheaf.map (eqToHom hImg.symm).op
  ((hU.fromSpec.appIso ⊤).inv ((ΓSpecIso _).inv.hom r))
  = r
```

combined with `Scheme.Modules.map_smul` to pull algebra-map images
through the presheaf restriction. The bridges identified by the
iter-190 prover:

- `Scheme.Hom.appLE_appIso_inv` (`OpenImmersion.lean:229`):
  `f.appLE U V e ≫ (f.appIso V).inv = Y.presheaf.map (homOfLE _).op`
- `IsAffineOpen.fromSpec_app_self` (`AffineScheme.lean:561`):
  `hU.fromSpec.app U = (ΓSpecIso _).inv ≫ (Spec _).presheaf.map (eqToHom _).op`
- `Hom.appLE` definition unfolds
  `appLE U V e = app U ≫ Y.presheaf.map (homOfLE e).op`.
- `ModuleCat.restrictScalars.smul_def` (`ChangeOfRings.lean`) for the
  bridge between Γ(Spec)-smul on `Γ(N.restrict, ⊤)` and Γ(Y, image)-smul
  on `Γ(N, hU.fromSpec ''ᵁ ⊤)`.

The prover's report estimates ~30-60 LOC iter-191 closure. The
question is: what is the CANONICAL Mathlib chaining order? Is there
a high-level lemma (e.g. `Scheme.Modules.restrictFunctorIsoPullback`
naturality at sections, or a specific naturality wrapper around
`Hom.app_smul`) that the project should be reaching for here
instead of manually fusing 4-5 sub-bridges?

## Failed approaches

- iter-189: 2 new typed-sorry pins (`tildeIso_of_isQuasicoherent_isAffineOpen`,
  `pullback_of_openImmersion_iso_restrict`) introduced as part of an
  analogist-licensed unbundle. **Why it failed to close**: the
  pin signatures decompose the work but each pin still requires the
  same compositional bookkeeping; the unbundle deferred the work to
  the body level.
- iter-190: AddEquiv chain fully built; smul-via-`Hom.app_smul`
  migrated; residual scoped to the ring-identity + restrictScalars
  smul-unfold. **Why it failed to close**: the prover identified all
  needed bridges but did not find a clean chaining path within the
  iter budget.

## Search radius: narrow

The question is specifically about Mathlib's `ModuleCat`-and-`Sheaf`
infrastructure. Look at:

- `Mathlib.Algebra.Category.ModuleCat.ChangeOfRings` — restrictScalars
  smul / extendScalars adjunction.
- `Mathlib.AlgebraicGeometry.Modules.Sheaf` —
  `Scheme.Modules.Hom.app_smul`, `restrictFunctorIsoPullback`,
  `restrict_obj`.
- `Mathlib.AlgebraicGeometry.OpenImmersion` —
  `appLE_appIso_inv`, `appIso_inv_app_eq_app`,
  `Hom.appLE` definition.
- `Mathlib.AlgebraicGeometry.AffineScheme` —
  `IsAffineOpen.fromSpec_app_self`, `IsAffineOpen.opensRange_fromSpec`,
  `IsAffineOpen.preimage`.

If Mathlib already has a high-level lemma that says
"pullback-along-open-immersion of a sheaf-of-modules is naturally
isomorphic to its restrict-along-open-immersion as a LinearEquiv of
sections at `⊤`", that's the canonical idiom and the project should
consume it. If Mathlib only has the pieces and the project must fuse,
the chaining order matters.

## What you might find

Possible outcomes:

(A) **A clean Mathlib lemma exists** at the LinearEquiv level (e.g.
  `Scheme.Modules.restrictFunctorIsoPullback_top_linearEquiv` or
  similar). The project should consume it directly; the iter-191
  Lane F prover would then close in ~5 LOC by `exact <lemma>`.

(B) **No high-level lemma exists**, but the chaining sequence is
  clear and the iter-190 prover's identified bridges are exactly
  the right ones in exactly the right order. The project should
  proceed with the existing recipe; the iter-192 prover dispatch
  is licensed.

(C) **No clean Mathlib idiom**; the residual is a project-bespoke
  fusion that the project owns. The project should consider
  refactoring the section-level LinearEquiv carrier (e.g. defining
  the LinearEquiv via the sheaf-level iso and only `Hom.app`-ing at
  the boundary) to expose a cleaner shape.

## Expected output

Per the api-alignment mode contract, your report should:

- Identify the Mathlib idiom (if any) at the LinearEquiv level for
  pullback-along-open-immersion vs restrict-along-open-immersion of
  sheaves of modules.
- If no high-level lemma, name the canonical chaining sequence:
  which Mathlib lemmas in which order, with the type-of-each-bridge
  spelled out.
- If a project refactor would expose a cleaner shape (outcome C),
  describe the refactor: which carrier should the LinearEquiv be
  defined through, what shape would the bodies then take.
- Verdict: **PROCEED** (recipe correct as-is) | **ALIGN WITH MATHLIB**
  (consume a high-level lemma) | **REFACTOR** (project carrier
  needs reshape).

Persist the report to `analogies/lane-f-restrictscalars-smul.md` (your
write-domain includes `analogies/**`) AND write your task_results
report to `task_results/mathlib-analogist-lane-f-restrictscalars-smul.md`.

## Why we're asking

The iter-191 plan DEFERS the Lane F prover dispatch to iter-192,
contingent on your verdict. If you return PROCEED with a clean
chaining sequence, iter-192 dispatches the prover with the sequence
in the directive. If ALIGN WITH MATHLIB, iter-192 dispatches the
prover with the named lemma. If REFACTOR, iter-192 plan-phase first
dispatches a refactor subagent for the carrier reshape, then iter-193
prover. The progress-critic specifically flagged "dispatching another
prover without the analogy consult risks a 6th flat iter" — your
verdict averts that risk.
