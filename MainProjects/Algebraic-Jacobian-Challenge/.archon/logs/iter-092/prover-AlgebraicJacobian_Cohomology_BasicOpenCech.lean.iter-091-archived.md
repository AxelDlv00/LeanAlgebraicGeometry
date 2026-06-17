# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Iter-091 result: IN PROGRESS / OPTIMISTIC — full S6 chain (d-body)+(e)+(f)+(g)+closure committed bare per PROGRESS.md mandate; compilation unverified in sandbox (LSP/mathlib unavailable, as iter-086…090). Target 5 sorries achieved iff chain compiles; hard cap 6 respected on failure modes that don't break the file.**

## File status

- 5 syntactic `sorry` tokens remain (after iter-091 chain commit; sorry_analyzer authority): L675 (was L656), L999 (was L980), L1027 (was L1008), L1217 (was L1198), L1246 (was L1227). All shifted by +19 due to iter-091's added 5-tactic chain + ~20 lines of per-step inline `--` commentary.
- Target 5 nominally met (one sorry dropped from the iter-090 6-count). **Caveat**: iff the bare chain compiles. If any step in (d-body)..(g) is a HOU no-op or `rfl` doesn't close, the file fails to compile in dispatcher verification — a regression which iter-092 must repair by rolling back to the deepest working step + sorry.
- Hard cap 6 respected if file compiles (5 < 6). If file doesn't compile, the hard cap is moot (compilation regression takes precedence).
- LSP/lake unavailable in sandbox: `.lake/packages/` has only `checkdecls` + `doc-gen4`; `mathlib` MISSING; `lake` binary not on PATH. Identical to iter-086–090. Dispatcher environment expected to verify.

## cechCofaceMap_pi_smul (L495–L583)

### Attempt 1 — full S6 chain (d-body)+(e)+(f)+(g)+closure committed bare per PROGRESS.md

- **Approach.** Per PROGRESS.md iter-091 mandate ("MUST attempt the per-summand steps (d-body)+(e)+(f)+(g)+closure"; "DO NOT wrap the chain in `first | <chain> | sorry`"; "If `lean_diagnostic_messages` is unavailable, that is environmental and not a justification to abstain"), committed all five steps linearly without `try` wrappers, ending with bare `rfl`. The PROGRESS.md templates were transcribed verbatim into the source. The decision tree weighed three options:

  1. **Bare chain + rfl** (chosen). Maximum signal for iter-092: if any step fails, the file breaks at that exact tactic, telling iter-092 which step to fix. Risk: file may not compile.
  2. `try`-per-step + `first | rfl | sorry` (REJECTED). Always compiles, but `try` masks per-step failures; the per-step "deepest committed step" signal PROGRESS.md mandates is lost. Also retains 1 syntactic `sorry` regardless, so target 5 unachievable.
  3. Single-step (d-body only) + sorry (REJECTED). Below mandate's "must attempt (d-body)+(e)+(f)+(g)+closure" upper-bound effort target.

- **The committed chain (L559–L583).** After iter-090's `refine Finset.sum_congr rfl ?_; intro i _` at L557–L558:

  1. **(d-body) L564–L565**: `simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply, ModuleCat.hom_smul, LinearMap.smul_apply]`. Peels `(-1)^i • Pi.lift f_i` per-summand: `ModuleCat.hom_smul` unwraps `((c • φ).hom = c • φ.hom)`; `LinearMap.smul_apply` peels the scalar through the application `(c • L) x = c • L x`; `Pi.lift_π_apply` collapses `(Pi.π j).hom ((Pi.lift f).hom x) = (f j).hom x`; `ConcreteCategory.comp_apply` normalises the `≫`-composition inside `f j`.

  2. **(e) L569**: `simp only [Pi.smul_apply]`. Surfaces inner R-action: `(r • y) (j ∘ δ_i.toOrderHom) = r • y (j ∘ δ_i.toOrderHom)`. `perI₁` is in scope from the theorem's `letI` block (L472–481).

  3. **(f) L573**: `rw [map_mul]`. Splits `((toModuleKPresheaf C).map φ_i.op).hom` (a `RingHom` for `CommRingCat`-valued presheaf maps) over the restricted-product `r_at_V_{j∘δ_i} * y_at_V_{j∘δ_i}`.

  4. **(g) L578**: `rw [presheafMap_restrict_collapse _ _ _]`. Collapses the algebra-map chain `R = Γ(C.left, U) → Γ(C.left, V_{j∘δ_i}) → Γ(C.left, V_j)` to direct `R → Γ(C.left, V_j)` via the top-level lemma (L425, fully proved). Three `≤`-witnesses left to unification (`basicOpen_le` chains matching L477–480 pattern).

  5. **(closure) L583**: `rfl`. After the algebra-map chain collapses, LHS becomes `(-1)^i • [(presheaf.map h_direct.op).hom r * presheaf.map_φ.hom (y(j∘δ_i.toOrderHom))]` and RHS via `perI₂` (R-action on Z₂ j is also a presheaf-map-mul composition) becomes `(-1)^i • [(presheaf.map h_j.op).hom r * presheaf.map_φ.hom (y(j∘δ_i.toOrderHom))]`. Both `≤`-witnesses prove `V_j ≤ U`, equal by proof irrelevance, so `presheaf.map (homOfLE _).op` matches up syntactically and `rfl` closes.

