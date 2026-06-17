# Mathlib-analogist directive — iter-208

## Mode: api-alignment

## Decision at stake

Lane TS has spent 4 iters trying to prove one isomorphism via an
abstract-adjoint comparison-map (mate δ) route, which is now definitively
blocked. Before I (the planner) commit a blueprint rewrite + prover round to a
**re-route**, I need you to tell me which route is the Mathlib-idiomatic,
bounded one — and whether its prerequisites exist in Mathlib today (commit
`b80f227`) or are an absent multi-file build.

## The declaration to close

In `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`:

```
noncomputable def tensorObj_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M N : X.Modules) :
    (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)
```

where `X.Modules := SheafOfModules X.ringCatSheaf` and
```
tensorObj M N := sheafification (R := X.ringCatSheaf)
                   (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val)
```
`.restrict f` is pullback along the open immersion `f` (= `restrictFunctor`),
and `LineBundle.IsLocallyTrivial M` means M is, around each point, isomorphic
to the structure sheaf on an affine open (locally free of rank 1).

This `def` is NOT in `archon-protected.yaml` — I may add hypotheses to it.

## Why the previous (δ) route died

The proof reduced (via the present Mathlib lemmas
`Scheme.Modules.restrictFunctorIsoPullback` and
`SheafOfModules.sheafificationCompPullback`) to the presheaf-level
base-change iso
`(PresheafOfModules.pullback φ.hom).obj (M.val ⊗ N.val) ≅
 (pullback φ.hom).obj M.val ⊗ (pullback φ.hom).obj N.val`,
i.e. to `(PresheafOfModules.pullback φ.hom).Monoidal` (strong monoidal). Two
walls: (1) the scheme ring presheaf is `RingCat`-valued where there is no
monoidal structure, but `tensorObj` uses the `CommRingCat`-valued
`X.presheaf` — a ring-layer mismatch; (2) `(PresheafOfModules.pullback φ).Monoidal`
(the presheaf-level lift of the sectionwise-Mathlib `ModuleCat.extendScalars`
monoidal structure) is ABSENT in Mathlib at `b80f227`.

## Candidate re-routes — which is bounded & idiomatic?

**(A) Exploit that `f` is an OPEN IMMERSION.** Along an open immersion, pullback
of presheaves of modules is sectionwise *restriction*, and the comparison ring
map `φ` is, on each section/stalk over the image, an *isomorphism* — so
"extension of scalars" is base change along an iso, which is trivially an
isomorphism (no genuine `extendScalars` monoidality needed). Does Mathlib have
the idiom to say "pullback along an open immersion is (strong) monoidal /
commutes with tensor sectionwise because the structure-sheaf map is a local
iso"? Is there a `Scheme.Modules.Hom.isIso_iff_isIso_app` (or stalkwise) lemma
to check a `SheafOfModules` morphism is an iso section-by-section? Name the
exact decls.

**(B) Line-bundle sectionwise.** Add `(hM : LineBundle.IsLocallyTrivial M)
(hN : LineBundle.IsLocallyTrivial N)` (the sole consumer,
`tensorObj_isLocallyTrivial`, already has these in scope to pass). Then on a
common trivialising affine `W`, both sides are `𝒪_W`, and the iso is built
locally then glued. Is this the Mathlib idiom, or is gluing local isos into a
global `SheafOfModules` iso itself a multi-lemma chore here?

## What I need back

1. Whether (A) or (B) (or a third idiom you find) is the **bounded** route, with
   the cost of each.
2. The exact Mathlib/project decl names for the load-bearing steps (e.g. the
   "iso on sections ⇒ iso" lemma for `SheafOfModules`, the
   "pullback-along-open-immersion is sectionwise restriction" lemma, any
   "base change along a ring iso is iso" lemma), tagged present/absent at
   `b80f227`.
3. A blunt verdict: is this iso closable by a `prove`-mode round on the chosen
   route, or does it ALSO bottom out in absent multi-file Mathlib infra (in
   which case I pause TS and pivot)?

Write your persistent analysis to `analogies/tsroute208.md`.
