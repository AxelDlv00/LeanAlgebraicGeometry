# Recommendations for the next plan-agent iteration (iter-100)

**Headline.** Iter-099 vindicated the iter-098 split-slot refactor:
both call sites of `alternating_sum_pi_smul_aux_sum_comp` fired
HOU-free at first probe. Step 1 (L532 body) is fully closed with a
3-line tactic proof. Step 2 (L695 → now L728) has its **bridge
successfully applied** — the iter-098 lemma's Miller-pattern
unification fills `Z_int`, `G`, `E`, `s` from the literal goal
shape, with `eqToHom` landing in `E`'s independent elaboration slot,
finally bypassing iter-097's Attempt-5 dead-end. Only the per-summand
R-linearity hypothesis `hG` remains open at L728. The conceptual gap
has shrunk from "design a refactor" to "manage typeclass synthesis
for one polymorphic scalar".

**Structural advance**: YES — the L728 sorry is qualitatively easier
than the L695 sorry it replaces. The frame of the proof obligation
has changed: pre-iter-099 was "find a structural bridge across the
outer `Pi.π Z₂ j` projection + intermediate `eqToHom`"; post-iter-099
is "show that the per-summand `(-1)^↑i • Pi.lift_thing ≫ eqToHom`
is R-linear after composition with `e₂ ∘ (...) ∘ e₁.symm`".

## Priority 1 (iter-100) — schedule PROVER lane to close the L728 `hG` sub-goal

**Action**: prover on `BasicOpenCech.lean`, single objective: replace
the L728 `sorry` with the per-summand R-linearity discharge. Target:
**close L728** to bring `BasicOpenCech.lean` sorries 6 → 5.

**Pre-flight blockers identified iter-099 (DO NOT RETRY)**:

| Dead-end | Mathlib name | Root cause |
|---|---|---|
| `simp only [Preadditive.smul_comp]` | DNE | Wrong name — correct is `CategoryTheory.Linear.smul_comp` (k-action) or `CategoryTheory.Preadditive.zsmul_comp` (ℤ-action) |
| `simp only [Linear.smul_comp]` raw on the goal | exists | Pattern `(?r • ?f) ≫ ?g` fails to unify because `(-1)^↑i`'s scalar type is polymorphic `?S` and Lean cannot pin it to `k` |
| `simp only [Preadditive.zsmul_comp]` raw on the goal | exists | Same — `?S` is neither `k` nor `ℤ` from the goal's surface |
| `simp only [zsmul_comp]` (no namespace) | wrong lemma | Resolves to a different declaration |
| `rw [ModuleCat.hom_smul]` raw after comp unfold | exists | Typeclass chain `[Monoid S] [DistribMulAction S _] [SMulCommClass k S _]` cannot synthesise with polymorphic `(-1)^↑i` |
| `simp only [neg_smul, one_smul, smul_neg, pow_succ, pow_zero]` | exist | Make no progress — these unfold low-level arithmetic but do not touch the typeclass blocker |

**Recommended iter-100 strategy** (per the prover's `task_results/Cohomology_BasicOpenCech.lean.md`
§ "What remains for iter-100 follow-up", refined):

