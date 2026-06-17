# Session 55 (iter-055) — recommendations for the next plan iteration

## CRITICAL — repair the RED build FIRST (must-fix, blocks every prover round)

`CechSectionIdentification.lean` does NOT compile and is imported by the root
`AlgebraicJacobian.lean:15`, so `lake build` fails project-wide. **No prover lane should be
dispatched until this is green.** The errors are all signature-level and trivially repairable
(auditor + both lvb confirm: no deep type error, all 6 stub statements are blueprint-faithful):

1. **`CechSectionIdentification.lean:37`** — move `open ... Scheme.Modules ...` to AFTER
   `namespace AlgebraicGeometry` (line 39). This is the ROOT error; it cascades into the `Over.mk`
   (lines 77, 164) and `evaluation` (line 258) failures. The sibling files
   (`OpenImmersionPushforward.lean`, `CechAugmentedResolution.lean`) place the `open` after the
   `namespace` and compile.
2. **`CechSectionIdentification.lean:126`** — change `∏` to `∏ᶜ` (categorical product in
   `AddCommGrpCat`). Stub 4 (line 203) already uses `∏ᶜ` correctly.
3. After (1), re-check `Over.mk` (lines 77, 164) — likely resolves; if not, qualify/import `Over`.

**This is a fast-path fix, not a proof.** Cheapest action: a short `refactor` or `lean-scaffolder`
directive scoped to those signature fixes (no proof obligation), then re-verify `lake build` green.
The scaffolder/refactor that produced this file should have verified it compiles before wiring the
root import — flag that as the process miss to avoid recurrence.

## Closest-to-completion / promising

### Lane 2 — `OpenImmersionPushforward.lean` `higherDirectImage_openImmersion_acyclic` (line 306)
The geometric corepresentability half is DONE. The remaining leaf is two clean pieces:
- (i) `(preadditiveCoyoneda (op P)).rightDerived q ≅ Ext^q(P,−)` via
  `InjectiveResolution.extAddEquivCohomologyClass ∘ CochainComplex.HomComplex.homologyAddEquiv` —
  pure homological algebra, off-the-shelf (see `analogies/deepbridge.md`).
- (ii) the DOMINANT wall: a **change-of-scheme** Serre vanishing of `Ext (jShriekOU (j⁻¹ᵁW)) H q`
  over the affine `j⁻¹ᵁW` (`q≥1`), i.e. transport `affine_serre_vanishing` /
  `cech_eq_cohomology_of_basis` to a `BasisCovSystem` on the affine scheme `U`. This is genuine new
  work, NOT near-rfl — scope it explicitly before dispatch (the prover's memory note flags (b) as
  dominant). Consider an `effort-breaker` on this leaf.

`_comp` (line 372) is mechanical assembly once `_acyclic` is closed — do NOT dispatch it before.

### Lane 1 — `CechSectionIdentification.lean` Sub-brick A stubs (after the build is green)
Prove bottom-up. Difficulty per the planner-strategy comments + auditor read:
- **Stub 3 `pushPull_leg_sections`** — LOW (three off-the-shelf steps, two `rfl`). Start here.
- **Stub 1 `cechBackbone_left_sigma`** — MEDIUM (geometric bookkeeping; sigma-fibre-product
  distribution + open-immersion intersection).
- **Stub 2 `pushPull_sigma_iso`** — HARD, the single new sheaf-infra leaf (sections over a
  coproduct scheme = product; iterate `TopCat.Sheaf.isProductOfDisjoint` / `coprodPresheafObjIso`).
  This is the genuine multi-iter wall; consider `effort-breaker` if it stalls.
- **Stubs 4/5/6** — assembly. Stub 6 (`cechSection_contractible`) consumes the now-deprivatized
  `CombinatorialCech.Dependent` engine (`depHomotopy`/`depHomotopy_spec`).
Once all 6 land, `CechAugmentedResolution.lean:229` closes by one line:
`exact isZero_homology_of_iso_homotopy_id_zero (cechSection_complex_iso 𝒰 F V) p (cechSection_contractible 𝒰 F V i hiV)`
(the consumer glue is already built + axiom-clean) — re-add the held-back import then.

