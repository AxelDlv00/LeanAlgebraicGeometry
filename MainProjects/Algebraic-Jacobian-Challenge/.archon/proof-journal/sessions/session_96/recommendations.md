# Recommendations for the next plan-agent iteration (iter-098)

**Headline.** Iter-097 closed `alternating_sum_pi_smul_aux` body at L478
(Step 1, plan-recipe transcribed cleanly with one Mathlib-name correction).
Step 2 (apply the new lemma to close `cechCofaceMap_pi_smul` L657) is
**still open**. The B1 bridging rewrite committed at L656
(`simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]`) is genuine
partial progress. Five subsequent application strategies all failed against
either HOU, `ComplexShape.prev` unification, or `whnf` deterministic
timeout — confirming the iter-096 refactor report §2 "(A1)/(A2)"
prediction that the abstract `alternating_sum_pi_smul_aux` does NOT
match the L657 goal directly.

The structural obstruction is precise: the L657 goal has an **outer
`Pi.π Z₂ j` projection** and an **intermediate `eqToHom`** (from
`dif_pos hRel` bridging `Fin ((ComplexShape.up ℕ).prev n + 1) → ↥s₀`
and `Fin (n+1) → ↥s₀` index types) wrapping the alternating sum.
Neither piece is absorbable at tactic level:
- Pushing eqToHom inside via `Preadditive.sum_comp` / `rw [key₂]`
  HOU-fails on the nested-`i` summand body (iter-094/095/097 thrice
  confirmed).
- Hand-typing the literal Čech body in a `suffices` or
  `have h_struct := …` re-triggers the iter-096 `whnf` timeout from
  the `ComplexShape.prev` reduction outside tactic state.
- `← ConcreteCategory.comp_apply` cannot re-fold because the eqToHom
  is structurally inside the inner `.hom`-application, not outside.

## Priority 1 (iter-098) — schedule REFACTOR subagent for the specialised projection-baked lemma

**Action**: invoke `archon-refactor-agent.py` with slug
`alternating-sum-pi-proj-spec` (or similar). The directive should add
`alternating_sum_pi_smul_aux_pi_proj` — a specialisation of
`alternating_sum_pi_smul_aux` whose conclusion bakes in:

1. the outer `Pi.π Z₂ j` projection (or, more flexibly, an explicit
   `Q`-codomain parameter `Q : ModuleCat.{u} k` and an arrow
   `E : ∏ᶜ Z₂ ⟶ Q` and an iso `eQ : Q ≃ₗ[k] ∀ j, …`); AND
2. an intermediate composition `(∑ F i) ≫ E` (or `… ≫ eqToHom`)
   between the sum and the carrier — i.e. allow the family `F : ι' →
   (∏ᶜ Z₁ ⟶ ∏ᶜ Z_intermediate)` to compose with a fixed `E : ∏ᶜ
   Z_intermediate ⟶ Q` before extraction.

A concrete signature draft (from the prover's iter-097 task report
§ "Concrete next step", refined):

```lean
theorem alternating_sum_pi_smul_aux_pi_proj
    {k : Type u} [Field k] {R : Type*} [Ring R]
    {ι₁ ι₂ : Type u} (Z₁ : ι₁ → ModuleCat.{u} k)
    (Z_intermediate : ι₂ → ModuleCat.{u} k)
    (Z₂ : ι₂ → ModuleCat.{u} k)
    [_mZ1 : Module R ((∀ i, Z₁ i))] [_mZ2 : Module R ((∀ j, Z₂ j))]
    {ι' : Type*} (s : Finset ι')
    (G : ι' → ((∏ᶜ Z₁ : ModuleCat.{u} k) ⟶
                (∏ᶜ Z_intermediate : ModuleCat.{u} k)))
    (E : (∏ᶜ Z_intermediate : ModuleCat.{u} k) ⟶
         (∏ᶜ Z₂ : ModuleCat.{u} k))
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] ∀ i, Z₁ i)
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] ∀ j, Z₂ j)
    (hG : ∀ i ∈ s, ∀ (r : R) (y : ∀ i, Z₁ i),
      e₂ ((G i ≫ E).hom (e₁.symm (r • y))) =
        r • e₂ ((G i ≫ E).hom (e₁.symm y))) (j : ι₂) :
    ∀ (r : R) (y : ∀ i, Z₁ i),
      (Pi.π Z₂ j).hom (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm (r • y))) =
        r • (Pi.π Z₂ j).hom (((∑ i ∈ s, G i) ≫ E).hom (e₁.symm y))
```

