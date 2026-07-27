Done. Everything is green.

## What landed

`AlgebraicJacobian/Picard/RigidPushforwardRank.lean` (492 lines), namespace `AlgebraicGeometry`, imports exactly the three requested modules (no `RigidPushforwardFrontier`).

**Final declarations** (all `#print axioms`-clean, all with `/-- … -/` docstrings):

| # | Name | Shape |
|---|---|---|
| 1 | `tensorAddHomOfRingEquiv` | `noncomputable def … (σ : R ≃+* R') (τ : S ≃+* S') (hστ : ∀ r, τ (algebraMap R S r) = algebraMap R' S' (σ r)) (e : N ≃+ N') (he : ∀ r n, e (r • n) = σ r • e n) : TensorProduct R S N →+ TensorProduct R' S' N'` |
| 2 | `tensorAddHomOfRingEquiv_tmul` | `lemma … : tensorAddHomOfRingEquiv σ τ hστ e he (s ⊗ₜ[R] n) = τ s ⊗ₜ[R'] e n` |
| 3 | `finrank_tensor_eq_of_ringEquiv` | `theorem … : Module.finrank S (TensorProduct R S N) = Module.finrank S' (TensorProduct R' S' N')` |
| 4 | `specResidueFieldRingEquiv` | `noncomputable def … (R : CommRingCat.{u}) (t : Spec R) : t.asIdeal.ResidueField ≃+* Γ(Spec ((Spec R).residueField t), ⊤)` |
| 5 | `appLE_fromSpecResidueField_apply` | `theorem … (x : Γ(Spec R, ⊤)) : (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom x = specResidueFieldRingEquiv R t (algebraMap R t.asIdeal.ResidueField ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv x))` |
| 6 | `finrank_ker_baseChange_residueField` | `theorem … (𝒰 : X.AffineCoverMVSquare) (f : X ⟶ Y) [IsAffine Y] (M : X.Modules) [M.IsQuasicoherent] (t : Y) [IsAffineHom (f.fiberι t)] : finrank Γ(Spec (Y.residueField t),⊤) (ker (d.baseChange …)) = finrank … (ker d_t)` |
| 7 | `rank_pushforward_eq_fiberH0` | `theorem … (p : X ⟶ Spec R) (𝒰 : X.AffineCoverMVSquare) (M : X.Modules) [M.IsQuasicoherent] [QuasiCompact p] [QuasiSeparated p] (t : PrimeSpectrum R) [IsAffineHom (p.fiberι t)] (hfin …) (hproj …) (hbc …) : sectionsRankAtStalk ((Scheme.Modules.pushforward p).obj M) t = p.fiberH0 M t` |
| 8 | `Adelic.p1RankIdentity_proved` | `theorem … (A : Type u) [CommRing A] [Algebra k A] : P1RankIdentity k A` |

## `lake build` — verbatim

Final run (`timeout 1800 lake build AlgebraicJacobian.Picard.RigidPushforwardRank`), filtered to the module + summary:

```
Build completed successfully (8661 jobs).
---exit 0---
```

The preceding full run (`real 4m25.841s`) emitted **zero** diagnostics for `RigidPushforwardRank.lean`. The only warnings/infos in that run were replayed from pre-existing, untouched modules: `sorry` in `QuotFunctorDef.lean:458,690`, `WeilDivisor.lean:1161`, `CodimOneExtension.lean:1691`, `FGAPicRepresentability.lean:259`, plus `Try this: [apply] rfl` infos from `TensorObjSubstrate/DualInverse*`. The earlier, pre-fix build of this module took `620s` and is what surfaced the linter warnings listed below.

## `#print axioms`

```
'AlgebraicGeometry.rank_pushforward_eq_fiberH0' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1RankIdentity_proved' depends on axioms: [propext, Classical.choice, Quot.sound]
```

## Proof-body changes (all linter-forced)

`linter.style.show` fired 5 times: *"The `show` tactic should only be used to indicate intermediate goal states… this tactic invocation changed the goal. Please use `change` instead."* I converted exactly those five `show` → `change`, nothing else:

- in `tensorAddHomOfRingEquiv`: `show τ (r • s) ⊗ₜ[R'] e n = τ s ⊗ₜ[R'] e (r • n)`
- in `finrank_ker_baseChange_residueField`: `show Φ (c • z.1) = _` and `show (Θ₁ (PR (c • z.1)).1, Θ₂ (PR (c • z.1)).2) = _`
- in `rank_pushforward_eq_fiberH0` (step 6): `show r • m = _` and `show _ = ((p.fiberResidueMap t).hom …) • m`

Every other byte of every proof body is identical to the probe's (verified by diff). No `sorry`. No other AJC file touched; nothing committed.

## Heartbeats — determined experimentally

`linter.style.setOption` rejected the file-wide options outright, so scoping was mandatory, not optional. To find out *which* declarations need headroom I compiled the file at Lean's defaults (200000 / 20000):

```
nohb.lean:215:10: error: (deterministic) timeout at `isDefEq`, maximum number of heartbeats (200000) has been reached
nohb.lean:124:0:  error: (deterministic) timeout at `whnf`,   maximum number of heartbeats (200000) has been reached
nohb.lean:266:8:  error: (kernel) unknown constant 'AlgebraicGeometry.finrank_ker_baseChange_residueField'
```

Both real timeouts are inside `finrank_ker_baseChange_residueField` (line 124 is its header, 215 the `rw [map_sub, smul_sub]` in the Čech-square step); the third error is only the downstream consequence. **No `synthInstance` timeout occurred anywhere**, so `synthInstance.maxHeartbeats 800000` was dropped entirely. The file now carries a single scoped

```lean
set_option maxHeartbeats 1600000 in
-- Heartbeat headroom: the statement carries six `letI` module structures, so
-- matching the three chart comparisons against the Čech square forces large
-- `isDefEq` checks.  Measured: this is the only declaration in the file that
-- exceeds the default budget (`synthInstance.maxHeartbeats` is never hit).
```

immediately above `finrank_ker_baseChange_residueField`, in the house order (option → `--` comment → docstring → decl). A confirmation compile of the final file (scoped option only) is error- and warning-free in 35s.

## Docstring content

The module docstring covers: the six-step route with the named lemmas at each step; the three transport bricks and why each was needed (mathlib gap for A, §9 extraction for B, §7's internal-only square for C); Stacks 02KG / 00NX / 01XJ, Mumford AV II §5, EGA III 7.7 & 7.9.9, Kleiman FGA §5; and, in two dedicated sections, that `rank_pushforward_eq_fiberH0` uses neither surjectivity of `d` (subsumed by `kerBaseChange` bijectivity) nor `[Algebra.FiniteType k A]` nor finite presentation of `M`; the `A = k[x]`, `M = 𝒪/x` counterexample reproduced from `RigidPushforwardP1Sheaf.lean:567-576`; and that `Module.finrank`'s junk value `0` hits both sides, with the argument (via `Module.Finite` of `ker d` plus the honest `κ(t)`-isomorphism chain) for why it cannot degrade under the hypotheses.

## One environment note

`lake env lean` and `lake build` were both blocking for 30+ minutes on lake contention — six concurrent AJC `lake build`s plus a full-umbrella build, load average ~50-62. The heartbeat experiments only became feasible by invoking `lean` directly with a hand-constructed `LEAN_PATH` (`.lake/build/lib/lean` plus `../../.lake-packages/*/.lake/build/lib/lean`), which bypasses lake's lock and cut a 30-minute timeout to 41 seconds. Worth knowing for other lanes measuring single-module elaboration under fleet load.