## Convergence watch (planner: read before re-dispatching Lane 1)
`cechAugmented_exact` has now been PARTIAL for **5 consecutive iters** (051 object → 052
import-cycle → 053 collapse-to-residual → 054 residual re-shaped → 055 residual re-routed into a
new scaffold file). iter-055 was the structural-extraction move the iter-054 review prescribed, so
it is not pure churn — but the residual is still open and now sits behind 6 fresh stubs + a RED
build. The next Lane-1 iter must produce **closed sub-stubs** (start with the LOW/MEDIUM ones), not
another re-route. If Stub 2 stalls ≥2 iters, escalate it to a dedicated effort-break, do not keep
re-dispatching the whole chain.

## Coverage debt — 6 unmatched Lean decls to blueprint (planner authors prose)
`archon dag-query unmatched` lists 7 nodes; 6 are new this iter (1 pre-existing dead
`CechAcyclic.affine`). Each needs a blueprint entry (when there is Lean there must be tex):
- `AlgebraicGeometry.isZero_homology_of_iso_homotopy_id_zero` (CechAugmentedResolution.lean:89) —
  homological-algebra glue: `(D ≅ D') → Homotopy (𝟙 D') 0 → IsZero (D.homology p)`. Depends only on
  `isZero_homology_of_homotopy_id_zero` + `IsZero.of_iso` + `homologyFunctor.mapIso`.
- `AlgebraicGeometry.sectionsFunctorCorepIso` (OpenImmersionPushforward) — `Γ(V,−) ≅ coyoneda(jShriekOU V)`.
- `AlgebraicGeometry.rightDerivedNatIso` — transports `rightDerived` across a `NatIso`.
- `AlgebraicGeometry.jShriekOU_homEquiv_nat` — import-isolation duplicate of the private
  `AbsoluteCohomology` naturality lemma (consider a `% NOTE:` documenting the duplication, like the
  `isZero_of_faithful_preservesZeroMorphisms` pair).
- `AlgebraicGeometry.sectionsFunctor_additive` — additivity instance for `sectionsFunctor`.
- `AlgebraicGeometry.toPresheafOfModules_additive` — additivity of `toPresheafOfModules`.

## Marker / blueprint fixes for the planner-writer (MAJOR, from lvb-openimm)
- **`isAffineHom_of_affine_separated` is `private`** but the blueprint block
  `lem:open_immersion_pushforward_comp` pins `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}`
  (public). `sync_leanok` cannot resolve a private qualified name → the pin will never get `\leanok`.
  Either (a) have a prover make it public, or (b) drop/annotate the pin with a `% NOTE:` (mirroring
  the `isZero_of_faithful_preservesZeroMorphisms` NOTE at the chapter's line 7184). I did not edit
  this — it's a Lean-visibility decision (prover) or a prose decision (writer), not a marker fix.

## Do NOT retry without a structural change
- The objectwise `isZero_presheafToSheaf_of_locally_isZero` for the open-immersion route — the
  affine opens are not downward-closed; the route correctly uses the SECTIONWISE
  `isZero_presheafToSheaf_of_sections_locally_zero` (already in place). Don't revert.
- ExtraDegeneracy for the section-complex contracting homotopy (variance mismatch — simplicial only;
  refuted in iter-054 `analogies/deepbridge.md`). Stub 6 must use the `Dependent` engine.

## Reusable patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Corepresent-then-rightDerive** to convert a sections functor's right-derived functor into a
  `coyoneda`/`Ext` right-derived functor: `sectionsFunctorCorepIso` (corepresentability NatIso) +
  `rightDerivedNatIso` (transport across NatIso) + `InjectiveResolution.isoRightDerivedObj`.
- **Scaffold-file gotcha:** `open <Namespace.Sub>` must come AFTER `namespace <Namespace>` when the
  sub-namespace is `<Namespace>.<Sub>` — placing it before yields `unknown namespace`, which cascades
  into unrelated `Unknown identifier` errors downstream. Always `lake build` a new scaffold before
  wiring its root import.
