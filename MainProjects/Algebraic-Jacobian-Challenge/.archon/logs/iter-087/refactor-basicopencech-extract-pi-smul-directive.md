# Refactor Directive

## Slug
basicopencech-extract-pi-smul

## Problem

The proof of `AlgebraicGeometry.Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` contains an inline
`have h_diff_pi_smul_f` (starting at L1013) whose body has been the active proof target
since iter-076 (10+ iterations). Over those iterations the body has accumulated
~250 lines of:

- Eight contiguous "ITER-NN advance: ..." comment blocks (L1024–L1101, L1121–L1280,
  L1281–L1322, L1325–L1347, L1349–L1382, L1384–L1404, L1420–L1477) documenting
  attempted-and-failed tactic chains, typeclass discoveries, dead-end rewrites,
  and recipes for the next iteration that themselves failed.
- A genuine inline `have R_restrict_R_linear` (L1406–1414, iter-086) — the per-summand
  R-linear restriction-collapse lemma, fully proved (no sorry).
- A genuine inline `have hsmul_eq` (L1415–1418, iter-085) — the smul-commutation
  rewrite, fully proved.
- A residual `sorry` at L1478.

The user's iter-086 feedback flagged this exact pattern ("doing trivial changes at
each iteration") and `STRATEGY.md` iter-086 records the ultimatum: close
`h_diff_pi_smul_f` in iter-086 or escalate to refactor in iter-087.

The iter-086 prover did not close it. **This refactor is the iter-087 escalation.**

The lemma is deeply nested inside a ~1000-line proof body whose enclosing local
context (`R`, `scK₀`, `K₀`, `Z₁`, `Z₂`, `Z₃`, `e₁`, `e₂`, `e₃`, `perI₁`, `perI₂`,
`perI₃`, `h_mod_pi₁`, `h_mod_pi₂`, `h_mod_pi₃`, `h_mod_X₁`, `h_mod_X₂`, `h_mod_X₃`,
`s₀`) all sits inside the proof body. The deep nesting + accumulated comment-block
scaffolding has made the goal hard to reason about as a focused, top-level
obligation.

## Mathematical Justification

The statement `h_diff_pi_smul_f` is mathematically well-defined as a top-level
lemma. Informally:

> Let `C : Over (Spec k)`, `U : Opens C.left` affine, `s₀ ⊆ Γ(C.left, U)` a finset
> spanning the unit ideal, and `n : ℕ` positive. The Čech differential
> `scK₀.f : K₀.X (prev n) ⟶ K₀.X n` is R-linear (R = Γ(C.left, U)) when both
> source and target are equipped with the R-module structure transported from
> the pointwise R-module structure on the product representation via the
> `ModuleCat.piIsoPi` isomorphism.

