# Session 103 — iter-103 review (project-narrative iter-105)

## Metadata

- **Archon iteration**: 103 (= session_103)
- **Project-narrative label**: iter-105 (single substantive prover lane;
  hard-stop close on `cechCofaceMap_pi_smul` trailing sorry at
  `BasicOpenCech.lean:L1147` via Route B wrapper).
- **Iteration shape**: 1 prover lane on
  `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`.
- **Sorry count before**: 14 (BasicOpenCech 6, Differentials 5, Monoidal 1,
  Jacobian 1, Picard.Functor 1) — as recorded at iter-104 / session_102
  close.
- **Sorry count after**: 14. **BasicOpenCech.lean: 6 → 6** (no closure).
  Hard cap of 7 held; **target of 5 missed** by 1 (L1147 partial). NB the
  iter-105 stretch goal of 4 (via wrapper R-linearity closing inline) was
  also missed.
- **Targets attempted**: `cechCofaceMap_pi_smul` per-summand `hG` discharge
  at L1147 (was L988 in iter-104). Wrapper helpers (Helper 1 + Helper 2)
  newly added at L604–L726.
- **Compile-verified at close**: yes (`lean_diagnostic_messages` returns
  `[]` for severity=error; 6 active syntactic sorry tactic sites verified
  by direct grep across all `.lean` files).
- **Total file events** (per `attempts_raw.jsonl` summary): 81 events;
  3 edits; 6 goal checks; 7 diagnostic checks; 0 builds; 3 lemma searches;
  6 clean diagnostics; 0 errors.
- **Prover model**: Sonnet (via Archon harness on `iter-103/provers`).
- **Streak status**: This is the **5th consecutive substantive prover
  lane** on `cechCofaceMap_pi_smul`'s `hG` slot
  (iter-099/100/101/103/105 in project-narrative). Iter-102 + iter-104 were
  refactor lanes. **Streak-escalation criterion** has been triggered for
  the 3rd time over the lifetime of this slot — see "Recommendations" for
  the iter-106 escalation rule.
- **Eleventh consecutive compile-verified iteration** (iter-092 through
  iter-105).

## Target: `cechCofaceMap_pi_smul` per-summand `hG` discharge (L1147, was L988)

### Iter-105 plan recipe (Route B — named wrapper)

The plan (PROGRESS.md L100–L160) prescribed a Route B with two new
top-level helpers explicitly lifting the iter-104 "no new top-level
helpers" rule:

1. **Helper 1** — wrapper def `cechCofaceMap_summand_family'`:
   `Fin (n + 1)`-indexed view of `cechCofaceMap_summand_family` bridging the
   Fin-index mismatch via `Fin.cast` + `eqToHom`.
2. **Helper 2** — wrapper R-linearity transport
   `cechCofaceMap_summand_family'_R_linear`, structurally mirroring
   iter-104's 50-LOC `cechCofaceMap_summand_family_R_linear`.
3. **Then close L1147** by applying `cechCofaceMap_summand_family'_R_linear`
   to the per-summand `hG` slot directly, with σ-sign handled by
   `smul_comm` + `map_zsmul`.

### Pre-iter goal state (LSP at L988, before iter-105 edits)

```
case h.h
…
⊢ (Pi.π Z₂ j').hom (eqToHom_hom (((-1)^↑i • F_at_i).hom (e₁.symm (r' • y')))) =
   r' • (Pi.π Z₂ j').hom (eqToHom_hom (((-1)^↑i • F_at_i).hom (e₁.symm y')))
```
where `F_at_i := cechCofaceMap_summand_family s₀ n (Fin.cast hRel.symm i)`
and the leading `eqToHom` carries the Fin-index transport
`(prev n + 2) = (n + 1)`.

### Attempt 1 — Helper 1 wrapper def (SUCCESS)

- **Tactic / strategy**: Define `cechCofaceMap_summand_family'` as a direct
  `Pi.lift` over `Fin (n + 1) → ↑s₀` with `Fin.cast` applied at each
  coordinate (rather than as `named_family ≫ eqToHom`).
