# Refactor Directive (CORRECTIVE)

## Slug
basicopencech-specialize-pi-smul

## Problem (soundness)

The previous iter-087 refactor (slug `basicopencech-extract-pi-smul`) extracted
`h_diff_pi_smul_f` as a top-level theorem `cechCofaceMap_pi_smul` with
**universally-quantified abstract signature**:

```lean
theorem cechCofaceMap_pi_smul
    {k R : Type u} [Field k] [CommRing R]
    {ι₁ ι₂ : Type u}
    {Z₁ : ι₁ → ModuleCat.{u} k} {Z₂ : ι₂ → ModuleCat.{u} k}
    (e₁ : (∏ᶜ Z₁ : ModuleCat.{u} k) ≃ₗ[k] (∀ i, Z₁ i))
    (e₂ : (∏ᶜ Z₂ : ModuleCat.{u} k) ≃ₗ[k] (∀ i, Z₂ i))
    (h_mod_pi₁ : Module R (∀ i, Z₁ i))
    (h_mod_pi₂ : Module R (∀ i, Z₂ i))
    (scK₀_f : (∏ᶜ Z₁ : ModuleCat.{u} k) ⟶ (∏ᶜ Z₂ : ModuleCat.{u} k))
    (r : R) (y : ∀ i, Z₁ i) :
    letI := h_mod_pi₁; letI := h_mod_pi₂
    e₂ (⇑(ConcreteCategory.hom scK₀_f) (e₁.symm (r • y))) =
      r • e₂ (⇑(ConcreteCategory.hom scK₀_f) (e₁.symm y)) := by
  sorry
```

**This statement is mathematically FALSE for general `scK₀_f`.** An arbitrary
morphism `(∏ᶜ Z₁) ⟶ (∏ᶜ Z₂)` between products of `ModuleCat k` is not R-linear
without further structural constraints — only morphisms induced by per-summand
R-algebra-hom restrictions (the Čech differential is of this special form) are
R-linear.

Combined with the `sorry` body, this is exactly the pattern that iter-085's
rejected `_root_.SheafOfModules.exact_iff_stalkwise (S) : S.Exact := sorry`
helper exhibited: a universally-false signature with `sorry` body is
functionally a false axiom that any future call site can exploit. Per the
STRATEGY.md (iter-086) soundness rule:

> No helper lemma with a universally-false signature may be introduced, even
> with a `sorry` body. Such a helper is logically an axiom; combined with
> `exact ... _` applications, it bypasses any subsequent goal.

This corrective refactor specializes the signature to the project-specific
Čech context, where the statement becomes mathematically true (provable in
principle, body remains `sorry`).

## Mathematical Justification

The genuine claim is:

> Let `C : Over (Spec k)` with `C.left` a scheme, `U : Opens C.left` affine,
> `s₀ ⊆ Γ(C.left, U)` a finset spanning the unit ideal, and `n : ℕ` positive.
> The Čech-cochain differential at degree `(prev n, n)` (i.e., the differential
> `scK₀.f : K₀.X (prev n) ⟶ K₀.X n` where
> `K₀ = cechCochain C (toModuleKSheaf C) (basicOpenCover ↑s₀)`,
> `scK₀ = K₀.sc n`) is R-linear (R = Γ(C.left, U)) under the
> `ModuleCat.piIsoPi`-transport between `↑scK₀.X_i` and the dependent product
> `(∀ i, ↑(Z_i i))`.

This is the *specialization* of `cechCofaceMap_pi_smul` to the Čech-cochain
context. The specialized statement is mathematically true (the Čech
differential IS R-linear because each per-summand presheaf-restriction map
is an R-algebra-hom — see `presheafMap_restrict_collapse` for the key per-summand
identity).

## Changes Requested

### Change 1 — replace abstract `cechCofaceMap_pi_smul` with a concrete one

Delete the current abstract `cechCofaceMap_pi_smul` at L466–L481 and replace
it with a **concrete** statement specialized to the Čech-cochain context.
The new signature should take as explicit arguments:

- `{k : Type u} [Field k]` — the base field.
- `{C : Over (Spec (CommRingCat.of k))}` — the curve.
- `{U : TopologicalSpace.Opens C.left.toTopCat}` (`hU : IsAffineOpen U`) — the
  affine open.
- `(s₀ : Finset Γ(C.left, U))` — the spanning finset.
- `{n : ℕ}` (`hn : 0 < n`) — the cochain degree.

And construct internally (via `letI` or `let`):

- `R := C.left.presheaf.obj (Opposite.op U)`.
- `K₀ := cechCochain C (toModuleKSheaf C) (basicOpenCover ↑s₀)`.
- `scK₀ := K₀.sc n` (i.e. `HomologicalComplex.sc K₀ n`).
- `Z₁`, `Z₂` — same as L854 / L900–L903 of the post-refactor file (the
  `ModuleCat.of k (C.left.presheaf.obj (Opposite.op (∏ᶜ ...)))` indexed
  families).
- `e₁`, `e₂` — the `ModuleCat.piIsoPi`-based `LinearEquiv`s.
- `perI₁`, `perI₂`, `h_mod_pi₁`, `h_mod_pi₂` — the per-i R-module structures
  and the `Pi.module` derivations (same definitions as L920–L949 of the
  post-refactor file).
- `h_mod_X₁`, `h_mod_X₂` — the transported `Module R scK₀.X_i` structures
  (same definitions as L971–L995 of the post-refactor file).