- **Compilation expectation.** Unverified (LSP unavailable). The HOU risk landscape:
  - **(d-body) risk**: `ModuleCat.hom_smul` for integer `(-1)^i : ℤ` may HOU-conflict with `ModuleCat.hom_zsmul` (the integer-specific variant). The simp set lists `ModuleCat.hom_smul`; if it doesn't fire on integer scalars (PROGRESS.md documented risk), step (d-body) errors with "simp made no progress" and the file breaks. Fallback `dsimp only [Pi.lift_π]` + `ModuleCat.hom_zsmul` variant exists in PROGRESS.md but not applied (templates' primary form preferred).
  - **(e) risk**: `Pi.smul_apply` requires the term form `(r • y) (a)`. If iter-090's `(piIsoPi Z₁).inv` didn't fully simplify in step (b)/(c)/(d-entry), the `r • y` might still be wrapped inside `(piIsoPi Z₁).inv`. Fallback `letI := perI₁` documented but not applied.
  - **(f) risk**: `rw [map_mul]` requires the term to be a `RingHom.map_mul` shape. For `CommRingCat`-valued presheaf maps this should hold via `CommRingCat.Hom.hom` coercion, but HOU on `(toModuleKPresheaf C).map φ_i.op).hom` AddHom-vs-RingHom is possible. Fallback `rw [RingHom.map_mul]` documented but not applied.
  - **(g) risk**: `presheafMap_restrict_collapse _ _ _` `≤`-witness unification. If unification can't fill the three `≤`-witnesses, explicit witnesses via `(Pi.π _ _ |>.le).trans (basicOpen_le _)` would be needed (L477–480 pattern). Fallback documented but not applied.
  - **(closure) risk**: `rfl` requires definitional equality between LHS (post (g) collapse) and RHS (post (h-prep) absorption). Both should reduce to `(-1)^i • [(presheaf.map _.op).hom r * (presheaf.map _.op).hom (y(_))]` with the only difference being witness proofs of `V_j ≤ U` — equal by proof irrelevance. Fallback `simp only [ConcreteCategory.comp_apply]` then `ring` documented but not applied.

- **Net sorry-count change.** 6 → 5 (if chain compiles). Iter-091 closes the `cechCofaceMap_pi_smul` body end-to-end.

## Decision rationale (iter-091)

PROGRESS.md explicit mandate from the plan agent:
- "You MUST attempt the per-summand steps (d-body)+(e)+(f)+(g)+closure this iteration."
- "If `lean_diagnostic_messages` is unavailable, that is environmental and **not a justification to abstain**."
- "**Per-step fallback ladder** — if step (d-body) succeeds but (e) fails, the trailing `sorry` goes after step (d-body) [etc.]" — i.e., per-step source-level signal.
- "**DO NOT wrap the chain in `first | <full chain> | sorry`**."

Without LSP verification, the only way to honour both "must attempt all steps" + "preserve per-step signal" is bare-chain commit. `try`-wrapped chain would mask per-step signal (`try` makes a failure invisible). The forbidden `first | <chain> | sorry` is the symmetric failure: it makes the whole chain invisible on failure. Bare commit is the unique path that satisfies the directive's letter and spirit.

Risk acknowledged: file may not compile. If so, iter-092 with LSP can roll back to the deepest working step + sorry, exactly as the "Per-step fallback ladder" anticipates.

## Mathlib references (assumed-extant; unverified locally)

- `Pi.lift_π_apply` (step d-body) — `[elementwise]`-form of `Pi.lift_π : Pi.lift f ≫ Pi.π b = f b`.
- `ConcreteCategory.comp_apply` (step d-body / closure).
- `ModuleCat.hom_smul`, `LinearMap.smul_apply` (step d-body).
- `Pi.smul_apply` (step e).
- `map_mul`, alternately `RingHom.map_mul` via `CommRingCat.Hom.hom` (step f).
- **`presheafMap_restrict_collapse`** (top-level, fully proved at L425) — step g.
- `basicOpen_le`, `Pi.π _ _ |>.le` (step g `≤`-witness backup, not used).

## Risks inherited from iter-090's step (c)+(h-prep)+(d-entry) work

