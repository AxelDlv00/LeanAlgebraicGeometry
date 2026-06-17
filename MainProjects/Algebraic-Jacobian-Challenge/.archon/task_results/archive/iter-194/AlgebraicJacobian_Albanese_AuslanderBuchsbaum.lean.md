# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## iter-194 Lane G — `depth(Fin k → R) = depth R` substrate (HARD BAR CLOSED)

### Status

**HARD BAR MET**: Sorries 2 → 1 (closed the `n = 0` branch substrate of
`auslander_buchsbaum_formula` at L953).

* L953 sorry — **CLOSED** axiom-clean via the new helper
  `Module.depth_pi_const_eq_depth_of_nonempty`.
* L1125 sorry — remains (n=k+1 inductive step, Stacks 090V; multi-iter
  substrate work documented at chapter L557-563).

### Approach 1 (RESOLVED)

**Goal at L953** (after the iter-193 Lane G scaffold):
```
Module.depth (𝔪) (Fin k → R) = Module.depth (𝔪) R    for k > 0.
```

* **Approach**: prove the general substrate `depth I (ι → M) = depth I M`
  for nonempty finite `ι`, then specialise at `ι = Fin k, M = R, I = 𝔪`.
* **Result**: RESOLVED axiom-clean (kernel axioms only:
  `propext, Classical.choice, Quot.sound`).
* **Lemmas added** (4 helpers + main, ~130 LOC, all `private` except the
  main lemma):
  1. `ideal_smul_top_pi_const` — `I • ⊤_{ι → M} = pi univ (fun _ => I • ⊤_M)`
     via `Submodule.smul_induction_on` (LHS≤RHS) + `Pi.single`-decomposition
     `Finset.univ_sum_single` (RHS≤LHS).
  2. `ideal_smul_top_pi_const_eq_top_iff` — side condition iff via
     `Pi.single j m` lifting and projection.
  3. `quotSMulTopPiConstLinearEquiv` — `QuotSMulTop r (ι → M) ≃ₗ ι → QuotSMulTop r M`
     via `Submodule.quotEquivOfEq` + `Submodule.quotientPi`, bridging
     `r • ⊤` and `Ideal.span {r} • ⊤` via `Submodule.ideal_span_singleton_smul`.
  4. `isRegular_pi_const_iff_of_nonempty` — sequence-level iff by induction
     on `rs` (generalising `M`), with the cons-case using
     `Pi.isSMulRegular_iff` for the SMul-regular conjunct and the
     `quotSMulTopPiConstLinearEquiv` + `LinearEquiv.isRegular_congr` for
     the quotient piece.
  5. **`depth_pi_const_eq_depth_of_nonempty`** (public main): assembles
     the supremum-set equality from #4 with the side-condition iff from #2.
* **Key Mathlib calls verified**: `Submodule.smul_induction_on`,
  `Submodule.map_smul''`, `LinearMap.single_apply` (rfl),
  `Finset.univ_sum_single`, `Pi.isSMulRegular_iff`,
  `LinearEquiv.isRegular_congr`, `Submodule.quotientPi`,
  `Submodule.quotEquivOfEq`, `Submodule.ideal_span_singleton_smul`.

### Site update (L953)

```lean
haveI : Nonempty (Fin k) := ⟨⟨0, hk⟩⟩
exact Module.depth_pi_const_eq_depth_of_nonempty _
```

Replaces the previous `sorry` and the obsolete plan comment.

### Remaining (L1125, n=k+1 inductive step)

**Per PROGRESS.md framing**: 4 Mathlib substrate gaps documented at
chapter `Albanese_AuslanderBuchsbaum.tex` L557-L563. All four are
multi-iter substrate work:
1. minimal finite free resolutions (`lemma-add-trivial-complex`)
2. the "what is exact" criterion (Stacks 00MF)
3. snake-lemma on resolutions (tensoring minimal resolutions by `R/xR`)
4. depth-drops-by-one (Stacks `lemma-depth-drops-by-one`)

**Per PROGRESS.md note**: Lane G is **OFF-CRITICAL-PATH** (A.4.b's
consumer-facing `CohenMacaulay.of_regular` uses the direct
regular-sequence route, not the AB formula). The n=k+1 step is push-beyond
and not gating.