```lean
intro i _ r' y'
-- A) Force-elaborate (-1)^↑i to a concrete scalar type.
--    Option A1 (preferred, recommended):
set s : ℤ := (-1 : ℤ)^(↑i : ℕ) with hs
-- Option A2 (fallback, if A1's `set` fails to fold the head smul):
--   change ((-1 : ℤ)^(↑i : ℕ) • Pi.lift fun … : ∏ᶜ Z₁ ⟶ _) ≫ _ = _
--     in the goal LHS+RHS via `show` or `change`.

-- B) Now Preadditive.zsmul_comp should fire (head smul scalar is ℤ).
rw [Preadditive.zsmul_comp]

-- C) Distribute composition's underlying linear-map application.
simp only [ModuleCat.hom_comp, LinearMap.comp_apply]

-- D) Extract zsmul past ModuleCat.Hom.hom of the Pi.lift.
--    ModuleCat.hom_zsmul or LinearMap.coe_zsmul.
rw [ModuleCat.hom_zsmul]
-- or simp only [ModuleCat.hom_zsmul, LinearMap.zsmul_apply]

-- E) k-linearity of e₂ commutes zsmul through e₂.
--    map_zsmul or AddMonoidHom.map_zsmul applies via Int-action SMulCommClass.

-- F) Now both sides have shape `r • • z = r • r' • (...)`, and the
--    inner R-linearity is the iter-087 presheafMap_restrict_collapse
--    finish.
rw [presheafMap_restrict_collapse _ _ _ r' y']
-- or with the iter-090 letI-bound Pi.module workaround if the pi-action
-- shape mismatches.
```

**Risk note**: even with the polymorphic scalar pinned, there may be
**residual typeclass-synthesis obstacles** for `SMulCommClass` between
`R` and `ℤ`. If iter-100 stalls here, fall back to manually unfolding
`zsmul` to `Int.cast n • _` and treating it as an `R`-module operation
(since `R` is a `CommRing` and the structure is canonical).

**Estimated effort**: 20–40 lines of tactic. **Hard cap**: 6 sorries
in `BasicOpenCech.lean` (no regression). **Acceptable outcome**:
L728 closed cleanly, bringing total to 13 sorries / 5 in
`BasicOpenCech.lean`.

## Priority 2 — preserve byte-for-byte across iter-100

1. `alternating_sum_pi_smul_aux` body at L478–L494 (CLOSED iter-097).
2. `alternating_sum_pi_smul_aux_sum_comp` (iter-098 lemma at
   L513–L531 signature + L532–L537 body CLOSED iter-099).
3. `cechCofaceMap_pi_smul` prefix L539–L699 — preserve (iter-092
   foundation through iter-097 B1 bridge at L699).
4. Iter-099 bridge tactics at L700–L712:
   `rw [← Pi.smul_apply (i := j)]; refine congrFun
   (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁
   e₂ ?_ r y) j` — preserve. The iter-100 prover's `intro i _ r' y'`
   should sit AFTER L712.
5. Iter-099 partial chain at L726–L727:
   `intro i _ r' y'; simp only [ModuleCat.hom_comp, LinearMap.comp_apply]`
   — preserve. The iter-100 prover replaces the L728 `sorry` only.

## Priority 3 — do NOT retry these dead-end classes

| Dead-end | Confirmed iter | Rationale |
|---|---|---|
| `simp only [Preadditive.smul_comp]` | **iter-099** | Lemma name DNE; use Linear.smul_comp or Preadditive.zsmul_comp |
| Raw `simp only [Linear.smul_comp]` / `[Preadditive.zsmul_comp]` without pre-elaborating scalar | **iter-099** | Pattern matching fails on polymorphic (-1)^↑i `?S` |
| Raw `rw [ModuleCat.hom_smul]` on polymorphic head smul | **iter-099** | Typeclass synthesis chain fails to resolve `?S` |
| `simp only [neg_smul, one_smul, smul_neg, pow_succ, pow_zero]` on head smul | **iter-099** | No progress — low-level arithmetic does not touch typeclass blocker |
| `rw [Preadditive.sum_comp]` / `rw [key₂]` / `simp only [key₂]` on the post-(b') goal | iter-094, iter-095, iter-097, **iter-099 (implied)** | HOU on nested-`i` Čech summand body — four-iteration trifecta |
| `suffices h_fam : <literal Čech body>` | iter-096 refactor, iter-097 | `whnf` deterministic timeout at 1.6M heartbeats; `ComplexShape.prev` reduction outside tactic state |
| `have h_struct := alternating_sum_pi_smul_aux ... (fun i => <literal F + eqToHom>) ...` | iter-097 | Same root cause as `suffices` — `Fin (prev n + 1)` vs `Fin (n+1)` non-unification outside tactic state. **NOTE**: this dead-end is now BYPASSED by the iter-098 split-slot refactor; the `eqToHom` lands in `E`'s independent slot |
| `refine congrFun (alternating_sum_pi_smul_aux ...)` with `?F` Miller-pattern on single-slot lemma | iter-097 | Lemma conclusion shape does not match goal (outer `Pi.π Z₂ j` + intermediate `eqToHom` unabsorbed). **NOTE**: superseded — iter-099's `refine congrFun (alternating_sum_pi_smul_aux_sum_comp …)` form works |
| `rw [← ConcreteCategory.comp_apply]` post-iter-095 cosmetic | iter-095, iter-097 | Both outer and inner in `ConcreteCategory.hom` form as separate applications |
| `convert key₂ _ _ _` via `set F :=` prefold | iter-095 | `set` does not fold the inner `Pi.π (fun i ↦ ...)` re-binding |
| `induction Finset.univ using Finset.cons_induction` at the call site | iter-095 | `Fintype ?m` typeclass stuck (HOU-free INSIDE the abstract lemma's body — that path succeeded iter-097) |
| `cechCofaceMap_pi_smul_summand` per-summand companion at signature level | iter-096 refactor | `whnf` timeout from `ComplexShape.prev` |

## Priority 4 — reusable patterns to remember

1. **Refactor split-slot pattern for HOU-blocked single-slot lemmas**
   *(iter-098/099, NEW + VINDICATED)*: when an abstract structural
   lemma's single morphism slot `F : ι' → (A ⟶ B)` is HOU-blocked
   at a call site whose literal F-body has nested non-Miller binder
   references, refactor to a two-slot signature
   `(G : ι' → (A ⟶ C), E : C ⟶ B)` with `F i = G i ≫ E`. The
   two-slot version's Miller-pattern unification at the call site
   puts the literal "blocker" (`eqToHom`, fixed post-composition,
   etc.) into the independent `E` slot. Body provable from the
   single-slot version via `Preadditive.sum_comp` + family-level
   rewrite (3 tactic lines).
