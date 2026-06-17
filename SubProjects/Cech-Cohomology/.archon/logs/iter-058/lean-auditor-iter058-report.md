# Lean Audit Report

## Slug
iter058

## Iteration
058

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **No errors, no sorry warnings** (confirmed via LSP: `items: []` for errors; no
    `declaration uses sorry` warning — the full transitive chain through
    `sectionCech_homology_exact_of_affineOpen → sectionCech_homology_exact_of_affineCover →
    sectionCechAbExact_affine` is sorry-free).
  - **New decl `affine_tildeVanishing_general` (private, lines 862–872)**: genuine.
    Body is a single application of `sectionCech_homology_exact_of_affineOpen`
    (which is itself sorry-free). Hypotheses — `haff : IsAffineOpen (⨆ D(g i))`
    and `hp : 0 < p` — are real and non-trivially-satisfiable. Not vacuous.
  - **New decl `affine_serre_vanishing_general_open` (public, lines 881–886)**:
    genuine. Unconditional `Ext^p(jShriekOU V, F) = 0` for qcoh `F`, any affine `V`,
    `p > 0`. No hypotheses beyond `[EnoughInjectives]` and `[IsQuasicoherent]`;
    those are real typeclass constraints (not trivially false). Not vacuous.
  - **Line 336, 355, 716, 735** — `show` tactic flagged by style linter as changing
    the goal (should be `change`). Four occurrences in `affine_surj_of_vanishing` and
    `affine_surj_of_vanishing_affine`.
  - **Lines 220, 363** — `set_option maxHeartbeats` without a comment, per style
    linter. Two occurrences (`affine_surj_of_vanishing` and `affineCoverSystem`).
  - **Code duplication**: `standard_cover_cofinal` (lines 167–216) and
    `standard_cover_cofinal_affine` (lines 556–600) are near-identical proofs
    differing only in the compactness source (`PrimeSpectrum.isCompact_basicOpen f`
    vs `hV.isCompact`). Similarly, `affine_surj_of_vanishing` (lines 233–359) and
    `affine_surj_of_vanishing_affine` (lines 615–739) share >120 identical lines;
    the general-affine versions could refactor the D(f) versions as a special case,
    significantly reducing maintenance surface.
  - Lines 369, 370, 372, 463, 464, 225 exceed the 100-character style limit
    (flagged by linter — minor).

