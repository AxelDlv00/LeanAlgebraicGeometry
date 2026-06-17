# Refactor Report

## Slug
basicopencech-extract-pi-smul

## Status
COMPLETE — with a verification caveat (see Compilation Status below).

The structural refactor was executed exactly as directed: the inline
`have h_diff_pi_smul_f` block (~466 lines including iter-073→iter-086 dead-end
scaffolding) inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` was replaced by a
two-line application of a new top-level theorem
`cechCofaceMap_pi_smul`; the genuine inline `have R_restrict_R_linear`
(iter-086, fully proved) was extracted as a new top-level lemma
`presheafMap_restrict_collapse`. The sorry count is preserved at 6.

The compilation caveat: the sandbox lacks built mathlib oleans (the
`/home/archon/Lean_tests/AlgebraicJacobian/.lake/packages/mathlib/.lake/build/`
directory is missing, and `lake build` / `lean_build` fails with chain of
`permission denied (error code: 13)` errors because mathlib's package
directory is owned by `root` not `archon`). Consequently `lean_diagnostic_messages`
on the edited file returns `{"success": false, "items": [], "failed_dependencies": []}`
— no diagnostics either way. I performed the refactor by careful inspection;
the new top-level theorem's type is byte-for-byte the same shape as the
inline `have`'s, and the call site uses the same identifier `h_diff_pi_smul_f`
applied with the same arguments. See "Compilation Status" for details.

## Directive

### Problem (summary from the directive)

The proof of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` contained an
inline `have h_diff_pi_smul_f` (L1013–L1478, current state) whose body had
accumulated ~250 lines of "ITER-NN advance" comment scaffolding documenting
attempted-and-failed tactic chains across iter-073→iter-086, plus a genuine
inline `have R_restrict_R_linear` (iter-086, fully proved), a genuine inline
`have hsmul_eq` (iter-085, fully proved), and a residual `sorry`. The deep
nesting (inside ~1000-line proof body with ~20 local `let`/`letI` bindings)
made the goal hard to reason about as a focused top-level obligation. This
refactor is the iter-087 escalation that the iter-086 STRATEGY.md flagged
("close `h_diff_pi_smul_f` in iter-086 or escalate to refactor in iter-087").

### Changes requested (summary)

1. Extract `R_restrict_R_linear` to a top-level lemma
   `presheafMap_restrict_collapse` (fully proved).
2. Extract `h_diff_pi_smul_f` to a top-level theorem `cechCofaceMap_pi_smul`
   (body `sorry`, the active prover target).
3. Replace the inline `have h_diff_pi_smul_f` block with a one-line
   application of `cechCofaceMap_pi_smul`.
4. Delete the accumulated iter-073→iter-086 comment scaffolding.
5. Keep all other infrastructure byte-for-byte.

## Changes Made

### File: AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Edit 1 — added top-level lemma `presheafMap_restrict_collapse`** (L412–L434
in the post-refactor file).

- **What**: New top-level `lemma` extracted from the inline
  `have R_restrict_R_linear` body at the original L1406–L1414. Signature
  takes a scheme `C` over `Spec (.of k)`, three nested opens `V ≤ W ≤ U`
  with the three pairwise ≤-proofs as separate explicit arguments
  (`h_VW`, `h_VU`, `h_WU` — matching the inline original's `intro`
  signature exactly), and an `r ∈ Γ(C.left, U)`. Conclusion: the two
  presheaf-restriction chains `Γ(U) → Γ(W) → Γ(V)` and `Γ(U) → Γ(V)`
  produce the same element when applied to `r`. Body is the 2-tactic
  proof verified by the iter-086 prover (`rw [← ConcreteCategory.comp_apply,
  ← C.left.presheaf.map_comp]; congr 1`).
- **Why**: per directive Change 1. The inline `have R_restrict_R_linear`
  is mathematically a standalone restriction-collapse fact, naturally
  hoists out of the proof body, and is referenced (by name) in the
  docstring of the new `cechCofaceMap_pi_smul` as the key
  reduction step for the per-summand R-linearity argument.
