# Lean Audit Report

## Slug
iter051

## Iteration
051

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechAcyclic.lean

- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (import Mathlib, project-wide)
- **excuse-comments**: none
- **notes**:
  - Line 110: `CechAcyclic.affine` body is `sorry` — expected, off-limits (directive). Comment
    at lines 79–108 accurately reflects the state of L1/L2/L3.
  - Lines 84–85: Comment "L1 (categorical→module bridge, STILL MISSING)" is slightly stale. The
    section-side of L1 is now substantially complete for the tilde case (via the new declarations
    through line 1853), but the *categorical* `CechComplex`→`sectionCechComplex` identification
    remains open; the comment is not actively misleading, just incomplete. Minor.
  - Lines 875–953: `AwayComparison.isLocalizedModule_comp_away` — three-case `IsLocalizedModule`
    proof (map_units, surjectivity, exists_of_eq). Each case is correct:
    - map_units: bijectivity of the `Rf`-endomorphism transported via `smulN`/`map_pow`; sound.
    - surjectivity: witness `h^l • m0` with `a^(j*l+k) = h^l*(f^l*a^k)` (line 949); algebra checked.
    - exists_of_eq: ladder via `IsLocalizedModule.exists_of_eq` for `gN` then for `mkf`; sound.
  - Lines 1201–1204: `set_option maxHeartbeats 1600000 / synthInstance.maxHeartbeats 800000` on
    `dDiff_exact_of_localizationAway`. Comment attributes cost to `AddMonoidHomClass` synthesis over
    `dCoeff`-abbreviated `LocalizedModule` carriers in `AddEquiv.piCongrRight` and three uses of
    `fLoc`. This is a genuine instance-search cost (product types over sigma domains with `LocalizedModule`
    abbreviations); not masking a fragile proof.
  - Lines 1217–1321: `SectionCechModule.dDiff_exact_of_localizationAway` — Route B proof.
    `change` at lines 921, 948: both are goal restatements replacing `Submonoid.smul_def`-expanded
    types; sound (defeq). `IsLocalizedModule.ext` at line 1280 (inside `nat`): uniqueness principle,
    correctly applied — the two sides agree on the composite structure map, so they're equal. The
    ladder via `Function.Exact.of_ladder_addEquiv_of_exact` with `eσL` is correctly assembled.
    Proof is axiom-clean.
  - Lines 1156–1159: `map_dDiff_eq_locDiff` uses `IsLocalizedModule.ext`. Sound: two maps that agree
    after precomposing with the structure map `fLoc s M r m` are equal. The witness equation comes
    from `locDiff_fLoc` (lines 1136–1145). Not a subsingleton-coherence trap.
  - Lines 1775–1827: `sectionCechAbExact` and `sectionCechAbExact_loc` contain an **identical**
    `sq` proof block (lines 1781–1793 and 1811–1823). The only difference is the final argument to
    `Function.Exact.of_ladder_addEquiv_of_exact`. The duplication is a code smell (the `sq` fact
    does not depend on `hs`/`hmem`/`hspan` and could be extracted as a shared lemma). Not a
    soundness issue.
  - Line 1567–1568 heartbeat raise (800000) on `phiL_naturality`: comment attributes to
    `IsLocalizedModule.ext` over `modulesSpecToSheaf` section types (accessor-2 sections of `~M`
    do not reduce cheaply). Genuine.
  - Line 1689–1690 heartbeat raise (1000000) on `phi_naturality`/`restr_bridge` area: same cause
    as above. Genuine.
  - Lines 1868–1893: `sectionCech_homology_exact_of_localizationAway` — complete proof.
    `hmem` via `PrimeSpectrum.basicOpen_le_basicOpen_iff`: correct (D(sᵢ) ⊆ D(f) ↔ f ∈ √(sᵢ)).
    `hspan` via `PrimeSpectrum.iSup_basicOpen_eq_top_iff` + `comap_basicOpen` + `algebraMap_isUnit f`:
    correct — `f/1` is a unit in `Localization.Away f`, so every prime of `Rf` avoids `f/1`, giving
    `D_Rf(f/1) = ⊤`, hence `⊔ i, D_Rf(sᵢ/1) = ⊤`. Proof is axiom-clean.
  - Line 5: `import Mathlib` broad import — project-wide convention but a bad Lean practice.

### AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (import Mathlib, project-wide)
- **excuse-comments**: none
- **notes**:
  - Line 780: `cech_computes_higherDirectImage` body is `sorry` — expected, protected P5b (directive).
    Route-A comment accurately describes the remaining gap (P3b bridge + acyclic-resolution lemma).
  - Lines 667–670: `cechComplexOnX` — clean definition dropping augmentation and applying
    `alternatingCofaceMapComplex`. No issues.
  - Lines 676–679: `cechNervePointIso` — composition of `pushforwardId` and `pullbackId` to iso
    `(𝟙 X)_* (𝟙 X)^* F ≅ F`. Correct: the augmentation point of `CechNerve` is exactly
    `pushPullObj F (Over.mk (𝟙 X))` by definition, and the two unitors compose to the required iso.
  - Lines 686–688: `cechAugmentation` — `cechNervePointIso.inv ≫ (CechNerve 𝒰 F).hom.app [0]`.
    Correct map `F ⟶ C⁰`. No issues.
  - Lines 697–719: `augmentation_comp_alternatingCofaceMap_objD_zero` (private). Key tactic is
    `erw [Preadditive.comp_add, comp_neg, hnat 0, hnat 1, add_neg_cancel]` at line 719.
    **This `erw` is sound.** The `Augmented = Comma (const) (𝟭)` construction makes the codomain
    of `N.hom.app [0]` literally `(𝟭 (CosimplicialObject C)).obj N.right` at type level; since
    `𝟭 X = X` is `rfl`-definitional, the reducible defeq match is valid. The comment at lines 716–718
    accurately describes why `erw` (not `rw`) is needed here. The `show` at line 711 (replacing
    `Augmented.drop.obj N` with `N.right` in the `objD` argument) is sound by the same rfl-defeq.
    `hnat` facts: correctly derived from `N.hom.naturality (SimplexCategory.δ i)` via `simpa`
    (uses `const.map δ = 𝟙`). The final `add_neg_cancel` closes the goal. **No unsound coercion.**
  - Lines 727–735: `cechAugmentation_comp_d` — applies the private lemma via `erw` for the same
    `𝟭`-wrapping reason. Sound.
  - Lines 745–747: `cechAugmentedComplex` — uses `CochainComplex.augment` with the proved
    `cechAugmentation_comp_d`. Clean.
  - Lines 341, 368, 434: `set_option maxHeartbeats` on `pushPullMap_eq_raw` (1000000), 
    `rawPushPullMap_self_gen` (4000000), `rawPushPullMap_comp` (1600000). Pre-existing from prior
    iters; not new this iter. The comment at line 348 accurately documents the dead-end
    (`erw`/`congr 1` whnf-unfolds `pullbackComp` — avoided via the `subst`-based approach). No
    issues.
  - Line 5: `import Mathlib` broad import — project-wide convention but a bad Lean practice.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `CechAcyclic.lean:84` — Comment "L1 (categorical→module bridge, STILL MISSING)" in
  `CechAcyclic.affine`'s `sorry` body no longer reflects the full picture: the tilde-case
  section-side of L1 is now proved (through `sectionCech_affine_vanishing`, line 1848).
  The comment should be updated to note that the remaining gap is the *categorical* identification
  `CechComplex ≅ sectionCechComplex`, not the entire L1.

- `CechAcyclic.lean:1781–1793` / `CechAcyclic.lean:1811–1823` — The `sq` proof block inside
  `sectionCechAbExact` and `sectionCechAbExact_loc` is word-for-word identical. The `sq` fact does
  not depend on any of `hs`/`f`/`hmem`/`hspan`. Should be extracted as a shared lemma (e.g.
  `sectionCechCofaceSquare`) to avoid the duplication.

- `CechAcyclic.lean:5` / `CechHigherDirectImage.lean:5` — `import Mathlib` broad import. Bad
  Lean practice (significantly slows build times by importing all of Mathlib). Project-wide
  convention; calling it out for completeness.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are clean this iter — the new declarations (`isLocalizedModule_comp_away`,
`dDiff_exact_of_localizationAway`, `sectionCechAbExact_loc`, `sectionCech_homology_exact_of_localizationAway`,
`cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`, `augmentation_comp_alternatingCofaceMap_objD_zero`,
`cechAugmentation_comp_d`, `cechAugmentedComplex`) are axiom-clean, the `erw`/`change`/`IsLocalizedModule.ext`
closures are sound reductions, the heartbeat raises are genuine instance-search costs, and the two
expected sorries are exactly in place; three minor style observations do not block downstream work.
