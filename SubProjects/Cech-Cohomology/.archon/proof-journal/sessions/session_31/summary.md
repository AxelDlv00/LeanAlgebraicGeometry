# Session 31 review (iter-031)

## Metadata
- **Iteration / session**: iter-031 / session_31
- **Total project sorry**: 2 → 2 (no regression). Both frozen/superseded:
  `CechAcyclic.lean:110` (`affine`, dead superseded relative form) +
  `CechHigherDirectImage.lean:679` (frozen P5b target). Both prover files this iter are 0-sorry.
- **Lanes planned 2, ran 2** (both `mathlib-build`).
- **+11 axiom-clean declarations** (10 in CechBridge + 1 in QcohTilde); **0 new sorries**.
- **Build**: GREEN. CechBridge `lake build` EXIT 0; QcohTilde `lake env lean` EXIT 0; both
  `lean_verify` = `{propext, Classical.choice, Quot.sound}`.
- `archon dag-query`: **gaps = 1** (`lem:tilde_preserves_kernels` / `tildePreservesFiniteLimits`,
  a known ∞-hole sub-gap of the 01I8 route), **unmatched = 10** (1 dead `CechAcyclic.affine` +
  9 new `…Fam` helpers from CechBridge).

## Targets attempted

### CechBridge.lean — Lane A family bridge — BOTH NAMED TARGETS SOLVED, axiom-clean
The plan drove the family-parameterized Čech bridge chain (the mirror of the iter-025
`X.OpenCover` chain onto a raw finite family `{ι}[Finite ι](U:ι→Opens X)` with **no covering
hypothesis**, consuming iter-030's `cechFreeComplex_quasiIsoFam`). The prover landed the entire
chain — 10 axiom-clean decls — including both named targets:
- **`sectionCechComplexMapOpIsoFam`** — cover-agnostic opposite-transport iso of the section Čech
  complex (`homCechComplexMapOpIsoFam ≪≫ cechComplex_hom_identificationFam`).
- **`injective_cech_acyclicFam (U : ι → Opens ↥X) (I : X.Modules) [Injective I] (p : ℕ) (hp : 0 < p)
  : IsZero ((sectionCechComplex U …I).homology p)`** — positive-degree Čech vanishing for
  injectives over ANY finite family, no covering hypothesis.

Approach: mechanical mirror, the `…Fam` substitution exactly as Lane A did on the free side
(`𝒰.I₀ ↦ ι`, `coverOpen 𝒰 ↦ U`, `coverInterOpen 𝒰 ↦ coverInterOpenFam U`, etc.). Generic helpers
(`pi_mapIso_hom_eq`, `freeYonedaHomAddEquiv_naturality`, `freeYoneda`, `opCoproductIsoProduct`,
`piComparison`, `opFunctor`, …) are open-indexed / category-generic and reused verbatim. Key defeq:
`coverInterOpenFam U σ` is `⨅ k, U (σ k)` definitionally — exactly the shape `sectionCechComplex U F`
already uses — so no extra `eqToHom`. `maxHeartbeats 2000000` reused (genuine nested-coercion defeq
cost, identical to the original). Existing `X.OpenCover` decls left byte-identical (lines 136–909).

lean-auditor independently confirmed: no covering hypothesis smuggled in, `injective_cech_acyclicFam`
genuinely non-vacuous (`0 < p` strictly required), `maxHeartbeats` a real perf need not a mask.

### QcohTildeSections.lean — Lane B Route-P — P0 SOLVED, P1 honestly BLOCKED
- **`exists_finite_basicOpen_subcover`** (P0) landed axiom-clean — finite basic-open refinement of
  any cover of `Spec R`, blueprint pin matches. Pure topology. The prover hit two friction points,
  both instructive (see milestones): (1) `isBasis_iff_nbhd`'s `{U}{x}` are implicit — apply inline,
  don't pre-bind; (2) `Opens.mem_iSup` must be applied via `.1` (defeq-lenient), not `rw`, when the
  collection is `(Spec R).Opens` (carrier `↥(Spec R)` vs `PrimeSpectrum ↑R`). Final form via
  `← PrimeSpectrum.iSup_basicOpen_eq_top_iff` + `eq_top_iff` + `equivFin` reindexing.
- **`qcoh_localized_sections`** (P1) deliberately NOT added (no sorry). Genuinely blocked on two
  multi-hundred-LOC pieces absent from Mathlib: **P1a** (SheafOfModules restriction-to-basic-open ≅
  Spec-of-localization + presentation transport from `QuasicoherentData`) and **P1b**
  (`IsLocalizedModule` local-on-a-finite-spanning-cover patching primitive — confirmed absent;
  only `IsLocalizedModule.mk`/`.of_linearEquiv` exist). The prover verified by Mathlib search and
  source grep that no shortcut exists, and rejected the off-critical-path conditional/global
  `[IsIso F.fromTildeΓ]` form (it trivialises `F` globally, not on basic opens, and near-duplicates
  `CechAcyclic`'s `qcohSectionsAwayLocalized`).

## Key findings / patterns
- **Cover-agnostic re-parameterization complete on the section/bridge side too.** With Lane A
  (iter-030, free side) + this iter's CechBridge family bridge, the entire Čech-vanishing-for-
  injectives machinery is now stated over a raw finite family with no covering hypothesis. This is
  exactly the form 02KG's `BasisCovSystem.injective_acyclic` needs over standard covers of arbitrary
  `D(f)` — the costly `Spec R_f`-restriction / `j_!` route Form B was chosen to avoid stays avoided.
- **The `…Fam` mirror is byte-cheap and non-fragile** when the generic helpers are already open-
  indexed; only the `cech*Simplicial`/`cech*Complex`-shaped decls need a `…Fam` twin.
- **Lane B stopped on real geometry, correctly bounded.** No sorry, no vacuity, no relabel. The
  01I8 gap is now decomposed to its two genuine missing primitives (P1a + P1b).

## Audit results (subagents — see reports)
- **lean-auditor `iter031`**: 0 critical / 0 major / 1 minor (stale aspirational module-doc mention
  of `cech_eq_cohomology_of_basis`/`affine_serre_vanishing` as "(planned)"). Both files axiom-clean,
  sorry-free, structurally sound. Report:
  `task_results/lean-auditor-iter031.md`.
- **lvb `cechbridge-iter031`**: both named targets correct + match blueprint exactly (cover-agnostic).
  1 **major** (blueprint-infra), 1 minor (6 public `…Fam` helpers unpinned). Report:
  `task_results/lean-vs-blueprint-checker-cechbridge-iter031.md`.
- **lvb `qcohtilde-iter031`**: P0 in full agreement; 1 **must-fix (blueprint-side)** —
  `lem:qcoh_localized_sections` proof sketch under-specified (P1a + P1b silently elided). Report:
  `task_results/lean-vs-blueprint-checker-qcohtilde-iter031.md`.

## The MAJOR: stale `blueprint/lean_decls` withheld `\leanok` on the two CechBridge named blocks
`blueprint/lean_decls` (368 entries) does not contain the new `…Fam` names (grep: 0 matches). Because
`lem:section_cech_complex_mapop_iso` and `lem:injective_cech_acyclic` now list a `…Fam` name in their
`\lean{}` that `lean_decls` can't resolve, the deterministic `sync_leanok` did **not** restore
`\leanok` on those two statement blocks (verified: lines 2601, 2662 carry no `\leanok`, although the
non-Fam decls in the same `\lean{}` list are proven and were `\leanok` in prior iters). This is a
false-negative caused by a stale generated file — the Lean is correct. **Fix (planner, next iter):
regenerate `blueprint/lean_decls` via `leanblueprint`, then the next `sync_leanok` restores `\leanok`.**
I did not touch `\leanok` (sync's domain) and `lean_decls` is a generated file outside my write domain.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_localized_sections`: added `% NOTE:` — NOT YET
  FORMALIZED; documents the P1a (affine restriction infra) + P1b (`IsLocalizedModule` span-cover
  patching) sub-gaps and the planner action (blueprint-writer decompose into P1a+P1b before
  re-assigning to a prover).

No `\mathlibok` added (all new decls are project-local proofs, no Mathlib re-exports). No `\lean{...}`
renames (named targets matched their pins). No stale `\notready` found.

## Recommendations for next session
See `recommendations.md`. Headline: (1) regenerate `blueprint/lean_decls` to clear the `\leanok`
false-negative; (2) bundle the 9 unmatched `…Fam` helpers into existing `\lean{}` lists; (3)
blueprint-writer decompose `lem:qcoh_localized_sections` into P1a + P1b before any P1 prover;
(4) the AffineSerreVanishing lane can now consume `injective_cech_acyclicFam` to discharge
`BasisCovSystem.injective_acyclic`.