More precisely (matching the existing inline `have`'s statement byte-for-byte):

```
∀ (r : R) (y : ∀ i, Z₁ i),
    letI := h_mod_pi₁
    letI := h_mod_pi₂
    e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) =
      r • e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm y))
```

where `R, scK₀, Z₁, Z₂, e₁, e₂, h_mod_pi₁, h_mod_pi₂` are the local quantities
defined inside the proof body (their explicit definitions are in the file at
L857–L949).

The auxiliary `have R_restrict_R_linear` (L1406–1414) is the per-summand R-linear
restriction-collapse lemma — also mathematically well-defined as a top-level
lemma (and trivially proved by `← presheaf.map_comp` + `Opens.op`-subsingleton
collapse, ~2 tactics).

The refactor is **structural only**: the same mathematical statement is moved
from an inline `have` to a top-level `theorem` (or `lemma`). The proof body
of `h_diff_pi_smul_f` remains `sorry` after the refactor — the iter-087 prover
will close it in a focused top-level context. The `R_restrict_R_linear`
extraction lands fully-proved (no `sorry`), since the prover already verified
its 2-tactic body in iter-086.

This refactor does not change any protected signature, does not introduce any
new axiom, and does not weaken any existing claim. It only reorganises code:
moves an inline `have` to top-level, removes accumulated scaffolding comments,
and replaces the inline call site with an application of the new top-level
lemma.

## Changes Requested

### Change 1 — extract `R_restrict_R_linear` to top-level

Add a new top-level lemma at the file-level (above `theorem basicOpenCover_isCechAcyclicCover_toModuleKSheaf`):

```lean
/-- Per-summand R-linear restriction-collapse: for nested opens `V ≤ W ≤ U`
in a scheme `C.left`, the chain of presheaf restrictions
`Γ(U) → Γ(W) → Γ(V)` collapses to the direct restriction `Γ(U) → Γ(V)`.
Used in the proof of R-linearity of the Čech differential. -/
lemma presheafMap_restrict_collapse
    {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    {V W U : TopologicalSpace.Opens C.left.toTopCat}
    (h_VW : V ≤ W) (h_VU : V ≤ U) (h_WU : W ≤ U)
    (r : C.left.presheaf.obj (Opposite.op U)) :
    (C.left.presheaf.map (homOfLE h_VW).op).hom
        ((C.left.presheaf.map (homOfLE h_WU).op).hom r) =
      (C.left.presheaf.map (homOfLE h_VU).op).hom r := by
  rw [← ConcreteCategory.comp_apply, ← C.left.presheaf.map_comp]
```

The body is the same 2-tactic proof verified by the iter-086 prover (the inline
`have R_restrict_R_linear` at L1406–1414 uses `intro V W h_VW h_VU h_WU r'`
followed by the `rw` + `congr 1`; the top-level version has the variables
in the binder so it only needs the `rw`).

(If the `congr 1` is actually needed after the `rw`, restore it — verify by
compiling.)

### Change 2 — extract `h_diff_pi_smul_f` to top-level

Add a new top-level theorem (above `theorem basicOpenCover_isCechAcyclicCover_toModuleKSheaf`,
below the `presheafMap_restrict_collapse` lemma):

```lean
/-- R-linearity of the Čech-cochain differential at degree (prev n, n), in the
product representation. Given the affine-open basic-cover data
(`U`, `s₀ ⊆ Γ(C.left, U)` spanning the unit ideal), the index-shifted product
modules `Z₁ : (Fin (prev n + 1) → ↑s₀) → ModuleCat k` and
`Z₂ : (Fin (n + 1) → ↑s₀) → ModuleCat k`, and their per-i R-module structures
`perI₁ : ∀ i, Module R (Z₁ i)`, `perI₂ : ∀ i, Module R (Z₂ i)`, the Čech
differential `scK₀.f.hom` viewed through the `ModuleCat.piIsoPi`-transport
commutes with R-scalar action. -/
theorem cechCofaceMap_pi_smul
    {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
    {U : TopologicalSpace.Opens C.left.toTopCat} (hU : IsAffineOpen U)
    (s₀ : Finset Γ(C.left, U))
    {n : ℕ} (hn : 0 < n)
    -- (all the further structural ingredients: extract from the proof body of
    --  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` exactly as they
    --  appear at L857–L949 of the current file; the signature below is a
    --  sketch; adjust to match the actual local context type-by-type.)
    (R := C.left.presheaf.obj (Opposite.op U))
    (Z₁ : (Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) → ModuleCat.{u} k)
    (Z₂ : (Fin (n + 1) → ↑s₀) → ModuleCat.{u} k)
    (e₁ : ↑(∏ᶜ Z₁) ≃ₗ[k] (∀ i, ↑(Z₁ i)))
    (e₂ : ↑(∏ᶜ Z₂) ≃ₗ[k] (∀ i, ↑(Z₂ i)))
    (perI₁ : ∀ i, Module R (Z₁ i))
    (perI₂ : ∀ i, Module R (Z₂ i))
    (h_mod_pi₁ : Module R (∀ i, Z₁ i))
    (h_mod_pi₂ : Module R (∀ i, Z₂ i))
    (scK₀_f : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂))
    -- (... structural hypothesis identifying `scK₀_f` with the alternating
    --      coface-map sum, e.g. an equation `scK₀_f = ∑ i, (-1)^i • ...` or
    --      its dsimp-form; choose whichever makes the lemma easiest to apply
    --      from the call site. If you cannot find a clean abstraction, take
    --      `scK₀_f` as opaque and leave the relationship to the call site —
    --      the proof body is `sorry` in this refactor.)
    (r : R) (y : ∀ i, Z₁ i) :
    e₂ (scK₀_f (e₁.symm (r • y))) = r • e₂ (scK₀_f (e₁.symm y)) := by
  sorry