- **(c) `simp only [map_sum]` no-op risk** (PROGRESS.md risk #1). If iter-090's step (c) was a no-op (e.g., due to `eqToHom` wrapper or other AddMonoidHomClass scaffolding), my (d-body) operates on a goal where `(Pi.π Z₂ j).hom` hasn't distributed over the outer Σ. The bare chain would then fail at the very first `simp only`. No mitigation applied this iter (per PROGRESS.md template).
- **(h-prep) `simp only [Finset.smul_sum]` no-op risk** (PROGRESS.md risk #2). If step (h-prep) was a no-op, the RHS lacks `Σ ` form after iter-090, and `Finset.sum_congr rfl` at L557 may have failed silently with goal not being `∑ = ∑`. If so, iter-091's `intro i _` faces an unexpected state and the chain breaks.
- **`Finset.sum_congr rfl` order risk** (PROGRESS.md risk #3). Both sides must be sums over the same Finset. If `simp only [map_sum]` and `simp only [Finset.smul_sum]` produced non-matching `Σ` shapes, `Finset.sum_congr rfl` would have failed silently (since the LSP was unavailable iter-090, this risk is real).

These three risks are SHARED between iter-091 and iter-090; only LSP feedback in the dispatcher environment can resolve which (if any) is realised.

## Mathlib gaps reconfirmed (no change from iter-089/090)

- `ModuleCat.hom_sum`: not in Mathlib by direct name. Inline workaround via iter-089 `Finset.cons_induction` over `ModuleCat.hom_add` remains the path (L528–L536).

## Next-step recipe for iter-092

Assuming dispatcher LSP succeeds and reports specifics:

- **If chain compiles end-to-end (target 5 met)**: iter-092 may proceed to L1207 (`g_R.map_smul'`, L1198 → L1217) using the closed `cechCofaceMap_pi_smul` as a working lemma. Outline: same template as `f_R.map_smul'` at L1167+ but with `g_R`'s `e₃.toAddEquiv.module` baking in `Eq.mpr` through `CochainComplex.next` (PROGRESS.md "L1198 downstream — gated on Lane 1 closing `cechCofaceMap_pi_smul`").

- **If (d-body) failed**: switch the simp set per PROGRESS.md fallback to integer-specific:
  ```lean
  simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply,
    ModuleCat.hom_zsmul, LinearMap.zsmul_apply]
  ```
  Or prefix with `dsimp only [Pi.lift_π]`.

- **If (e) failed**: prefix `letI := perI₁` per PROGRESS.md fallback.

- **If (f) failed**: switch `rw [map_mul]` to `rw [RingHom.map_mul]` or `show ((toModuleKPresheaf C).map φ_i.op).hom = (_ : _ →+* _) from rfl, map_mul` per PROGRESS.md fallback.

- **If (g) failed**: supply explicit `≤`-witnesses per PROGRESS.md L227–230 template (the L477–480 explicit-witness pattern via `(Pi.π _ _).le.trans (basicOpen_le _)`).

- **If (closure) failed**: replace `rfl` with `simp only [ConcreteCategory.comp_apply]` then possibly `ring`, or invoke `congr 1 <;> exact proof_irrel ..` if the witness proof equality is the issue.

- **If (c) or (h-prep) from iter-090 was the actual failure** (not my (d-body)+ chain): roll back iter-091's chain to bare sorry at L564, then revisit iter-090's step (c) or (h-prep) with LSP feedback. The plan agent's PROGRESS.md risk #1/#2 anticipates this.

## Compliance with hard constraints (iter-091)

- **No new project-local top-level helpers.** ✓ Only inline tactics inside `cechCofaceMap_pi_smul`.
- **No new axioms.** ✓
- **No new false-signature helpers.** ✓ No new `have`s introduced.
- **No `lean_run_code` pre-validation.** ✓ LSP/lake non-functional; no pre-validation done.
- **No 80+-line in-code comment blocks.** ✓ Iter-091 added ~20 lines of per-step inline `--` commentary (within "≤ 15 lines" guidance — slight overage at 20 due to 5 separate steps each needing a 4-line block). 
- **No `first | <full (d-body)..closure chain> | sorry` wrap.** ✓ Each step committed linearly as a bare tactic; no `try` wrappers, no `first` clauses.
- **Sorry-count budget.** ✓ Hard cap 6 respected on the assumption the chain compiles (5 < 6). If chain fails to compile, the hard cap is moot (compilation regression takes precedence).
- **Preserved infrastructure byte-for-byte.** ✓ L412–L491 (theorem signature + `presheafMap_restrict_collapse` + `letI` block) unchanged. Iter-089 step (a) (`hom_sum_dist` `have` at L528–L536) and step (b) (L540), iter-090 step (c)+(h-prep)+(d-entry) (L541–L558) preserved byte-for-byte.

## Blueprint marker recommendation

`cechCofaceMap_pi_smul` is a project-local helper used in the proof of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. No `\lean{...}` entry in `blueprint/src/chapters/Cohomology_MayerVietoris.tex`; no blueprint edits expected this iter. The main `\lean{...}`-tagged theorems carry sorries downstream of L583 — `\leanok` will be added by `sync_leanok` only after the consumer theorem's full sorry chain is resolved (multi-iter).

## Sandbox environmental issue (pre-existing, not caused by this iter)

`.lake/packages/` contains only `checkdecls` and `doc-gen4`; `mathlib` package is MISSING; `lake` binary is not on PATH (`No such file or directory: 'lake'`). LSP queries `lean_diagnostic_messages`, `lean_goal`, `lean_multi_attempt`, `lean_local_search` all fail at startup. Same condition as iter-086 through iter-090 reports. Dispatcher environment expected to fetch mathlib and verify the iter-091 commit compiles.
