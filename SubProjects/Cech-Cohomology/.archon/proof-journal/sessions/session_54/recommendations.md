# Recommendations for the next plan iteration (post-iter-054)

## TOP PRIORITY — Lane 1 D1 reversal signal is TRIGGERED: build the shared L1 bridge as its own lane

`cechAugmented_exact` is now PARTIAL for a 4th consecutive iter (051 object layer → 052 import-cycle →
053 collapse-to-residual → 054 residual *re-shaped* but not closed). The planner's own iter-054 D1
reversal signal — "2nd consecutive Lane-1 PARTIAL with the residual unchanged" — is now met. **Do NOT
re-dispatch `cechAugmented_exact` as-is for a 5th attempt.** The iter-054 prover proved the residual is
**Sub-brick A**, the *same* L1 categorical bridge that keeps `CechAcyclic.affine` open:

> identify `Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)` (degreewise + on differentials).

**Structural corrective (build BEFORE any re-dispatch of either dependent lane):**
1. **Extract the section identification as a standalone foundational lemma** — `Γ(V, pushPullObj F Y) ≅
   ∏_σ Γ(U_σ∩V, F)`. Anchors confirmed available this iter: pushforward half is DEFINITIONAL
   (`Scheme.Modules.pushforward_obj_obj`); remaining = pullback-along-open-immersion sections + backbone
   geometry unpacking of `coverCechNerveOver` + differential match (`sectionCech_objD_apply` /
   `sectionCechProductEquiv` at CechAcyclic.lean:1513 give the alternating-restriction pattern). This
   lemma is reusable by BOTH `cechAugmented_exact` AND `CechAcyclic.affine` — the two lanes share ONE
   irreducible obstruction.
2. **Promote `CombinatorialCech.Dependent`** (`depDiff`/`depHomotopy`/`depDiff_exact`, currently `private`
   to `CechAcyclic.lean`) to a public/importable home. Once (1) lands, Sub-brick B (the prepend-`i_fix`
   contractibility, given a maximal cover member `U'_{i_fix}=V`) is a one-call consumer — but it cannot
   be reached from `CechAugmentedResolution.lean` while the engine is `private`. Consider an
   `effort-breaker` / `refactor` dispatch to relocate it.

This is a route-shape decision (progress-critic territory): consider an `effort-breaker` on the
extracted section-identification lemma and re-running the progress-critic on the merged Lane-1/`affine`
foundation.

## Lane 2 — `_acyclic` residual is the known 02kg change-of-base leaf (multi-iter)

`higherDirectImage_openImmersion_acyclic` is wired axiom-clean down to ONE precisely-typed leaf
(OpenImmersionPushforward.lean:224): `IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)`
for affine `W`, `q>0` = Serre vanishing `Hᵠ(j⁻¹W,H)=0`. Discharging needs (1) `rightDerived`-of-sections
≅ `Ext^q(jShriekOU(j⁻¹W),H)` (corepresentability + `rightDerived`-of-Hom = Ext) and (2) change-of-space
transport `j⁻¹W ≅ Spec Γ(j⁻¹W,𝒪)` to invoke `affine_serre_vanishing`. This is the same machinery the
02kg work used; estimate multi-iter. `_comp` (line 290) is **blocked on `_acyclic`** — do NOT re-dispatch
`_comp` until `_acyclic`'s leaf lands.

## Blueprint coverage debt (planner domain — author prose, I do not)
`archon dag-query unmatched` = 6 nodes: 5 new this iter + the pre-existing dead `CechAcyclic.affine`.
Add `\lean{}`/`\label` blocks (`when there is Lean there must be tex`):

| Lean decl | File | Lean proof depends on |
|---|---|---|
| `AlgebraicGeometry.isZero_homology_of_homotopy_id_zero` | CechAugmentedResolution | `Homotopy.homologyMap_eq`, `HomologicalComplex.homologyMap_id`/`_zero`, `IsZero.iff_id_eq_zero` (all Mathlib). lvb-cechaug recommends promoting it from inline Step-3(d) note to a standalone lemma block with `\uses{lem:cech_augmented_resolution}`. |
| `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` | OpenImmersionPushforward | `isZero_presheafToSheaf_obj_of_isLocallyBijective` + `Presheaf.IsLocallyInjective/Surjective`. **SUBSTANTIVE** — see Bridge (3) correction below. |
| `AlgebraicGeometry.pushforwardSectionsFunctor` | OpenImmersionPushforward | composite `pushforward j ⋙ forget ⋙ restrictScalars 𝟙 ⋙ toPresheaf ⋙ eval(W)` = `Γ(j⁻¹W,-)`. |
| `AlgebraicGeometry.pushforwardSectionsFunctor_additive` | OpenImmersionPushforward | explicit `instAdditiveComp` chain (5-fold composite defeats `infer_instance`). |
| `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` | OpenImmersionPushforward | DUPLICATE of the CechAugmentedResolution copy (import-graph reason). Either reference the canonical copy with a `% NOTE:` or extract to a shared util (see auditor Major below). |

