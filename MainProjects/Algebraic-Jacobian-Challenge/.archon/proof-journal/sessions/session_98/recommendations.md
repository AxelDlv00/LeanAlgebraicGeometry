# Recommendations for the next plan-agent iteration (iter-101)

**Headline.** Iter-100 ran a single substantive prover lane on
`BasicOpenCech.lean` L728 `cechCofaceMap_pi_smul` per-summand `hG`
discharge. **No sorry closed**, but a real structural advance was
committed: `funext j'` per-coordinate pivot reduces the goal from
"push polymorphic `(-1)^↑i` scalar through Pi.lift's anonymous-closure
codomain in a categorical morphism chain" to "discharge per-coordinate
R-linearity on a single concrete `Z₂ j'`", where
`presheafMap_restrict_collapse` (iter-087 lemma at L425) applies
directly. Sorry shifts: L728→L768 (+40 lines of iter-100 diagnostic
comments + iter-101 6-step closure plan). Other sorries shift by
the same offset.

The iter-100 plan's `set h_sgn : k` recommendation was **demonstrably
wrong** (the scalar elaborates in ℤ via Preadditive ZSMul, not k);
six iter-100 routes confirmed `ModuleCat.hom_zsmul`,
`Preadditive.zsmul_comp`, `Linear.smul_comp`, `Preadditive.nsmul_comp`
all fail to fire because of a discrimination-tree pattern-unification
issue through the Pi.lift's anonymous-closure codomain — even though
`ModuleCat.hom_zsmul` is rfl-applicable in vacuum (verified). The
prover's `funext j'` pivot is the right structural move; iter-101
should follow the documented 6-step recipe to close.

**Structural advance**: YES (qualified) — the L768 sorry's frame is
qualitatively easier than the L728 sorry it replaces. The
conceptual gap has shrunk from "manage polymorphic-scalar typeclass
synthesis across a categorical Pi.lift chain" to "execute the 6-step
per-coordinate closure recipe documented at L748–L767 in the file".

## Priority 1 (iter-101) — schedule PROVER lane to close L768 per-coordinate residual

**Action**: prover on `BasicOpenCech.lean`, single objective:
replace the L768 `sorry` with the per-coordinate R-linearity
discharge. Target: **close L768** to bring `BasicOpenCech.lean`
sorries 6 → 5.

**Pre-flight blockers identified iter-099+iter-100 (DO NOT RETRY at L768):**

| Dead-end | Mathlib name | Root cause |
|---|---|---|
| `set h_sgn : k := (-1)^(↑i : ℕ)` | n/a | Scalar is ℤ not k; `set : k` doesn't fold. Use `set h : ℤ` if needed at all. |
| `simp only [Preadditive.smul_comp]` (iter-099) | DNE | Wrong name. |
| `rw [ModuleCat.hom_zsmul]` / `simp only [ModuleCat.hom_zsmul]` / `dsimp only [ModuleCat.hom_zsmul]` on the pre-`funext` goal | exists, rfl in vacuum | Discrimination tree cannot locate occurrence through Pi.lift's anonymous-closure codomain |
| `rw [Preadditive.zsmul_comp]` / `rw [Linear.smul_comp]` / `rw [Preadditive.nsmul_comp]` on the pre-`funext` goal | exists | Pattern `(?n • ?f) ≫ ?g` not found for same discrimination-tree reason |
| `change e₂ ... (((-1 : ℤ) ^ ↑i) • ModuleCat.Hom.hom (Pi.lift fun i_1 ↦ _)) ... = _` | n/a | Inner `_` placeholders can't be filled because codomain types don't unify across eqToHom cast |
| `set f' := Pi.lift fun (i_1 : Fin (n+1) → ↑s₀) ↦ ...` | n/a | Pi.lift's body has elaboration-ambiguous holes; type-level coercions through `δ i` collide |
| `apply LinearEquiv.injective e₂.symm; funext j'` | n/a | LHS becomes `↑(∏ᶜ Z₂_unfolded)` but RHS `e₂.symm (r' • e₂ ...)` doesn't reduce |

**The L768 partial state already has `funext j'` committed**. Iter-101
prover starts from the per-coordinate goal:
```
case h.h
[heavy context]
⊢ e₂ (eqToHom_hom (smul_thing.hom (e₁.symm (r' • y')))) j' =
   (r' • e₂ (eqToHom_hom (smul_thing.hom (e₁.symm y')))) j'
```
where `smul_thing = (-1)^↑i • Pi.lift_thing`.

