# Recommendations for iter-019 plan

## HIGH — administrative, cheap, unblock-everything

1. **Add the orphan file to the root barrel.** `AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean`
   is NOT imported by `AlgebraicJacobian.lean` (verified: root imports the other 6 Cohomology files but
   not this one). Its 6 axiom-clean decls are unreachable from the root build graph and will silently
   drift. Dispatch a `refactor` to add `import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf`
   to the root. (lean-auditor §1 major.)

2. **Resolve the P5a design fork (planner decision).** The named target
   `higherDirectImage_isSheafify_presheafCohomology` was NOT built; the prover built the **resolution
   form** `higherDirectImage_iso_sheafify_presheafHomology` + the reusable engine
   `homologyIsoSheafify` instead, and recommends a re-sign (option 1) mirroring the Q4 section re-sign.
   I added a `% NOTE` at `lem:higher_direct_image_presheaf` flagging this. **Action**: decide the
   re-sign, then have a blueprint-writer update the `\lean{}` hint to the resolution form and add
   blueprint blocks for `homologyIsoSheafify` + `pushforwardResolutionPresheafComplex`. The stale
   `\lean{}` hint currently names a non-existent decl (blueprint-doctor will flag it next iter too).

3. **Fix the broken `\uses` cross-ref** (blueprint-doctor): `Cohomology_CechHigherDirectImage.tex`
   has `\uses{AlgebraicGeometry.CombinatorialCech.depDiff_exact}` pointing at a raw Lean name with no
   matching `\label`. Either point the `\uses` at the proper blueprint label, or add an anchor block.
   (Plan/blueprint-writer domain.)

## HIGH — closest-to-completion prover targets (priority order)

The two P3b lanes are now genuinely unblocked and are the shortest paths to a landed named target:

1. **`cechComplex_hom_identification` (CechBridge.lean)** — CLOSEST. The entire mathematical core (5
   decls) is built and axiom-clean; only operationally deferred (FreePresheafComplex was broken
   mid-session, now compiles). The full 2-declaration assembly recipe is in
   `task_results/CechBridge.md`: `homCechSectionCosimplicialIso` via `NatIso.ofComponents` (fully
   derived `Pi.hom_ext` naturality) + `cechComplex_hom_identification := (alternatingCofaceMapComplex
   Ab).mapIso …`. Re-dispatch a prover with the `erw`/term-mode discipline. This is a `prove`-mode
   finish, not a fresh build.

2. **`cechFreeComplex_quasiIso` (FreePresheafComplex.lean)** — the augmentation chain map is built; the
   target is `QuasiIso (cechFreeComplexAug 𝒰)`. This is still a LARGE lane (~250–450 LOC: objectwise
   reduction + sectionwise free-module description + the contracting homotopy). **Port
   `CombinatorialCech.combHomotopy` from CechAcyclic.lean** for the homotopy (same combinatorial
   content). Consider an `effort-breaker` to split it before dispatch. DEAD END: do NOT route through
   `SimplicialObject.Augmented.ExtraDegeneracy`.

3. **CechAcyclic L1 next step** — `D•` un-localised complex + `Function.Exact` via
   `exact_of_isLocalized_span`. Needs `IsLocalizedModule.pi` (verified present) + transitivity of
   localisations (`M →[s_σ] M_{s_σ} →[s r] M_{s r s_σ}` is `M →[s r s_σ]`). Then `qcohSectionsAwayLocalized`
   — **build for `tilde M` first** (no 01I8 gap), bolt on Stacks-01I8 (`QCoh(Spec R)≃Mod R`)
   globalisation separately as its own mathlib-build sub-step (the genuine remaining Mathlib brick).
   This lane is NOT churning (it built the hardest sub-task this iter), but it is multi-step — keep it
   open, don't expect a named-target landing next iter.

## MEDIUM — blueprint adequacy (blueprint-writer, before re-dispatching the affected lanes)

Per the lvb-checkers, the blueprint is **under-specified for the new infrastructure** in 2 lanes:
- **CechBridge**: the proof sketch of `lem:cech_complex_hom_identification` gives the high-level 3
  steps but no guidance on the intermediate objects (`homCechCosimplicial` as `.rightOp ⋙
  preadditiveYoneda`, `opCoproductIsoProduct`/`piComparison` for the per-degree iso). Expand it.
- **FreePresheafComplex**: the blueprint is **silent** on the augmentation chain-map construction
  (`cechFreeComplexAug`); `lem:cech_free_complex_quasi_iso` sketches only the homotopy. Add a block.
- **CechAcyclic**: the `AwayComparison`/`CechLocalized` tier has no `\lean{}` hints (prover discovered
  the API from scratch). When bundling coverage (below), give them a home block with prose.

