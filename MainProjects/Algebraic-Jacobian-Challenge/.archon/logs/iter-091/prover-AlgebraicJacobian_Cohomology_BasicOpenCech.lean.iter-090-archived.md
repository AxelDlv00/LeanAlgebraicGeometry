# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Iter-090 result: PARTIAL — S6 steps (c), (h-prep), (d-entry) landed;
trailing `sorry` pushed L547 → L564 at per-summand goal. Compilation
unverified in sandbox (LSP/mathlib unavailable, as iter-086…089).**

## File status

- 6 syntactic sorries (unchanged from iter-089 hard cap; target 5 NOT met):
  L564 (was L547, `cechCofaceMap_pi_smul` body, now after step d-entry),
  L656 (was L639), L980 (was L963), L1008 (was L991), L1198 (was L1181),
  L1227 (was L1210). All shifted by +17 due to iter-090's added comment
  block + 3 substantive tactic lines.
- Hard cap 6 respected. Target 5 NOT met (S6 chain not closed end-to-end
  — per-summand body (d-body)/(e)/(f)/(g)/closure remain).
- LSP/lake unavailable in sandbox: `.lake/packages/` contains only
  `checkdecls` and `doc-gen4`; `mathlib` package MISSING; `lake` binary
  not on PATH. Identical to iter-086 through iter-089. Dispatcher
  environment expected to verify.

## cechCofaceMap_pi_smul (L495–L564)

### Attempt 1 — S6 steps (c), (h-prep), (d-entry) landed per PROGRESS.md mandate

- **Approach.** Following the PROGRESS.md iter-090 templates for steps (c),
  (h), and the per-summand entry of (d). The iter-090 mandate requires
  attempting steps beyond (b), so I committed three substantive tactic
  lines after the iter-089 step-(b) `simp only [hom_sum_dist]`:

  1. **Step (c)** — `simp only [map_sum]` (L547). Distributes
     `(Pi.π Z₂ j).hom` (a LinearMap via the ModuleCat `.hom` projection)
     over the outer Finset.sum. `simp only` (not `rw`) for HOU
     robustness — fires recursively through any nested AddMonoidHomClass
     functions (e.g., `eqToHom`) sitting between the outer hom and Σ.
     Universal `map_sum` is preferred over `LinearMap.map_sum` so the
     elaborator picks the right `[AddMonoidHomClass]` instance regardless
     of how the prior `simp` (L504–511) shaped the term.

  2. **Step (h-prep)** — `simp only [Finset.smul_sum]` (L551). Pushes
     outer `r •` on RHS through the Σ (forward direction
     `r • ∑ = ∑ r • _`) so both sides align to `∑ i ∈ s, _` form,
     enabling per-summand congruence. PROGRESS.md template (h) had this
     at the END of the chain (`rw [← Finset.smul_sum]`); per the
     mathematical structure, doing it here (forward direction, before
     `sum_congr`) is equivalent and lets us split per-summand cleanly.

  3. **Step (d-entry)** — `refine Finset.sum_congr rfl ?_; intro i _`
     (L557–L558). Per-summand congruence drops the outer Σ on both sides.
     After this, the goal becomes (for fixed `i`):
     ```
     (Pi.π Z₂ j).hom (((-1)^i • Pi.lift f_i).hom ((piIsoPi Z₁).inv (r • y)))
     = r • (Pi.π Z₂ j).hom (((-1)^i • Pi.lift f_i).hom ((piIsoPi Z₁).inv y))
     ```
     where `f_i a = Pi.π Z₁ (a ∘ δ_i.toOrderHom) ≫ (toModuleKPresheaf C).map φ_i.op`.

- **Code change at L540–L564.** After the iter-089 step-(b)
  `simp only [hom_sum_dist]` at L540, replaced the 6-line iter-089 hint
  comment + trailing `sorry` (at L547) with 17 new lines:
  - L541–546: 6-line comment scaffold for step (c) (rationale + HOU
    robustness note).
  - L547: `simp only [map_sum]` — step (c).
  - L548–550: 3-line comment for step (h-prep).
  - L551: `simp only [Finset.smul_sum]` — step (h-prep).
  - L552–556: 5-line comment for step (d-entry) (per-summand goal sketch).
  - L557–558: `refine Finset.sum_congr rfl ?_; intro i _` — step (d-entry).
  - L559–563: 5-line comment for remaining (d-body)/(e)/(f)/(g)/closure.
  - L564: trailing `sorry`.

  Total: ~15 comment lines + 4 tactic lines added inside the
  `cechCofaceMap_pi_smul` body. Comment budget well within the
  "≤ 20 lines total of new commentary" limit. No new top-level
  declarations, no new axioms.

