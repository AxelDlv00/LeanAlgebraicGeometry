# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-028 — Phase A step 6 *Path 2* / Serre-finiteness scaffolding kickoff

**Status: RESOLVED.** Two new declarations appended cleanly; zero new `sorry`,
zero new `axiom`, file compiles with `{success: true, items: [], failed_dependencies: []}`.

### `Scheme.AffineCoverMVSquare` (structure, new)
**Approach:** Verbatim copy of the plan-agent probe-confirmed body block —
six fields (`U₁`, `U₂`, `isAffineOpen_U₁`, `isAffineOpen_U₂`,
`isAffineOpen_inf`, `cover`). Inserted into the existing
`namespace AlgebraicGeometry.Scheme` block (already opened at L44 of the
file, closed at the bottom).
**Result:** RESOLVED. No proof obligation (pure `structure`).

### `Scheme.AffineCoverMVSquare.toMayerVietorisSquare` (`noncomputable def`, new)
**Approach:** Term-mode body `Opens.mayerVietorisSquare S.U₁ S.U₂` per the
plan-agent's probe-confirmed instructions. The `noncomputable` modifier is
load-bearing because Mathlib's `Opens.mayerVietorisSquare` is itself
`noncomputable`.
**Result:** RESOLVED.

### Verification (this session)

1. **`lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean`** —
   `{success: true, items: [], failed_dependencies: []}`. Zero errors, zero
   warnings.
2. **Four corner `rfl`-equalities probed via `lean_run_code`** —
   `{success: true, diagnostics: []}`:
   - `S.toMayerVietorisSquare.toSquare.X₁ = S.U₁ ⊓ S.U₂` by `rfl` ✓
   - `S.toMayerVietorisSquare.toSquare.X₂ = S.U₁` by `rfl` ✓
   - `S.toMayerVietorisSquare.toSquare.X₃ = S.U₂` by `rfl` ✓
   - `S.toMayerVietorisSquare.toSquare.X₄ = S.U₁ ⊔ S.U₂` by `rfl` ✓
3. **Sorry count** — 9 actual `sorry` tokens project-wide (5 `Jacobian.lean`,
   3 `AbelJacobi.lean`, 1 `Picard/Functor.lean`); the 9 → 10 → 9 transient
   trajectory was avoided because the body was inlined directly (no scaffold
   `sorry` ever introduced).
4. **No new `axiom` declarations** in `AlgebraicJacobian/`.
5. **Section/namespace integrity** — wrapped the two declarations in a
   `section AffineCoverMVSquare` … `end AffineCoverMVSquare` block placed
   before the file-final `end AlgebraicGeometry.Scheme`. The file's
   `namespace AlgebraicGeometry.Scheme` (L44) and `end AlgebraicGeometry.Scheme`
   (now ~L605) both stand unchanged in their roles; the section header is
   purely organizational and adds no namespacing.
6. **Protected file unchanged** — `archon-protected.yaml` not touched
   (no protected declarations live in this file).

### Blueprint markers ready for review-agent attention

The blueprint chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
already contains the iter-028 § *2-affine cover Mayer-Vietoris square (iter-028)*
with the three labels:
- `def:Scheme_AffineCoverMVSquare` — formalised, ready for `\leanok`
- `def:Scheme_AffineCoverMVSquare_toMayerVietorisSquare` — formalised, ready for `\leanok`
- `lem:Scheme_AffineCoverMVSquare_corners` — informal lemma; the four
  `rfl`-equalities are documented but not exposed as named Lean lemmas (the
  blueprint records them as plan-agent probe-verified). The plan-agent
  documented this is "not formalised as named lemmas". No marker change
  expected unless the review agent decides to upgrade.

### Notes

- Single-Edit form was used (refactor + prover sub-phases collapsed, per
  iter-028 plan permission).
- No deviations from the probe-confirmed body block.
- No alternative routes attempted; the prescribed body compiled on the first
  try.

### Next-iteration suggestions (informational only)

Per `task_pending.md` § *Iter-029+ candidate scoping*:
1. `Scheme.AffineCoverMVSquare.cover_top` — derived simp lemma identifying
   `S.toMayerVietorisSquare.toSquare.X₄` with `⊤` via `S.cover`.
2. `Scheme.AffineCoverMVSquare.HModule'_apply` — apply iter-022/iter-026 LES
   to `S.toMayerVietorisSquare` and `toModuleKSheaf C`.
3. Affine vanishing input `H^{>0}(Spec A, F) = 0` (multi-iteration probe of
   Mathlib state required first).
4. `Module.Finite k (HModule k (toModuleKSheaf C) i)` — multi-iteration target
   that consumes all of (1)–(3).