**Body sketch (~5–8 lines)**: `Preadditive.sum_comp _ G E` rewrites
`(∑ G_i) ≫ E` to `∑ (G_i ≫ E)`; then apply
`alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i => G i ≫ E) e₁ e₂ hG`
to get the family-level R-linearity; finally apply `congrFun (… r y) j`
and `Pi.smul_apply` to extract the `j`-evaluated form. Both rewrites
are HOU-free at the signature level because `G` is a binder, not a
literal — exactly the workaround iter-095 needed but couldn't express
at call site.

**Why this is a refactor, not a prover task.** The blocker is not a
proof gap but a signature gap — the new lemma's conclusion shape
must include `(Pi.π Z₂ j).hom`. Adding such a top-level lemma is
exactly the refactor subagent's job (single new top-level decl,
read-only on protected signatures, body proved cleanly from
`alternating_sum_pi_smul_aux + Preadditive.sum_comp + congrFun +
Pi.smul_apply`).

**Companion check.** The iter-096 refactor's `cechCofaceMap_pi_smul_summand`
companion was DROPPED due to a `whnf` timeout when the directive
tried to embed the literal Čech summand inside a `let φ_i := …`
binding in the signature. The iter-098 refactor's
`alternating_sum_pi_smul_aux_pi_proj` is **NOT** subject to this
timeout — its signature uses only abstract `G` / `E` binders, never
mentions `ComplexShape.prev` or `SimplexCategory.δ`, and the body's
rewrites operate purely at the categorical level (`Preadditive.sum_comp`,
`congrFun`, `Pi.smul_apply`). The whnf budget should not be an issue.

## Priority 2 (iter-099, contingent on Priority 1 success) — schedule PROVER lane to close L657

