# Session 19 (iter-019) — review summary

## Metadata
- **Iteration / session**: iter-019 / session_19
- **Model**: claude-opus-4-8 (3 parallel mathlib-build prover lanes)
- **Project sorry count**: 2 → 2 (no regression). Both intentional:
  `CechAcyclic.affine` (line 109, superseded relative-form, left per Q4) +
  frozen P5b assembly `cech_computes_higherDirectImage` (CechHigherDirectImage:715).
- **Build**: GREEN (all three touched files `lean_diagnostic_messages`-clean).
- **New axiom-clean declarations**: +29 (CechAcyclic 24, CechBridge 2, FreePresheafComplex 3),
  all `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
- **Named lane targets landed: 2** — `SectionCechModule.dDiff_exact` (P3 section-form step (a))
  and `cechComplex_hom_identification` (P3b bridge, the named Lane-1 target).
- **Targets attempted**: 3 lanes — CechAcyclic.lean (P3 L1), CechBridge.lean (P3b bridge),
  FreePresheafComplex.lean (P3b free quasi-iso).

## Lane 1 — CechAcyclic.lean (P3 L1): `dDiff_exact` LANDED (24 decls)

Built the complete `R`-module exactness core of the section-form `lem:cech_acyclic_affine`,
bottom-up, culminating in the named **step (a)** target
`SectionCechModule.dDiff_exact : Function.Exact (dDiff s M (m+1)) (dDiff s M (m+2))`
(positive-degree exactness of the un-localised section Čech module complex `D• = ∏_σ M_{s_σ}`).

Key sub-results:
- **`AwayComparison.comparison_isLocalizedModule`** — the planner's flagged keystone:
  localisation transitivity `M_a[1/b] = M_{ab}` (the comparison `M_a → M_{ab}` is
  `IsLocalizedModule (powers b)`). Proved via the `IsLocalizedModule.mk` constructor.
- `dCoeff`, `dCoface`, `dDiff`/`dDiff_apply` — the `D•` complex (`LinearMap.pi` of
  alternating-signed composed projections).
- `dToCech` + `dToCech_isLocalizedModule` (away `s r`), `cechCoface_dToCech`, `dToCech_comm`
  (the differential-naturality square).
- `locDiff` + `locDiff_eq_depDiff` + `locDiff_exact` (transports `cechLocalized_exact`).
- `fLoc` + `fLoc_isLocalizedModule` (`IsLocalizedModule.pi`), `locDiff_fLoc`,
  `map_dDiff_eq_locDiff` (`IsLocalizedModule.ext` uniqueness).
- `spanIdx`/`spanIdx_spec` (private) — the opaque chosen index device.
- `dDiff_exact` — assembled via `exact_of_isLocalized_span (Set.range s) hs`, localising at each
  spanning element and discharging each node with `map_dDiff_eq_locDiff` + `locDiff_exact`.

### Notable errors and resolutions (full per-attempt detail in milestones.jsonl)
- `rw [↑ρ = s ρ.2.choose]` gave **"motive is not type correct"** — `ρ.2.choose` syntactically
  depends on `↑ρ`. **Fix**: introduce an OPAQUE `private noncomputable def spanIdx ρ := ρ.2.choose`
  so the rewrite motive does not mention `↑ρ`. (New Knowledge-Base pattern.)
- `exact_of_isLocalized_span`'s `[∀ r, IsLocalizedModule.Away ↑r (f r)]` are **instance-implicit**
  (synthesised, not goals): must be supplied via `haveI inst : ∀ ρ, …` BEFORE the `refine`.
- `s_r * sprod σ` vs `sprod σ * s_r`: the canonical `IsLocalizedModule` instance attaches to the
  literal `cechCoeff` element; bridge with `rw [mul_comm]; infer_instance`.
- `dDiff_apply`: `simp only [...]` made no progress after `rw [dDiff, LinearMap.pi_apply,
  LinearMap.sum_apply]` — residual is termwise-rfl; closed by
  `exact Finset.sum_congr rfl fun d _ => rfl`.

## Lane 2 — CechBridge.lean (P3b bridge): `cechComplex_hom_identification` LANDED (2 decls)

- **`homCechSectionCosimplicialIso`** — `homCechCosimplicial 𝒰 F ≅ sectionCechCosimplicial
  (coverOpen 𝒰) F`, via `NatIso.ofComponents (homCechSectionIsoApp 𝒰 F)`. The naturality square
  was the entire difficulty.
- **`cechComplex_hom_identification`** (NAMED TARGET) — `homCechComplex 𝒰 F ≅ sectionCechComplex
  (coverOpen 𝒰) F`, a one-liner:
  `(AlgebraicTopology.alternatingCofaceMapComplex Ab.{u}).mapIso (homCechSectionCosimplicialIso 𝒰 F)`.
  Both complexes are by-definition the alternating-coface complex of their cosimplicial objects, so
  `mapIso` of the cosimplicial iso has exactly the required type and intertwines differentials.

### KEY LESSON (dead-end avoidance) — defeq-non-syntactic carrier mismatch
Plain `rw [Category.assoc]` / `simp only [Category.assoc]` **fail silently** ("pattern not found" /
"no progress") in the naturality square because every composition's shared object is
definitionally-but-not-syntactically equal (`(F.obj …)` vs unfolded product `∏ᶜ`/`piObj`; the Yoneda
hom-group carriers; the `homOfLE ⋯` proof terms). The proof MUST: (1) one upfront
`dsimp only [sectionCechCosimplicial]` to expose the product, then (2) **`erw` for every**
associativity / `Functor.map_comp` / naturality step; (3) reduce to the underlying `PMod` morphism
equality and close with `Quiver.Hom.unop_inj` + `Limits.Sigma.ι_desc` + `rfl`. Do not retry with
`rw`/`simp`. (Reinforces the iter-018 KB pattern.)

## Lane 3 — FreePresheafComplex.lean (P3b free quasi-iso): step 1 of 3 LANDED (3 decls)

Named target `cechFreeComplex_quasiIso` NOT built; the **objectwise reduction** (recipe step 1) is:
- **`quasiIso_of_evaluation`** (non-private) — a morphism of complexes of presheaves of modules is a
  quasi-iso iff each evaluation `(evaluation R V).mapHomologicalComplex.map` is. Stated generally for
  any `R : Cᵒᵖ ⥤ RingCat` (reusable, not scheme-specific).
- `isIso_of_evaluation`, `isIso_Fmap_homologyMap` (private helpers).

Mathlib's single-functor `quasiIso_map_iff_of_preservesHomology` needs `F.ReflectsIsomorphisms`,
**FALSE** for a single `evaluation R V` (not conservative). The joint-conservativity version was built
instead: `toPresheaf R` reflects isos + `NatTrans.isIso_iff_isIso_app` + `PreservesHomology`/`Additive`
of `evaluation`. Verified end-to-end that `apply quasiIso_of_evaluation X.ringCatSheaf.obj; intro V`
reduces the named target to a SINGLE per-`V` obligation.

**Remaining (steps 2–3, the bulk)**: the per-`V` sectionwise contracting homotopy — `dh + hd = id`
over dependent direct sums with an `I₁ = {i : V ≤ U_i}` case split. Size comparable to the whole
`CombinatorialCech.*` development. Prover's corrected analysis: there is **no presheaf-level extra
degeneracy** (`s₀ ↦ prepend i_fix` is not natural across `V`, since `i_fix` depends on `V`) — which is
*why* the objectwise reduction is mandatory — BUT sectionwise (fixed `V`, `I₁ ≠ ∅`) the extra
degeneracy IS the clean tool, exactly as Mathlib proves `Rep.standardComplex.εToSingle₀`
(`AugmentedCechNerve.extraDegeneracy` linearized by `ModuleCat.free`). Two routes handed off:
(a) port `CombinatorialCech.combHomotopy` to ModuleCat; (b) reuse `AugmentedCechNerve.extraDegeneracy`
(Mathlib-blessed template).

## Cross-lane: `injective_cech_acyclic` — BLOCKED (not attempted)
Needs `cechFreeComplex_quasiIso` (Lane 3, not built). The transport bridge
`cechComplex_hom_identification` is now available, so when Lane 3 lands this decl needs only the
bridging lemma + injectivity. Do NOT dispatch until the quasi-iso lands.

## Review-subagent findings (full reports linked in recommendations.md)
- **lean-auditor iter019**: 0 must-fix. 4 **major stale comments** (no wrong code) — most dangerous
  `CechHigherDirectImage.lean:347–387` claims `pushPullMap_comp` "dead-ends" but it is proved at
  line 564. 2 minor. All 29 new decls confirmed axiom-clean; both sorries match the known list.
- **lvb cechacyclic**: `dDiff_exact` faithfully realizes step (a); all referenced decls present and
  correctly signed. 2 major (blueprint-side): two substantive `AwayComparison.*` lemmas missing from
  `\lean{}` lists, and the `SectionCechModule.*` proof sketch is under-specified.
- **lvb cechbridge**: 0 red flags; signature faithful. Major (known debt): `homCechSectionCosimplicialIso`
  unreferenced in blueprint. Minor: 3 private helpers listed by full external namespace.
- **lvb freepresheafcomplex**: **1 must-fix (blueprint adequacy)** — `lem:cech_free_complex_quasi_iso`
  proof sketch omits the Lean packaging pathway (`HomologicalComplex.Homotopy`, `HomotopyEquiv.toQuasiIso`,
  the `quasiIso_of_evaluation` bridge, `K(𝒰)_p(W)` evaluation). Must be expanded before the next prover.

## Key findings / patterns discovered (see PROJECT_STATUS.md Knowledge Base)
1. **Spanning-element rewrite needs an opaque index def** — `exact_of_isLocalized_span` + a per-`ρ`
   `Exists.choose` index must be wrapped in a `private def spanIdx` or the `↑ρ = s i` rewrite motive
   is ill-typed.
2. **`erw`-everywhere for cosimplicial/Yoneda naturality** — defeq-non-syntactic carriers (products,
   Yoneda hom-groups, `homOfLE` proof terms) defeat `rw`/`simp`; one upfront `dsimp` + `erw` chain.
3. **Joint-conservativity objectwise reduction** — `evaluation R V` is not conservative; reduce a
   `PresheafOfModules` quasi-iso to per-`V` via `toPresheaf` (reflects isos) + `PreservesHomology`.
4. **Localisation transitivity** `M_a[1/b] = M_{ab}` via `IsLocalizedModule.mk` is now a project lemma
   (`comparison_isLocalizedModule`), the L1 keystone.

## Recommendations for next session
See `recommendations.md`. Headline: (1) blueprint-writer to expand `lem:cech_free_complex_quasi_iso`
(must-fix) before re-dispatching the FreePresheafComplex quasi-iso lane; (2) bundle 28+ unmatched
helpers into `\lean{}` lists; (3) refactor to fix 4 stale module-docstring comments; (4) the P3 L1
route continues with the sheaf-section sub-build (steps b–d), independent of the P3b lanes.

## Blueprint markers updated (manual)
- None this iter. No Mathlib re-exports landed (no `\mathlibok` warranted); no prover renamed a
  blueprint-referenced declaration (`cechComplex_hom_identification` matches its `\lean{}`); no
  `\notready` markers present anywhere. Coverage-debt bundling and proof-sketch expansion are
  blueprint-writer (prose) tasks for the planner, not review-agent marker edits.

## Notes (low)
- `sync_leanok` ran for iter-019 (sha 3e1f84b): added 0, removed 1 `\leanok` in
  `Cohomology_CechHigherDirectImage.tex` (deterministic).
- blueprint-doctor: no structural findings (no orphan chapters, all refs resolve, no new axioms).
- `CechHigherDirectImage.lean` uses high `maxHeartbeats` options (lean-auditor minor) — accurate,
  unusual; not a defect.
