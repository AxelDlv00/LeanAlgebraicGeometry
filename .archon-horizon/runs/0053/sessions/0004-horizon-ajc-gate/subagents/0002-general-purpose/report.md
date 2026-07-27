Done. The module compiles clean and all headline results have clean axioms.

## What was built

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1ChartSections.lean` (457 lines, one new file, nothing else touched, no commit, no `sorry`).

**Headline declarations** (all in `namespace AlgebraicGeometry.Adelic`, `variable (k : Type u) [Field k]`):

```lean
noncomputable def p1ChartSectionsAlgEquivX :
    Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨0⟩) ≃ₐ[k] Polynomial k
noncomputable def p1ChartSectionsAlgEquivY :
    Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨1⟩) ≃ₐ[k] Polynomial k
@[simp] theorem p1ChartSectionsAlgEquivX_p1XSection : p1ChartSectionsAlgEquivX k (p1XSection k) = Polynomial.X
@[simp] theorem p1ChartSectionsAlgEquivY_p1YSection : p1ChartSectionsAlgEquivY k (p1YSection k) = Polynomial.X
@[simp] theorem p1ChartSectionsAlgEquivX_symm_X / …Y_symm_X            -- inverse direction
instance instIsDomainP1ChartSectionsX / instIsDomainP1ChartSectionsY   -- IsDomain Γ(ℙ¹, Vᵢ)
theorem p1XSection_ne_zero / p1YSection_ne_zero
theorem not_isNilpotent_p1XSection / not_isNilpotent_p1YSection
theorem p1Chart_inf_ne_bot : p1Chart k ⟨0⟩ ⊓ p1Chart k ⟨1⟩ ≠ ⊥
```

**Exported intermediate API** (all generic in `i j : ULift (Fin 2)`, `hij : i ≠ j`, so the y-chart costs zero duplication):
`gammaTerminalIsInitial : IsInitial Γ(⊤_ Scheme.{u}, ⊤)`, `isPushout_p1ChartSections k i`, `p1CoordSection k i j` (+ `_zero_one`/`_one_zero` = `p1XSection`/`p1YSection`, both `rfl`), `surjective_aeval_p1CoordSection`, `uliftIntCast`, `p1ProjLeg`, `p1SpecLeg`, `p1ChartRetraction`, `p1ChartRetraction_p1CoordSection`, `algebraMap_p1ChartSections`, `p1ChartRetraction_algebraMap`, `p1ChartRetraction_aeval`, `p1Index_zero_ne_one`/`p1Index_one_ne_zero`, `bijective_aeval_p1XSection`/`…YSection`.

## Verification

```
✔ [8587/8587] Built AlgebraicJacobian.Picard.RigidPushforwardP1ChartSections (988s)
Build completed successfully (8587 jobs).
```
Zero errors, zero warnings (style linters included). `#print axioms` on all 14 exported headline names: `[propext, Classical.choice, Quot.sound]` for every one.

## Where your route was right / wrong

The route was **essentially exactly right** — every brick was where you said. Corrections and notes:

- **`hpoCat` orientation.** `isIso_pushoutSection_iff` produces the square with `inl = toProjInt.appLE D₊(Xᵢ) Vᵢ` and `inr = (ℙ¹ ↘ Spec k).appLE ⊤ Vᵢ`, so `IsPushout.desc` takes the `Proj` leg first. I factored the whole square out as `isPushout_p1ChartSections k i`, generic in `i`, exactly as you suggested; it needed `maxHeartbeats 800000` and nothing else.
- **Initiality was painless.** `CommRingCat.isInitial.ofIso ((Scheme.ΓSpecIso (CommRingCat.of (ULift ℤ))).symm ≪≫ Scheme.Γ.mapIso (terminalIsTerminal.uniqueUpToIso specULiftZIsTerminal).op)` typechecked first try — no fallback needed. `IsInitial.hom_ext` then discharges the compatibility square with `_ _`.
- **`Proj.basicOpenIsoAway .inv`, not `awayToSection`-inverse.** Used `(basicOpenIsoAway 𝒜 (X i) hdeg one_pos).inv` and collapsed `inv.hom (awayToSection.hom c) = c` via `← Proj.basicOpenIsoAway_hom` + `Iso.hom_inv_id_apply`.
- **`ULift ℤ → k` has no `algebraMap`.** There is no `Algebra (ULift ℤ) k` instance; I added `uliftIntCast := (Int.castRingHom k).comp ULift.ringEquiv.toRingHom` and used `Polynomial.mapRingHom` of that.
- **One real trap:** `rw [← CommRingCat.comp_apply]` matches the *inner* composite (`awayToSection ≫ appLE`) rather than the outer one, and then breaks type-correctness. Use `rw [← hinl]; rfl` (or `congrArg (fun φ => φ.hom z) hinr`) instead.
- **The local algebra instance generalizes cleanly.** I declared one `local instance instAlgebraΓp1Chart k i` (indexed by `i`) instead of two copies of `instAlgebraΓV0`/`instAlgebraΓV1`; `span_pow_p1XSection_scaffold` and `span_pow_p1YSection_scaffold` both apply verbatim against it.
- **`p1Chart_inf_ne_bot`:** the standalone `p1Chart_inf_eq_basicOpen_coordSection` is `private`, but `(p1LaurentChartData k).inf_eq_basicOpen_x` has exactly the right type by defeq — no restatement needed. The name you half-remembered is `Scheme.isNilpotent_iff_basicOpen_eq_bot_of_isCompact` (needs `IsCompact`, supplied by `(isAffineOpen_p1Chart k ⟨0⟩).isCompact`); `Scheme.basicOpen_eq_bot_iff` exists but requires `[IsReduced X]`, which is the wrong hypothesis here.

## Not done / caveats

- Nothing was cut — both charts landed.
- `instAlgebraΓp1Chart` is **`local`** (matching the P1ChartData convention), so the *types* of `p1ChartSectionsAlgEquivX/Y` mention an instance that is not exported. Downstream consumers can use `(p1ChartSectionsAlgEquivX k).toRingEquiv` without re-declaring anything; only restating something in `≃ₐ[k]` form requires re-declaring the instance. The `IsDomain` instances and all the `≠ 0` / `¬IsNilpotent` / `≠ ⊥` corollaries are instance-free and export normally.
- Host note: the first `lake build` was killed by its 30-min timeout purely because the machine was thrashing (63 GB RAM + 18 GB swap exhausted, load ~50, from concurrent lanes); the rerun took 988 s. Also, a `pgrep`-based wait loop I wrote matched its own command line — the gotcha already recorded in memory; worth re-reading before writing wait loops.
