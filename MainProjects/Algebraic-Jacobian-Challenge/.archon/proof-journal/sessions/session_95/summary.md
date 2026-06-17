# Session 95 — iter-095 review

## Metadata

- **Archon iteration**: 095
- **Stage**: prover (single substantive prover lane — `Cohomology/BasicOpenCech.lean`).
  The meta-level stage description reads "HOU-blocker breakthrough", but
  this framing is **stale** — it was carried over from the iter-094
  meta and does NOT describe iter-095's actual outcome. The iter-094
  breakthrough (`rw [← ModuleCat.hom_comp]` at L570) is preserved, but
  iter-095 itself committed only a **cosmetic normalisation** of
  `ModuleCat.Hom.hom → ConcreteCategory.hom`; the structural HOU
  blocker on the post-(b') Preadditive distribution is unresolved.
- **Prover session** (from `.archon/logs/iter-095/provers-combined.jsonl`):
  session_id `99875567-a6ba-40e0-953f-9ce599dfd6aa`, model `opus`
  (`claude-opus-4-7`), 1308 s wall.
- **Sorry count before iter-095** (per session_94 / PROJECT_STATUS):
  **14** total / **6** in `BasicOpenCech.lean` (L589, L681, L1005,
  L1033, L1223, L1252) — compile-verified.
- **Sorry count after iter-095**: **14** total — direct grep confirmed:
  - `BasicOpenCech.lean`: **6** at **L593, L685, L1009, L1037, L1227,
    L1256** (offsets +4 throughout due to the iter-095 cosmetic
    insertion of 3 comment lines + 1 tactic line at L589–L592). Same
    sorry SITES as iter-094. **Hard cap 6 respected.**
  - `Differentials.lean`: **5** at L122, L636, L957, L974, L1116 (unchanged).
  - `Modules/Monoidal.lean`: **1** at L173 (unchanged).
  - `Jacobian.lean`: **1** at L179 (unchanged).
  - `Picard/Functor.lean`: **1** at L190 (unchanged).
- **Net sorry change**: **0**. Hard cap respected. **No substantive
  structural advance.** Iter-094 breakthrough (`rw [← ModuleCat.hom_comp]`
  at L570 + `have key₂` at L580–L588) is byte-for-byte preserved; the
  only new content is a 4-line cosmetic block at L589–L592.
- **Compilation status iter-095**: **VERIFIED** —
  `lean_diagnostic_messages` with `severity=error` on the file returns
  `[]` at iter-095 close (per `attempts_raw.jsonl` log_line 54, the
  final clean diagnostic check). Fourth consecutive compile-verified
  iteration (iter-092 + iter-093 + iter-094 + iter-095).
- **Env state**: `attempts_raw.jsonl` **is FRESH this iteration**
  (timestamps 09:45:38Z–10:07:06Z; iter-095 prover scheduling per
  `meta.json` started at 09:25:12Z). The harness's pre-processor
  staleness bug noted in sessions 92/93/94 appears to be resolved
  (or, at minimum, did not recur this iteration).
  Counts taken from `attempts_raw.jsonl` summary:
  **53 events / 3 `Edit`s + 1 `Write` (task_result) / 9
  `lean_multi_attempt` / 5 `lean_diagnostic_messages` / 2 `lean_goal`
  / 5 `lean_local_search` / 0 `lean_run_code` / 4 Read / 6 Bash /
  4 TodoWrite / 1 ToolSearch / 1 Glob / 1 lean_hover_info**. LSP/lake
  working throughout.
- **`lean_verify`**: not run this iteration.

## Per-target detail

### Target 1 — `cechCofaceMap_pi_smul` (BasicOpenCech.lean L589 → L593)

**Status**: **BLOCKED** (no substantive progress beyond iter-094).
The plan's three iter-095 routes — (D′) `convert`, (D″)
`Finset.cons_induction`, (D‴) `Preadditive.comp_sum` — **all
failed**. The prover relabelled them (G/H/I/X/Y) in the task result;
substantively, all six probe-sites in the iter-095 attempt log hit
the same fundamental obstruction: the summand body references the
outer summation binder `i` at nested binding depths AND the goal has
an `eqToHom`-bridged Pi-product / unfolded-carrier type mismatch.

**Iter-095 entry goal** (post-iter-094 `have key₂`, L589):
```
(ConcreteCategory.hom (Pi.π Z₂ j))
  ((ConcreteCategory.hom
      ((∑ i, (-1)^↑i • Pi.lift fun i_1 ↦
          Pi.π (fun i ↦ ModuleCat.of k ↑(...basicOpenCover ↑s₀ ∘ i...))
              (i_1 ∘ ⇑(SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i))) ≫
            (toModuleKPresheaf C).map
              (Pi.lift fun x ↦
                  Pi.π (basicOpenCover ↑s₀ ∘ i_1)
                    ((SimplexCategory.Hom.toOrderHom (SimplexCategory.δ i)) x)).op) ≫
        eqToHom ⋯))
    ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm (r • y))) =
r • (ConcreteCategory.hom (Pi.π Z₂ j))
    ((ConcreteCategory.hom (... same expression ...))
     ((ModuleCat.piIsoPi Z₁).toLinearEquiv.symm y))
```

**Iter-095 commits** (lines 589–593):
```lean
-- (c) iter-095: normalize all `ModuleCat.Hom.hom` to `ConcreteCategory.hom`
-- so we can apply `← CategoryTheory.comp_apply` to absorb the outer
-- `Pi.π Z₂ j` into the categorical composition.
rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl]
sorry
```
Cosmetic only: `ModuleCat.Hom.hom` and `ConcreteCategory.hom (C :=
ModuleCat R)` are abbrev-equal (per `Mathlib.Algebra.Category.ModuleCat.Basic`
L113–115). No structural progress. The intended follow-on
`rw [← CategoryTheory.comp_apply]` (to absorb the outer `Pi.π Z₂ j`
into the categorical composition) **does not fire** even after the
normalisation — see Attempt 5 below.

**Nine `lean_multi_attempt` probes from `attempts_raw.jsonl`** —
grouped into six attempt clusters below.

#### Attempt 1 — `rw [show ∀ (x : ↑(∏ᶜ Z₂)), (ConcreteCategory.hom (Pi.π Z₂ j)) x = (Pi.π Z₂ j).hom x from fun _ => rfl, ← ModuleCat.hom_comp]`
- **Approach**: unfold `ConcreteCategory.hom (Pi.π Z₂ j)` to
  `(Pi.π Z₂ j).hom` via a pointwise rfl, then re-fold the outer
  `(Pi.π Z₂ j).hom ((...).hom x)` to `((...) ≫ Pi.π Z₂ j).hom x`
  via reverse `ModuleCat.hom_comp`.
- **Probe** (attempts_raw log_line 29): `lean_multi_attempt`.
- **Result**: FAILED — the second `rw` (`← ModuleCat.hom_comp`)
  cannot bind because the pattern requires `g.hom ∘ₗ f.hom` (LinearMap
  composition) but the goal has `g.hom (f.hom x)` (function
  application). The intermediate type between `(Pi.π Z₂ j)` and the
  inner `(∑F) ≫ eqToHom` is def-equal but not syntactically equal —
  same eqToHom-source obstruction we hit in iter-093, just one layer up.

#### Attempt 2 — `rw [← ConcreteCategory.comp_apply]`
- **Probe** (attempts_raw log_line 35): `lean_multi_attempt`.
- **Result**: FAILED — pattern not found.
- **Diagnosis**: the categorical-level `(?g) ∘ (?f)` composition
  pattern, like the LinearMap-level one in Attempt 1, requires
  syntactic agreement between `?f`'s codomain and `?g`'s domain.
  With the unfolded Pi-product carrier on one side and the named
  `∏ᶜ Z₂` on the other, that agreement fails.

#### Attempt 3 — `rw [show ∀ (M N : ModuleCat.{u} k) (f : M ⟶ N) x, (ConcreteCategory.hom f) x = ModuleCat.Hom.hom f x from fun _ _ _ _ => rfl]`
- **Probe** (attempts_raw log_line 39): `lean_multi_attempt`.
- **Result**: FAILED — this is the reverse of the eventual cosmetic
  commit. `rw` does match (proof witness fires), but the rewrite
  leaves the goal in the `ModuleCat.Hom.hom` form, which is no closer
  to a `← CategoryTheory.comp_apply` match than the entry goal was.

#### Attempt 4 — `show (Pi.π Z₂ j).hom _ = r • (Pi.π Z₂ j).hom _ ; rw [← LinearMap.comp_apply]`
- **Probe** (attempts_raw log_line 41): `lean_multi_attempt`.
- **Result**: FAILED — `LinearMap.comp_apply` reverse pattern `?f (?g ?x)`
  doesn't unify because the intermediate type between the outer
  `Pi.π Z₂ j` (input `∏ᶜ Z₂`) and the inner `(∑F i) ≫ eqToHom` (output
  `ModuleCat.of k (∀ i, ↑(Z₂ i))`, the eqToHom target) is def-equal
  but not syntactically equal. `LinearMap.comp_apply` requires
  syntactic intermediate-type match. **This is exactly the iter-093
  blocker, surfacing one layer up.**
- **Committed** in a brief Edit (log_line 51): `show (Pi.π Z₂ j).hom _
  = r • (Pi.π Z₂ j).hom _` + trailing `sorry`. The `rw` was never
  added. This Edit was **superseded** in log_line 76.

#### Attempt 5 — `change (ConcreteCategory.hom (Pi.π Z₂ j)) ((ConcreteCategory.hom ((∑ i, _) ≫ eqToHom _)) _) = ...`
- **Probe** (attempts_raw log_line 74): `lean_multi_attempt`.
- **Result**: FAILED — `change`'s target uses `_` placeholders for the
  unification holes (the summand body and the `eqToHom`'s implicit
  argument), but Lean cannot elaborate the placeholders because the
  summand and eqToHom-source live in metavariable contexts driven by
  `dif_pos hRel` (the same dependency that powers the iter-093/094
  eqToHom blocker). The probe returns a fresh elaboration failure on
  the very target string we needed `change` to accept.

#### Attempt 6 — first Edit: `rw [show @ModuleCat.Hom.hom k _ = @ConcreteCategory.hom _ _ _ (ModuleCat.{u} k) _ _ _ from rfl]`
- **Probe + commit** (attempts_raw log_lines 76, 79): Edit, then
  `lean_diagnostic_messages`.
- **Result**: FAILED — `rfl` raised `Type mismatch: rfl has type ?m = ?m
  but is expected to have type @ModuleCat.Hom.hom k inst✝.toDivisionRing.toRing
  = ?m`. The over-explicit @-form of the show clause left too many
  underscores for the elaborator to fill.

#### Attempt 7 (FINAL COMMIT) — `rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl]`
- **Probe + commit** (attempts_raw log_lines 81, 84): Edit + diagnostics.
- **Result**: SUCCESS (cosmetic). File compiles, 6 sorries, no new
  errors. Goal after the rewrite is identical except that all
  occurrences of `ModuleCat.Hom.hom` are now spelled `ConcreteCategory.hom`.
- **Why this was committed**: the prover noted that downstream lemmas
  like `CategoryTheory.comp_apply` (defined in
  `Mathlib.CategoryTheory.ConcreteCategory.Basic` with
  `(ConcreteCategory.hom ?g) ((ConcreteCategory.hom ?f) ?x) = (f ≫ g)
  ?x`) take `ConcreteCategory.hom` as a uniform shape, so normalising
  the goal first ought to enable a later `rw [← CategoryTheory.comp_apply]`.
  However, the follow-on `rw [← CategoryTheory.comp_apply]` (probed
  in log_lines 64, 86, 90) FAILED for exactly the reason already
  documented in Attempts 2 and 4: the intermediate type is def-equal
  but not syntactic. The cosmetic commit therefore yields no
  structural advance — it just renames the syntax at the trailing
  `sorry`.

#### Attempt 8 — `set F : Fin (n + 1) → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ (fun i ↦ ModuleCat.of k (↑...)) : ModuleCat.{u} k)) := fun i => ((-1 : ℤ) ^ (i : ℕ)) • Pi.lift fun i_1 ↦ ...`
- **Probe** (attempts_raw log_line 88): `lean_multi_attempt`.
- **Result**: ELABORATION SUCCEEDS but `set` does NOT fold the goal
  (the literal sum body remains after `set`, NOT replaced with `∑ F`).
- **Diagnosis**: `set` only renames upon EXACT syntactic match. The
  plan's recipe required a `change` first to fold the inner
  `Pi.π (fun i ↦ ModuleCat.of k ↑(...))` back to a named `Z₁`-like
  form, but the inner family uses `basicOpenCover ↑s₀ ∘ i` (composition
  notation) whereas `Z₁`'s body uses `fun a ↦ basicOpenCover ↑s₀ (i a)`
  (applied). These are eta-equivalent but not syntactically identical,
  so the `change` fold cannot be expressed with `Z₁` directly. **The
  plan's `change` + `set F` + `rw [key₂ F]` recipe is internally
  consistent but requires producing a `change` target that already
  contains the HOU blocker we're trying to break. Circular.**

#### Attempt 9 — `conv_lhs => rw [← CategoryTheory.comp_apply]`
- **Probe** (attempts_raw log_line 90): `lean_multi_attempt`.
- **Result**: FAILED — `conv_lhs` navigates correctly, but the
  rewrite still fails at the focus point for the same reason as the
  direct rewrite. `conv` does not relax HOU's syntactic-intermediate
  requirement.

#### Attempt 10 — `simp only [← CategoryTheory.comp_apply, Preadditive.sum_comp]`
- **Probe** (attempts_raw log_line 92): `lean_multi_attempt`.
- **Result**: FAILED — simp's HOU pre-filter rejects the first lemma;
  cascade does not fire. Same failure mode as the iter-094 ensemble
  simp attempt.

#### Attempt 11 — `induction Finset.univ using Finset.cons_induction with | empty => simp | cons i s hi ih => sorry`
- **Probe** (attempts_raw log_line 96): `lean_multi_attempt` — the
  plan's primary fallback (Route D″).
- **Result**: FAILED — `typeclass instance problem is stuck: Fintype ?m.1151`
  (also `AddCommMonoid ?m.1153` for a `Finset.sum_induction` variant).
- **Diagnosis**: Lean cannot determine the carrier type for
  `Finset.univ` because the sum's underlying carrier is implicit and
  the body has `i` in non-Miller positions. To make Route (D″) work,
  the WHOLE goal would need to be rephrased without the implicit
  `Finset.univ`, e.g., by generalising to an arbitrary
  `s : Finset (Fin (n+1))` outside the goal. But this requires
  abstracting the sum body — which itself has the HOU blocker we're
  trying to break.

#### Attempt 12 — `rw [show e₁.symm (r • y) = e₁.symm (r • y) from rfl]` / `simp only [Pi.lift_π_apply]` / `conv_lhs => rw [Preadditive.sum_comp]`
- **Probes** (attempts_raw log_lines 99, 101, 103): `lean_multi_attempt`.
- **Result**: ALL FAILED — "no progress" / pattern not found. The
  Pi.lift / Pi.π / eqToHom structure prevents direct simp/rw firing.

### Target 2–9 — off-limits (per PROGRESS.md)

`BasicOpenCech.lean` L685/L1009/L1037 (augmented Čech infrastructure),
L1227 (`g_R.map_smul'`, gated on `cechCofaceMap_pi_smul`), L1256
(`h_loc_exact`, gated on `IsLocalizedModule.Away`); `Differentials.lean`
L636 (`cotangentExactSeq_structure case h_exact`); `Modules/Monoidal.lean`
L173 (Mathlib gap); `Jacobian.lean` L179 (Phase C/E); `Picard/Functor.lean`
L190 (Phase C gating). All deferred per PROGRESS.md.

## Key findings / proof patterns discovered

### Finding 1 — The plan's three routes (D′)/(D″)/(D‴) are ALL blocked by the same root cause

The iter-094 review proposed three orthogonal routes to discharge
`key₂` against the binder-shadowed summand. Iter-095 attempted all
three (relabelled G/H/I in the task result) plus several minor
variants (X/Y), and **all hit the same root obstruction**: the
combination of (a) the outer `i`-binder appearing at nested binding
depths in the summand, (b) inner `Pi.π (fun i ↦ ...)` rebinding the
same letter, and (c) the eqToHom-bridge between the named `∏ᶜ Z₂`
and the unfolded `ModuleCat.of k (∀ i, ↑(Z₂ i))` Pi-product carrier.

- **(D′) `convert`** — could not be deployed because `set F :=`
  refused to fold the goal (Attempt 8), so there was no `F` to
  `convert key₂ F _ _` against.
- **(D″) `Finset.cons_induction`** — typeclass synthesis stuck on
  `Fintype ?m` because the sum's carrier is metavariable-driven
  (Attempt 11).
- **(D‴) `Preadditive.comp_sum`** dual — never made it to the dual
  move because the preceding `← CategoryTheory.comp_apply` step that
  was supposed to fuse the outer `Pi.π Z₂ j` into the composition
  fails for the same eqToHom-source reason (Attempts 1, 2, 4, 5, 9).

### Finding 2 — eqToHom-source HOU is the meta-blocker that defeats all syntactic strategies

Across iter-091 → iter-095, the recurring obstruction is the same:
`eqToHom`'s source/target ModuleCat is built from `dif_pos hRel`
inside `letI` / `letI ... in def ...` constructs, so it is
**metavariable-driven** at term-elaboration time and **never
syntactically equal** to the named target. Every syntactic strategy
that requires intermediate-type agreement (LinearMap.comp_apply,
ConcreteCategory.comp_apply, CategoryTheory.comp_apply, `set` folding,
`change`, `convert` arity-2, Finset.cons_induction over implicit
Finset.univ) is defeated by this. The iter-094 `rw [← ModuleCat.hom_comp]`
breakthrough escaped one layer of it; iter-095 surfaced the SAME
obstruction one layer up at the outer `Pi.π Z₂ j` composition.

### Finding 3 — Cosmetic normalisation does not lower HOU obstructions

`ModuleCat.Hom.hom` and `ConcreteCategory.hom (C := ModuleCat R)` are
abbrev-equal, so rewriting one to the other (the iter-095 commit) is
syntactic re-skinning that does not affect the discrimination tree's
HOU pre-filter. **Lesson**: spending a commit on a cosmetic
rename without first proving that the rename enables a follow-on
non-cosmetic rewrite is a net-zero iteration.

### Finding 4 — `attempts_raw.jsonl` pre-processor freshness restored

Sessions 92/93/94 all had stale iter-091 artefacts in
`attempts_raw.jsonl`. **Iter-095's `attempts_raw.jsonl` is fresh**
(timestamps 09:45–10:07Z; iter-095 prover started 09:25Z per
`meta.json`). The harness pre-processor bug appears resolved or at
least quiescent. Good signal.

## Recommendations for next session

See `recommendations.md` (companion file). The bottom line: **the
three syntactic routes are exhausted**. Iter-096 should invoke the
refactor subagent to reformulate `scK₀.f` coordinate-wise from the
start, bypassing the `Pi.lift` / `Pi.π` / `eqToHom` construction in
the closed term so that no eqToHom appears in any goal derived from
`scK₀.f.hom`.

## Blueprint markers updated (manual)

None this iteration. `cechCofaceMap_pi_smul` is a project-local helper
without a `\lean{...}` entry in `Cohomology_MayerVietoris.tex`; no
blueprint surface changed. No `\mathlibok` candidates surfaced. No
`\notready` removals warranted (no chapter blocks landed). No
`\lean{...}` macro renames flagged in the prover task result.

The deterministic `sync_leanok` phase runs between the prover and this
review; any `\leanok` adds/removes it produced are recorded in the
inner-git commit `archon[095/marker-sync]` and not listed here.
