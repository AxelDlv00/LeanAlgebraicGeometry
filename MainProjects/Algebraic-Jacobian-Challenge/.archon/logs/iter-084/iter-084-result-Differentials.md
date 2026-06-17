# AlgebraicJacobian/Differentials.lean

## Summary (iter-084, Lane 2)

**Result: RESOLVED — `h_epi` of `cotangentExactSeq_structure` closed via Option (c).**

Lane 2 closure target achieved: `h_epi` is now fully proved via
`_root_.KaehlerDifferential.span_range_derivation`. The `h_exact ∧ h_epi`
conjunction was split (`refine ⟨?h_exact, ?h_epi⟩`); `h_exact` carries the
single explicit sorry (deferred to iter-085+ per plan). Net sorry count
**5 → 5** (1-for-1 absorbed → explicit shift; no regression; closure achieved).

| Metric | Before | After |
|---|---|---|
| Syntactic sorries | 5 | 5 |
| File compiles | yes | yes |
| New axioms | 0 | 0 |
| New helpers | none (iter-083's `cotangentExactSeqBeta_hη` preserved byte-for-byte) | none |

## `cotangentExactSeq_structure` `h_epi` (line 641–677) — RESOLVED

### Approach: Option (c) — `Submodule.span_induction` over `span_range_derivation`

**Strategy.** After `apply SheafOfModules.epi_of_epi_presheaf` and
`rw [PresheafOfModules.epi_iff_surjective]`, the goal reduces to per-U
surjectivity of `(cotangentExactSeqBeta f g).val.app U`. We then:

1. Introduce the `Algebra` instance via `letI := (φ_2'.app U).hom.toAlgebra`.
2. For `y : ↑((relativeDifferentials f).val.obj U)`, transport
   `Submodule.mem_top` through `KaehlerDifferential.span_range_derivation`
   (avoiding the typeclass synthesis blocker from iter-083 — we go
   *implicit* via `hspan ▸ Submodule.mem_top` rather than asserting the
   explicit type, which forces the bundled `Module` instance and fails to
   synthesize).
3. Inducting over `Submodule.span` membership with four cases:
   - **mem case** (`y = D b`): preimage is `CommRingCat.KaehlerDifferential.d b`;
     closed by `unfold cotangentExactSeqBeta` followed by
     `ModuleCat.Derivation.desc_d _ _` — the bundled `desc` collapses against
     `d b` to the inner derivation's value, which is exactly `D b` after the
     letI bridges `D` ≡ `_root_.KaehlerDifferential.D A B`.
   - **zero case**: preimage `0`; closed by `map_zero`.
   - **add case**: preimage sum; closed by `map_add` + `rw [ha₁, ha₂]`.
     Trailing `rfl` needed because `rw` leaves the structurally-equal
     `x + y = x + y` reflexivity goal.
   - **smul case**: preimage scalar multiple; closed by `map_smul` + `rw [ha']`.
     Trailing `rfl` for the same reason.

### Key insight that unblocks iter-083's typeclass barrier

The iter-083 plan's Option (c) recipe (sketch) was correct in shape but
overspecified the membership claim, forcing the elaborator to synthesize
`Module ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)` — which
fails because the natural module is over the forget₂-image `RingCat`. The
fix is to **let elaboration infer the membership type**: write
`have hy := hspan ▸ (Submodule.mem_top : y ∈ ⊤)` and the inferred type
threads through both `span_range_derivation` and the induction without
ever forcing the explicit `Module` synthesis. The Algebra instance is
introduced as a `letI` (untyped) so that `f.hom.toAlgebra` can be matched
against the bundled `CommRingCat.KaehlerDifferential`'s internal letI.

### Mathlib lemmas used (all verified via `lean_leansearch`)

- `SheafOfModules.epi_of_epi_presheaf` (project-local, iter-079).
- `PresheafOfModules.epi_iff_surjective`.
- `_root_.KaehlerDifferential.span_range_derivation`.
- `Submodule.mem_top`, `Submodule.span_induction`.
- `ModuleCat.Derivation.desc_d` (THE KEY for the mem case — closes
  `((isUniversal' φ_fg').desc d1).app U) (d b) = d2.d b` after
  `unfold cotangentExactSeqBeta`).
- `map_zero`, `map_add`, `map_smul`.

### Dead-end note (preserved for iter-085+)

The iter-083-attempted `LinearMap.range_eq_top` + `rw [← span_range_derivation]`
path fails: the `⊤` on the LHS of the `eq_top_iff`-style goal has type
`Submodule ↑(X.presheaf.obj U) ↑((relativeDifferentials f).val.obj U)`, while
`span_range_derivation`'s `⊤` is over the unbundled `_root_.KaehlerDifferential A B`
type. Lean's `rw` cannot bridge these definitionally-equal but syntactically-distinct
types. **Solution: avoid `LinearMap.range_eq_top` entirely; use
`Submodule.span_induction` directly on `hy : y ∈ ⊤`.**

### Comments in code reflect the new path

The ~30-LOC iter-083 comment block (describing Route 2's failure) is preserved
above the closed `h_epi` branch as historical context. A new ~5-LOC comment
block ("Iter-084 Lane 2: Option (c)") was added directly above the
`refine ⟨?h_exact, ?h_epi⟩` to document the new closure path.

## Preserved iter-079/081/082/083 advances (byte-for-byte)

- `_root_.SheafOfModules.epi_of_epi_presheaf` at L472–478 (iter-079).
- `_root_.PresheafOfModules.Derivation.postcomp_comp` at L489–500 (iter-081).
- `cotangentExactSeqBeta_hη` at L356–411 (iter-083).
- Route (c) chain for `h_zero` at L522–593 (iter-082).
- `cotangentExactSeqBeta` `.choose`/`.choose_spec` refactor (iter-083).
- `set_option maxHeartbeats 16000000 in` markers preserved.

## Remaining sorries (out of scope this iter)

| Line | Declaration | Status |
|---|---|---|
| 122 | `relativeDifferentialsPresheaf_isSheaf` | out of scope; phase B infrastructure pending |
| **640** | **`cotangentExactSeq_structure` `h_exact` branch** | **deferred iter-085+: needs `SheafOfModules.exact_iff_stalkwise` + ring-level `KaehlerDifferential.exact_mapBaseChange_map`** |
| 961 | `smooth_iff_locally_free_omega` | out of scope |
| 978 | `cotangent_at_section` | out of scope |
| 1120 | `serre_duality_genus` | out of scope |

## Blueprint marker recommendation (review agent)

The blueprint lemma `lem:cotangent_exact_structure` (in
`blueprint/src/chapters/Differentials.tex`) already carries `\leanok` in the
**statement** block (since the declaration has been formalized with at least
`sorry` since earlier iterations). The **proof** block does NOT yet carry
`\leanok` because the `h_exact` branch still has a `sorry`. The `sync_leanok`
phase will handle this automatically — no agent action needed.

No new declarations were introduced this iteration, so no new `\lean{...}` hints
are required.

## Verification

- `lean_diagnostic_messages` reports 0 errors after the edit.
- `lake env lean AlgebraicJacobian/Differentials.lean` builds successfully
  with 5 `sorry` warnings (matches the 5-sorry budget).
- `lean_verify cotangentExactSeq_structure` shows only the standard axioms
  `propext`, `sorryAx` (from the remaining `h_exact` sorry), `Classical.choice`,
  `Quot.sound` — no new axioms introduced.
- The hard constraints from the iter-084 plan are all satisfied:
  preserved `set_option maxHeartbeats 16000000 in`, preserved the four iter-079/081/082/083
  helpers byte-for-byte, no new project-local helper lemmas, no new axioms,
  no `lean_run_code` pre-validation of candidate bodies (only `lean_multi_attempt`
  + `lean_diagnostic_messages` after each save).
