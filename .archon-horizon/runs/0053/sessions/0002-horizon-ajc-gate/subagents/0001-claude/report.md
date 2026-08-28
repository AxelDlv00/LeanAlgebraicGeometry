All 8 bricks landed plus the target theorem. Final state verified: `lake env lean` output is completely empty, `lake build` succeeds with zero warnings attributable to the file, no `sorry`, and every declaration is axiom-clean.

## (a) What landed — 8 of 8 bricks, plus the target theorem

Single file, 789 lines: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean`

| § | Brick | Name (all in `namespace AlgebraicGeometry`) |
|---|---|---|
| 1 | 1 | `isPushout_appLE_of_isPullback'` — section-ring pushout on arbitrary compatible affine opens |
| 2 | 2 | `Scheme.Hom.isPullback_fiberι` — fibre square is cartesian (`IsPullback.of_hasPullback _ _`) |
| 3 | 3 | `isPushout_appLE_fiberChart` — `Γ(X_t, W_t) = Γ(X,W) ⊗_{Γ(Y,⊤)} Γ(Spec κ(t),⊤)`, categorical form |
| 4 | 5-core | `pullback_app_isoTensor_baseMap_res'` — public re-derivation of the `private` QuotScheme lemma |
| 5 | 4 | `exists_fiberChartTensorEquiv` — the chart comparison `Θ_W`, with `Θ_W (b ⊗ₜ x) = b · baseMap x` |
| 6 | 5 | `fiberChart_smul_baseMap_res` — restriction naturality of `Θ` |
| 7 | 6 | `Scheme.AffineCoverMVSquare.surjective_moduleSectionDiffBase_baseChange_residueField` |
| 8 | 8 | `surjective_baseChange_of_algEquiv` |
| 9 | 7 | `exists_point_appLE_fromSpecResidueField_of_isMaximal` |
| 10 | — | **`Adelic.p1_hfib_of_fiberH1Vanishing`** — the target, exact shape |

Bricks 1–8 are stated **generally** (any family `f : X ⟶ Y` over an affine base, any bundled 2-affine cover) rather than pinned to ℙ¹; the ℙ¹ specialisation happens only in §10. Two deviations from the plan, both deliberate: Brick 3 is delivered as the categorical `IsPushout` and the `Algebra.IsPushout` is derived inside Brick 4's proof (it needs the five-algebra `letI` dictionary in scope, so a separate named lemma would have to restate all of it); and the affineness of fibre charts enters Bricks 4/6 as a hypothesis `hWt`/`[IsAffineHom (f.fiberι t)]` rather than a re-derived instance — at the ℙ¹ site `isAffineHom_p1BaseChange_fiberι` (Transfer:1303) is found by instance search automatically, which I confirmed.

## (b) `lake env lean` output

Empty. Verbatim:

```
$ cd $P && lake env lean AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean
[exit=0 — no output]
```

`lake build AlgebraicJacobian.Picard.RigidPushforwardFiberChart` also succeeds (33 s, 8655 jobs) with no warning naming my file — I fixed the three `linter.style.maxHeartbeats` (missing justification comments) and three `linter.style.show` (`show` → `change`) warnings that only `lake build` surfaces.

## (c) Bricks that did not land

None. All 8 landed.

One honest caveat on verification. The **shape test** — the engine's `_hfib` binder copied verbatim from `RigidPushforwardP1Engine.lean:1206-1221`, `letI` preamble included, closed by `p1_hfib_of_fiberH1Vanishing A M h1` — compiles in 10 s (`/tmp/fiberchart_shape.lean`). The **full** end-to-end application `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing A M hflat hH0 (p1_hfib_of_fiberH1Vanishing A M h1)` did **not** finish in a scratch file: it hit `(deterministic) timeout at isDefEq` at 1.6M heartbeats after 3m20s. The reported position was inside the scratch example's own `hflat`/`h1` hypothesis block, i.e. the cost is elaborating `Scheme.CoherentSheafFlat` and `Algebra.FiniteType` in a fresh context, not the `_hfib` slot. I did not push that further.

## (d) `#print axioms`

All ten, no `sorryAx`:

- `isPushout_appLE_of_isPullback'`, `Scheme.Hom.isPullback_fiberι`, `isPushout_appLE_fiberChart`, `pullback_app_isoTensor_baseMap_res'`, `exists_fiberChartTensorEquiv`, `fiberChart_smul_baseMap_res`, `Scheme.AffineCoverMVSquare.surjective_moduleSectionDiffBase_baseChange_residueField`, `exists_point_appLE_fromSpecResidueField_of_isMaximal`, `Adelic.p1_hfib_of_fiberH1Vanishing` — all `[propext, Classical.choice, Quot.sound]`
- `surjective_baseChange_of_algEquiv` — `[propext, Quot.sound]` (does not even use choice)

Only `$P/AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean` was created or edited; scratch files live in `/tmp/fiberchart_*.lean`.

result: All 8 bricks landed green in one new file — `AlgebraicJacobian/Picard/RigidPushforwardFiberChart.lean` (789 lines, no sorry, axiom-clean, empty `lake env lean` output) — culminating in `AlgebraicGeometry.Adelic.p1_hfib_of_fiberH1Vanishing`, which discharges the ℙ¹ engine's `_hfib` hypothesis from fibrewise `h¹`-vanishing and is machine-verified to close the engine's binder verbatim.