---

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **5 sorries confirmed** (LSP: lines 368, 417, 504, 568, 635 = Stubs 1–6 as
    labeled in the file; five warnings `declaration uses sorry`).
  - **New complete decls** (all sorry-free, all genuinely typed):
    - `widePullback_overX_isLimit` (L54–75): valid `mkFanLimit` with explicit
      lift/fac/uniq; `WidePullback.hom_ext` used correctly.
    - `widePullback_overX_eq_prod` (L81–85): one-liner via `conePointUniqueUpToIso`.
    - `overSigmaDescCofan` (L89–93): straightforward cofan.
    - `overSigmaDescIsColimit` (L98–116): `mkCofanColimit` with `Sigma.hom_ext`.
    - `overSigmaDescIso` (L121–125): one-liner.
    - `prodFinSuccIso` (L134–156): `mkFanLimit` with `Fin.cases` case split.
    - `prod_coproduct_distrib` (L163–179): uses `FinitaryPreExtensive.isIso_sigmaDesc_fst`
      and `pullbackLeftPullbackSndIso`; proof reconstructs the correct iso chain.
    - `coproduct_fibrePower_reindex` (L186–193): `sigmaSigmaIso` + `Sigma.whiskerEquiv`
      with `Fin.consEquiv`; correct.
    - `widePullback_coproduct_iso_zero` (L205–216): base case, chains five isos.
  - **Stubs 5 & 6 re-signing verified** (directive concern). Stub 5 (`cechSection_complex_iso`,
    lines 568–583) now returns `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`; `D` is
    built from `cechAugmentedComplex 𝒰 F` (augmented). Stub 6
    (`cechSection_contractible`, lines 635–642) now states `Homotopy (𝟙 (…augment ε hε)) 0`.
    Both signatures correctly target the augmented complex. The provably-false
    non-augmented form (iter-056 finding) is gone.
  - **Sorry honesty** (all five):
    - Stub 1 `cechBackbone_left_sigma` (L368): asks for `(coverCechNerveOver 𝒰).obj [p] ≅ ∐ σ, Over.mk j_σ`
      — a genuine iso that requires coproduct-distributes-over-fibre-power in Scheme; not
      provably false.
    - Stub 2 `pushPull_sigma_iso` (L417): asks for `pushPullObj F Y_p ≅ ∏ σ, pushPullObj F (Over.mk j_σ)`
      — genuine sheaf-infra; not provably false.
    - Stub 4 `pushPull_eval_prod_iso` (L504): depends on Stub 2 (sorry'd), but its own
      signature is mathematically correct.
    - Stub 5 `cechSection_complex_iso` (L568): augmented target, correct signature.
    - Stub 6 `cechSection_contractible` (L635): augmented target, correct signature.
    None of the five sorries carry excuse-comments or misrepresent provability.
  - **MAJOR — universe restriction in `prod_coproduct_distrib` and
    `coproduct_fibrePower_reindex`**: both use `{ι : Type}` (= `Type 0`) instead of
    `{ι : Type*}`. Every other `ι`-polymorphic declaration in the same file
    (`widePullback_overX_isLimit`, `widePullback_overX_eq_prod`, `overSigmaDescCofan`,
    `overSigmaDescIsColimit`, `overSigmaDescIso`, `widePullback_coproduct_iso_zero`,
    `coverArrowOverCofan`, etc.) uses `{ι : Type*}`. The intended consumers of these
    two lemmas (the inductive step filling Stub 1 `cechBackbone_left_sigma`) will
    instantiate `ι = 𝒰.I₀ : Type u`; with `u > 0` that instantiation will fail to
    elaborate. The declarations type-check now only because no sorry-free code yet
    applies them.
  - **Minor — redundant concrete coproduct family**: `coverArrowOverCofan`,
    `coverArrowOverIsColimit`, `coverArrowOverSigmaIso` (L293–325) are concrete
    duplications of `overSigmaDescCofan/IsColimit/Iso`; the concrete versions copy
    the proof bodies verbatim rather than using the abstract declarations.
  - **Minor — `prodFinSuccIso` in wrong namespace**: lives in
    `CategoryTheory.FinitaryPreExtensive` but carries no `[FinitaryPreExtensive C]`
    hypothesis; it only needs `[HasFiniteProducts C]`. Namespace-mismatch is not
    harmful but is confusing.
  - **Minor — `set_option synthInstance.maxHeartbeats 800000`** on sorry'd
    `pushPull_sigma_iso` (line 416) has no explanatory comment (linter-flagged), and
    is vacuously meaningless while the body is `sorry`.
  - Lines 198, 199, 202, 340, 377, 405, 515, 532 exceed the 100-character limit.

---

## Must-fix-this-iter

None.

All five sorries in `CechSectionIdentification.lean` are honest (Stubs 1–6; the
augmented re-signing is confirmed). `AffineSerreVanishing.lean` is sorry-free with no
excuse-comments or weakened definitions. No unauthorized axioms, no parallel API copies,
no suspect bodies.

---

## Major

- `CechSectionIdentification.lean:165` — `prod_coproduct_distrib` declares `{ι : Type}`
  (universe 0). The intended application (closing Stub 1 at `ι = 𝒰.I₀ : Type u`) will
  fail for `u > 0`. Fix: change to `{ι : Type*}` (matching all sibling declarations in
  the file).
- `CechSectionIdentification.lean:186` — `coproduct_fibrePower_reindex` same issue:
  `{ι : Type}` should be `{ι : Type*}`.

---

## Minor

- `AffineSerreVanishing.lean:336,355,716,735` — `show` used where goal is mutated;
  style linter asks for `change`.
- `AffineSerreVanishing.lean:220,363` — `set_option maxHeartbeats` without explanatory
  comment (linter).
- `AffineSerreVanishing.lean` — near-duplicate proof bodies: `standard_cover_cofinal` /
  `standard_cover_cofinal_affine` and `affine_surj_of_vanishing` /
  `affine_surj_of_vanishing_affine`. The ~120-line shared body should be factored out.
- `CechSectionIdentification.lean:293–325` — `coverArrowOver*` family copies the proofs
  of `overSigmaDesc*` verbatim instead of applying the abstract versions.
- `CechSectionIdentification.lean:134` — `prodFinSuccIso` in `FinitaryPreExtensive`
  namespace but requires only `[HasFiniteProducts C]`, not `[FinitaryPreExtensive C]`.
- `CechSectionIdentification.lean:416` — `set_option synthInstance.maxHeartbeats 800000`
  on sorry'd declaration, no comment (linter).
- `CechSectionIdentification.lean:198,199,202,340,377,405,515,532` — lines > 100 chars.
- `AffineSerreVanishing.lean:225,369,370,372,463,464` — lines > 100 chars.

---

## Excuse-comments (always called out separately)

None found in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (universe restriction `{ι : Type}` in `prod_coproduct_distrib` and
  `coproduct_fibrePower_reindex`)
- **minor**: 9
- **excuse-comments**: 0

Overall verdict: Both files are honest — no wrong definitions, no excuse-comments, no
unauthorized axioms; the two new `affine_tildeVanishing_general` /
`affine_serre_vanishing_general_open` decls are genuine and sorry-free; Stubs 5/6 have
been correctly re-signed to the augmented complex. The two universe-0 restrictions in
`prod_coproduct_distrib` and `coproduct_fibrePower_reindex` are latent blockers for
the Stub 1 inductive proof and should be fixed before that sorry is attempted.