- **Cascading**: none. This is a new declaration; nothing else in the
  project references `R_restrict_R_linear` outside the inline `have`
  that was deleted, so no other file needs updating.

**Edit 2 — added top-level theorem `cechCofaceMap_pi_smul`** (L436–L481
in the post-refactor file).

- **What**: New top-level `theorem` extracted from the inline `have
  h_diff_pi_smul_f` (statement at original L1013–L1017, byte-for-byte
  the same shape modulo abstraction over the project-local quantities).
  Signature is generic in `{k R : Type u} [Field k] [CommRing R]`,
  `{ι₁ ι₂ : Type u}`, `{Z₁ Z₂ : · → ModuleCat k}`, linear isomorphisms
  `e₁`, `e₂` between `↑(∏ᶜ Z_i)` and the dependent product, R-module
  structures `h_mod_pi₁`/`h_mod_pi₂` on the dependent products, and an
  abstract morphism `scK₀_f : (∏ᶜ Z₁) ⟶ (∏ᶜ Z₂)`. The statement uses
  `letI := h_mod_pi₁; letI := h_mod_pi₂` to bring the R-module instances
  into scope for the smul expressions, matching the inline `have`'s
  structure exactly. The body is `sorry` — this is the active prover
  target for iter-087+.
- **Why**: per directive Change 2. The directive explicitly authorizes
  taking `scK₀_f` opaque ("If you cannot find a clean abstraction, take
  `scK₀_f` as opaque and leave the relationship to the call site — the
  proof body is `sorry` in this refactor"). The docstring acknowledges
  the statement-generality issue and points the next-iteration prover
  toward the closure strategy (either re-specialize back to the local
  Čech context, or add explicit hypotheses on `scK₀_f`).
- **Cascading**: none. The new theorem is applied at exactly one call
  site (the new short `have h_diff_pi_smul_f` line below).
- **Heartbeat budget**: a `set_option maxHeartbeats 1600000 in` is
  attached above the theorem (more than the inline `have`'s enclosing
  `800000` because the abstract signature uses CoeSort coercions on
  `ModuleCat k` and unification through `∏ᶜ` may be more elaboration-heavy
  at the top level than in the original deeply-nested inline `have`).

**Edit 3 — replaced inline `have h_diff_pi_smul_f` block** (original
L1013–L1478, now collapsed to L1063–L1070 in the post-refactor file —
8 lines of comment + 2 lines of `have`).

- **What**: The original ~466-line inline `have h_diff_pi_smul_f` (with
  its proof body containing iter-073→iter-086 dead-end scaffolding, the
  genuine inline `have R_restrict_R_linear`, the genuine inline `have
  hsmul_eq`, and the residual `sorry`) is replaced by:
  ```
  have h_diff_pi_smul_f :=
    cechCofaceMap_pi_smul (R := R) e₁ e₂ h_mod_pi₁ h_mod_pi₂ scK₀.f
  ```
  The `(R := R)` named argument is explicit (rather than letting it
  be inferred from `h_mod_pi₁`'s type) to anchor the local
  `R := Γ(C.left, U)` value early in elaboration. `e₁`, `e₂`,
  `h_mod_pi₁`, `h_mod_pi₂`, `scK₀.f` are all available in the local
  proof context (the latter via `let scK₀ := HomologicalComplex.sc K₀ n`
  at L959 of the post-refactor file).
- **Why**: per directive Change 3. The type of `h_diff_pi_smul_f` is
  preserved byte-for-byte (modulo whether one views the `letI`s as
  part of the type or expanded into the equation's smul-instance
  resolution), so the surrounding cochain-complex machinery (`f_R`'s
  `map_smul'` at L1098, in particular the `rw [..., h_diff_pi_smul_f
  r (e₁ x), ...]` chain) continues to see the same `h_diff_pi_smul_f`
  shape it referenced before the refactor.
- **Cascading**: none. The `rw [..., h_diff_pi_smul_f r (e₁ x), ...]`
  call site at L1098 (post-refactor) is unchanged byte-for-byte; the
  identifier `h_diff_pi_smul_f` has the same type after the refactor
  (just sourced from `cechCofaceMap_pi_smul` rather than an inline
  `have` with its own proof body).

**Edit 4 — deleted comment scaffolding** (parts of L1056–L1083 in the
pre-refactor file, now collapsed to L1056–L1068 in the post-refactor
file).

- **What**: Replaced the iter-072 comment block (~28 lines describing
  the in-flight closure plan for `map_smul'` via `Equiv.smul_def` and
  the `h_diff_pi_smul_{f,g}` sub-claim factorization) with a 6-line
  iter-087 refactor note pointing at `cechCofaceMap_pi_smul` as the
  active prover target. Comments at L1071–L1080 (the "ITER-076 prover:
  dropped `h_diff_pi_smul_g`..." block) are preserved verbatim because
  they document the active state of `g_R.map_smul'` (still `sorry`).
- **Why**: per directive Change 4. The iter-073→iter-086 dead-end
  scaffolding inside the original inline `have h_diff_pi_smul_f` body
  was deleted as part of Edit 3 above; this Edit 4 cleans the
  immediately-surrounding comment block that referred to the now-deleted
  inline structure.

### Other state files

No other files were touched: this refactor is entirely contained in
`AlgebraicJacobian/Cohomology/BasicOpenCech.lean`.

- `archon-protected.yaml`: unchanged (no protected declaration was
  modified). The new `presheafMap_restrict_collapse` and
  `cechCofaceMap_pi_smul` are additions, not modifications; the
  protected `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  signature is unchanged.
- No blueprint chapter was modified (the directive explicitly says
  "no blueprint edits needed for this refactor").

## New Sorries Introduced

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:481` — body of the
  new top-level `cechCofaceMap_pi_smul`. This sorry replaces the
  original `sorry` at L1478 (pre-refactor), so the net sorry count
  is unchanged. **This is the iter-087+ active prover target.**

No truly new sorries were introduced — the L1478 sorry was *moved*
into a top-level context for focused work.

## Sorry inventory (post-refactor)

Total sorries: **6** (matches the directive's "stays at 6" expected
outcome). The mapping from pre-refactor lines to post-refactor lines:

| Pre-refactor | Post-refactor | Description                                              |
|--------------|---------------|----------------------------------------------------------|
| L502         | L573          | substep (a) infrastructure (extra-degeneracy)            |
| L826         | L897          | h_transport sorry (Čech-cohomology refinement transport) |
| L854         | L925          | h_a₀ sorry for s₀-indexed slice cover                    |
| L1478        | **L481 (new)**| h_diff_pi_smul_f / cechCofaceMap_pi_smul (refactor target)|
| L1523        | L1115         | g_R.map_smul' sorry                                      |
| L1552        | L1144         | h_loc_exact sorry                                        |

## Compilation Status

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **unverifiable in
  current sandbox** (see caveat below). Refactor verified by inspection
  only.

### Caveat: sandbox build infrastructure broken

In the current execution sandbox:

1. The mathlib oleans have never been built in this environment:
   `find .lake/packages/mathlib -name "*.olean"` finds only
   `.lake/config/mathlib/lakefile.olean`, no Mathlib.olean tree.
2. The mathlib package directory is owned by `root`, while the
   sandbox runs as user `archon`. So `lake build` (or `lean_build`
   via the LSP) fails with a chain of `error: permission denied
   (error code: 13)` messages when it tries to populate mathlib's
   build cache.
3. Consequently `mcp__archon-lean-lsp__lean_diagnostic_messages` on
   `BasicOpenCech.lean` returns `{"success": false, "items": [],
   "failed_dependencies": []}` — no errors, no warnings, no info
   either. The LSP cannot process the file because its mathlib
   dependencies are unbuilt.
4. The previously-cached `.lake/build/lib/lean/AlgebraicJacobian/Cohomology/BasicOpenCech.olean`
   from May 13 11:01 (pre-refactor) exists, confirming the file
   *did* compile in the original developer environment before the
   refactor.

The plan agent's directive does not include verification steps the
refactor agent can run in this sandbox. The refactor's correctness
rests on these inspection points:

- **Type preservation**: the new `cechCofaceMap_pi_smul`'s statement
  type (after the `letI`s) is the same `∀ r y, e₂ (...) = r • e₂ (...)`
  shape as the inline `have h_diff_pi_smul_f`. The call site at L1098
  applies `h_diff_pi_smul_f r (e₁ x)` and continues with the same
  `rw [LinearEquiv.apply_symm_apply, ..., LinearEquiv.symm_apply_apply]`
  chain that worked pre-refactor — this chain is independent of
  whether `h_diff_pi_smul_f` came from an inline `have` or a
  top-level theorem application.

- **`presheafMap_restrict_collapse` body**: byte-for-byte the same
  2-tactic proof body as the inline `have R_restrict_R_linear` at the
  pre-refactor L1411–L1414 (which the iter-086 prover verified).

- **Implicit-arg inference**: the call site passes `e₁`, `e₂`,
  `h_mod_pi₁`, `h_mod_pi₂`, `scK₀.f`. The implicit `Z₁`, `Z₂` of
  `cechCofaceMap_pi_smul` are determined by `e₁`/`e₂`'s types
  (each is `↑(∏ᶜ Z_local) ≃ₗ[k] (∀ i, Z_local i)`). The implicit
  `R`, `[CommRing R]` are determined by `h_mod_pi₁`'s type (`Module R
  (∀ i, Z₁ i)`); the explicit `(R := R)` named argument anchors `R`
  to the local `R := Γ(C.left, U)` value.

- **`scK₀.f` type-match**: at the call site, `scK₀.f : scK₀.X₁ ⟶
  scK₀.X₂`. The theorem expects `scK₀_f : (∏ᶜ Z₁) ⟶ (∏ᶜ Z₂)`. These
  unify iff `scK₀.X₁ ≡ ∏ᶜ Z₁` (defeq), which was the same defeq used
  by the inline `have h_diff_pi_smul_f` pre-refactor (when it wrote
  `e₁.symm (r • y)` as an input to `scK₀.f.hom`), so the defeq holds.

The user (with build permissions in their own environment) should
run `lake build AlgebraicJacobian.Cohomology.BasicOpenCech` after
this refactor lands to confirm compilation. If a type mismatch
surfaces, the most likely fix sites are:
1. The `e₁`, `e₂` signature in `cechCofaceMap_pi_smul` may need
   explicit `↑(...)` coercions: change `(∏ᶜ Z₁ : ModuleCat.{u} k)`
   to `↑(∏ᶜ Z₁)` and `(∀ i, Z₁ i)` to `(∀ i, ↑(Z₁ i))` in the
   LinearEquiv types. The current form relies on Lean's `CoeSort`
   firing automatically; if it doesn't, the explicit `↑` arrows are
   the canonical fix.
2. The `scK₀_f : (∏ᶜ Z₁ : ModuleCat k) ⟶ (∏ᶜ Z₂ : ModuleCat k)`
   may similarly need `↑` adjustments, though the `⟶` arrow at the
   `ModuleCat k` category level is morphism-typed, not Type-typed,
   so this is less likely to need adjustment.

## Notes for Plan Agent

### What this refactor accomplished

- **Mechanical sorry count: unchanged at 6.** The L1478 `sorry` was
  *moved* into the new top-level `cechCofaceMap_pi_smul`, not
  eliminated.
- **Net file shrinkage: −408 LOC** (1562 → 1154 lines, exceeding the
  directive's "~250 LOC shorter" expected outcome — the iter-073→iter-086
  comment scaffolding was larger than the directive estimated).
- **New top-level scaffolding: +71 LOC** (`presheafMap_restrict_collapse`
  + `cechCofaceMap_pi_smul`, with docstrings).
- **Single prover target**: the iter-087+ prover now has a single,
  focused top-level theorem to work on (`cechCofaceMap_pi_smul`)
  rather than a 466-line inline `have` buried inside a 1000-line
  proof body.

### What this refactor did NOT accomplish

- **Did not fill the sorry**. The sorry was moved, not eliminated.
  The iter-087+ prover assignment remains: close `cechCofaceMap_pi_smul`.
- **Did not verify compilation** (sandbox limitation; see Compilation
  Status above).
- **Did not modify the surrounding proof body** of
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` outside the
  refactored `have h_diff_pi_smul_f` site.

### Signature generality trade-off

The new `cechCofaceMap_pi_smul` is stated abstractly (generic in
`scK₀_f`), which means the statement is *generically false* — an
arbitrary morphism `(∏ᶜ Z₁) ⟶ (∏ᶜ Z₂)` is not R-linear without further
hypotheses on `scK₀_f`. The directive explicitly authorizes this
abstraction ("take `scK₀_f` as opaque and leave the relationship to
the call site"), and the body is `sorry`, so the abstract statement
is "axiomatized as sorry" rather than as an actual axiom. The
docstring notes this and points the next iteration's prover toward
two closure paths:

1. **Specialize back to the project's Čech context** inside the
   theorem body: re-introduce the local `C`, `U`, `s₀`, `n`, `K₀`,
   `scK₀` quantities and unfold the differential as an alternating
   sum of presheaf-restriction maps (recipe S1–S8 from iter-081 of
   the deleted scaffolding, plus the per-summand R-linearity step
   using `presheafMap_restrict_collapse`).
2. **Add explicit hypotheses on `scK₀_f`** in a follow-up refactor:
   express `scK₀_f` as `∑ i : Fin _, (-1)^i • Pi.lift (...)` with each
   summand R-linear (this is the structural form the inline iter-081
   `dsimp+simp` chain attempted to expose).

If the iter-087 prover finds (1) ergonomically painful (the local
context is large), the plan agent could land a *second* refactor in
iter-088 that adds the concrete project-context hypotheses to
`cechCofaceMap_pi_smul`'s signature. The current abstract form is the
minimum-friction first step that the directive prescribed.

### Lost mathematical roadmap

Some of the deleted iter-073→iter-086 comment scaffolding contained
useful recipes (S1–S8, the `Pi.smul_apply`-`Finset.sum_apply` route,
the `presheaf.map_comp` collapse via `R_restrict_R_linear`). These
are not preserved in the file; the iter-087+ prover may need to
re-derive them or consult `STRATEGY.md`'s iter-073→iter-086
records. The docstring of `cechCofaceMap_pi_smul` mentions
`presheafMap_restrict_collapse` as the key reduction step but does
not reproduce the full S1–S8 chain inline.

If the plan agent finds that the iter-087 prover would benefit from
the recipe preserved as comments on the new top-level theorem, a
small follow-up refactor could append a `/- Closure recipe: ... -/`
block to the theorem's body (above the `sorry`). The current report
flags this as a discretionary improvement, not a blocker.

### Compilation verification follow-up

This is the most actionable item. The plan agent should either:

(a) Run `lake build AlgebraicJacobian.Cohomology.BasicOpenCech` (or
    the project-wide build) in an environment where mathlib is
    properly built, and surface any errors back to a follow-up
    refactor directive; or

(b) Schedule iter-088 to verify-and-fix any type-elaboration issues
    in the new top-level theorem's signature (Compilation Status
    above lists the two most-likely fix sites).

The refactor is structurally correct; any breakage would be at the
CoeSort / unification level, which is mechanical to repair.