- **Code (final, L604–L630)**:
  ```lean
  noncomputable def cechCofaceMap_summand_family'
      {k : Type u} [Field k] {C : Over (Spec (.of k))}
      {U : TopologicalSpace.Opens C.left.toTopCat}
      (s₀ : Finset Γ(C.left, U)) (n : ℕ) (hn : 0 < n) (i : Fin (n + 1)) :
      (∏ᶜ fun j : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀ => ...) ⟶
      (∏ᶜ fun j : Fin (n + 1) → ↑s₀ => ...) :=
    have hRel : (ComplexShape.up ℕ).prev n + 2 = n + 1 := by
      rcases n with _ | k
      · omega
      · simp [ComplexShape.prev, ComplexShape.up_Rel]
    Pi.lift fun j_new : Fin (n + 1) → ↑s₀ =>
      Pi.π (...) ((j_new ∘ Fin.cast hRel) ∘
                  (SimplexCategory.δ (Fin.cast hRel.symm i)).toOrderHom) ≫
      (toModuleKPresheaf C).map
        (Pi.lift fun x : Fin ((ComplexShape.up ℕ).prev n + 1) =>
          Pi.π (...) (Fin.cast hRel
            ((SimplexCategory.δ (Fin.cast hRel.symm i)).toOrderHom x))).op
  ```
- **Result**: COMPILES CLEAN. `lean_diagnostic_messages` returns `[]`.
- **Insight (NEW, iter-105)**: defining the wrapper as a *direct Pi.lift*
  (not `named_family ≫ eqToHom`) is the key structural decision. The
  alternative `named_family ≫ eqToHom` form would have re-introduced the
  iter-099/100/101 discrim-tree blocker at the binder-level R-linearity
  proof. Direct Pi.lift makes the wrapper R-linearity proof reuse iter-104's
  binder-level pattern verbatim — at the cost of deferring the
  eqToHom-vs-Pi.π transport burden into the L1147 client proof.

### Attempt 2 — Helper 2 wrapper R-linearity (SUCCESS, FULLY CLOSED)

- **Code (final, L634–L726, ~90 LOC)**: see file. Structure:
  1. `intro R Z₁ Z₂ e₁ e₂`.
  2. `have hRel`; `letI perI₁ … letI h_mod_pi₂` (4 module instances).
  3. `intro r y; funext j_new; simp only [Pi.smul_apply]`.
  4. `show (Pi.π Z₂ j_new).hom (...) = r • (Pi.π Z₂ j_new).hom (...)`.
  5. `unfold cechCofaceMap_summand_family'`.
  6. `simp only [Limits.Pi.lift_π_apply, ConcreteCategory.comp_apply]`.
  7. `have hSym ... := ModuleCat.piIsoPi_inv_kernel_ι_apply Z₁ _ _;
     rw [hSym, hSym]`.
  8. `simp only [Pi.smul_apply, RingHom.toModule_smul]`.
  9. `set Pl := Pi.lift fun x => Pi.π _ (Fin.cast hRel (δ x)) with hPl_def`.
  10. `exact ((C.left.presheaf.map Pl.op).hom.map_mul _ _).trans
        (congrArg (· * ...) (presheafMap_restrict_collapse _ _ _ r))`.
- **Result**: COMPILES CLEAN, body fully closed (zero sorries).
- **Insight (NEW, iter-105)**: the wrapper R-linearity proof structurally
  mirrors iter-104's `cechCofaceMap_summand_family_R_linear` body byte-for-
  byte up to the Fin.cast index translation. Both use the same iter-104
  pattern: `RingHom.toModule_smul` + `piIsoPi_inv_kernel_ι_apply` +
  term-level `Eq.trans` + `congrArg` + `presheafMap_restrict_collapse`.
  The Fin.cast translation cleanly factors out and
  `presheafMap_restrict_collapse` still fires because the morphism Pl is
  structurally the same as iter-104's, just with Fin.cast-translated
  indices. **The iter-104 binder-level pattern is now confirmed as a
  reusable production template.**

### Attempts 3–6 — close L1147 via wrapper R-linearity (FAILED across 4 routes)

After the helpers landed clean, four probes targeted L1147:

