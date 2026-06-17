# Recommendations for the next plan-agent iteration (iter-094)

## TL;DR

Iter-093 committed substantive progress in `cechCofaceMap_pi_smul`:
a body-local `have key₁ : ∀ F z, (∑F).hom z = ∑ (F i).hom z` block
(L570–L577) that proves the per-application form of `ModuleCat.hom_sum`
in 3 lines. The active blocker has **shifted down one structural
layer**: from iter-092's step-(b) `.hom`-distribution HOU to iter-093's
step-(b→c) `∘ₗ`-unfolding HOU. The new root cause is a `dif_pos hRel`-
introduced `eqToHom` whose source ModuleCat is metavariable-driven and
not syntactically `∏ᶜ Z₂`, so `LinearMap.comp_apply`'s discrimination
tree cannot bind.

Iter-094's job is to **unfold `∘ₗ`-application BEFORE `rw [key₁]`**.
Three documented routes; **Route (D) (`LinearMap.ext` peel + per-
summand collapse) is the recommended starting point**.

## Priority targets for iter-094 plan

### Priority 1: `cechCofaceMap_pi_smul` step (b→c) — Route (D)

**Approach**: peel `(Pi.π Z₂ j).hom` to the outside via `LinearMap.ext`
and reduce to a LinearMap equality `((Pi.π Z₂ j).hom ∘ₗ eqToHom_hom ∘ₗ
(∑F).hom) = ∑ ((Pi.π Z₂ j).hom ∘ₗ eqToHom_hom ∘ₗ (F i).hom)`. Then
`rw [key₁]` can fire against the sum-of-`∘ₗ` shape because both sides
are explicit LinearMaps (no application to a hidden `z`).

**Why this is the recommended route**:
- Direct continuation of the iter-093 `key₁` infrastructure (no new
  helpers needed).
- Reduces the problem to a per-summand `Pi.π ≫ Pi.lift` collapse via
  `Pi.lift_π` — a standard categorical move with high mathlib coverage.
- Does NOT require restructuring the iter-088 simp prefix at
  L526–L535 (which Routes E and F do).

**Concrete tactic sequence** (paste into `cechCofaceMap_pi_smul` at the
post-`have key₁` position L578):
```lean
-- Route (D): peel outer (Pi.π Z₂ j).hom via LinearMap.ext; collapse
-- per-summand Pi.lift via Pi.lift_π_apply
apply congrFun ∘ congrArg ConcreteCategory.hom  -- peel outer Pi.π
-- now goal is a LinearMap equality without the outer (Pi.π Z₂ j).hom
ext z
rw [key₁]  -- fires now because no ∘ₗ wraps the sum
simp only [Pi.lift_π_apply, LinearMap.sum_apply, LinearMap.smul_apply]
-- continue with (d-body)+(e)+(f)+(g)+closure per PROGRESS.md
```

If the `apply congrFun ∘ congrArg ConcreteCategory.hom` chain doesn't
elaborate, fall back to manual `congr 1` + `LinearMap.ext z`.

**Predicted blockers / fallbacks**:
- If `LinearMap.ext` fails because the outer expression isn't itself
  a `LinearMap` equality, use `Pi.π_ext` or `Limits.Pi.hom_ext` at
  the categorical level first to peel the outer `Pi.π Z₂ j`.
- If the `∘ₗ`-chain still resists after `ext z`, try `simp only
  [LinearMap.coe_comp, Function.comp_apply]` AFTER the `ext` (because
  `ext` reduces both sides to function-application, which is what
  `Function.comp_apply` operates on).

### Priority 2 (parallel/fallback): `cechCofaceMap_pi_smul` step (b→c) — Route (F)

**Approach**: categorical-level `Preadditive.sum_comp`. Reorder the
iter-088 simp prefix so step (b) operates BEFORE the dsimp at
L526–L535 unfolds the categorical structure into LinearMap form.

**Why this is a fallback, not a primary**:
- Requires restructuring iter-088 / iter-092's S5 prefix. Risk of
  breaking other parts of the chain.
- `Preadditive.sum_comp` does exist in Mathlib (verified iter-093:
  `CategoryTheory/Preadditive/Basic.lean` L185).

**Concrete tactic sequence**: insert BEFORE the iter-088 dsimp at
L526–L535:
```lean
-- Push Pi.π Z₂ j inside the sum at categorical level
rw [Preadditive.sum_comp]
-- now the sum is already projection-evaluated; (b→c) is trivial
```

### Priority 3 (only if D and F fail): Route (E) — bypass `dif_pos hRel`

Replace the `dif_pos hRel` step at L535 with an explicit `Eq.mpr`-cast
that the prover controls, so the resulting eqToHom-source ModuleCat is
syntactically `∏ᶜ Z₂`. Most invasive of the three routes.

## Do NOT retry in iter-094 (carried from session_92 + session_93)

The plan agent should explicitly enumerate these in `PROGRESS.md`'s
"Dead-ends to avoid" section:

- **`simp only [hom_sum_dist]` / `simp only [ModuleCat.hom_sum]` /
  `rw [ModuleCat.hom_sum]` on the L568 post-`have key₁` goal** —
  HOU-blocked (iter-092 + iter-093 confirmed).
