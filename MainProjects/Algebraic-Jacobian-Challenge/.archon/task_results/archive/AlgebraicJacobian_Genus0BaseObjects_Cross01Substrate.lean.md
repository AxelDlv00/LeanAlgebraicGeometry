# AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean

## gmRing_tensor_homogeneousAway_isDomain (line ~129, Substrate 2)

### Attempt 1
- **Approach:** Build an explicit `kbar`-AlgHom `φ : (Away f) ⊗[kbar] (GmRing kbar) →ₐ[kbar] L`
  where `L := Localization.Away (X () : MvPolynomial Unit (Away f))`, then construct
  a left-inverse `RingHom` `ψ_ring : L →+* (Away f) ⊗[kbar] (GmRing kbar)` and conclude
  injectivity of `φ` via `Function.Injective.isDomain`.
  - `L` is a domain (localization of polynomial ring over a domain at non-zero-divisor).
  - `φ` lifts the pair `(f1_kbar, f2)` via `Algebra.TensorProduct.lift`:
    - `f1_kbar : (Away f) →ₐ[kbar] L` via `Algebra.ofId`,
    - `f2 : GmRing kbar →ₐ[kbar] L` via `IsLocalization.Away.lift` after showing
      that `X () : MvPolynomial Unit kbar` maps to a unit in `L` (it does — the image
      is the localized element via `polkToLocAwayxS`).
  - `ψ_ring : L →+* target` via `IsLocalization.Away.lift`, where the base map is
    `s_to_target = Algebra.TensorProduct.map (AlgHom.id A) (algebraMap Polk Gm)`.
    The image of `xS = 1 ⊗ₜ X ()` is a unit (its inverse is `1 ⊗ₜ (X ())⁻¹` in Gm).
  - To verify `ψ_ring ∘ φ = id` on `(Away f) ⊗[kbar] (GmRing kbar)`:
    - On `a ⊗ b`: `φ (a ⊗ b) = f1_kbar a * f2 b`, then `ψ_ring (f1_kbar a) = a ⊗ 1`
      (Helper B) and `ψ_ring (f2 b) = 1 ⊗ b` (Helper D), so the product becomes
      `a ⊗ b` via `tmul_mul_tmul`.
    - Helper D follows from showing `ψ_ring ∘ f2 = includeRight` on the image of
      `algebraMap (MvPolynomial Unit kbar) (GmRing kbar)`, then applying
      `IsLocalization.ringHom_ext` for the localization `GmRing kbar`.
- **Result:** RESOLVED — full body axiom-clean (kernel-only axioms:
  `propext`, `Classical.choice`, `Quot.sound`).
- **Key technique:** Use of `IsLocalization.Away.lift` + `IsLocalization.ringHom_ext`
  to verify the inverse on a generating set; avoids needing tensor-product associativity
  isomorphisms.
- **Key lemmas used:**
  - `HomogeneousLocalization.val_injective` — bridge to `Localization.Away f`.
  - `MvPolynomial.algebraTensorAlgEquiv` — iso `(Away f) ⊗[kbar] (MvPolynomial Unit kbar) ≃ MvPolynomial Unit (Away f)`
    used to show `xS ≠ 0` via image in `MvPolynomial Unit (Away f)`.
  - `IsLocalization.Away.lift_eq` / `lift_comp` — universal property of localization.
  - `IsLocalization.isDomain_of_le_nonZeroDivisors` — localization at non-zero-divisors preserves domains.
  - `IsLocalization.ringHom_ext` — extensionality for ring homs out of localizations.
  - `powers_le_nonZeroDivisors_of_noZeroDivisors` — domain ⟹ powers ≤ non-zero-divisors.
  - `Algebra.TensorProduct.lift` / `lift_tmul` / `tmul_mul_tmul` — tensor universal property.
- **LOC:** ~270 LOC (well above the analogist's 50-80 LOC estimate; the iso-chain machinery
  requires extra plumbing because `Away f` is not natively a `MvPolynomial Unit kbar`-algebra,
  forcing manual algebra-map composition).

### Style warnings
- 12 stylistic warnings about `show` vs `change` (Lean's `linter.style.show` flagging
  `show` that actually changes the goal up to defeq). Build is GREEN; warnings can be
  silenced by `set_option linter.style.show false` at file scope or replaced with `change`.

### Blueprint marker
- `\leanok` ready for `thm:gmRing_tensor_homogeneousAway_isDomain` in
  `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex`.
  (The deterministic `sync_leanok` phase will apply it.)

### Iteration metadata
- iter-190 Lane B Substrate 2 HARD BAR: **MET**.
- Cross01Substrate.lean: was 0 sorries → still 0 sorries (Substrate 2 axiom-clean closure).
- Net axiom-clean delta: −1 deferred substrate (Substrate 2 now closed).
- Next steps (iter-191+ per `analogies/lane-b-substrate.md` §3):
  - Use Substrate 1 + Substrate 2 to close the three GmScaling consumer sorries:
    `gmScalingP1_chart_agreement_cross01`, `gm_geomIrred`, `projGm_isReduced`.
- File `set_option maxHeartbeats 1600000` left in place; needed for the proof body.
  Future work may golf the proof to fit under default heartbeats, but the current
  proof's size is largely from instance plumbing (algebra structure on tensors).
