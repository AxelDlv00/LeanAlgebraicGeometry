# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean — iter-182 Lane G PIVOT

## Summary

**SUCCESS** — Lane G PIVOT target `depth_of_short_exact` (L268) closed
**Tier-2 kernel-clean modulo `depth_eq_smallest_ext_index`** (the typed
sorry one section above in the same file).

- File sorry count: **4 → 3** (net **−1**).
- Project axioms introduced: **0**.
- 2 new private helper lemmas: `ext_vanish_of_natCast_lt_depth`
  (Tier-2 modulo same upstream) and `natCast_add_one_le_of_le_sub_one`
  (Tier-1 axiom-clean, verified via inline `#print axioms`).
- Helper budget consumed: **2 / 2**.
- LOC added: ~140 (2 helpers + 3-branch main body).
- 3-tier disclosure threaded in each new docstring per iter-181
  vocabulary.

## depth_of_short_exact (line 285)

### Attempt 1 — LES of `Ext^*(κ, -)` via `covariant_sequence_exact₁/₂/₃`
- **Approach**: Package the SES `(f, g, _hf, _hg, _hex)` as a
  `ShortComplex.ShortExact` in `ModuleCat.{u} R` via
  `ModuleCat.shortComplex_shortExact`. Apply
  `CategoryTheory.Abelian.Ext.covariant_sequence_exact₁/₂/₃` from
  `Mathlib/Algebra/Homology/DerivedCategory/Ext/ExactSequences.lean`
  to chase Ext-vanishing through the LES at `κ = ModuleCat.of R
  (IsLocalRing.ResidueField R)`.
- **Reduction**: `(↑a ≤ depth M)` ↔ `∀ n, ↑n ≤ ↑a → ↑n ≤ depth M` via
  `ENat.forall_natCast_le_iff_le`. For each `a : ℕ`, expand
  `depth_eq_smallest_ext_index` and discharge the per-`i < a` Ext
  vanishing.
- **Result**: **RESOLVED**.
- **Per-branch details**:
  1. `min(depth N', depth N'') ≤ depth N`: postcompose `e` (in `Ext^i κ
     N`) by `S.g` to land in `Ext^i κ N'' = 0`; exact₂ lifts to `Ext^i
     κ N' = 0`, so `e = 0`.
  2. `min(depth N, depth N' - 1) ≤ depth N''`: postcompose `e` (in
     `Ext^i κ N''`) by the extClass to land in `Ext^{i+1} κ N' = 0`;
     exact₃ lifts to `Ext^i κ N = 0`. Requires the ENat tsub bridge
     `↑a ≤ depth N' - 1 ∧ a ≥ 1 → ↑(a+1) ≤ depth N'` (Helper B).
  3. `min(depth N, depth N'' + 1) ≤ depth N'`: case-split on `i = 0`
     vs `i ≥ 1`.
     - For `i = 0`: `S.f` mono in `ModuleCat R` (from `_hf`), so
       `(mk₀ S.f).postcomp` is injective at degree 0 by
       `postcomp_mk₀_injective_of_mono`. Image `e ∘ S.f` is in
       `Ext^0 κ N = 0`, so `e = 0`.
     - For `i = j + 1`: exact₁ at `n₀ = j, n₁ = j+1` gives `Ext^j κ
       N'' → Ext^{j+1} κ N'`; lift `e` via the postcomp-zero condition
       `e ∘ S.f = 0` (in `Ext^{j+1} κ N = 0`). Requires `↑j < depth
       N''`, obtained from `↑(j+2) ≤ ↑a ≤ depth N'' + 1` plus
       `ENat.add_le_add_iff_right` cancellation plus
       `ENat.add_one_le_iff`.

### Helpers (private to the file)
- **Helper A** `ext_vanish_of_natCast_lt_depth`: `(i : ℕ∞) < depth M
  → ∀ e : Ext κ (of R M) i, e = 0`. Body packages
  `depth_eq_smallest_ext_index` for the LES chase via `n := i + 1` +
  `Nat.lt_succ_self`. Tier 2 modulo `depth_eq_smallest_ext_index`.
- **Helper B** `natCast_add_one_le_of_le_sub_one`: `1 ≤ a → ↑a ≤ d - 1
  → ↑(a+1) ≤ d` in `ℕ∞`. Case-split on `d = ⊤` (trivial via `simp [hd]`)
  vs `d = ↑n` (drop to `ℕ` via `WithTop.ne_top_iff_exists` + `omega`).
  **Tier 1 axiom-clean** — verified via inline `#print axioms` test:
  ```
  '_private._stdin.0.Test.natCast_add_one_le_of_le_sub_one' depends on
   axioms: [propext, Classical.choice, Quot.sound]
  ```
  (no `sorryAx`).