The L1125 sorry retains its full plan-comment (Stacks 090V recipe) for the
future substrate-fill iteration. No structural change to this branch.

### Axiom hygiene

| Decl | Axioms |
|---|---|
| `ideal_smul_top_pi_const` | `propext, Classical.choice, Quot.sound` |
| `isRegular_pi_const_iff_of_nonempty` | `propext, Classical.choice, Quot.sound` |
| `depth_pi_const_eq_depth_of_nonempty` | `propext, Classical.choice, Quot.sound` |

All kernel axioms only. Zero project axioms introduced.

### File state

* Build: GREEN.
* Sorries: 2 → 1 (–1).
* Net LOC delta: ~+135 (helpers + main lemma).
* Linter warnings: 8 (4 lemmas × 2 each) about unused
  `[Fintype]`/`[DecidableEq]` instances in type signatures (the proofs
  use them internally via `LinearMap.single` and `Finset.univ_sum_single`,
  but they're not visible from the type — these are non-fatal style
  linter notes, not errors).

### Blueprint

`chapters/Albanese_AuslanderBuchsbaum.tex` documents
`thm:auslander_buchsbaum` (Stacks 090V); the chapter already
acknowledges the 4 substrate gaps at L557-L563. The Lean-side n=0 closure
is consistent with the chapter's recipe. **Recommendation**: the n=0
branch is now formalisation-complete; the `\leanok` on
`thm:auslander_buchsbaum` should remain unset (1 of 2 cases closed; the
post-prover `sync_leanok` phase will check sorry-count automatically).

### Per-attempt log

#### depth_pi_const_eq_depth_of_nonempty (new helper, ~25 LOC main)
##### Attempt 1
- **Approach**: factor through Pi-quotient identification (sidesteps the
  Ext-biproduct route).
- **Result**: RESOLVED axiom-clean.
- **Key insight**: the side condition `I • ⊤ = ⊤` on `ι → M` reduces to
  the same on `M` via `Pi.single`-lifting (RHS→LHS) and projection
  (LHS→RHS); the regular-sequence sets agree by induction on `rs` using
  the `QuotSMulTop` linear equiv.
- **Lemmas found**: `Pi.isSMulRegular_iff`, `Submodule.quotientPi`,
  `Submodule.ideal_span_singleton_smul`, `Submodule.map_smul''`,
  `Finset.univ_sum_single`, `LinearEquiv.isRegular_congr`,
  `Submodule.quotEquivOfEq`.

#### auslander_buchsbaum_formula n=0 branch (L953)
##### Attempt 1
- **Approach**: invoke `Module.depth_pi_const_eq_depth_of_nonempty`
  with `Nonempty (Fin k)` from `hk : 0 < k`.
- **Result**: RESOLVED axiom-clean (1-LOC closure).

#### auslander_buchsbaum_formula n=k+1 branch (L1125)
##### Attempt 1 (deferred)
- **Approach**: not attempted this iter — Stacks 090V recipe needs 4
  substrate pieces all absent from Mathlib b80f227 (confirmed by
  chapter audit). Per progress-critic + Lane G OFF-CRITICAL-PATH
  framing, n=k+1 push-beyond is multi-iter substrate work.
- **Result**: unchanged (sorry retained with full plan-comment).
- **Next step**: iter-195+ substrate work on (a) minimal finite free
  resolutions, (b) Stacks 00MF "what is exact", (c) snake-lemma on
  resolutions, (d) depth-drops-by-one.

### Marker recommendation for review

* `thm:auslander_buchsbaum` (`\lean{RingTheory.auslander_buchsbaum_formula}`)
  → leave `\leanok` UNSET (sync_leanok auto-detects 1 sorry remaining).
* `def:depth`, `lem:depth_via_ext`, `def:projective_dimension`,
  `lem:depth_short_exact_sequence`, `def:cohen_macaulay_local`,
  `cor:regular_cohen_macaulay` → unchanged (no Lean signature changes).
* New helper `Module.depth_pi_const_eq_depth_of_nonempty` is not pinned
  in the blueprint (private substrate); no marker action needed.