```

**IMPORTANT: choose the actual signature freely.** The above is a sketch.
Determine the minimal set of arguments that captures the inline `have`'s
content without leaking unnecessary local context (e.g. the dimension `m`,
the `(prev n + 1) = n` relation, the `eqToHom` cast, the `K₀` definition).
You may inline some of these as `let` clauses inside the theorem body, or
absorb them into the signature, whichever is cleaner.

**Hard requirement on the signature**: the new top-level theorem must be
applicable at the call site (the inline `have` at L1013) via a single
`have h_diff_pi_smul_f := cechCofaceMap_pi_smul (...args...)` line.

### Change 3 — replace the inline `have` at L1013

Replace the entire inline `have h_diff_pi_smul_f : ∀ (r : R) (y : ∀ i, Z₁ i), ... := by ...`
block (L1013–L1478, ~466 lines including comment scaffolding) with a single
short `have` that applies the new top-level theorem:

```lean
have h_diff_pi_smul_f := cechCofaceMap_pi_smul hU s₀ hn ... (with appropriate args)
```

### Change 4 — delete the accumulated comment scaffolding

The comment blocks documenting iter-073 → iter-086 tactic attempts inside the
inline `have` body (L1024–L1101, L1108–L1119, L1121–L1153, L1156–L1196,
L1198–L1280, L1281–L1322, L1325–L1347, L1349–L1382, L1384–L1404, L1420–L1477)
are removed entirely. The mathematical content needed to write the proof is
captured in the new top-level lemma's docstring (per Change 2 above) and in
the blueprint chapter (no change to blueprint required for this refactor).

The `R_restrict_R_linear` inline `have` (L1406–1414) and the `hsmul_eq` inline
`have` (L1415–1418) are also removed: the former becomes a top-level lemma per
Change 1, and the latter is only meaningful as a step inside the proof body of
the top-level `cechCofaceMap_pi_smul` — when the iter-087 prover fills the
`sorry` in `cechCofaceMap_pi_smul`, they can re-introduce `hsmul_eq` if needed.

### Change 5 — keep all OTHER infrastructure byte-for-byte

The rest of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`'s proof body
remains unchanged:

- L857–L949 (the `letI perI_n` / `h_mod_pi_n` / `h_mod_X_n` block, plus the
  preceding `Z₁/Z₂/Z₃` definitions and `e₁/e₂/e₃` LinearEquivs) — preserved
  byte-for-byte.
- L1489–L1525 (`f_R`, `g_R` LinearMap definitions; `f_R.map_smul'` uses
  `h_diff_pi_smul_f`) — preserved byte-for-byte.
- L1526–L1559 (h_loc_X_i, h_loc_exact, exact_of_localized_span call) —
  preserved byte-for-byte.
- L502, L826, L854 sorries (dead-end substeps, out of scope) — preserved
  byte-for-byte.

### Change 6 — `set_option maxHeartbeats 800000 in` at L418

This `set_option` is preserved exactly. Add `set_option maxHeartbeats 16000000 in`
(or comparable) above the new top-level `cechCofaceMap_pi_smul` theorem if
needed for the elaboration of its signature (the original inline `have` benefited
from the enclosing `maxHeartbeats 800000`).

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — refactor target.

No other Lean file imports `h_diff_pi_smul_f` directly (it is inline), so
**no other file should need changes**. The protected `archon-protected.yaml`
file is unchanged: `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`'s top-level
signature is preserved; the new top-level helpers (`presheafMap_restrict_collapse`,
`cechCofaceMap_pi_smul`) are additions, not modifications.

## Expected Outcome

After the refactor:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` compiles cleanly (`lean_diagnostic_messages` → 0 errors).
- File line count: shrinks by ~300–400 lines (the removed comment scaffolding) but adds ~60 lines for the two extracted top-level decls. Net: ~250 LOC shorter.
- Sorry count: **stays at 6** (the L502/L826/L854 dead-end sorries unchanged; the L1478 `h_diff_pi_smul_f` sorry moves into the new `cechCofaceMap_pi_smul` top-level; L1523 `g_R.map_smul'` and L1552 `h_loc_exact` unchanged).
- New top-level decls:
  - `presheafMap_restrict_collapse` — fully proved, no `sorry`.
  - `cechCofaceMap_pi_smul` — body is `sorry`; this is the new active prover target for iter-087+.
- No new axiom. Verified via diff inspection.
- `archon-protected.yaml` unchanged (no protected signature was touched).

## What this refactor does NOT do

- Does not fill the `sorry` in `cechCofaceMap_pi_smul`. That is the iter-087
  prover's job (assigned after this refactor lands).
- Does not modify the surrounding proof body of
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` outside the L1013–L1478
  inline block.
- Does not affect any other `.lean` file.

## Reading list (read in order)

1. `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — the file to refactor.
   Pay special attention to L857–L1478 (the proof body region containing the
   `h_diff_pi_smul_f` inline `have`) and L1489–L1525 (the call site).
2. `archon-protected.yaml` — to verify which signatures are frozen.
3. The blueprint chapter `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
   (§ Čech acyclicity) — for the mathematical content. No blueprint edits
   needed for this refactor.
