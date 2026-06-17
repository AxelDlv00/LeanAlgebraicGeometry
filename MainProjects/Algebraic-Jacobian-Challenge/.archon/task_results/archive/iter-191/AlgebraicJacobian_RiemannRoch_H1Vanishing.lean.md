# AlgebraicJacobian/RiemannRoch/H1Vanishing.lean

## Iter-191 Lane H prover dispatch (second call this iter)

### Summary

**PARTIAL RESOLVED** beyond the iter-191 file-skeleton HARD BAR: four
of the seven typed-`sorry` pins introduced by the file-skeleton dispatch
were closed axiom-clean. The headline declaration
`Scheme.H1_skyscraperSheaf_finrank_eq_zero` (decl #8) is now closed via
composition; only its substrate `HModule_flasque_eq_zero` (Hartshorne
III.2.5) carries the remaining sorry. Sorry trajectory for this file:
**7 → 3** (net −4).

### Status after this dispatch

| # | Declaration | Body before | Body after |
|---|---|---|---|
| 1 | `Scheme.IsFlasque`                              | concrete | concrete |
| 2 | `Scheme.IsFlasque.pushforward`                  | `sorry` | **CLOSED** |
| 3 | `Scheme.IsFlasque.constant_of_irreducible`      | `sorry` | `sorry` |
| 4 | `Scheme.HModule_flasque_eq_zero`                | `sorry` | `sorry` |
| 5 | `Scheme.skyscraperSheaf_eq_pushforward_const`   | `sorry` | `sorry` |
| 6 | `Scheme.PrimeDivisor.closure_isIrreducible`     | `sorry` | **CLOSED** |
| 7 | `Scheme.skyscraperSheaf_isFlasque`              | `sorry` | **CLOSED** |
| 8 | `Scheme.H1_skyscraperSheaf_finrank_eq_zero`     | `sorry` | **CLOSED** (chained on #4) |

### Closures (4 declarations)

#### `Scheme.IsFlasque.pushforward` (line 119) — RESOLVED

**Approach:** by-definition unfolding. The pushforward sheaf's restriction
map along `V ≤ U` in `Y` is, definitionally (`rfl`), the restriction map
of `F` along `(Opens.map f).map (homOfLE h) : (Opens.map f).obj V ⟶
(Opens.map f).obj U` in `X`. Hence flasqueness of `F` applied to
`((Opens.map f).map (homOfLE h)).le` closes the conclusion.

**Final proof (2 lines):**
```lean
intro U V h
exact hF ((Opens.map f).map (homOfLE h)).le
```
Axioms: `propext, Classical.choice, Quot.sound` (kernel only).

#### `Scheme.PrimeDivisor.closure_isIrreducible` (line 226) — RESOLVED

**Approach:** the predicted iter-192+ one-liner. Direct application of
Mathlib's `isIrreducible_singleton.closure`.

**Final proof (1 line):**
```lean
isIrreducible_singleton.closure
```
Axioms: `propext, Classical.choice, Quot.sound` (kernel only).

#### `Scheme.skyscraperSheaf_isFlasque` (line 250) — RESOLVED via direct route

**Approach:** the iter-191 file-skeleton task_results predicted closure
via the 4-input composition `7 ← {2, 3, 5, 6}` (Hartshorne II Ex.
1.16(a)/(d) and 1.17). This dispatch found a shorter direct route that
bypasses the unproven (3) and (5):

1. Unfold `(skyscraperSheaf p A).val = skyscraperPresheaf p A` (this is
   `rfl`, confirmed via `lean_run_code`).
2. The restriction map along `V ≤ U` is, by `skyscraperPresheaf_map`:
   - if `P.point ∈ V`: `eqToHom _` (a category-theoretic identity-up-to-
     proof-of-equality), hence `IsIso` by Mathlib's `instIsIsoEqToHom`,
     hence surjective on the underlying type by
     `ConcreteCategory.bijective_of_isIso.2`;
   - if `P.point ∉ V`: codomain is `⊤_ ModuleCat kbar`, which is the
     zero object, hence the underlying type is `Subsingleton` (via
     `ModuleCat.subsingleton_of_isZero` and
     `terminalIsTerminal.isZero`); surjectivity is then trivial
     `⟨0, Subsingleton.elim _ _⟩`.

This avoids needing decl (3) `IsFlasque.constant_of_irreducible` (the
sheafification-of-constant-presheaf-on-irreducible lemma) and decl (5)
`skyscraperSheaf_eq_pushforward_const` (the sheaf-level pushforward
upgrade of Mathlib's presheaf-level `skyscraperPresheaf_eq_pushforward`),
both of which require substantial Mathlib API work. The chapter prose can
still cite the Hartshorne route while the formalization uses the direct
calculation.

**Final proof (~20 lines):**
```lean
intro U V h
change Function.Surjective
  (((skyscraperPresheaf P.point (ModuleCat.of kbar kbar)).map
    (homOfLE h).op).hom)
by_cases hV : P.point ∈ V
· have heq : (skyscraperPresheaf ...).obj (op U) =
      (skyscraperPresheaf ...).obj (op V) := by
    simp [skyscraperPresheaf, h hV, hV]
  have hmap := skyscraperPresheaf_map P.point ... (i := (homOfLE h).op)
  rw [dif_pos hV] at hmap
  rw [hmap]
  have : IsIso (eqToHom heq) := inferInstance
  exact (ConcreteCategory.bijective_of_isIso (eqToHom heq)).2
· have hzero : Limits.IsZero ((skyscraperPresheaf ...).obj (op V)) := by
    simp [skyscraperPresheaf, hV]; exact terminalIsTerminal.isZero
  have : Subsingleton ((skyscraperPresheaf ...).obj (op V)) :=
    ModuleCat.subsingleton_of_isZero hzero
  intro y; exact ⟨0, Subsingleton.elim _ _⟩
```
Axioms: `propext, Classical.choice, Quot.sound` (kernel only).

#### `Scheme.H1_skyscraperSheaf_finrank_eq_zero` (line 283) — RESOLVED via composition

**Approach:** straight composition of (now-closed) #7
`skyscraperSheaf_isFlasque` and (still-open) #4
`HModule_flasque_eq_zero` at `i = 1`. Because the chain feeds the closed
#7 into the still-open #4, this declaration is **logically chained on
#4**: the *current* file has 0 visible `sorry` in this declaration's
body, but the kernel-level dependency on `sorryAx` flows through the
chain into #4.

**Final proof (1 line):**
```lean
Scheme.HModule_flasque_eq_zero (Scheme.skyscraperSheaf_isFlasque C P) 1 le_rfl
```
Axioms: `propext, sorryAx, Classical.choice, Quot.sound` (the
`sorryAx` is inherited from decl #4's body, not introduced here).

### Remaining sorries (3 declarations)

These three are deferred to iter-192+ per the original Lane H plan; their
substrate work is substantial and not closeable within a single prover
dispatch.

#### `Scheme.IsFlasque.constant_of_irreducible` (line 137) — `sorry`

**Why deferred:** `constantSheaf` is defined as the sheafification of the
constant presheaf. On an irreducible space, the constant presheaf is
*already* a sheaf, so the sheafification iso is the identity. Proving this
rigorously requires:
1. Mathlib API for the constant presheaf as already-a-sheaf on
   irreducible spaces — **not present** as a direct lemma in
   `Mathlib.Topology.Sheaves.Sheafify` or
   `Mathlib.CategoryTheory.Sites.ConstantSheaf` (snapshot b80f227 — see
   `lean_leansearch "constant presheaf is sheaf when irreducible"`).
2. Either build that API (~50-100 LOC), OR use
   `Sheaf.isConstant_iff_isIso_counit_app` machinery to show the
   `constantSheafAdj` counit is an iso on the constant sheaf (requires
   `(constantSheaf _ _).Faithful`/`.Full` instances — also not directly
   present).

**Negative search results recorded:**
- `lean_leansearch "constant presheaf is sheaf when irreducible"` —
  nothing in Mathlib.
- `lean_leansearch "constantSheaf evaluation on opens"` — no
  computational lemma for `(constantSheaf J D).obj A` value on opens.

**iter-192+ approach options:**
- (A) Build `constantPresheaf.IsSheaf` on irreducible spaces, then use
  `sheafification_unique`.
- (B) Use the `Functor.Faithful`/`Functor.Full` route via
  `constantSheafAdj` and `Sheaf.isConstant_iff_isIso_counit_app`.
- (C) **Direct route per the iter-191 prover's #7 closure**: simply note
  that #7 was closed *without* using #3 or #5, so #3 may become only
  optional / project-orphan. The blueprint chapter and downstream
  consumers should be reviewed to determine whether (3) is still needed
  anywhere.

#### `Scheme.HModule_flasque_eq_zero` (line 169) — `sorry`

**Why deferred:** this IS the heavy Hartshorne III.2.5 itself. Per the
file-skeleton task_results, the substrate inputs (Hartshorne II Ex.
1.16(b)/(c) helpers + LES carrier for `Abelian.Ext.covariantSequence` at
the `HModule` level) are scheduled across **~8-12 iters / ~150-300 LOC**
per `STRATEGY.md` `RR.2.H¹`. Not closeable in one dispatch.

#### `Scheme.skyscraperSheaf_eq_pushforward_const` (line 199) — `sorry`

**Why deferred:** Mathlib has the *presheaf-level*
`skyscraperPresheaf_eq_pushforward` (snapshot b80f227
`Topology/Sheaves/Skyscraper.lean`), but no direct sheaf-level upgrade.
Closing this requires either lifting the presheaf equality to a sheaf
iso (manual `⟨hom, inv, ...⟩` construction with the underlying presheaf
equality as the iso witness) or refactoring `PUnit` to the closure
subspace. Either route is non-trivial.

**iter-192+ note:** since #7 was closed without using #5, this
declaration is also now **only optional** for the Lane H deliverable.
Review whether downstream consumers still want it as a standalone lemma.

### Build verification

- `lake build AlgebraicJacobian.RiemannRoch.H1Vanishing` — **GREEN**
  (4.8s, 3 `sorry` warnings as designed: lines 138, 170, 200).
- `lake build AlgebraicJacobian` — **GREEN** (8360 jobs).
- `lean_diagnostic_messages` with `severity: error` — empty.

### Axiom hygiene

Verified via `lean_verify` (full names, scan_source=false):

| Declaration | Axioms |
|---|---|
| `Scheme.PrimeDivisor.closure_isIrreducible` | `{propext, Classical.choice, Quot.sound}` |
| `Scheme.IsFlasque.pushforward`             | `{propext, Classical.choice, Quot.sound}` |
| `Scheme.skyscraperSheaf_isFlasque`         | `{propext, Classical.choice, Quot.sound}` |

All three direct closures are **kernel-axiom-only** (no `sorryAx`). The
chained closure of `H1_skyscraperSheaf_finrank_eq_zero` carries `sorryAx`
inherited via #4 `HModule_flasque_eq_zero`'s body.

### Strategic note on bypassed (3) and (5)

The file-skeleton task_results predicted the closure chain
`8 ← {4, 7}, 7 ← {2, 3, 5, 6}`. This dispatch found that #7
`skyscraperSheaf_isFlasque` admits a **direct route** that bypasses both
(3) and (5):

- (3) `IsFlasque.constant_of_irreducible` — was supposed to feed the
  flasqueness of the constant sheaf on `PUnit` into the pushforward.
- (5) `skyscraperSheaf_eq_pushforward_const` — was supposed to identify
  `skyscraperSheaf` with the pushforward of the constant sheaf.

The direct route uses `skyscraperPresheaf_map` + ModuleCat-specific
`Subsingleton`-of-zero-object reasoning. The result: **#7 closes without
either (3) or (5)**, and so the Lane H minimal logical chain to close
#8 (the headline `H1_skyscraperSheaf_finrank_eq_zero`) is now just:

```
#8 (chained) ← #4 (heavy) + #7 (direct, closed)
```

i.e. the headline ONLY waits on Hartshorne III.2.5 (#4) to fully close;
(3) and (5) become **optional auxiliary lemmas** rather than the
critical-path substrate they were originally planned as.

**Recommendation for plan agent iter-192:** revisit whether decls (3)
and (5) are needed at all. If downstream consumers don't reference them
explicitly, they could be deleted from the file (and from the blueprint
`\lean{...}` pins) to consolidate the critical path to just (4) and
(8). If they remain in the blueprint as supporting lemmas (which has
mathematical/exposition value), they should stay as documented sorries.
The current file keeps both as documented `sorry`s with the docstring
notes flagging their now-optional status.

### Files modified

* `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` — 4 sorry bodies
  replaced with proofs; 4 docstrings updated from
  "Tier-3 honest typed sorry" to "iter-191 Lane H prover dispatch —
  closed via ..." with the specific closure recipe noted.

### Flag for the review agent

* Decls 2, 6, 7 are now **`\leanok`-eligible** (statement + body
  axiom-clean, no `sorry`). `sync_leanok` should add `\leanok` to their
  proof blocks in `chapters/RiemannRoch_H1Vanishing.tex`.
* Decl 8 has 0 visible `sorry` in body but carries inherited `sorryAx`
  via #4. `sync_leanok` policy: typically `\leanok` is added on
  statement block (decl exists) but the proof block should remain
  unmarked because of the inherited `sorryAx` (consistent with the
  blueprint-reviewer iter191 concern about spurious `\leanok`s). The
  deterministic `sync_leanok` phase should handle this correctly per
  its standard logic.
* Decls 3, 4, 5 retain `sorry`; their statement blocks remain `\leanok`-
  eligible (decls exist) but proof blocks remain unmarked.

### Sorry trajectory

`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`: **7 → 3** (net −4).
Project-wide expected delta from this file: **−4** (or net **0** vs the
post-file-skeleton baseline of +7, since the file-skeleton itself was
+7 over zero — so the total Lane H file-skeleton+closure delta is +3
sorries for the project, not the originally-budgeted +7).
