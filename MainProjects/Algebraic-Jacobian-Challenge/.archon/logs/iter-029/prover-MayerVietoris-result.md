# AlgebraicJacobian/Cohomology/MayerVietoris.lean

## Iter-029 — Phase A step 6 *Path 2* / Serre-finiteness scaffolding companions

### Outcome: RESOLVED — six new declarations appended

Six declarations appended at the end of `section AffineCoverMVSquare`,
between L596 (the iter-028 `toMayerVietorisSquare` body) and the previous
`end AffineCoverMVSquare`:

1. `AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₁` (`@[simp] lemma`, `rfl`)
2. `AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₂` (`@[simp] lemma`, `rfl`)
3. `AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₃` (`@[simp] lemma`, `rfl`)
4. `AffineCoverMVSquare.toMayerVietorisSquare_toSquare_X₄` (`@[simp] lemma`, `S.cover`)
5. `AffineCoverMVSquare.HModule'_sequence` (`noncomputable def`)
6. `AffineCoverMVSquare.HModule'_sequence_exact` (`lemma`)

### Attempt 1 — verbatim probe-confirmed body block

- **Approach**: Pasted the plan-agent's probe-confirmed body block verbatim with
  bare in-namespace short names `HModule'_sequence` and `HModule'_sequence_exact`
  in the term-mode bodies of declarations (5) and (6).
- **Result**: FAILED. `lean_diagnostic_messages` returned two errors at L634/L644:
  - L634: `S.toMayerVietorisSquare` had type
    `(Opens.grothendieckTopology X.toTopCat).MayerVietorisSquare` but was
    expected to be `X.AffineCoverMVSquare`. The bare `HModule'_sequence` was
    being resolved to the **new** declaration being defined (recursive lookup),
    not the abstract iter-022 one at L397.
  - L644: cascading type mismatch between abstract `(HModule'_sequence k _ F …).Exact`
    and the lemma's stated `(S.HModule'_sequence k F …).Exact` because of the
    upstream broken def.
- **Root cause**: Lean 4 auto-opens the `AffineCoverMVSquare` namespace inside
  the body of `def AffineCoverMVSquare.HModule'_sequence`. With both
  `AlgebraicGeometry.Scheme.HModule'_sequence` (abstract, L397) and
  `AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence` (the new def)
  reachable, the deeper namespace wins on bare references.

### Attempt 2 — fully-qualified `_root_.AlgebraicGeometry.Scheme.HModule'_sequence`

- **Approach**: Disambiguated by replacing bare `HModule'_sequence` and
  `HModule'_sequence_exact` in (5) and (6)'s term-mode bodies with their
  fully-qualified `_root_.AlgebraicGeometry.Scheme.HModule'_sequence` and
  `_root_.AlgebraicGeometry.Scheme.HModule'_sequence_exact` references.
  The `_root_` prefix bypasses both the auto-opened `AffineCoverMVSquare`
  sub-namespace and the in-namespace `Scheme` short-name (which would
  double-prefix to `AlgebraicGeometry.Scheme.Scheme.HModule'_sequence`).
- **Result**: RESOLVED. `lean_diagnostic_messages` returns
  `{success: true, items: [], failed_dependencies: []}`.
- **Key insight**: The plan-agent's "Known dead ends" listed
  `Scheme.HModule'_sequence` as a double-prefix trap, but did not flag the
  reverse problem — that the bare `HModule'_sequence` short name is also
  unsafe **when the new declaration is named with a sub-namespace prefix**
  (`AffineCoverMVSquare.`). The bare-name convention works for the iter-016 →
  iter-026 cohort because all of those declarations are top-level inside
  `namespace AlgebraicGeometry.Scheme`. Once a declaration is itself
  sub-namespaced (`AffineCoverMVSquare.X`), the auto-opened sub-namespace
  shadows the parent's bare names.
- **Docstring update**: Added a one-line note in (5)'s docstring documenting
  why the `_root_` prefix is required, so future iterations don't retry the
  bare-name form.

### Verification

1. `lean_diagnostic_messages` on the post-edit file: `{success: true, items: [],
   failed_dependencies: []}`. Zero warnings, zero errors.
2. `lean_verify AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence`:
   `{axioms: [propext, Classical.choice, Quot.sound], warnings: [pre-existing
   local instance warning at L179]}` — kernel-only.
3. `lean_verify AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_exact`:
   same kernel-only axioms.
4. Sorry count via `sorry_analyzer.py`: `9 total across 3 file(s)` — unchanged
   from pre-iter-029 (`9 → 9`).
5. File LOC: 652 (was 600 → +52). Slightly above the +30 estimate due to the
   added explanatory docstring on (5) about `_root_`. Still well under the
   ~700 LOC threshold.
6. The four `@[simp]` corner lemmas (1)–(4) closed exactly as plan-agent
   specified: `rfl` for X₁/X₂/X₃, `S.cover` for X₄.

### Deviation from plan

- **Bodies (5) and (6) use `_root_.AlgebraicGeometry.Scheme.HModule'_sequence`
  and `_root_.AlgebraicGeometry.Scheme.HModule'_sequence_exact`** instead of
  the bare `HModule'_sequence` / `HModule'_sequence_exact` form the
  plan-agent's probe specified. The plan-agent's probe missed the auto-open
  sub-namespace shadowing. The semantics are identical (both resolve to the
  same iter-022 / iter-026 declarations); the `_root_` prefix is a
  syntactic disambiguation only.
- The "Known dead ends" list should be updated to note: **bare name resolution
  inside `AffineCoverMVSquare.X` declaration bodies is also a dead end** for
  declarations whose name collides with a parent-namespace declaration.

### Blueprint markers

The review agent should mark the following blueprint environments in
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` § *Companion simp lemmas
+ abstract LES specialisation (iter-029)*:

- `lem:Scheme_AffineCoverMVSquare_X1` → `\leanok` (proof complete)
- `lem:Scheme_AffineCoverMVSquare_X2` → `\leanok`
- `lem:Scheme_AffineCoverMVSquare_X3` → `\leanok`
- `lem:Scheme_AffineCoverMVSquare_X4` → `\leanok`
- `def:Scheme_AffineCoverMVSquare_HModule_prime_sequence` → `\leanok`
- `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_exact` → `\leanok`

### Next steps for plan agent

- Iter-030+ work continues with the toModuleKSheaf specialisation (specialising
  the iter-029 sheaf-parameterised LES to `F = toModuleKSheaf C`), the
  affine-vanishing extraction `H^{>0}(Spec A, F) = 0`, and the eventual
  Serre-finiteness `Module.Finite k (HModule k F i)` on a proper k-curve, which
  `smoothOfRelativeDimension_genus` (Jacobian.lean) will eventually consume.
- The four `@[simp]` corner lemmas are now in the simp set, so iter-030+
  `simp`-driven unfolding of `S.toMayerVietorisSquare.toSquare.X_j` will rewrite
  to the underlying cover data automatically.
