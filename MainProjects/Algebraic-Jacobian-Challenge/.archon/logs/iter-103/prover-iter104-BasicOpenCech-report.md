# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-104 prover report

## Step 1: close `cechCofaceMap_summand_family_R_linear` body at L536

### Outcome: **RESOLVED** ✓

Closed the L536 body with a 50-line tactic proof (now spans L536–L599).
Total sorry count: **6 active** (was 7); target = 6 met. FILE COMPILES.

### Committed proof

```lean
theorem cechCofaceMap_summand_family_R_linear ... := by
  intro R Z₁ Z_int e₁ e_int
  -- iter-104 Step 1: reconstruct the letI module instances inside the body so
  -- the `r • y` HSMul synthesises against perI₁/perI_int (matching the goal).
  letI perI₁ : ∀ i, Module R (Z₁ i) := fun i => by
    apply RingHom.toModule
    refine (C.left.presheaf.map (homOfLE ?_).op).hom
    let a0 : Fin ((ComplexShape.up ℕ).prev n + 1) := ⟨0, by omega⟩
    ...
    exact h1.trans h2
  letI h_mod_pi₁ : Module R (∀ i, Z₁ i) := Pi.module _ _ _
  letI perI_int : ∀ i, Module R (Z_int i) := fun i => by ...
  letI h_mod_pi_int : Module R (∀ i, Z_int i) := Pi.module _ _ _
  intro r y
  funext j'
  -- Step 2: pivot e_int X j' via Pi.smul_apply, then Pi.π Z_int j' via show
  simp only [Pi.smul_apply]
  show (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom
      (e₁.symm (r • y))) =
    r • (Pi.π Z_int j').hom ((cechCofaceMap_summand_family s₀ n i).hom (e₁.symm y))
  -- Step 3: unfold named family + Pi.lift_π_apply + ConcreteCategory.comp_apply
  unfold cechCofaceMap_summand_family
  simp only [Limits.Pi.lift_π_apply, ConcreteCategory.comp_apply]
  -- Step 4: (Pi.π Z₁ a).hom (e₁.symm Z) = Z a via piIsoPi_inv_kernel_ι_apply
  have hSym : ∀ (Z : (i : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀) → ↑(Z₁ i))
      (a : Fin ((ComplexShape.up ℕ).prev n + 1) → ↑s₀),
      (Pi.π Z₁ a).hom (e₁.symm Z) = Z a := by
    intro Z a; exact ModuleCat.piIsoPi_inv_kernel_ι_apply Z₁ a Z
  rw [hSym, hSym]
  -- Step 5: expand both `r •` actions via RingHom.toModule_smul (rfl)
  simp only [Pi.smul_apply, RingHom.toModule_smul]
  -- Step 6 (FINAL): term-level Eq.trans + congrArg with map_mul + restrict_collapse
  set Pl : ... := Pi.lift fun x => Pi.π _ ((SimplexCategory.δ i).toOrderHom x) with hPl_def
  exact ((C.left.presheaf.map Pl.op).hom.map_mul _ _).trans
    (congrArg (· * (C.left.presheaf.map Pl.op).hom
        (y (j' ∘ (SimplexCategory.δ i).toOrderHom)))
      (presheafMap_restrict_collapse _ _ _ r))
```

### Key insights (for next prover / refactor agent)

1. **`letI` reconstruction inside body** — the signature's `letI perI₁/perI_int/h_mod_pi_*` bindings don't survive `intro` into the goal frame in a way that the `r • y` HSMul synthesises. Reconstructing them inside the tactic body is mandatory; this mirrors the pattern at L781-L805 of `cechCofaceMap_pi_smul`.

2. **`piIsoPi_inv_kernel_ι_apply` for `e₁.symm`** — converting `(Pi.π Z₁ a).hom (e₁.symm Z) = Z a` requires the `inv` form (not `hom`) of the iso. The wrapper `hSym` works because `e₁.symm = (piIsoPi Z₁).inv.hom` definitionally.

3. **`RingHom.toModule_smul` is rfl** — used as a simp lemma to expand both `r • _` actions on `Z₁` and `Z_int` (which are RingHom.toModule constructions) to explicit `f(r) * _` multiplication, exposing the underlying ring structure.

4. **Term-level `Eq.trans + congrArg` for the final step** — tactic-level `rw [(C.left.presheaf.map Pl.op).hom.map_mul]` failed across multiple variants (`change`, `generalize_proofs`, `set`, `show ... from ...`) because of HMul-synth issues on the W₂ output ring (despite W₁ HMul resolving fine). The term-level chain bypasses these issues entirely:
   - `(...).hom.map_mul _ _ : f(a * b) = f a * f b` (Eq #1)
   - `congrArg (· * f y_val) (presheafMap_restrict_collapse _ _ _ r)` proves `f(g₁ r) * f y_val = g₂ r * f y_val` (Eq #2)
   - `.trans` composes them into the goal.

5. **`set Pl := Pi.lift ... with hPl_def`** is required to give `presheafMap_restrict_collapse` a target type that unifies with the implicit-arg metas; without it, the `_` placeholders blow up trying to discover the source/target opens.

## Step 2 (STRETCH): close L988 (was L929) `cechCofaceMap_pi_smul`

### Outcome: **NOT ATTEMPTED**

Per PROGRESS.md's escalation rule: "do NOT attempt Step 2 if Step 1 takes more than ~3 attempts. Step 1 closure alone hits the iter-104 target budget." Step 1 took ~25 LSP probes and a long termal-level workaround to close. Skipped Step 2.

## Sorry count

- **Before iter-104**: 7 (`L536, L929, L1021, L1345, L1373, L1563, L1592`).
- **After iter-104**: **6** active (`L988, L1080, L1404, L1432, L1622, L1651` — line numbers shifted by ~52 due to the 53-line proof body insertion at L536).
- **Hard cap**: 7 (no regression) ✓
- **Target**: 6 (close L536) ✓ **MET**
- **Stretch**: 5 (close L536 + L988) — not attempted.

## Final verification

`lean_diagnostic_messages` (severity=error) on the file returns `[]`. File compiles. No new axioms. No new top-level helper lemmas introduced (only body-local `have`s/`letI`s/`set`s).

## Blueprint markers

`cechCofaceMap_summand_family_R_linear` is a project-local helper without its own `\lean{...}` entry in the blueprint — no marker updates required this iter. The sync_leanok phase will pick up the closure if/when it gains a blueprint entry.

## Notes for plan/refactor agents (iter-105+)

The L988 (former L929) trailing sorry in `cechCofaceMap_pi_smul` remains. The infrastructure available:
- `cechCofaceMap_summand_family` (L454) — named def, no sorry.
- `cechCofaceMap_summand_family_R_linear` (L494) — **now fully proved**.
- `alternating_zsmul_pi_smul_aux_sum_comp` (L672) — sister lemma, no sorry.

The Fin-index mismatch (`Fin (n+1)` at call site vs `Fin ((prev n) + 2)` on the new def) still blocks direct application — the refactor agent's Route B recommendation (build a `cechCofaceMap_summand_family' : Fin (n+1) → ...` wrapper via Fin.cast + eqToHom) is now viable since the per-summand R-linearity is in place.
