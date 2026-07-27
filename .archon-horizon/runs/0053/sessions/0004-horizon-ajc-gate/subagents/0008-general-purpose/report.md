All done. Final verification is green.

## Report

### What landed

New file (the only file I touched): `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardChartBaseChange.lean` — 441 lines, namespace `AlgebraicGeometry.Adelic`, imports only `AlgebraicJacobian.Picard.RigidPushforwardFiberChart`, **no `sorry`**, **no `set_option` at all** beyond the file-header `autoImplicit false` (no heartbeat bumps were needed — see "where the brief was wrong").

**All three requested bricks landed, plus the optional bonus.**

```lean
theorem isPushout_appLE_chartBaseChange {X Y X' Y' : Scheme.{u}}
    {f : X ⟶ Y} {g : Y' ⟶ Y} {f' : X' ⟶ Y'} {g' : X' ⟶ X}
    (h : IsPullback g' f' f g) [IsAffine Y] [IsAffine Y']
    {W : X.Opens} (hW : IsAffineOpen W) :
    CategoryTheory.IsPushout (f.appLE ⊤ W le_top) (g.appLE ⊤ ⊤ le_top)
      (g'.appLE W (g' ⁻¹ᵁ W) le_rfl) (f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top)
```
(§1; one-liner from `isPushout_appLE_of_isPullback'`, added as a named helper since it is the general-square replacement for `isPushout_appLE_fiberChart`.)

**(M1)** `exists_chartTensorEquiv` — exactly the shape the brief sketched, with `f'.appLE ⊤ (g' ⁻¹ᵁ W) le_top` as the target-side scalar and `Nonempty { Θ : TensorProduct Γ(Y,⊤) Γ(Y',⊤) Γ(M,W) ≃+ Γ((Scheme.Modules.pullback g').obj M, g' ⁻¹ᵁ W) // ∀ b x, Θ (b ⊗ₜ x) = … • pullback_app_isoTensor_baseMap g' M (le_refl _) x }`, under `letI : Algebra Γ(Y,⊤) Γ(Y',⊤) := (g.appLE ⊤ ⊤ le_top).hom.toAlgebra` and `letI := f.baseSectionsModule M W`.

**(M2)** `chart_smul_baseMap_res (f' : X' ⟶ Y') (g' : X' ⟶ X) (M : X.Modules) {W W₀ : X.Opens} {W'' : X'.Opens} (hWW₀ : W₀ ≤ W) (hW'' : W'' ≤ g' ⁻¹ᵁ W₀) (hle : W'' ≤ g' ⁻¹ᵁ W) (b : Γ(Y',⊤)) (x : Γ(M,W))` — exactly the brief's spelling. Confirmed: it needs neither the cartesian square nor any affineness.

**(BONUS)** `exists_kerChartTensorEquiv` — the Čech square on kernels, taking `[IsAffineHom g']`, a `𝒰 : X.AffineCoverMVSquare`, and `hker : ∀ (B : Type u) [CommRing B] [Algebra Γ(Y,⊤) B], Function.Bijective (AlgebraicJacobian.TwoTerm.kerBaseChange (𝒰.moduleSectionDiffBase f M) B)` (no flatness), concluding `Nonempty { Ξ : Γ(Y',⊤) ⊗_{Γ(Y,⊤)} ker d ≃+ ker d' // (formula on pure tensors) }` where `d' = (𝒰.preimage g').moduleSectionDiffBase f' ((Scheme.Modules.pullback g').obj M)`. Characterizing formula: `↑(Ξ (b ⊗ₜ u)) = (… b • baseMap ↑u.1, … b • baseMap ↑u.2)`, componentwise §2's formula.

### Verification

`timeout 3000 lake build AlgebraicJacobian.Picard.RigidPushforwardChartBaseChange` →
`✔ [8656/8656] Built AlgebraicJacobian.Picard.RigidPushforwardChartBaseChange (34s)` / `Build completed successfully (8656 jobs).` Zero diagnostics of its own (all warnings/infos in the log are replayed pre-existing modules: `QuotFunctorDef`, `WeilDivisor`, `CodimOneExtension`, `FGAPicRepresentability`, `TensorObjSubstrate/*`).

`#print axioms`, all four:
```
'…isPushout_appLE_chartBaseChange' depends on axioms: [propext, Classical.choice, Quot.sound]
'…exists_chartTensorEquiv'          depends on axioms: [propext, Classical.choice, Quot.sound]
'…chart_smul_baseMap_res'           depends on axioms: [propext, Classical.choice, Quot.sound]
'…exists_kerChartTensorEquiv'       depends on axioms: [propext, Classical.choice, Quot.sound]
```

### Where the brief was wrong

1. **"The adversarial pass found that the obvious statement does NOT elaborate — the `letI` binder list is the trap."** Not for M1. The statement as sketched in the brief (and in `RigidPushforwardAffineDescent.lean`'s route, step 3) elaborated **on the first attempt** with exactly the two `letI` binders shown. Correction 2 in the AffineDescent docstring is about the *Γ-level Čech statement* (four `baseSectionsModule` binders), not about M1; the brief conflated the two. The four-binder warning *was* right for the bonus — my `exists_kerChartTensorEquiv` needs seven `letI`s (one `Algebra`, three on `X`, three on `X'`), and the two failures I hit there were (a) instance search not seeing `g' ⁻¹ᵁ 𝒰.U₁` as `(𝒰.preimage g').U₁`, so the target-side binders must be written with `(𝒰.preimage g').Uᵢ`, and (b) needing the `↑u`-coercion type ascription written out.
2. **No heartbeat headroom is needed.** The fibre originals carry `set_option maxHeartbeats 1600000`, `synthInstance.maxHeartbeats 800000` and `backward.isDefEq.respectTransparency false`. None of the three is required in the general form — I removed all of them and the file compiles clean. Reason: the fibre spelling forces defeq unfolding of `Scheme.Hom.fiberModule`/`fiber`, which the general spelling states directly as `(Scheme.Modules.pullback g').obj M`.
3. Both proofs ported **verbatim** modulo the dictionary, as predicted. The only substantive edit was `isPushout_appLE_fiberChart f t hW ↝ isPushout_appLE_chartBaseChange h hW`.

### Notes

- The bonus proof needed one non-obvious step: after `simp only [map_zero]` / `simp only [map_add, ih₁, ih₂]` in the `TensorProduct.induction_on` the goal is syntactically `X = X` but `simp` does not close it (the two sides carry different-but-defeq module instances from the `letI` dictionary); an explicit `rfl` is required.
- I did not edit `AlgebraicJacobian.lean`, so the new module is not yet in the umbrella import; a follow-up lane will need to add it (or import it directly from whatever consumes it).
- Other AJC files changed on disk during my run (`RigidPushforwardAffineDescent.lean`, `RigidPushforwardGate.lean`, `RigidPushforwardRank.lean`, several `RiemannRoch/Adelic/*`) — those are the two concurrent lanes (runs 0054/0055), not me. None is on my import path; my final build post-dates them and is green.
