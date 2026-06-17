# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
tsconstruct209

## Design question
The project equips the relative Picard functor with its abelian-group law by
building a tensor product `tensorObj` on `Scheme.Modules X` (sheaves of modules
over the structure sheaf) as `sheafification ∘ PresheafOfModules.Monoidal.tensorObj`,
and then needs `tensorObj_restrict_iso`: ⊗ commutes with restriction along an open
immersion, `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`.
This compatibility lemma has been blocked for 4 consecutive iters. The iter-208
prover established WHY: `tensorObj := sheafification ∘ PresheafTensor` while
`restrict := pushforward`, and relating the two forces the comparison through
`PresheafOfModules.pullback φ`, which is the OPAQUE abstract left adjoint
`(pushforward φ).leftAdjoint` (no sectionwise formula). Closing it now costs
~200–300 LOC across 4 absent Mathlib ingredients (presheaf-level
`pushforwardNatTrans` / `pushforwardCongr` / `pushforwardPushforwardAdj`, and a
strong-monoidal `ModuleCat.restrictScalars`-along-a-ring-iso).

**Is the `sheafification ∘ PresheafOfModules.tensorObj` construction the
Mathlib-aligned shape for obtaining the line-bundle (invertible-sheaf) group law,
or is `tensorObj_restrict_iso`'s difficulty an ARTIFACT of this construction?**
Concretely, evaluate whether a different, cheaper construction makes restriction-
compatibility definitional or trivial:
  (a) For invertible sheaves specifically, define the tensor / group law via local
      trivializations (transition 1-cocycles), where restriction-compatibility is
      free because Čech cocycles restrict;
  (b) The cohomological Picard group `Pic X = H¹(X, 𝒪_X^×)`, whose abelian-group
      structure is automatic (derived-functor / Ext-valued), bypassing ⊗ of
      sheaves of modules entirely;
  (c) Lift Mathlib's `Module.Invertible` / `CommRing.Pic` idiom to schemes via the
      affine-local structure, gluing the affine Picard groups.
For whichever is cheapest, say whether `tensorObj_restrict_iso` is even needed in
that formulation, and what the project would have to build.

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:199–202` — `tensorObj` (= `sheafification ∘ PresheafOfModules.Monoidal.tensorObj`).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:330–399` — `tensorObj_restrict_iso` (3 reduction steps + residual `sorry`; the blocked lemma).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:438–453` — `exists_tensorObj_inverse`, `tensorObjOnProduct` (line-bundle cone consumers).
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:235–269` — `addCommGroup` (the consumer the whole cone discharges) + placeholder `PicSharp := const PUnit` (L327), `functorial := 0` (L372).
- `AlgebraicJacobian/Picard/LineBundlePullback.lean` — `LineBundle.IsLocallyTrivial` (the project's `Module.Invertible`-shaped predicate) + `OnProduct` carrier.
- `informal/tensorObj_restrict_iso.md` — the iter-208 4-ingredient decomposition.
- Prior analogies (READ THESE — do not re-derive): `analogies/ts-design206.md` (established: build group law on line-bundle subcategory via 4 existence-of-iso lemmas; Mathlib idiom `CommRing.Pic = Units (Skeleton …)`, `Module.Invertible`), `analogies/tsroute208.md` (the open-immersion route, now disproven for the construction reason above), `analogies/mate207.md`.

## Why now
Lane TS is the sole USER-permitted productive lane on the critical path to the
PRIMARY GOAL (A.2.c Pic representability). It has churned 4 iters on
`tensorObj_restrict_iso`, each iter disproving a fresh "almost there" framing.
Before either grinding through the 4-ingredient ~200–300 LOC mathlib-build OR
abandoning the lane, the planner needs to know whether the difficulty is intrinsic
to the line-bundle group law (in which case the build is unavoidable) or an
artifact of the `sheafification ∘ PresheafTensor` construction (in which case a
cheaper construction sidesteps `tensorObj_restrict_iso` entirely). This is the
"design-shape suspected" structural consult.

## Hints (optional)
- Mathlib namespaces to survey: `Mathlib.RingTheory.PicardGroup` (`CommRing.Pic`,
  `Module.Invertible`), `Mathlib.AlgebraicGeometry.Modules.Sheaf`
  (`Scheme.Modules`, `restrict_obj`/`restrict_map`), `Mathlib.AlgebraicGeometry`
  (is there a `Scheme.Pic` / invertible-sheaf group? check `TODO` at
  `PicardGroup.lean` line ~59 which reportedly lists "connect to invertible
  sheaves" as unbuilt), sheaf cohomology (`H¹`, `Mathlib.CategoryTheory.Abelian.Ext`).
- The project already has substantial sheaf-cohomology machinery
  (`AlgebraicJacobian/Cohomology/*`: Čech, Mayer–Vietoris, `HModule`) — but for
  `ModuleCat k`-valued cohomology, NOT for the multiplicative sheaf `𝒪_X^×`.
  Assess honestly whether route (b) reuses any of it or needs fresh `𝒪_X^×` infra.
- Key prior finding to respect: `tensorObj_restrict_iso` is TRUE for arbitrary
  M, N (no flatness needed); the blocker is purely the opaque-`pullback`
  construction, not exactness (`ts-design206`'s flat-exactness reduction was wrong).

## Severity expectation
high-stakes — this design is load-bearing for the entire critical path (TS → RPF → A.2.c) and has already absorbed 4 iters.