## MEDIUM — stale comments (refactor cleanup, misleading future provers)

lean-auditor flagged 4 **actively-misleading** stale planning comments (declarations described as
open/remaining that are in fact proved). A refactor should strip/update:
- `AcyclicResolution.lean:924–964` — "TARGET 3 remains" / `rightDerivedIsoOfAcyclicResolution` listed
  REMAINING, but it is proved at 893–922 immediately above.
- `CechHigherDirectImage.lean:161–183` and `:245–293` — both describe `pushPullMap_comp` as unfinished
  / "not yet closed" with dead-end routes; it is proved at line 627 and `pushPullFunctor` assembled at
  640. The :245–293 block is the most actively misleading in the project.
- `PresheafCech.lean:17–23` — module docstring claims it hosts 5 decls, 4 of which moved to
  FreePresheafComplex/CechBridge.

## Coverage debt — 44 unmatched Lean decls (planner to bundle into `\lean{...}` lists)

`archon dag-query unmatched` = 44. Bundle per the established multi-name `\lean{...}` rule. Grouped by
home block:

**Into `lem:section_cech_homology_exact` / a new `def:away_comparison` + `lem:cech_localized_exact`
block** (CechAcyclic, 22):
`AwayComparison.{Inverts, Inverts.isUnit_powers, Inverts.mul, Inverts.of_dvd, comparison,
comparison_apply, comparison_comp, comparison_comp_apply, comparison_comp_structure, comparison_self,
comparison_unique}` and `CechLocalized.{cechCoeff, cechCoeff_transport_eq_comparison, cechCoface,
cechLocalized_exact, cechPrepend, cech_hcomm, cech_hsh, cech_hu, sprod, sprod_cons,
sprod_succAbove_dvd}`.

**Into `def:cover_structure_presheaf` / `lem:cech_free_complex_quasi_iso`** (FreePresheafComplex, ~8):
`cechFreeComplexAug, cechFreeComplexAug_f_zero, cechFreeAug, cechFree_d_comp_aug,
cechFree_d_comp_factorThruImage, cechFreeSimplicial_δ_comp_aug, freeYonedaAug,
freeYonedaAug_app_freeMk, freeYonedaHomEquiv_freeYonedaAug, freeYoneda_map_comp_aug`.
NB also: `sigma_ι_eqToHom_transport` currently appears in `def:cech_free_presheaf_complex`'s
`\lean{}` list but is `private` (mangled name, un-lookupable) — **remove it or de-private it**.

**Into `lem:cech_complex_hom_identification`** (CechBridge, 5):
`homCechCosimplicial, homCechComplex, homCechSectionIsoApp, homCechSectionIsoApp_hom_π,
freeYonedaHomAddEquiv_naturality` (+ trivial `pi_mapIso_hom_eq`).

**New blocks for the 01XJ engine** (HigherDirectImagePresheaf, 6) — see HIGH #2:
`homologyIsoSheafify, pushforwardResolutionPresheafComplex, higherDirectImage_iso_sheafify_presheafHomology`
(substantive) + `Functor.mapHomologyIso', sheafificationAdditive, counitComplexIso` (helpers).

## Reusable proof patterns discovered (also added to PROJECT_STATUS Knowledge Base)
- **Defeq-not-syntactic carrier mismatch** (`.X n` vs `.obj (op [n])`): prove the underlying identity
  as a FRESH-elaborated standalone `have`, then `rw`/`exact` it. Do NOT rewrite into the `.X`-pinned
  composition.
- **`∏ᶜ`/`op`/`Functor.map` matching**: `erw` for projection lemmas (`Pi.map_π`,
  `piComparison_comp_π_assoc`), term-mode `exact`/`congrArg` for functor-map combines; plain
  `rw`/`simp only` silently no-op.
- **Away-localisation comparison**: parameterise by `Inverts a Mb := IsUnit (algebraMap R (End R Mb) a)`,
  NOT divisibility — products-of-invertibles arise where divisibility fails.
- **HC-level homology iso from SC-level**: `Functor.mapHomologyIso' := (K.sc i).mapHomologyIso F` via
  the `((F.mapHomologicalComplex c).obj K).sc i ≃defeq (K.sc i).map F` identity.

## Do NOT
- Do NOT re-dispatch `CechAcyclic.affine` (the line-109 relative form) as a body fill — it is
  superseded by Q4 and unprovable via localisation (pushforward preserves kernels, not homology).
- Do NOT build the standalone module-valued `Hⁿ(open,F)` object for P5a unless the planner explicitly
  rejects the resolution-form re-sign — it is a "zero-lemmas" fork the validated analysis advises against.
