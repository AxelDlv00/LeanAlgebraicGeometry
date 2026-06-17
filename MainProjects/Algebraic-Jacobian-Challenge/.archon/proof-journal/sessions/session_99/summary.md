# Session 99 — iter-099 review (project narrative iter-101)

## Metadata

- **Archon iteration**: 099 (= session_99)
- **Project-narrative label**: iter-101 (single substantive prover lane, hard-stop close)
- **Iteration shape**: 1 prover lane on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- **Sorry count before**: 14 (BasicOpenCech 6, Differentials 5, Monoidal 1, Jacobian 1, Picard.Functor 1) — as recorded at iter-100 close.
- **Sorry count after**: 14. **BasicOpenCech.lean: 6 → 6** (no closure). Hard cap held; target of 5 missed.
- **Targets attempted**: `cechCofaceMap_pi_smul` per-summand `hG` discharge — was L768 sorry, now L811 sorry (shifted +43 from S1–S3 partial chain commit).
- **Compile-verified at close**: yes (`lean_diagnostic_messages` returns `[]` for severity=error; 7 sorry occurrences in raw grep, 6 active syntactic sorry tactic sites verified by line probe).
- **Total file events** (per `attempts_raw.jsonl` summary): 63 events; 1 edit; 2 goal checks; 4 diagnostic checks; 17 lemma searches; 0 builds; 4 clean diagnostics; 0 errors.
- **Prover model**: Sonnet (via Archon harness on `iter-099/provers`).

## Target: `cechCofaceMap_pi_smul` per-summand `hG` discharge (file L768 → L811)

### Iter-101 plan recipe (6 steps)

```
(1) simp only [Pi.smul_apply]
(2) rw [ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j', ...]
(3) rw [← ModuleCat.hom_comp, ← ModuleCat.hom_comp]
(4) simp only [eqToHom_naturality, Pi.lift_π_apply]
(5) rw [presheafMap_restrict_collapse _ _ _ r' _]
(6) ring  -- or `congr 1; ring`, or `mul_smul; smul_comm`
```

### Pre-funext goal state (LSP at L768, before S1)

```
case h.h
…
⊢ e₂ (eqToHom_hom (smul_thing.hom (e₁.symm (r' • y')))) j' =
   (r' • e₂ (eqToHom_hom (smul_thing.hom (e₁.symm y')))) j'
```
where `smul_thing := (-1)^↑i • Pi.lift_thing`, the Pi.lift codomain is the anonymous closure `∏ᶜ (fun i_1 ↦ ModuleCat.of k Γ(C.left, op (∏ᶜ basicOpenCover ↑s₀ ∘ i_1)))`.

### Attempt 1 — S1 push Pi.smul through `r' • _`

- **Tactic**: `simp only [Pi.smul_apply]`
- **Multi-attempt probe**: success (goal moves from `... = (r' • _) j'` to `... = r' • _ j'`).
- **Result**: **PARTIAL SUCCESS** — committed to file at L766.
- **Insight**: Trivial first step of the 6-step recipe lands as predicted by the iter-100 plan.

### Attempt 2 — S2 `e₂ _ j' = (Pi.π Z₂ j').hom _` rewrite via `piIsoPi_hom_ker_subtype_apply`

