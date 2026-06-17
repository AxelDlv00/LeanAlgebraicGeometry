# Iter 012 — Objectives (per-lane detail)

4 import-independent prover lanes; HARD GATE cleared by `blueprint-reviewer iter012-rereview`
(PROCEED, 0 must-fix). Sorry line numbers verified by grep at plan time.

## Lane 1 — FBC-A · `Cohomology/FlatBaseChange.lean` · [prove]

- **Gate:** PASS. Chapter `Cohomology_FlatBaseChange.tex` complete + correct; 3 seam lemmas have
  elaboration-checked `% LEAN SIGNATURE`s.
- **Build (NEW decls, not in Lean):**
  - `base_change_mate_unit_value` (Seam 1, chapter ~L1379–1405) — the affine unit IS the algebraic
    unit `η_M : m ↦ 1⊗ₜm`.
  - `base_change_mate_fstar_reindex` (Seam 2, ~L1435–1473) — pushforward pseudofunctor reindex;
    `\uses{unit_value, codomain_read, …}`.
  - `base_change_mate_gstar_transpose` (Seam 3, ~L1514–1538) — the `(g^*⊣g_*)` transpose on sections.
  - All three are section-level generator-checks over concrete modules (`R'⊗M`, `(A⊗R')⊗M`) —
    hom-extensionality on explicit `r'⊗m`.
- **Close (existing sorries):** `base_change_mate_section_identity` (~1011) via the 3 seams →
  `affineBaseChange_pushforward_iso` (~1142). Chain collapse: seams → section_identity →
  generator_trace (proof already conditional) → cancelBaseChange → affine_base_change.
- **Leave:** `flatBaseChange_pushforward_isIso` (~1164) = FBC-B.
- **Recipe:** chapter seam blocks + `analogies/fbc-base-change-square-transparent-module.md`.

## Lane 2 — GF · `Picard/FlatteningStratification.lean` · [prove] · CHURNING must-close

- **Gate:** PASS. `gf_torsion_reindex` is the progress-critic's must-close corrective.
- **Close in order:**
  1. `gf_torsion_reindex` (~949) — localization-module-transport assembly of the 3 landed Nagata
     sub-lemmas (`gf_torsion_annihilator`, `gf_nagata_monic_lastVar`,
     `gf_mvPolynomial_quotient_finite_monic`). 5-step recipe in chapter L5b. **Caller discharges a
     `RingHom.Finite` goal** when applying `gf_mvPolynomial_quotient_finite_monic` (F-3a).
  2. `exists_free_localizationAway_polynomial` (L5, ~1034) — `Nat.strong_induction_on d` with the base
     domain `A` reverted into the motive (IH applies at `A_g`).
  3. `exists_localizationAway_finite_mvPolynomial` (L4, ~516) — Finset-fold over
     `gf_clear_one_denominator`.
  4. `genericFlatnessAlgebraic` (~1101).
- **Leave:** `genericFlatness` (~1168) = GF-geo.
- **Escalation:** if `gf_torsion_reindex` does not close, iter-013 → mathlib-analogist consult on the
  localization-module transport (instance-diamond identification).
- **Recipe:** `analogies/gf-generic-rank-ses.md` + chapter.

## Lane 3 — SNAP-S2 · `Picard/QuotScheme.lean` · [prover-mode: mathlib-build]

- **Gate:** PASS (node). `lem:gradedHilbertSerre_rational` is a clean frontier (all deps `\mathlibok`,
  decoupled by the snap-s2 writer).
- **Build (NEW decl):** `AlgebraicGeometry.gradedModule_hilbertSeries_rational` — graded Hilbert–Serre
  rationality (Stacks 00K1). For `𝒜 : ℕ → Submodule κ A`, `[GradedAlgebra 𝒜]`, `R_0=κ` field,
  degree-1 generated, f.g. graded `M`: `n ↦ dim_κ M_n` is the eventual coefficient function of
  `toPowerSeries(p) · invOneSubPow(ℚ,d)`. Induction on the number of degree-1 generators; degreewise
  SES `0→K_n→M_n→M_{n+1}→C_{n+1}→0` + additivity of `dim_κ`.
- **Anchors (verified `\mathlibok`):** `Submodule.finrank_quotient_add_finrank`,
  `PowerSeries.invOneSubPow`.
- **Constraints:** axiom-clean bottom-up; hand off a decomposition if blocked (no sorry). Do NOT touch
  SNAP-S1/S3 (`sectionGradedRing` etc.), the QCoh bridge, or the 4 downstream-blocked skeleton stubs.
- **Source:** `references/hilbert-serre-algebra.tex` L13893–13947 (Tag 00K1).

## Lane 4 — GR-cells · `Picard/GrassmannianCells.lean` · [prover-mode: mathlib-build]

- **Gate:** PASS. `lem:gr_cocycle` signature pinned (gr-cocycle writer, chapter ~L483–514); orphan
  anchor removed (F-4b).
- **Build (NEW infra, ~3 aux defs + lift lemmas):** doubly-localised rings
  `S_K := Localization.Away (minorDet K I · minorDet K J)`, `S_J`, `S_I` (invert BOTH relevant
  minors); the `algebraMap`s single→double localisation; localised transition maps
  `Θ_{J,K}: S_K→+*S_J`, `Θ_{I,J}: S_J→+*S_I`, `Θ_{I,K}: S_K→+*S_I` (each via
  `IsLocalization.Away.lift` of the relevant `transitionPreMap`).
- **Then `cocycleCondition`** (`lem:gr_cocycle`): `Θ_{I,K} = Θ_{I,J}.comp Θ_{J,K}` as ring homs
  `S_K →+* S_I` — agreement on the K-generators `x^K_{p,q}`, both giving `(X^I_K)⁻¹ X^I` over `S_I`.
- **Anchors (verified `\mathlibok`):** `IsLocalization.Away.lift`,
  `IsLocalization.Away.algebraMap_isUnit`, `Matrix.{nonsing_inv_mul,mul_nonsing_inv}`.
- **Constraints:** axiom-clean bottom-up; hand off a decomposition if blocked (no sorry). File
  demonstrably accepts large clean output (16 decls landed iter-011).

## Disproof / soundness notes

- No false-statement risk identified this iter. GF `gf_torsion_reindex` and the FBC seams are
  decomposition/assembly of already-proved-axiom-clean pieces with verified Mathlib anchors; SNAP-S2
  is a classical Stacks-00K1 result; GR cocycle is a standard Plücker-chart identity. None warrant a
  disproof pass (no recurring-blocker-on-a-possibly-false-statement signal).