2. **`rw [← Pi.smul_apply (i := j)]; refine congrFun … j` as
   j-eval lifter** *(iter-099, NEW)*: when a goal has shape
   `f z j = r • g z j` where `f` and `g` agree as functions of `z`,
   reverse the smul-eval on the RHS to `(r • _) j` form, then
   strip `j` symmetrically with `congrFun`. The remaining sub-goal
   is the family-level statement.
3. **`Finset.cons_induction` on an abstract Finset binder + `revert hF`**
   *(iter-097, NEW)* — proven recipe for "sum of P-satisfying maps
   satisfies P" structural lemmas. HOU-free.
4. **Name-correction discipline for plan-recipe transcription**
   *(iter-097/099, meta-pattern)* — directives frequently mis-name
   Mathlib lemmas by one suffix swap or missing namespace prefix.
   `lean_local_search` / `lean_loogle` / `lean_leansearch` resolve
   in ≤ 30s; always verify before transcribing.

## Priority 5 — speculative iter-100 follow-up (contingent on L728 close)

If iter-100 closes L728 cleanly, the next L820 sorry inside
`cechCofaceMap_pi_smul` is **NOT** the next priority; rather:

- **`g_R.map_smul'` (L1362)** becomes ungated. This is the immediate
  downstream consumer of `cechCofaceMap_pi_smul`, and is the second
  Phase-A obstruction beyond `cechCofaceMap_pi_smul`. The plan
  should re-assess gating dependencies and schedule a scoping pass
  before assigning L1362 to a prover.

- **L820, L1144, L1172** (augmented Čech) remain off-limits — multi-iter
  infrastructure gap unchanged.

## Sorry budget guidance for iter-100

- **Iter-100 (prover pass)**: TARGET sorries 5 in `BasicOpenCech.lean`
  (close L728). HARD CAP 6 (no regression). Acceptable outcome: L728
  closed; structural advance is one fully-closed downstream consumer
  of the iter-098 split-slot refactor.

## Off-limits for iter-100 (same as iter-099)

- `Differentials.lean` — Mathlib-gap deferral; Route A/B decision
  on L636 still pending.
- `Modules/Monoidal.lean` — Mathlib gap.
- `Jacobian.lean`, `Picard/Functor.lean` — Phase C/E.
- `BasicOpenCech.lean` L820, L1144, L1172 (augmented-Čech).
- `BasicOpenCech.lean` L1362, L1391 (gated on L728 closing — defer
  until iter-100 succeeds).

## Note on the streak

Iter-099 continued the iter-097 trend of substantive structural
advance per iteration (closing one sorry in `BasicOpenCech.lean`
each pass through the refactor → prover lane). Sixth consecutive
compile-verified prover iteration (iter-092 + iter-093 + iter-094 +
iter-095 + iter-097 + iter-099; iter-096 and iter-098 were refactor
lanes that left the file compiling too). The cycle
**refactor (split-slot signature change) → prover (apply at call
site)** is the production loop that is now closing sorries. Iter-100
is the *third* prover application of this cycle (the first two
being iter-097 closing the abstract lemma body and iter-099
applying the split-slot lemma at the call site).
