# AlgebraicJacobian/Differentials.lean — iter-076 REPAIR LANE

## Status: RESOLVED (compilation restored)

File compiles cleanly. Errors: 0. Warnings: 7 `declaration uses sorry`. Sorry
count: **7** (budget was 8; +1 over the starting 6 from the in-flight
rollbacks of `cotangentExactSeqAlpha` and `cotangentExactSeqBeta`, offset by
the merge of `cotangentExactSeq_structure`'s two sub-sorries into one).

## Repair strategy

Per PROGRESS.md / task_pending.md instructions, this lane was repair-only.
The 12-error / 200k-heartbeat cascade rooted in three in-flight definitions
was too entangled to repair in-iteration without violating the "no chains
of thin helpers" / "no new helpers" hard constraints. All three definitions
rolled back to a clean `sorry` with a `-- ITER-076` marker comment naming the
specific blocker.

The long h_zero strategy block (Steps 1-7, ~220 LOC with `hα_fac` / `hβ_fac` /
`hd_app` setup, adjunction-coherence `hcoh`, `SheafOfModules.hom_ext`,
`isUniversal'.postcomp_injective`, `Derivation.congr_d`, `postcomp_d_apply`
chain) is preserved verbatim inside a `/- ... -/` block comment from the
rolled-back `cotangentExactSeq_structure`, marked `ITER-076 disabled chain`.
The next prover can re-enable it once the upstream `cotangentExactSeqAlpha`
and `cotangentExactSeqBeta` bodies are closed.

## Per-declaration outcomes

### `relativeDifferentialsPresheaf_isSheaf` (L113)
UNCHANGED. Compile-clean sorry. Original phase-B placeholder.

### `cotangentExactSeqAlpha` (L199)
- **Result:** ROLLED BACK to `sorry`.
- **Blocker.** Five cumulative `rw` / pattern errors in the `d_target` constructor:
  - L244: `(by intro a b; simp)` for `AddMonoidHom.mk'`'s additivity left
    `D_X.d ((f.c.app U).hom (a + b)) = D_X.d ((... a)) + D_X.d ((... b))`
    unsolved. `simp` insufficient; `rw [map_add, D_X.d_add]` is the natural fix
    but unverified.
  - L248: `rw [(f.c.app U).hom.map_mul, D_X.d_mul]` fails — Lean reports the
    pattern `(CommRingCat.Hom.hom (f.c.app U)) (?a * ?b)` not found, despite
    the term being syntactically present. Likely a coercion / elaboration
    mismatch on the implicit `*`-instance.
  - L256: `Function expected at ConcreteCategory.hom h` — `congr_arg (fun h => ConcreteCategory.hom h x) (f.c.naturality f')` leaves `h` underspecified.
    Tagging the type via `(fun h : _ ⟶ _ => ...)` is the suggested fix.
  - L258: same `rw` pattern issue as L248.
  - L266: `rfl` claim for `φ_g' ≫ f.c = adj_f.unit ≫ pushforward.map φ_fg'`
    fails — the adjunction-coherence identity across `(f ≫ g).base = g.base ≫ f.base`
    is NOT definitionally true. Needs to be derived via
    `Adjunction.homEquiv_naturality` + `Equiv.symm_apply_eq`.
- **Decomposition preserved.** Strategy is `homEquiv.symm` to convert to a
  morphism on `Y.Modules`, then build via the universal property of
  `relativeDifferentials' φ_g'` with `d_target.d b = D_X.d ((f.c.app U).hom b)`
  where `D_X := derivation' φ_fg'`.

### `cotangentExactSeqBeta` (L224)
- **Result:** ROLLED BACK to `sorry`.
- **Blocker.** `set adj_fg / set η / hη` chain (L304-L306 in original) produced
  cumulative `whnf` heartbeat timeouts (≥ 200000 hb) at L297, L342, L343, and a
  redundant `exact h4` at L332 after the upstream simp chain already closed the
  goal. The proof shape is correct but the elaboration cost of the nested
  `homEquiv` / `pushforward` rewrites is too high.
- **Recovery routes for iter-077+.**
  - `set_option maxHeartbeats 400000 in noncomputable def cotangentExactSeqBeta ...`
  - Or inline `η` rather than `set`-ing it.
- **Decomposition preserved.** Derive `d1 : Derivation' φ1'` from
  `d2 := derivation' φ2'` via the adjunction-mediated `η : φ_{(f≫g)}'` factoring
  through `φ_f'`, then call `isUniversal' φ1'.desc d1`.

### `cotangentExactSeq_structure` (L251)
- **Result:** ROLLED BACK whole body to single `sorry`. Eliminated L604 and L617
  (original two sub-sorries `h_exact` / `h_epi`).
- **Blocker.** Cascade. `h_zero`'s Step 7c `Universal.fac` chain (L452 simp made
  no progress, then `unfold cotangentExactSeqAlpha / cotangentExactSeqBeta`
  failed because those upstream defs are sorries). The strategic comment block
  (Steps 1-7 + Mathlib leverage names + adjunction-coherence `hcoh` + per-step
  `hα_fac` / `hβ_fac`) is preserved as a `/- ... -/` block comment after the
  rolled-back body for the next prover to re-enable.

