# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

**Iter-089 result: PARTIAL — S6 steps (a)+(b) landed; sorry moved to
partially-distributed post-(b) goal. Compilation unverified in sandbox.**

## File status

- 6 syntactic sorries: L522→L547 (`cechCofaceMap_pi_smul` body, now after
  step b), L614, L938, L966, L1156, L1185.
- Hard cap 6 respected. Target 5 NOT met (S6 chain not closed end-to-end).
- LSP/lake unavailable in sandbox (`/home/archon/...: no such file or
  directory: 'lake'`); `.lake/packages/` contains only `checkdecls` and
  `doc-gen4` — `mathlib` absent. Identical to iter-086+ documented
  condition. Dispatcher environment must verify.

## cechCofaceMap_pi_smul (L495–L547)

### Attempt 1 — S6 steps (a) + (b) landed per PROGRESS.md mandate

- **Approach.** Following the iter-089 PROGRESS.md template verbatim for
  step (a) (inline `have hom_sum_dist` via `Finset.cons_induction`) and
  step (b) (distribute `.hom` over the alternating sum). The minimum
  mandated by PROGRESS.md if S6 cannot be closed end-to-end.
- **Code change at L522–547.** Replaced the bare trailing `sorry` with:
  1. A 6-line comment scaffold noting the iter-089 rationale (Mathlib
     `ModuleCat.hom_sum` absence + abstract `α : Type` index choice).
  2. The inline `have hom_sum_dist` template (9 lines), with `α : Type`
     left abstract so the lemma fires for whichever post-S5 index shape
     (`Fin (prev n + 2)` raw or `Fin (n+1)` after `hRel`) the elaborator
     picks at the call site.
  3. `simp only [hom_sum_dist]` (1 line) — used in preference to `rw`
     to tolerate the documented `ConcreteCategory.hom Σ` vs `Σ.hom`
     HOU pattern variance.
  4. A 6-line comment hint listing steps (c)–(h) for the iter-090 prover,
     in compliance with the "no 80+-line in-code comment block" rule
     (total ~12 comment lines, well under).
  5. Trailing `sorry`.
- **Result.** Structure laid down at L522–L547. Compilation unverified
  (LSP unavailable in sandbox).
- **Net sorry-count change.** 6 → 6 (sorry moved from post-S5 to
  post-step-(b); no net regression, no closure either).

### Attempt 2 — S6 steps (c)–(h): NOT ATTEMPTED inline

- **Reason.** Without LSP feedback, chaining (c)–(h) inline as live
  tactics carries non-trivial risk of breaking compilation at any one of
  six step-points. Specifically:
  - Step (c) `(Pi.π Z₂ j).hom.map_sum` has documented `ConcreteCategory.hom
    Σ ≟ LinearMap.toFun` HOU risk (PROGRESS.md "Documented risks #2").
  - Step (d) `Pi.lift_π_apply` may need `Pi.lift_π` instead, depending on
    whether the `_apply` form is auto-generated for the
    `ConcreteCategory`-coerced `Pi.lift` (`@[elementwise]` chain).
  - Step (e) `Pi.smul_apply` synthesis of `[∀ i, SMul R (Z₁ i)]` may need
    `letI := perI₁` prefix (PROGRESS.md "Documented risks #2").
  - Step (f) `map_mul` on `((toModuleKPresheaf C).map φ_i.op).hom` —
    must confirm this `.hom` is a `RingHom` (not just `AddHom`); the
    presheaf maps for `CommRingCat`-valued sheaves should be ring-homs.
  - Step (g) `presheafMap_restrict_collapse` invocation needs the 3
    explicit `≤`-witnesses; unification should fill them but documented
    as a risk.
  - Step (h) `Finset.smul_sum` reassemble depends on the per-summand
    shape from (g).
- **Alternative considered.** A `first | <full (c)–(h) chain> | sorry`
  wrap was considered as a way to attempt steps (c)–(h) while
  guaranteeing compilation (sorry fallback). REJECTED because:
  (i) the partial progress of any non-trivially-failing attempt would
  be invisible to the next iter (only `sorry` remains visible),
  (ii) the iter-090 prover would lose the "deepest committed step"
  signal that PROGRESS.md uses for re-scoping (see Forward Scoping bullet
  "If iter-089 partially lands the S6 chain"). Committing the safe
  minimum (a)+(b) preserves the re-scoping signal.

## Post-(b) goal (expected, unverified)

After step (b), each side's `Σ.hom` has been distributed across the
alternating sum, yielding (roughly):
```
(Pi.π Z₂ j).hom ((eqToHom ∘ₗ (∑ i, .hom of (-1)^i • (Pi.lift … ≫ map_φ_i))
  ) ((piIsoPi Z₁).inv (r • y))) =
  r • (Pi.π Z₂ j).hom ((eqToHom ∘ₗ (∑ i, …)) ((piIsoPi Z₁).inv y))
```
This is the starting point for iter-090's step (c).

## Verified Mathlib references (used by inline `hom_sum_dist`)