**Recommended iter-101 strategy (6-step recipe, documented at L748–L767):**

```lean
-- (1) Push j' through `r' • _` on RHS
simp only [Pi.smul_apply]
-- (2) Push j' through `e₂` on both sides via
-- ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j' to convert
-- `e₂ _ j'` to `(Pi.π Z₂ j').hom _`
rw [ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j']
rw [ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j']
-- (3) Fuse Pi.π Z₂ j' ∘ eqToHom_hom into single LinearMap
-- via `← ModuleCat.hom_comp` (categorical fuse)
rw [← ModuleCat.hom_comp, ← ModuleCat.hom_comp]
-- (4) eqToHom-naturality on `eqToHom ≫ Pi.π Z₂ j'` (this is
-- Pi.π Z₂_unfolded j' where Z₂_unfolded is the anonymous-closure
-- form), then Pi.lift_π_apply to evaluate the j'-th summand
-- (the residual is no longer a Pi.lift but a single morphism)
simp only [eqToHom_naturality, Pi.lift_π_apply]
  -- adjust lemma names per LSP verification
-- (5) The j'-th summand R-linearity is per-coordinate
-- `(presheaf.map _).hom ∘ (Pi.π Z₁ (j' ∘ δ i)).hom`, which
-- `presheafMap_restrict_collapse` (L425) handles directly
rw [presheafMap_restrict_collapse _ _ _ r' _]
-- (6) Factor out the (-1)^↑i • scalar (symmetric on both sides
-- post-funext; commutes with k-linear projections and with R-action)
ring  -- or `congr 1; ring`, or `mul_smul; smul_comm`
```

**Risk note**: Steps 3–4 may need fine-tuning at LSP — the
eqToHom-naturality lemma name is not pre-verified; try
`eqToHom_naturality`, `eqToHom_app`, `eqToHom_comp_iso_eq`, or fully
manual `subst` of the equality witness. Step 6's scalar factoring
may need explicit `smul_comm` / `mul_smul` if the implicit ring
proof leaves a normalized form.

**Estimated effort**: 20–40 lines of tactic. **Hard cap**: 6 sorries
in `BasicOpenCech.lean` (no regression). **Acceptable outcome**:
L768 closed cleanly, bringing total to 13 sorries / 5 in
`BasicOpenCech.lean`.

**Mathematical justification (re-confirmed iter-100)**: The
composite `e₂ ∘ eqToHom_hom ∘ smul_thing.hom ∘ e₁.symm` at output
coordinate `j'` is per-coordinate the presheaf restriction map
`R = Γ(C.left, U) → Γ(C.left, basicOpenCover ↑s₀ ∘ j')` applied to
`y' (j' ∘ δ i)`. Since the coordinate-restriction-then-evaluate
map is exactly `R-action via RingHom.toModule`, R-linearity is
intrinsic. The `(-1)^↑i •` is a scalar (in ℤ-action on the
categorical morphism) that commutes with R-action by
`SMulCommClass` at the coordinate level.

## Priority 2 — Alternative escalation if iter-101 stalls on the 6-step recipe

The iter-100 prover's task result identifies three escalation paths
(see `task_results/AlgebraicJacobian_Cohomology_BasicOpenCech.lean.md`
§ "Suggested iter-101 plan-agent action"):

1. **Per-coordinate scalar push-out helper** — introduce a body-local
   `have h_scalar_extract : ∀ M N (n : ℤ) (f : M ⟶ N) (x : M)
   (j' : ...), (n • f).hom x j' = n • f.hom x j' := by intros; rfl`
   then `rw [h_scalar_extract]`. This bypasses the discrimination
   tree's pattern issue by using a body-local lemma whose pattern
   is explicit.

2. **Refactor `cechCofaceMap_pi_smul` to use `Pi.lift_thing` as a
   let-binder at the body level** — so the family `G : ι' → (∏ᶜ Z₁ ⟶
   ∏ᶜ Z_int)` in the iter-098 split-slot lemma is matched against
   the let-binder rather than the literal anonymous-closure. This
   sidesteps the discrimination-tree issue at the call site. Costs
   one refactor lane, but durably eliminates the blocker class.

3. **Direct computation via `LinearMap.ext` + per-element verification**
   — fully expand the per-coordinate R-linearity as a finite
   computation involving `presheaf.map`'s ring-action property,
   without going through `presheafMap_restrict_collapse`'s
   helper signature. More verbose but more transparent.

**Recommendation**: try the 6-step recipe first (Priority 1). If
that exhausts after 3–4 sub-attempts at LSP, escalate to (1) —
body-local helper. (2) is heavier; reserve for iter-102+ if (1)
also fails.

## Priority 3 — preserve byte-for-byte across iter-101

1. `alternating_sum_pi_smul_aux` body at L478–L494 (CLOSED iter-097).
2. `alternating_sum_pi_smul_aux_sum_comp` (iter-098 lemma at L513–L531
   signature + L532–L537 body CLOSED iter-099).
3. `cechCofaceMap_pi_smul` prefix L539–L699 — preserve (iter-092
   foundation through iter-097 B1 bridge at L699).
4. Iter-099 bridge tactics at L700–L712:
   `rw [← Pi.smul_apply (i := j)]; refine congrFun
   (alternating_sum_pi_smul_aux_sum_comp Z₁ _ Z₂ Finset.univ _ _ e₁
   e₂ ?_ r y) j` — preserve.
5. Iter-100 partial chain at L726–L767:
   `intro i _ r' y'; simp only [ModuleCat.hom_comp,
   LinearMap.comp_apply]; <40 lines of diagnostic comments>;
   funext j'; <iter-101 6-step plan comments>` — preserve. The
   iter-101 prover replaces only the L768 `sorry`.

## Priority 4 — do NOT retry these dead-end classes

| Dead-end | Confirmed iter | Rationale |
|---|---|---|
| `set h_sgn : k := (-1)^(↑i : ℕ)` | **iter-100** | Scalar is ℤ, not k; set : k does not fold |
| `rw [ModuleCat.hom_zsmul]` / `simp only [ModuleCat.hom_zsmul]` on pre-funext goal | **iter-100** | rfl in vacuum but discrimination tree fails on Pi.lift's anonymous-closure codomain |
| `rw [Preadditive.zsmul_comp]` / `[Linear.smul_comp]` / `[Preadditive.nsmul_comp]` on pre-funext goal | iter-099, **iter-100** | Pattern `(?n • ?f) ≫ ?g` not found for the same discrimination tree reason |
| `change e₂ ... ((((-1 : ℤ)^↑i) • ...) ...) = _` | **iter-100** | Inner placeholders can't fill across eqToHom cast |
| `set f' := Pi.lift fun ... ↦ ...` | **iter-100** | Pi.lift body has elaboration-ambiguous holes |
| `apply LinearEquiv.injective e₂.symm; funext j'` | **iter-100** | LHS/RHS types don't match through e₂.symm |
| `simp only [Preadditive.smul_comp]` | iter-099 | Lemma name DNE; use Linear.smul_comp or Preadditive.zsmul_comp |
| `simp only [neg_smul, one_smul, smul_neg, pow_succ, pow_zero]` on head smul | iter-099 | No progress — low-level arithmetic does not touch typeclass blocker |
| `rw [Preadditive.sum_comp]` / `rw [key₂]` / `simp only [key₂]` on the post-(b') literal goal | iter-094/095/097/099 | HOU on nested-i Čech summand body — fully bypassed iter-098/099 by split-slot refactor |
| `suffices h_fam : <literal Čech body>` | iter-096/097 | `whnf` deterministic timeout; bypassed by split-slot refactor |
| `have h_struct := alternating_sum_pi_smul_aux ... (fun i => <literal F + eqToHom>) ...` | iter-097 | Same root cause; bypassed by split-slot |
| `refine congrFun (alternating_sum_pi_smul_aux ...)` with `?F` Miller-pattern on single-slot lemma | iter-097 | Lemma shape mismatch; superseded by split-slot |
| `rw [← ConcreteCategory.comp_apply]` post-iter-095 cosmetic | iter-095/097 | Both outer/inner in `ConcreteCategory.hom` form |

## Priority 5 — reusable patterns to remember

1. **`funext j'` per-coordinate pivot for Pi.lift-anonymous-closure
   discrimination-tree failures** *(iter-100, NEW)*: when a smul- or
   composition-rewrite fails because the discrimination tree cannot
   locate an occurrence through Pi.lift's anonymous-closure codomain,
   pivot to per-coordinate via `funext`. Reduces the goal to a
   single concrete `Z j'`, where `Pi.π Z j'` projections fuse via
   `← ModuleCat.hom_comp` + eqToHom-naturality + `Pi.lift_π_apply`.
   The original polymorphic-scalar blocker dissolves because each
   output coordinate carries its own concrete R-action via
   `RingHom.toModule (presheaf.map _).hom`.

2. **`set : T` as a scalar-type diagnostic** *(iter-100, NEW)*: when
   uncertain whether a polymorphic `n` elaborates to `T₁` or `T₂`,
   try both `set h : T₁ := n` and `set h : T₂ := n`. The one that
   folds is the elaborated type. (In iter-100: `set : ℤ`
   substituted, `set : k` did not — but `ModuleCat.hom_zsmul` ALSO
   failed pattern-match through Pi.lift's closure, so the `set`
   diagnostic merely identified the type, not a working route.)

3. **Refactor split-slot pattern for HOU-blocked single-slot lemmas**
   *(iter-098/099, VINDICATED)*. Preserved.

4. **`rw [← Pi.smul_apply (i := j)]; refine congrFun … j` as j-eval
   lifter** *(iter-099)*. Preserved.

5. **Plan-recipe transcription with one-call name-correction**
   *(iter-097/099/100, meta-pattern)*: directives mis-name Mathlib
   lemmas OR mis-ascribe scalar types. **Iter-100 specific lesson**:
   verify a plan's `set : T` ascription with one `lean_multi_attempt`
   probe BEFORE transcribing — the `set` not folding is a clear
   diagnostic signal.

## Priority 6 — speculative iter-101 follow-up (contingent on L768 close)

If iter-101 closes L768 cleanly, the next priorities are:

- **`g_R.map_smul'` (L1402)** becomes ungated. This is the immediate
  downstream consumer of `cechCofaceMap_pi_smul`. The plan should
  re-assess gating dependencies and schedule a scoping pass before
  assigning L1402 to a prover.

- **L860, L1184, L1212** (augmented Čech) remain off-limits — multi-iter
  infrastructure gap unchanged.

## Sorry budget guidance for iter-101

- **Iter-101 (prover pass)**: TARGET sorries 5 in `BasicOpenCech.lean`
  (close L768). HARD CAP 6 (no regression). Acceptable outcome:
  L768 closed via the 6-step per-coordinate recipe; structural
  advance is one downstream consumer of the iter-098 split-slot
  refactor finally fully closed.

## Off-limits for iter-101 (same as iter-099/iter-100)

- `Differentials.lean` — Mathlib-gap deferral; Route A/B decision
  on L636 still pending.
- `Modules/Monoidal.lean` — Mathlib gap.
- `Jacobian.lean`, `Picard/Functor.lean` — Phase C/E.
- `BasicOpenCech.lean` L860, L1184, L1212 (augmented-Čech).
- `BasicOpenCech.lean` L1402, L1431 (gated on L768 closing — defer
  until iter-101 succeeds).

## Plan-agent warning — same blocker, 3rd iteration

The L728/L768 sorry has now been the target of 3 consecutive
substantive prover lanes (iter-099, iter-100, iter-101 upcoming).
**Plan-agent must not re-issue an `hom_smul`/`smul_comp` chain
without first confirming via `lean_multi_attempt` that the chain
fires post-`funext j'`.** The per-coordinate frame is qualitatively
different from the pre-funext frame; iter-101 should issue tactics
against the per-coordinate goal, not against the pre-funext goal.
If iter-101 also fails to close L768, **escalate to the body-local
helper (Priority 2 option 1) or to a refactor lane (option 2)** —
do not try a 4th raw-tactic pass.

## Note on the streak

Iter-100 broke the iter-097/iter-099 streak of 1-sorry-closed-per-iter.
**Compile-verified but 0 sorries closed** is a notable regression
vs. the iter-097/099 production rhythm. However, the iter-100
`funext j'` pivot IS a real structural step (the qualitative goal
frame changed), so this is a "deepening" iteration rather than a
"stalled" one. Seventh consecutive compile-verified prover
iteration (iter-092 + iter-093 + iter-094 + iter-095 + iter-097 +
iter-099 + iter-100; iter-096 + iter-098 were refactor lanes that
left the file compiling too). The cycle **refactor → prover** is
the production loop; iter-100 was a pure prover with no refactor,
and stalled on the discrimination-tree issue that a refactor (option
2 above) might resolve. Iter-101 has one more shot at the tactic
route (the per-coordinate 6-step recipe); if it stalls, escalate
to a refactor lane.