### `cotangent_exact_sequence` (L506) — UNCHANGED
Stays a definitional `obtain` from `cotangentExactSeq_structure`. Compiles fine
once the upstream sorries are accepted.

### `smooth_iff_locally_free_omega` (L543)
UNCHANGED. Phase-B placeholder.

### `cotangent_at_section` (L559)
UNCHANGED. Phase-B placeholder.

### `serre_duality_genus` (L703)
UNCHANGED. Phase-D placeholder.

## Mathlib leverage names re-confirmed (for next iter)

`Adjunction.homEquiv_naturality_right`, `Adjunction.homAddEquiv_zero`,
`Equiv.apply_symm_apply`, `SheafOfModules.hom_ext`,
`PresheafOfModules.DifferentialsConstruction.isUniversal'.postcomp_injective`,
`PresheafOfModules.Derivation.d_app`, `PresheafOfModules.Derivation.congr_d`,
`PresheafOfModules.Derivation.postcomp_d_apply`,
`PresheafOfModules.comp_app`, `PresheafOfModules.pushforward_map_app_apply`,
`PresheafOfModules.DifferentialsConstruction.derivation'`,
`Adjunction.homEquiv_naturality_left`, `LocallyRingedSpace.comp_c`.

## Sorry inventory (final)

| Line | Decl | Origin |
|------|------|--------|
| 122 | `relativeDifferentialsPresheaf_isSheaf` | pre-iter-076 |
| 207 | `cotangentExactSeqAlpha` | ITER-076 rollback |
| 232 | `cotangentExactSeqBeta` | ITER-076 rollback |
| 266 | `cotangentExactSeq_structure` | ITER-076 rollback (absorbs old L604/L617) |
| 543 | `smooth_iff_locally_free_omega` | pre-iter-076 |
| 559 | `cotangent_at_section` | pre-iter-076 |
| 703 | `serre_duality_genus` | pre-iter-076 |

## Blueprint marker

No blueprint edits performed (prover-stage rule). `\leanok` markers in
`blueprint/src/chapters/Differentials.tex` should be re-synced by
`sync_leanok` next phase based on the actual sorry state above.

## Recommendation for iter-077 (next prover round)

Priority for `Differentials.lean` should be:

1. **Re-attempt `cotangentExactSeqAlpha`** with the specific fixes from the
   plan agent's error inventory (L244 use `rw [map_add, D_X.d_add]`; L248/L258
   use explicit `show ...; rw [...]; rfl`; L256 type-annotate the `h` in
   `congr_arg`; L266 use `Adjunction.homEquiv_naturality` instead of `rfl`).
2. **Re-attempt `cotangentExactSeqBeta`** with `set_option maxHeartbeats 400000 in`
   prepended to the definition, and remove the redundant `exact h4` at the
   original L332 site.
3. Once both upstream defs compile, re-enable the disabled `h_zero` chain
   inside `cotangentExactSeq_structure` (it's preserved verbatim in the
   `/- ITER-076 disabled chain ... -/` block comment).

No new helper lemmas; no new axioms; `lean_diagnostic_messages` after every
save (NOT `lean_run_code` pre-validation).