**Action**: prover on `BasicOpenCech.lean`, single objective: replace
the L657 `sorry` with a call to `alternating_sum_pi_smul_aux_pi_proj`.
The expected call-site chain is short (3–8 tactic lines, well under
the iter-097 prover's 5-Edit budget):

```lean
-- L656 (preserve iter-097 B1 bridge):
simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]
-- iter-099: apply the specialisation.
-- Provide G := the per-summand alternating body (fun i => (-1)^↑i • Pi.lift ...)
-- and E := eqToHom (...); per-summand R-linearity via the per-summand
-- chain (Pi.lift_π_apply, ConcreteCategory.comp_apply, ModuleCat.hom_smul,
-- Pi.smul_apply, map_mul, presheafMap_restrict_collapse).
refine alternating_sum_pi_smul_aux_pi_proj _ _ _ _ Finset.univ
  (fun i => (-1)^(↑i : ℕ) • Pi.lift fun i_1 =>
    Pi.π Z₁ (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom) ≫
    (toModuleKPresheaf C).map (Pi.lift fun x =>
      Pi.π (basicOpenCover ↑s₀ ∘ i_1) ((δ i).toOrderHom x)).op)
  (eqToHom ⋯) e₁ e₂ ?_ j r y
intro i _ r' y'
-- per-summand R-linearity, well-trodden iter-090/091 template:
simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply,
  ModuleCat.hom_smul, LinearMap.smul_apply, Pi.smul_apply]
rw [map_mul, presheafMap_restrict_collapse _ _ _]
rfl
```

**Risk note**: even with the specialisation, the per-summand
discharge `?hG` may face a residual HOU obstruction at
`Pi.lift_π_apply` because the inner `Pi.π (basicOpenCover ↑s₀ ∘ i_1)`
re-binds the same letter as `(δ i).toOrderHom x`. The prover should
verify per-step via `lean_diagnostic_messages` and may need to use
the iter-090 `Pi.smul_apply` + `letI`-bound `Pi.module` workaround.
If the per-summand chain stalls, the L657 closure remains open but
the bridge is functionally complete — escalate then to a small
follow-up refactor specialising the per-summand R-linearity.

## Priority 3 — preserve byte-for-byte across iter-098

1. `alternating_sum_pi_smul_aux` body at L478–L494 (CLOSED iter-097).
2. `cechCofaceMap_pi_smul` prefix L500–L655 — preserve (iter-092
   foundation through iter-095 cosmetic through iter-097 B1 bridge,
   all locked in).
3. Iter-097 B1 bridge at L652–L656 (the `simp_rw [←
   ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]` line and its
   2-line comment) — preserve. The iter-099 prover's `refine`
   should sit AFTER L656.
4. Inserting the new top-level
   `alternating_sum_pi_smul_aux_pi_proj` after L494 (i.e.
   immediately after `alternating_sum_pi_smul_aux`) is the
   recommended placement.

## Priority 4 — do NOT retry these dead-end classes

| Dead-end | Confirmed iter | Rationale |
|---|---|---|
| `rw [Preadditive.sum_comp]` / `rw [key₂]` / `simp only [key₂]` on the post-(b') goal | iter-094, iter-095, **iter-097** | HOU on nested-`i` Čech summand body — three-iteration trifecta. |
| `suffices h_fam : <literal Čech body>` | iter-096 refactor, **iter-097** | `whnf` deterministic timeout at 1.6M heartbeats; `ComplexShape.prev` reduction outside tactic state. |
| `have h_struct := alternating_sum_pi_smul_aux ... (fun i => <literal F + eqToHom>) ...` | **iter-097** | Same root cause as `suffices` — `Fin (prev n + 1)` vs `Fin (n+1)` non-unification outside tactic state. |
| `refine congrFun (alternating_sum_pi_smul_aux ...)` with `?F` Miller-pattern | **iter-097** | Lemma conclusion shape does not match goal (outer `Pi.π Z₂ j` + intermediate `eqToHom` are unabsorbed). |
| `rw [← ConcreteCategory.comp_apply]` post-iter-095 cosmetic | iter-095, **iter-097** | Both outer and inner are in `ConcreteCategory.hom` form but as separate applications, not a composition. |
| `convert key₂ _ _ _` via `set F :=` prefold | iter-095 | `set` does not fold the inner `Pi.π (fun i ↦ ...)` re-binding. |
| `induction Finset.univ using Finset.cons_induction` at the call site | iter-095 | `Fintype ?m` typeclass stuck. (HOU-free INSIDE `alternating_sum_pi_smul_aux`'s body — that path succeeded iter-097.) |
| `cechCofaceMap_pi_smul_summand` per-summand companion at signature level | iter-096 refactor | `whnf` timeout from `ComplexShape.prev`. |

## Priority 5 — reusable patterns to remember

1. **`Finset.cons_induction` on an abstract Finset binder + `revert hF`**
   *(iter-097, NEW)* — proven recipe for "sum of P-satisfying maps
   satisfies P" structural lemmas. HOU-free.
2. **`simp_rw [← ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j]` as a
   `(Pi.π Z₂ j).hom z`-to-`(piIsoPi Z₂).hom.hom z j` bridge**
   *(iter-097, NEW)* — converts both LHS and RHS occurrences in one
   pass, structurally separating outer `j`-eval from inner body.
3. **Name-correction discipline for plan-recipe transcription**
   *(iter-097, meta-pattern)* — when the plan suggests a Mathlib
   lemma name, `lean_local_search` or `lean_loogle` in 30s confirms
   or corrects (`ModuleCat.zero_hom` → `ModuleCat.hom_zero`).

## Sorry budget guidance for iter-098 (refactor) + iter-099 (prover)

- **Iter-098 (refactor pass)**: NET ZERO new sorries expected — the new
  `alternating_sum_pi_smul_aux_pi_proj` should be provable from
  `alternating_sum_pi_smul_aux + Preadditive.sum_comp + congrFun +
  Pi.smul_apply` in 5–8 lines. **Hard cap 6** sorries in
  `BasicOpenCech.lean` (no regression from iter-097 close).
- **Iter-099 (prover pass)**: TARGET sorries 5 in `BasicOpenCech.lean`
  (close L657). HARD CAP 6 (no regression). Acceptable outcome: L657
  closed cleanly.

## Off-limits for iter-098 (same as iter-097)

- `Differentials.lean` — Mathlib-gap deferral.
- `Modules/Monoidal.lean` — Mathlib-gap.
- `Jacobian.lean`, `Picard/Functor.lean` — Phase C/E.
- `BasicOpenCech.lean` L749, L1073, L1101 (augmented-Čech).
- `BasicOpenCech.lean` L1291, L1320 (gated on L657 closing — defer until
  iter-099 succeeds).

## Note on the streak

Iter-097 ended a TWO-iteration streak of zero substantive structural
advance (iter-095 cosmetic-only; iter-096 refactor added but didn't
close anything). Closing `alternating_sum_pi_smul_aux` (Step 1) IS a
structural advance — the abstract lemma now has a verified body,
ready for use by the iter-098 specialisation. The L637/L657 ladder is
one well-defined refactor step away from closure. Five consecutive
compile-verified iterations (iter-092 + iter-093 + iter-094 +
iter-095 + iter-097); iter-096 is excluded only because the
intervening `sync_leanok` / refactor reorganisation phases changed
the file but not the prover lane's outcome.