The conclusion is:

```lean
∀ (r : R) (y : ∀ i, Z₁ i),
    letI := h_mod_pi₁; letI := h_mod_pi₂
    e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm (r • y))) =
      r • e₂ (⇑(ConcreteCategory.hom scK₀.f) (e₁.symm y))
```

The body remains `sorry`. The iter-088+ prover closes this body in iter-088
(see "Iter-088+ prover roadmap" section).

### Change 2 — update the call site

The current call site at L1069–L1070 reads:

```lean
have h_diff_pi_smul_f :=
  cechCofaceMap_pi_smul (R := R) e₁ e₂ h_mod_pi₁ h_mod_pi₂ scK₀.f
```

With the new concrete signature, the call site simplifies to:

```lean
have h_diff_pi_smul_f := cechCofaceMap_pi_smul hU s₀ hn
```

(Or with whichever exact explicit/implicit argument structure you choose for
the concrete theorem signature.)

The `h_diff_pi_smul_f` identifier must continue to have the same equational
type as before, so that the downstream `f_R.map_smul'` proof at L1094–L1099
(which invokes `h_diff_pi_smul_f r (e₁ x)`) continues to type-check.

### Change 3 — preserve `presheafMap_restrict_collapse` byte-for-byte

The new top-level lemma `presheafMap_restrict_collapse` at L425–L434 is correct
and should be preserved byte-for-byte. (Its signature is honest: the universal
quantification is over scheme-`Opens`-side data, not over arbitrary morphisms,
and the conclusion is true for all such data.)

### Change 4 — preserve everything else byte-for-byte

The remainder of the file (everything except the L466–L481 abstract
`cechCofaceMap_pi_smul` and the L1069–L1070 call site) is preserved
byte-for-byte.

### Change 5 — handle the local letI dependency

The new concrete `cechCofaceMap_pi_smul` reproduces the L920–L995 letI/letI
block (perI₁/perI₂/h_mod_pi₁/h_mod_pi₂/h_mod_X₁/h_mod_X₂) inside its theorem
body (since these quantities depend on `s₀`, `n`, `hU` etc which are now its
explicit arguments). The original L920–L995 letI block inside
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` ALSO remains — both copies
must exist because:

1. The new top-level theorem `cechCofaceMap_pi_smul` needs them to *state*
   its conclusion.
2. The inline proof of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
   still uses them for `f_R`, `g_R`, `h_loc_X_i`, etc.

This means the cost of this refactor is duplicating ~75 LOC of letI bindings.
That's acceptable: it's cleaner than the alternative (false-universal abstract
signature).

If you can find a way to share the letI block via an intermediate `def` or
`abbrev`, do so — but only if it doesn't complicate the proof. If sharing is
too fiddly, just duplicate.

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — refactor target.

No other Lean file imports `cechCofaceMap_pi_smul` (it was just introduced
in the previous iter-087 refactor and is referenced only at the L1069 call
site). `archon-protected.yaml` is unchanged.

## Expected Outcome

After the refactor:

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` compiles cleanly (`lean_diagnostic_messages` → 0 errors).
- Sorry count: **stays at 6** (sorry in the new concrete `cechCofaceMap_pi_smul`
  body replaces the previous sorry in the abstract version).
- File line count: increases by ~75 LOC (the duplicated letI block); current is
  1154 LOC, expected ~1230 LOC.
- The new `cechCofaceMap_pi_smul` signature is **concrete to the Čech-cochain
  context** — its statement is mathematically true (provable in principle),
  even though the body is `sorry`. **No false-universal signature**.
- `presheafMap_restrict_collapse` unchanged byte-for-byte.
- No new axiom. `archon-protected.yaml` unchanged.

## What this refactor does NOT do

- Does not fill the `sorry` in `cechCofaceMap_pi_smul`. That is the iter-088+
  prover's job.
- Does not modify the protected `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  signature.
- Does not affect any other `.lean` file.

## Reading list (read in order)

1. `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — the file to refactor.
   Pay special attention to:
   - L412–L481 (the current abstract `cechCofaceMap_pi_smul` and the
     `presheafMap_restrict_collapse` lemma) — replace L466–L481, keep L412–L434.
   - L854–L995 (the `Z₁/Z₂/Z₃/e₁/e₂/e₃/perI₁/perI₂/perI₃/h_mod_pi₁/h_mod_pi₂/h_mod_pi₃/h_mod_X₁/h_mod_X₂/h_mod_X₃` local definitions inside
     `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`) — these must be
     **reproduced** inside the new concrete `cechCofaceMap_pi_smul` theorem
     body so the theorem can state its conclusion. They also remain in the
     original `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` proof body.
   - L1069–L1070 (the call site of the abstract `cechCofaceMap_pi_smul`) — replace.
2. `archon-protected.yaml` — to verify which signatures are frozen.
3. `.archon/STRATEGY.md` § "Soundness rule" — the soundness constraint this
   corrective refactor enforces.

## Notes on the iter-087 abstract refactor's mistake

The previous refactor's directive permissively said "If you cannot find a
clean abstraction, take `scK₀_f` as opaque and leave the relationship to the
call site — the proof body is `sorry` in this refactor." The refactor agent
followed this instruction literally, producing an abstract signature that
matches the directive's letter but violates the project's soundness rule (no
universally-false signatures).

This corrective directive does **not** authorize the abstract path. The new
theorem MUST specialize the Čech-cochain context concretely.