- **Result.** Structure laid down at L540–L564. Compilation unverified
  (LSP unavailable in sandbox); the dispatcher environment will verify.

- **Net sorry-count change.** 6 → 6 (sorry moved from post-step-(b) at
  L547 to post-step-(d-entry) at L564; no net regression, no closure
  either; +3 substantive tactic lines = +3 deepest-committed-step depth).

### Attempt 2 — S6 (d-body)/(e)/(f)/(g)/closure: NOT ATTEMPTED inline

- **Reason.** The per-summand inner work involves:
  - **(d-body)** Peel `(-1)^i • Pi.lift f_i` per-summand. The scalar
    `(-1)^i` requires `ModuleCat.hom_zsmul` (lemma name unverified
    locally; may be `ModuleCat.hom_smul` or `LinearMap.smul_apply` —
    each carrying HOU risk for the integer-vs-natural scalar action).
    The `Pi.lift` peel requires `Pi.lift_π_apply` (`.hom`-elementwise
    form; iter-089 confirmed name uncertainty).
  - **(e)** `Pi.smul_apply` on `(r • y) (j ∘ δ_i.toOrderHom)`. May need
    `letI := perI₁` prefix for `[∀ i, SMul R (Z₁ i)]` synthesis
    (PROGRESS.md "Documented risks #2").
  - **(f)** `map_mul` on `((toModuleKPresheaf C).map φ_i.op).hom`. Must
    confirm this `.hom` is a `RingHom`, not just `AddHom` (presheaf maps
    for `CommRingCat`-valued sheaves should be ring-homs, but HOU
    unverified without LSP).
  - **(g)** `presheafMap_restrict_collapse _ _ _` — the three
    `≤`-witnesses are documented to flow from unification; PROGRESS.md
    inherits a documented risk if unification cannot fill them.
  - **closure** — `rfl` or `simp only [ConcreteCategory.comp_apply]`
    depending on which definitional residue remains.

  Each step carries non-trivial HOU risk without LSP feedback.
  Chaining them inline would risk a compile error at the deepest
  failing step, breaking the file.

- **Alternative considered.** A `first | <full (d-g) chain> | sorry`
  wrap would have guaranteed compilation (sorry fallback). REJECTED
  per PROGRESS.md "DO NOT wrap the chain in `first | <full chain> |
  sorry`" — this is exactly the iter-089-documented forbidden pattern
  because it loses the "deepest committed step" signal needed for
  iter-091 re-scoping.

- **Mitigation.** The iter-090 commit is conservative-but-substantive:
  3 new tactic lines (c, h-prep, d-entry) take iter-091 directly into
  the per-summand goal, where the per-step fallback ladder applies in
  finer granularity (each of (d-body)/(e)/(f)/(g)/closure becomes its
  own scopeable step).

## Post-(d-entry) per-summand goal (expected, unverified)

After step (d-entry), the per-summand goal (for fixed `i`) is:
```
(Pi.π Z₂ j).hom (((-1)^i • Pi.lift (fun a => Pi.π Z₁ (a ∘ δ_i.toOrderHom)
  ≫ (toModuleKPresheaf C).map φ_i.op)).hom ((piIsoPi Z₁).inv (r • y)))
= r • (Pi.π Z₂ j).hom (((-1)^i • Pi.lift (fun a => Pi.π Z₁ (a ∘ δ_i.toOrderHom)
  ≫ (toModuleKPresheaf C).map φ_i.op)).hom ((piIsoPi Z₁).inv y))