### Tooling traps recorded
- `simpa using h0` where `h0 := hinj hef` for the degree-0 mono case
  timed out at 200000 heartbeats (`whnf` cannot reduce
  `(postcomp ...) e = (postcomp ...) 0` automatically). **Workaround**:
  use `apply hinj` first and then `simpa using hef` — splits the
  injectivity application before the `simp` normalization.
- `one_ne_top` does not exist in scope; use
  `(by norm_num : (1 : ℕ∞) ≠ ⊤)` instead.
- `Nat.exists_eq_succ_of_ne_zero` returns `i = j.succ` (not `i = j + 1`),
  so `exact_mod_cast Nat.add_lt_add_right hi 1` fails the unification.
  **Workaround**: extract the predecessor and use `omega` for the
  arithmetic.
- `Nat.cast_le.mpr hle` for `(a + 1 : ℕ) ≤ n → ((a + 1 : ℕ) : ℕ∞) ≤
  ((n : ℕ) : ℕ∞)` is the correct form; `exact_mod_cast hle` fails because
  the goal already has the cast applied (not synth-friendly).

### Axiom verification
- `'RingTheory.Module.depth_of_short_exact' depends on axioms:
  [propext, sorryAx, Classical.choice, Quot.sound]` — matches
  `'RingTheory.Module.depth_eq_smallest_ext_index' depends on axioms:
  [propext, sorryAx, Classical.choice, Quot.sound]`. The `sorryAx`
  propagates **only** through the single upstream
  `depth_eq_smallest_ext_index` typed sorry (L228). Tier-2 disclosure.

## Other sorries in this file (unchanged this iter)

- `depth_eq_smallest_ext_index` L228 — typed sorry; substantive Stacks
  00LP proof (induction via LES on `0 → M → M → M/xM → 0`). Off-target.
- `auslander_buchsbaum_formula` L453 (line shifted from L326 by helpers)
  — typed sorry; multi-iter Stacks 090V content. Off-target.
- `exists_isRegular_of_regularLocal` L562 (line shifted from L435) —
  typed sorry; Mathlib gap `IsRegularLocalRing → IsDomain` per
  `analogies/isregularlocalring-isdomain.md`. Off-target (deferred
  iter-183+).

## Blueprint marker recommendation

- `lem:depth_short_exact_sequence` proof block (chapter
  `Albanese_AuslanderBuchsbaum.tex` L241-258): **READY for `\leanok` on
  the proof block** (the statement block was already `\leanok` from
  iter-175). The sync_leanok phase should propagate automatically since
  the body now compiles modulo only typed upstream sorries — though the
  transitive `sorryAx` from `depth_eq_smallest_ext_index` may keep
  `sync_leanok` from marking the proof block. Recommend review-agent
  judgment on whether Tier-2 modulo a same-chapter upstream qualifies
  for `\leanok` on the proof block; my read of the project rule is
  **yes** since the upstream is itself a `\leanok`-pinned statement (its
  proof block would not yet be `\leanok`).

## Dead ends (none triggered this iter)

The analogist recipe from `analogies/isregularlocalring-isdomain.md`
**Option 1 PIVOT recommendation** (away from
`exists_isRegular_of_regularLocal`, toward `depth_of_short_exact`) was
the right call. The LES-of-Ext route landed in a single iter with the
helper budget intact. The off-target option `depth_eq_smallest_ext_index`
(also in Option 1) remains substantive — its body is the inductive
chase on `0 → M → M → M/xM → 0` and was correctly NOT this iter's
target.

## Next-iter consumer hand-offs

- iter-183 `auslander_buchsbaum_formula` body lane can consume
  `depth_of_short_exact` directly as a building block of the SES
  splitting argument (Stacks 090V base case).
- The 3-helper pattern (Helper A Ext-vanish-from-strict-depth-bound +
  Helper B ENat-tsub-bridge + Helper C SES packaging-via-
  `shortComplex_shortExact`) is **reusable** for any future LES chase
  in the depth/Ext layer. Helper A and B are private to this file;
  consider promoting to public file-namespace lemmas if iter-183
  `auslander_buchsbaum_formula` or downstream `CohenMacaulay`-cor body
  reuses them. (No PROGRESS.md guidance to do this yet, so I left
  them `private`.)