- **Tactic tried**: `rw [ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j', ModuleCat.piIsoPi_hom_ker_subtype_apply Z₂ j']` (multi-attempt probe).
- **Error**: parse error in multi-attempt (interpreted as command boundary); when wrapped in parens, the rewrite reported "did not find an occurrence" — the lemma's discrimination pattern `(ConcreteCategory.hom (ModuleCat.piIsoPi Z₂).hom) ?x j'` doesn't match `e₂ x j'` syntactically even though they're def-equal (`e₂ = (ModuleCat.piIsoPi Z₂).toLinearEquiv`, but the discrimination tree keys on the `LinearEquiv`'s elaborated head, not the `(piIsoPi).hom`).
- **Workaround chosen**: `show` to pivot the goal shape by definitional equality directly:
  ```
  show (CategoryTheory.ConcreteCategory.hom (Limits.Pi.π Z₂ j')) _ =
      r' • (CategoryTheory.ConcreteCategory.hom (Limits.Pi.π Z₂ j')) _
  ```
- **Result**: **PARTIAL SUCCESS** — committed to file at L770–L771 as a `show` pivot rather than `rw`.
- **Insight (NEW)**: `piIsoPi_hom_ker_subtype_apply` documented as a one-shot bridge in iter-097 (forward direction in iter-082; reverse in iter-097) is **NOT** equally applicable to the per-coordinate post-funext frame — the same lemma name does NOT fire via `rw` when the LHS is `e₂ _ j'` (LinearEquiv elaboration) rather than `(piIsoPi Z₂).hom.hom _ j` (raw category morphism). Use `show` for the def-eq pivot in this frame.

### Attempt 3 — S3 fuse `(Pi.π Z₂ j') ∘ eqToHom ∘ smul_thing ∘ e₁.symm` into single categorical morphism

- **Tactic**: ```
  rw [show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl,
      show ModuleCat.Hom.hom = ConcreteCategory.hom (C := ModuleCat.{u} k) from rfl,
      ← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply,
      ← ConcreteCategory.comp_apply, ← ConcreteCategory.comp_apply]
  ```
- **Result**: **PARTIAL SUCCESS** — committed to file at L776–L779. Post-S3 goal: both LHS and RHS now have shape `(ConcreteCategory.hom (((-1)^↑i • Pi.lift_thing) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j')) (e₁.symm _)`.
- **Insight**: The 4-level `← ConcreteCategory.comp_apply` chain (LHS has 4 function-application layers: `e₁.symm`, `smul_thing.hom`, `eqToHom_hom`, `Pi.π j'`) cleanly absorbs into one categorical composition. The S1–S3 prefix is the clean post-funext frame the plan targeted.

### Attempts 4–9 — S4 extract `(-1)^↑i •` from the morphism composition (six routes, all FAILED)

The post-S3 goal contains `(((-1)^↑i • Pi.lift_thing) ≫ eqToHom ⋯ ≫ Pi.π Z₂ j')` — the prover needs to push the `(-1)^↑i •` scalar out of this morphism composition. Six routes were tried:

| # | Route | Tactic | Result |
|---|-------|--------|--------|
| 4 | `Preadditive.zsmul_comp` direct rw | `rw [Preadditive.zsmul_comp]` | FAIL: "did not find an occurrence of the pattern `(?n • ?f) ≫ ?g`" |
| 4b | `simp_rw [Preadditive.zsmul_comp]` | same as 4 | FAIL: no progress |
| 4c | `simp only [← ConcreteCategory.comp_apply, Preadditive.zsmul_comp]` (terminal-attempt probe) | same | FAIL: no progress |
| 5 | Body-local `have h_smul_hom : ∀ {M N} (n : ℤ) (f : M ⟶ N) (x), (n • f).hom x = n • f.hom x := by intros; rfl` then `simp only [h_smul_hom]` | typechecks (rfl proof valid), `simp only` fails | FAIL: "no progress" |
| 5b | Same helper but `rw [h_smul_hom]` | rw fails | FAIL: pattern not found |
| 6 | `set Pi_lift_thing : (∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ _ := Pi.lift fun i_1 ↦ ...` | `set` accepts syntactically but does NOT fold (the `_` codomain annotation doesn't match the actual `∏ᶜ (fun i_1 ↦ ...)` codomain in the goal) | PARTIAL FAIL: `set` is a no-op; subsequent `Preadditive.zsmul_comp` still fails |

**Root cause confirmed by the prover** (recorded in task_result § "Root cause confirmed"):

The `Pi.lift fun i_1 ↦ ...` smul-RHS with anonymous-closure codomain `∏ᶜ (fun i_1 ↦ ModuleCat.of k Γ(C.left, op (∏ᶜ basicOpenCover ↑s₀ ∘ i_1)))` blocks Lean's discrimination tree at every level: `(?n • ?f) ≫ ?g` (Preadditive.zsmul_comp), `(n • f).hom` (ModuleCat.hom_zsmul), `f ≫ Pi.π _` (raw composition), `set f := Pi.lift _` (manual naming). The failure is **structural** (discrimination-tree pattern unification through anonymous closure) and persists regardless of whether the lemma is a Mathlib `@[simp]` rfl, a body-local rfl helper, or a manual `set` binding.

**Per the prover's own analysis**: the iter-100 plan's hypothesis that `funext j'` would dissolve this class is **WRONG** — the discrimination-tree blocker persists post-funext at the morphism level, just shifted from pre-funext to post-funext-with-show-pivot. The S1–S3 partial chain landed cleanly but S4–S6 hit the same wall.

### Final state at iter-099 close

- **Committed**: S1–S3 chain at L765–L779; structural comments at L780–L810 documenting the iter-101 6-step recipe, the iter-099 prover's S4–S6 failure modes (six routes), and the iter-102 escalation options (E1/E2/E3).
- **Original L768 sorry preserved at L811**, with the post-S3 goal as the new entry point.
- **Line shift**: L768 → L811 (+43). Other sorries shift by the same offset:
  - `L860 → L903` (substep (a) augmented Čech)
  - `L1184 → L1227` (substep (a) for `s₀`)
  - `L1212 → L1255` (extra-degeneracy)
  - `L1402 → L1445` (`g_R.map_smul'`)
  - `L1431 → L1474` (`h_loc_exact`)

### Streak escalation criterion TRIGGERED

The iter-100 plan and the iter-101 plan both explicitly stated: "If iter-101 also stalls after 3–4 sub-attempts at LSP, the prover MUST abort and write a SHORT report. The iter-102 plan agent will then MANDATE escalation."

The iter-099 prover ran SIX sub-attempts (S4 raw `rw`, S4 `simp_rw`, S4 `simp only [← comp_apply, ...]`, body-local `have` rfl, body-local `set`, terminal `set`-via-`Pi_lift_thing`) — all failed at the same discrimination-tree class. The criterion is met.

**This is the 3rd consecutive substantive prover lane on this sorry** (iter-099 ≡ session_97 closed adjacent split-slot body L532 but left L728 hG residual; iter-100 ≡ session_98 added `funext j'` pivot; iter-101 ≡ session_99 added S1–S3 partial chain). All three landed a structural advance but no full closure.

## Key findings

1. **`piIsoPi_hom_ker_subtype_apply` does not fire via `rw` in the post-funext per-coordinate frame** *(NEW, iter-101)*: when the LHS uses `e₂ x j'` (LinearEquiv coercion) rather than `(piIsoPi Z₂).hom.hom x j'` (raw category morphism), the discrimination-tree key differs and `rw` reports "no occurrence". Use `show` for the def-eq pivot, then `← ConcreteCategory.comp_apply` chains.
2. **`show` + 4-layer `← ConcreteCategory.comp_apply` fuses `(Pi.π) ∘ eqToHom ∘ smul ∘ e₁.symm` into one categorical morphism** *(NEW, iter-101)*: confirmed pattern for absorbing nested function applications through ConcreteCategory.hom into a single composition. Useful whenever a post-funext goal has `(Pi.π Z j).hom` outermost over multiple hom-application layers.
3. **`set h : (∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ _ := Pi.lift fun i_1 ↦ ...` is a NO-OP** *(NEW, iter-101)*: even when the binding syntactically typechecks, `set` substitutes by syntactic match against the goal's current shape, and `_`-codomain ascription does NOT fold the actual `∏ᶜ (fun i_1 ↦ ...)` codomain in the goal. The Pi.lift's anonymous-closure codomain CANNOT be hidden behind a name without rewriting the full inferred type. **Workaround for iter-100**: top-level lemma with `(T : ∀ j, Z₁ (h j) ⟶ Z₂ j)` named per-coordinate.
4. **Body-local `have h : (n • f).hom x = n • f.hom x := by intros; rfl` fails to fire** *(NEW, iter-101)*: even though it typechecks (the equation is `rfl`), `simp only [h]` and `rw [h]` both report "no progress" because the discrimination tree pattern-match on the LHS occurs **before** the rfl-evaluator gets a chance. Same structural class as `ModuleCat.hom_zsmul`. **The body-local helper escape route is now confirmed insufficient.**
5. **Discrimination-tree blocker is structural, not tactical** *(NEW, iter-101 confirmation)*: regardless of layer (`(n • f) ≫ g`, `(n • f).hom x`, `Pi.lift _ ≫ Pi.π _`, naming `Pi.lift _` via `set`), Lean's discrimination tree fails the same way when the smul's RHS or the composition's LHS has a `Pi.lift fun i ↦ <body-with-i>` with i-referencing body. **Plan-agent corollary**: the next iteration's plan should NOT prescribe a 4th raw-tactic pass against this sorry; escalate to refactor (E2) or `LinearMap.ext` route (E3).

## Blueprint markers updated (manual)

None this iteration. The current sorry sites in `BasicOpenCech.lean` correspond to blueprint declarations that already have neither `\leanok` nor `\mathlibok` (correctly — they still have `sorry`). The `\leanok` deterministic phase ran prior to this review and made no relevant adjustments (file compiles with sorries; no decl flipped from sorry-free to sorry'd or vice versa).