## Blueprint-CORRECTNESS gap (must address — not just coverage) — lvb-openimm major
**Bridge (3) of `lem:open_immersion_pushforward_comp` MISDIRECTS.** The sketch + `\uses{}` (blueprint
line 7643) point to the *objectwise* `lem:isZero_presheafToSheaf_of_locally_isZero`, but the actual proof
**cannot** use it: affine opens are NOT downward-closed in the opens topology, so no single covering sieve
of affines supplies an objectwise-zero family. The prover correctly introduced the *sectionwise*
`isZero_presheafToSheaf_of_sections_locally_zero`. Dispatch a blueprint-writer to (a) add the sectionwise
lemma block, (b) rewrite Bridge (3) + its `\uses{}` to the sectionwise route, (c) explain why the
objectwise form fails. A prover following the current sketch alone would hit this wall blind.

## Blueprint precision gap — lvb-cechaug major
The Step-3(b)+(c) `Homotopy (𝟙 D) 0` obligation inside `cechAugmented_exact` is under-specified: the
blueprint names *what* to prove but not *which Lean constructions* reach it (the `\uses` points at
quasi-iso results, not a packaged `Homotopy` term). A blueprint-writer should name the engine-complex
identification + `cechEnginePrepend`/`cechEnginePrepend_spec` packaging as a `Homotopy`. (This dovetails
with the TOP-PRIORITY extraction above.)

## Code-quality (auditor) — non-blocking
- **Major:** `isZero_of_faithful_preservesZeroMorphisms` is duplicated across `CechAugmentedResolution.lean`
  (`AlgebraicGeometry.`) and `OpenImmersionPushforward.lean` (`CategoryTheory.Functor.`). Both bodies
  identical; OIP copy exists because the sibling isn't in its import chain. Consider extracting to a shared
  `Cohomology/Utils.lean` (refactor dispatch) to avoid future name collision / divergence.
- **Minor:** `hF : F.IsQuasicoherent` is bound but UNUSED in `cechAugmented_exact` (the residual is proven
  F-agnostic/cover-agnostic). Matches the Knowledge-Base note that the prepend homotopy needs no qcoh.
  The hypothesis matches the blueprint statement, so leave it; flag only for post-sorry cleanup. (If the
  protected/downstream P5a consumer does not need qcoh here, a future generalization could drop it.)
- **Minor:** inline `/- Planner strategy: … -/` blocks (CechAugmentedResolution:129, OpenImmersion:111) are
  navigation commentary in-source; harmless, no correctness impact.

## NOT a defect — verified first-hand, do NOT spend effort on it
lvb-openimm flagged the `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` pin (blueprint 7601) as
"broken because the decl is `private`". **This is NOT confirmed:** `lean_verify` resolves the full name
(axiom-clean), and `dag-query unmatched` did NOT list it (the dag matched the pin). Private Lean-4 decls
keep their real qualified name within tooling lookups. No marker change made. (Separately, the planner may
choose to un-`private` it for the P5b consumer per the iter-054 Open flag re `[X.IsSeparated]`, but that is
a downstream-use decision, not a broken-pin fix.)

## Do-NOT-retry / blocked
- `cechAugmented_exact` as-is (5th plain re-dispatch) — blocked on the shared L1 bridge; needs the
  structural extraction above first.
- `higherDirectImage_openImmersion_comp` — blocked on `_acyclic`; do not dispatch standalone.

## Reusable proof patterns discovered this iter
- **`Homotopy (𝟙 D) 0 → IsZero (D.homology p)`** (any preadditive `C`): `(IsZero.iff_id_eq_zero _).mpr` then
  `rw [← homologyMap_id, ho.homologyMap_eq p, homologyMap_zero]`. Now a reusable project lemma
  (`isZero_homology_of_homotopy_id_zero`).
- **Sectionwise sheafification-vanishing** (`isZero_presheafToSheaf_of_sections_locally_zero`): when the
  vanishing locus is NOT downward-closed (e.g. affine opens), use the sectionwise local-injectivity form
  (`s` restricts to 0 on a covering sieve via `x−y` trick) instead of the objectwise `of_locally_isZero`.
- **Additivity of a deep functor composite over `pushforward`**: `infer_instance` fails even at top level
  with bumped `synthInstance.maxHeartbeats`; build an explicit `instAdditiveComp` chain and pass the tail
  instance EXPLICITLY (`@…instAdditiveComp … hpf … i2`). (Already in MEMORY `openimm-acyclic-reduced.md`.)