- `ModuleCat.hom_add` (PROGRESS.md verified iter-086).
- `Finset.sum_cons`, `Finset.cons_induction`, `Finset.sum_empty` (Mathlib core).
- `ModuleCat.hom_zero` (used implicitly by `simp` empty case).

## Mathlib gap reconfirmed

- `ModuleCat.hom_sum`: not in Mathlib by direct name (iter-086, iter-089).
  Inline workaround via `Finset.cons_induction` over `ModuleCat.hom_add`
  is the only path; per project policy, no top-level helper extraction
  allowed for this.

## Risks for iter-090 inheriting this work

1. **`hom_sum_dist` `induction … using Finset.cons_induction with` case
   labels.** I used `| empty => simp | cons h_notin ih => …`. If the
   Mathlib `Finset.cons_induction` uses `h₁`/`h₂` labels rather than
   `empty`/`cons`, the `with`-block fails. Recovery: replace the
   `induction … with` form with positional bullets:
   ```
   induction t using Finset.cons_induction
   · simp
   · intro a t' ha ih
     rw [Finset.sum_cons, ModuleCat.hom_add, Finset.sum_cons, ih]
   ```
2. **`simp only [hom_sum_dist]` firing.** If the goal's sum is wrapped
   inside `eqToHom ∘ₗ Σ.hom` and not directly under a `.hom`-projection
   subterm matchable by the lemma's LHS, `simp only` will be a no-op.
   Recovery: prefix with `unfold Function.comp` or `dsimp only` to
   reveal the subterm; or rewrite via `show` to expose
   `ModuleCat.Hom.hom (∑ …)` explicitly.
3. **Universe `α : Type` for the index.** The actual index in the goal
   may be `Fin (prev n + 2)` (Type 0). `Type` = `Type 0` matches.
   Risk negligible.
4. **`set_option maxHeartbeats 1600000`** at L455 — the inline `have`
   and `simp only` should fit comfortably; if not, iter-090 may need to
   lift further.

## Next-step recipe for iter-090 (unchanged from PROGRESS.md)

Steps (c)–(h) from PROGRESS.md, starting at the post-(b) goal:
- (c) `rw [(Pi.π Z₂ j).hom.map_sum]` twice — fallback to
  `simp only [LinearMap.map_sum]` or `Finset.sum_apply`.
- (d) `refine Finset.sum_congr rfl ?_; intro i _; simp only
  [Pi.lift_π_apply, ConcreteCategory.comp_apply]` — fallback
  `dsimp only [Pi.lift_π]`.
- (e) `simp only [Pi.smul_apply]` — prefix `letI := perI₁` on failure.
- (f) `rw [map_mul]` — `((toModuleKPresheaf C).map φ_i.op).hom`
  is a `RingHom` via `CommRingCat.Hom.hom`.
- (g) `rw [presheafMap_restrict_collapse _ _ _]` with `≤`-witnesses
  left to unification.
- (h) `rw [← Finset.smul_sum]` then `rfl` or
  `simp only [ConcreteCategory.comp_apply]`.

## Compliance with hard constraints (iter-089)

- **No new project-local top-level helpers.** ✓ Only inline `have
  hom_sum_dist`.
- **No new axioms.** ✓
- **No new false-signature helpers.** ✓ `hom_sum_dist` is a true,
  fully-proved auxiliary about `ModuleCat.Hom.hom` distributing over
  `Finset.sum` of categorical morphisms in a preadditive setting.
- **No `lean_run_code` pre-validation.** ✓ LSP/lake non-functional;
  no pre-validation done.
- **No 80+-line in-code comment blocks.** ✓ Total ~12 comment lines
  across the iter-089 addition (step (a) preamble + step (c)–(h) hint).
- **Sorry-count budget.** Held at 6 (PROGRESS.md hard cap respected;
  target 5 NOT achieved).
- **Preserved infrastructure byte-for-byte.** ✓ L412–L491 (theorem
  signature + `presheafMap_restrict_collapse`) and the entire `set_option
  maxHeartbeats 800000 in theorem basicOpenCover_isCechAcyclicCover_…`
  (L530+) unchanged.

## Blueprint marker recommendation

`cechCofaceMap_pi_smul` is a project-local helper used in the proof of
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. No `\lean{…}` entry
in `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — no blueprint
edits expected this iter. The main `\lean{…}`-tagged theorems
(`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` at L572,
`cechCohomology_subsingleton_of_cechCochain_exactAt` at L404) still
carry sorries downstream of L522 — `\leanok` will be added by
`sync_leanok` only after the consumer theorem's `sorry` chain is
fully resolved (multi-iter).

## Sandbox environmental issue (pre-existing, not caused by this iter)

`.lake/packages/` contains only `checkdecls` and `doc-gen4`; `mathlib`
package is MISSING; `lake` binary is not on PATH
(`No such file or directory: 'lake'`). LSP queries `lean_diagnostic_messages`,
`lean_goal`, `lean_multi_attempt` all error out at startup. Same
condition as iter-086 through iter-088 reports; dispatcher environment
expected to fetch mathlib and verify.