| # | Route | Tactic | Result |
|---|-------|--------|--------|
| 3 | Direct simp with ModuleCat.hom_zsmul / smul-commutativity lemmas | `simp only [ModuleCat.hom_zsmul, LinearMap.smul_apply, map_zsmul, smul_comm _ r']` | FAIL: no progress; `ModuleCat.hom_zsmul` doesn't fire by simp in the eqToHom-wrapped form (same iter-099/100/101 class). |
| 4 | rcases on n + simp on ComplexShape.prev | `rcases n with _ | m; case zero => exact absurd hn (lt_irrefl 0); case succ => simp only [show prev (m+1) = m from by simp [...]] at *; sorry` | FAIL: `simp at *` doesn't fully collapse eqToHom — `Fin (m+2) = Fin (m+1)` still drives the eqToHom proof object. |
| 5 | Wrapper application + congrFun + `simp only [Pi.smul_apply]` at h_wrap_pt, then write structured partial proof with sorry. | `have hRel' := omega; have h_wrap := cechCofaceMap_summand_family'_R_linear hU s₀ n hn (Fin.cast hRel' i); have h_wrap_pt := congrFun (h_wrap r' y') j'; simp only [Pi.smul_apply] at h_wrap_pt; sorry` | PARTIAL — committed as final state at L1126–L1147. The wrapper R-linearity hypothesis `h_wrap_pt` is in context; goal LHS still needs the eqToHom-vs-Pi.π transport reduction. |
| 6 | `rw [ModuleCat.piIsoPi_hom_ker_subtype_apply, ...]` at h_wrap_pt to convert to `(Pi.π _ j').hom` form. | same lemma | FAIL: re-confirmed iter-099's finding — this rw doesn't fire on the LinearEquiv-coerced `e₂ _ j'` form. |

**Root cause confirmed by the prover** (recorded in task_result §
"Remaining gap (precise)"):

The wrapper R-linearity equation `h_wrap_pt` provides:
```
(Pi.π Z₂ j').hom ((wrapper at (Fin.cast hRel' i)).hom (e₁.symm (r' • y'))) =
  r' • (Pi.π Z₂ j').hom ((wrapper at (Fin.cast hRel' i)).hom (e₁.symm y'))
```

The L1147 goal LHS has `(Pi.π Z₂ j').hom (eqToHom.hom (((-1)^↑i • F_at_i).hom z))`.
Reducing the goal LHS to h_wrap_pt's LHS requires:

1. **Pull `(-1)^↑i •` out**:
   `((-1)^↑i • F).hom z = (-1)^↑i • F.hom z` via `ModuleCat.hom_zsmul` +
   `LinearMap.smul_apply`, then push through eqToHom and `Pi.π Z₂ j'`
   (both k-linear, hence ℤ-linear, via `map_zsmul`).

2. **Commute `(-1)^↑i •` past `r' •`** via `smul_comm` on `Z₂ j'`
   (R-module with ℤ acting as iterated addition).

3. **CORE GAP**: identify
   `(Pi.π Z₂ j').hom (eqToHom.hom (F_at_i.hom z))`
   with
   `(Pi.π Z₂ j').hom ((wrapper at (Fin.cast hRel' i)).hom z)`.

   This is morphism-level equality
   `F_at_i ≫ eqToHom_outer = wrapper at (Fin.cast hRel' i)` per-coord, or
   equivalently the per-coord Pi.lift bodies coincide after the
   `Fin.cast_cast` round-trip `Fin.cast hRel.symm (Fin.cast hRel i) = i`.

   **Mathlib does NOT directly expose eqToHom-vs-Pi.π transport for
   object-equality eqToHom** (only `Pi.π_comp_eqToHom` for index equality).
   Therefore the transport requires either an explicit `convert` + `congr`
   on the eqToHom proof object (3-deep), or a custom morphism-equality
   lemma proved by `Limits.Pi.hom_ext` / `limit_ext` + per-coord
   `Pi.lift_π_apply` + `Fin.cast_cast`.

### Final state at iter-105 close

- **Committed**: Helpers at L604–L726 (~120 LOC of new top-level defs +
  theorem, both fully proved); structured partial proof at L1126–L1147
  inside `cechCofaceMap_pi_smul` (~22 LOC of forward-progress tactics +
  explanatory comments).
- **Sorry preserved at L1147** (was L988 at iter-104 close, +159 line
  offset due to the inserted helpers).
- **All non-target sorries shifted by +159 lines** from iter-104:
  - L1080 → L1239 (substep (a) augmented Čech)
  - L1404 → L1563
  - L1432 → L1591 (substep (a) for s₀ extra-degeneracy)
  - L1622 → L1781 (`g_R.map_smul'`)
  - L1651 → L1810 (`h_loc_exact`)
- **No new axioms.** `grep -nE "^axiom" BasicOpenCech.lean` returns empty.
- **No protected signatures touched.**

### Streak escalation criterion — TRIGGERED for the 3rd time

This is the **5th consecutive substantive prover lane** on
`cechCofaceMap_pi_smul`'s `hG`-discharge slot, counting
iter-099/100/101/103/105 in the project-narrative numbering. Iter-102 +
iter-104 were the refactor lanes. The streak has produced:

- iter-099: closed `_sum_comp` body + applied at L695.
- iter-100: `funext j'` pivot.
- iter-101: S1–S3 chain at L770–L779 (`simp only [Pi.smul_apply]; show ...
  (Pi.π Z₂ j').hom _; rw [..., ← ConcreteCategory.comp_apply (×4)]`).
- iter-103: S4–S5 chain at L823, L826 (ConcreteCategory→ModuleCat.Hom rfl
  pivot + LinearMap.comp_apply decomposition); Path B closed inert
  σ-sign lemma body.
- iter-104: refactor lane added named family + R-linearity skeleton at
  L454/L494; prover closed R-linearity body at L536.
- iter-105 (this iter): wrapper helpers at L604/L634 fully proved;
  L1147 partial proof at L1126–L1147 documents the eqToHom-vs-Pi.π
  transport residual.

Each substantive lane has produced durable forward progress, but L1147
itself has resisted closure for five iterations. The remaining residual
is **NOT** the discrim-tree blocker that defeated iter-099/100/101/103;
it is now a clean **morphism-level transport** identification. The
iter-106 plan must commit to a specific morphism-level route (see
Recommendations) and NOT regress to tactic-only attempts on the L1147
goal in its current form.

## Key findings (NEW this iter)

1. **Wrapper-via-direct-Pi.lift is the structural escape route**
   *(iter-105, NEW)*: when bridging a Fin-index mismatch via a wrapper
   def, define the wrapper as a *direct Pi.lift* rather than `named_family
   ≫ eqToHom`. The direct form keeps the binder-level R-linearity proof
   discrim-tree-clean (reusing the iter-104 pattern) while deferring the
   eqToHom transport burden into a single client proof — a much smaller
   piece of work than re-running the iter-099/100/101/103 wall.

2. **The iter-104 R-linearity pattern is a reusable production
   template** *(iter-105, REINFORCED)*: `RingHom.toModule_smul` +
   `piIsoPi_inv_kernel_ι_apply` + term-level `Eq.trans` + `congrArg` +
   `presheafMap_restrict_collapse` mirrored byte-for-byte from iter-104
   to iter-105 with only the Fin.cast index translation differing. The
   pattern is now confirmed across 2 invocations and should be
   referenced by any future R-linearity transport in this file.

3. **eqToHom-vs-Pi.π transport for object-equality is a Mathlib gap**
   *(iter-105, NEW)*: Mathlib's `Pi.π_comp_eqToHom` handles eqToHom
   for **index** equality, but the project's `cechCofaceMap_pi_smul`
   needs the **object** equality case
   (`∏ᶜ Z₁ = ∏ᶜ Z₂` from `Fin a = Fin b`). The workaround is a
   project-local helper proved via `Limits.Pi.hom_ext` + per-coord
   `Pi.lift_π_apply` + `Fin.cast_cast`. **Project-local pattern; not
   suitable for Mathlib upstream (would need universe-polymorphic
   generalization).**

4. **iter-099's "rw piIsoPi_hom_ker_subtype_apply fails on `e₂ _ j'`
   form"** re-confirmed at iter-105 attempt 6 (probe failed on the
   wrapper R-linearity `h_wrap_pt` in `e₂` LinearEquiv form). The
   workaround is to restate the wrapper lemma with `(Pi.π _ _).hom`
   directly in the conclusion (avoiding `e₂`), or use `show` for the
   def-eq pivot. **Same lesson as iter-099, now reconfirmed across the
   wrapper.**

## Blueprint markers updated (manual)

None this iteration. All sorries in scope correspond to blueprint
declarations that already lack both `\leanok` and `\mathlibok` (correctly
— underlying Lean still has `sorry`). The `sync_leanok` deterministic
phase ran prior to this review and made no `\leanok` adjustments
(file compiles with sorries; no decl flipped sorry-free or sorry'd).
No protected declaration renames or moves to apply.

## Notes (LOW-priority findings)

- The 12800000-heartbeat budget bumped at iter-102 has been REVERTED
  (file now uses default 800000 at the relevant set_option lines). The
  wrapper R-linearity body closes within default budget, validating
  iter-104's removal of the heartbeat bump. **The plan agent does not
  need to re-add the heartbeat bump for iter-106.**
- The wrapper helpers add ~120 LOC to BasicOpenCech.lean. File is now
  1820 lines (was 1661 at iter-104 close).