```
This is the starting point for iter-091's (d-body)+(e)+(f)+(g)+closure.

## Risks inherited from iter-090's work

1. **`simp only [map_sum]` no-op risk.** If iter-089's step (b)
   (`simp only [hom_sum_dist]`) was a no-op in actual compilation
   (iter-089 risk #2), then iter-090's step (c) operates on the
   pre-(b) form `(Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) ...)`. `map_sum`
   may not fire if the outer wrapping is non-distributable. Recovery
   (iter-091): try `simp only [map_sum, ConcreteCategory.hom_def]` or
   prefix with `dsimp only [Function.comp]` to expose subterms.

2. **`simp only [Finset.smul_sum]` no-op risk.** If step (c) didn't
   fire correctly, the RHS may not have `r • ∑` shape. In that case
   step (h-prep) is a no-op, and `refine Finset.sum_congr rfl ?_`
   fails (LHS/RHS not both `∑`). Recovery: invert the order — try
   `refine Finset.sum_congr rfl ?_` first; if it fails, the goal isn't
   yet in `∑ = ∑` form, and additional simp/rw work is needed.

3. **`Finset.sum_congr rfl` order risk.** `Finset.sum_congr` requires
   both sides to be sums over the same Finset. If `simp only [map_sum]`
   distributed `(Pi.π Z₂ j).hom` over the LHS Σ but the RHS Σ has a
   different shape (e.g., due to `r •` being absorbed into the body
   differently), the congruence fails. Recovery (iter-091): try
   `Finset.sum_congr` with explicit equality witnesses.

4. **`maxHeartbeats 1600000`** at L455 should suffice for the iter-090
   additions (3 lightweight `simp only`/`refine` tactic lines). If
   step (d-entry) blows the budget, lift to 3200000 inline at L455.

## Verified Mathlib references (used by iter-090)

- `map_sum` (universal AddMonoidHomClass distribution; Mathlib core).
- `Finset.smul_sum` (Mathlib `Algebra.BigOperators.GroupWithZero.Action`).
- `Finset.sum_congr` (Mathlib core).

(All unverified locally due to LSP/mathlib absence in sandbox;
dispatcher environment expected to confirm.)

## Mathlib gaps reconfirmed (no change from iter-089)

- `ModuleCat.hom_sum`: not in Mathlib by direct name. Inline
  workaround via iter-089 `Finset.cons_induction` over
  `ModuleCat.hom_add` remains the only path.

## Next-step recipe for iter-091

Per-summand work starting from the post-(d-entry) goal (at L564 sorry):
- **(d-body)** peel `(-1)^i • Pi.lift f_i`:
  `simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply,
   ModuleCat.hom_smul, LinearMap.smul_apply]` (fallback to
   `dsimp only [Pi.lift_π]` if `_apply` form is unavailable).
- **(e)** `Pi.smul_apply` to surface inner `r •`. Prefix
  `letI := perI₁` if synthesis fails for `[∀ i, SMul R (Z₁ i)]`.
- **(f)** `rw [map_mul]` — `((toModuleKPresheaf C).map φ_i.op).hom`
  should be a `RingHom` for `CommRingCat`-valued presheaf maps.
- **(g)** `rw [presheafMap_restrict_collapse _ _ _]` with `≤`-witnesses
  left to unification (or supplied explicitly via `(Pi.π _ _ |>.le)`
  chained with `basicOpen_le` per L477–L480 pattern).
- **closure** `rfl` or `simp only [ConcreteCategory.comp_apply]`.

## Compliance with hard constraints (iter-090)

- **No new project-local top-level helpers.** ✓ Only inline tactics.
- **No new axioms.** ✓
- **No new false-signature helpers.** ✓ No new `have`s introduced;
  only tactic applications on the existing post-(b) goal.
- **No `lean_run_code` pre-validation.** ✓ LSP/lake non-functional;
  no pre-validation done.
- **No 80+-line in-code comment blocks.** ✓ Iter-090 added ~15
  comment lines (well under 20-line limit per PROGRESS.md).
- **No `first | <full (c)–(h) chain> | sorry` wrap.** ✓ Each step
  committed linearly with trailing `sorry` after the deepest
  committed step (d-entry).
- **Sorry-count budget.** Held at 6 (PROGRESS.md hard cap respected;
  target 5 NOT achieved — would have required full (d-body)–(h)
  closure which carries too much HOU risk without LSP).
- **Preserved infrastructure byte-for-byte.** ✓ L412–L491 (theorem
  signature + `presheafMap_restrict_collapse` + `letI` block)
  unchanged. Iter-089 step (a) (`hom_sum_dist` `have` at L528–L536)
  and step (b) (`simp only [hom_sum_dist]` at L540) preserved byte-for-byte.

## Blueprint marker recommendation

`cechCofaceMap_pi_smul` is a project-local helper used in the proof of
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. No `\lean{...}`
entry in `blueprint/src/chapters/Cohomology_MayerVietoris.tex`; no
blueprint edits expected this iter. The main `\lean{...}`-tagged
theorems carry sorries downstream of L564 — `\leanok` will be added
by `sync_leanok` only after the consumer theorem's `sorry` chain is
fully resolved (multi-iter).

## Sandbox environmental issue (pre-existing, not caused by this iter)

`.lake/packages/` contains only `checkdecls` and `doc-gen4`; `mathlib`
package is MISSING; `lake` binary is not on PATH (`No such file or
directory: 'lake'`). LSP queries `lean_diagnostic_messages`, `lean_goal`,
`lean_multi_attempt`, `lean_local_search` all fail at startup. Same
condition as iter-086 through iter-089 reports; dispatcher environment
expected to fetch mathlib and verify the iter-090 commit compiles.