- **`simp_rw [hom_sum_dist]` / `simp_rw [ModuleCat.hom_sum]`** —
  NEW DEAD-END (iter-093 confirmed). `simp_rw` is no better than
  `simp only` for this goal shape.
- **`have key₁ : ∀ F, (∑F).hom = ∑ (F i).hom` (without the `z`-
  argument) followed by `rw [key₁]`** — NEW DEAD-END (iter-093). The
  index-specialised LHS still HOU-fails. Use the **per-application**
  form (`∀ F z, (∑F).hom z = ∑ (F i).hom z`) instead.
- **`simp only [LinearMap.comp_apply]` / `simp only [LinearMap.coe_comp,
  Function.comp_apply]` / `rw [LinearMap.comp_apply]` on the
  post-`have key₁` goal at L578** — NEW DEAD-END (iter-093). The
  `eqToHom`-source ModuleCat is metavariable-driven; the
  discrimination tree cannot bind. **Must peel the outer
  `(Pi.π Z₂ j).hom` first via `LinearMap.ext` / `congr 1` (Route D).**
- **`show ...` / `change ...` with explicit eqToHom source** — NEW
  DEAD-END (iter-093). The eqToHom term cannot be reconstructed from
  local `Z₁, Z₂` data because its source ModuleCat lives in a
  metavariable context fed by `dif_pos hRel`.
- **`rw [show ... from ModuleCat.hom_sum f Finset.univ]` with concrete
  type `Fin (n+1) → (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂)`** (carried from iter-092):
  triggers `failed to synthesize instance AddCommMonoid ((∏ᶜ Z₁).Hom
  (∏ᶜ Z₂))`. Use the unspecialised `ModuleCat.hom_sum (R := k)`
  binding pattern instead.

## Reusable proof patterns discovered

### Per-application form for ModuleCat sum-distribution

Whenever a project-local proof needs to distribute `(∑F).hom` over a
sum, prefer the 2-argument keyed form:
```lean
have key : ∀ (F : ι → (M ⟶ N)) (z : ↑M), ((∑ i, F i) : M ⟶ N).hom z = ∑ i, (F i).hom z := by
  intro F z
  rw [ModuleCat.hom_sum F Finset.univ]
  exact LinearMap.sum_apply Finset.univ (fun i => (F i).hom) z
```
over the 1-argument `(∑F).hom = ∑ (F i).hom` form. The two-argument
keying gives `rw` enough fixed positions to bind both sides of the
discrimination tree.

### Diagnostic `pp.notation false`

When a rfl-lemma rewrite fails inexplicably, use `set_option
pp.notation false in show True` BEFORE the failing rewrite to print
the goal in un-notated form. Hidden `eqToHom`-casts, implicit
ModuleCat-types, and `dif_pos`-introduced metavariables become visible.
This pattern resolved iter-093's debugging in ~3 minutes.

## Off-limits this iteration (carry to iter-094)

- `Differentials.lean` `cotangentExactSeq_structure case h_exact` —
  off-limits parallel to `instIsMonoidal_W`.
- `Modules/Monoidal.lean` `instIsMonoidal_W` — Mathlib gap.
- `Jacobian.lean` `nonempty_jacobianWitness` — Phase C/E packaging,
  iter-100+.
- `Picard/Functor.lean` `representable` — gated on C0–C3.
- `BasicOpenCech.lean` `basicOpenCover_isCechAcyclicCover_*` substeps
  at L670/L994/L1022 — gated on `cechCofaceMap_pi_smul` closing.
- `BasicOpenCech.lean` `g_R.map_smul'` (L1212), `h_loc_exact` (L1241)
  — gated on `cechCofaceMap_pi_smul` closing (Lane 1 cascade).

## Notes for the plan agent

1. **The iter-093 commit is a NET POSITIVE despite no sorry reduction.**
   It pins down the EXACT line where iter-094 should fire `rw [key₁]`
   (immediately after the `∘ₗ`-unfolding step) and verifies that
   `ModuleCat.hom_sum + LinearMap.sum_apply` chain works. iter-094
   does not need to re-derive `key₁`.

2. **No subagent escalation needed for iter-094.** The Route (D)
   pattern is standard (`LinearMap.ext` + `congr` + `Pi.lift_π_apply`).
   Refactor subagent could be useful in iter-095+ if Route (D) fails
   and we need to reorder the S5 prefix for Route (F), but iter-094
   should attempt Route (D) first with the LSP available.

3. **`attempts_raw.jsonl` is stale again this iteration.** The
   harness's pre-processor produced data from iter-091 (timestamps
   06:07–06:27) but iter-093 prover ran 07:51–08:15. This is the
   second consecutive iteration affected (session_92 noted the same).
   Plan agent should not rely on `attempts_raw.jsonl` until the
   harness bug is fixed; use `.archon/logs/iter-NNN/provers-combined.jsonl`
   directly. A debug-feedback note has been left.

4. **PROGRESS.md update needed** — record the iter-093 sub-blocker
   shift (step (b)`.hom`-distribution → step (b→c)`∘ₗ`-unfolding) so
   iter-094's plan starts from the correct mental model.

5. **Sorry hard cap for iter-094**: maintain 6 in `BasicOpenCech.lean`.
   Target 5 if Route (D) closes the chain through (c)+(h-prep)+(d-entry)+
   (d-body)+(e)+(f)+(g)+closure. File must continue to compile.
