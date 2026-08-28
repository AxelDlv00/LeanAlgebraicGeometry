Read-only API audit complete.

Exact specialization:

```lean
R := P.N.1
K := k
A := Pic0FiniteStageChartBaseChangeRing ... U
B := Pic0FiniteStageOverlapBaseChangeRing ... U V
phi := pic0FiniteStageRestrictionBaseChange ... U V
q := Sum.inl (Sum.inl (U, V))
```

For `q`, source/target reduce to `Sum.inl U` and `Sum.inr (U, V)`, while the exact map reduces to `pic0FiniteStageRestrictionLeft C U V`.

The final-base-change theorem gives `eTarget.comp f = g.comp eSource`; conjugating by the inverse equivalences yields the ring equation needed by contravariant `Spec`:

```lean
f.comp eSource.symm.toAlgHom =
  eTarget.symm.toAlgHom.comp g
```

The implementing agent integrated the verified proof in [Pic0FiniteStageRestrictionBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionBaseChange.lean:132). A narrow `lake env lean` check passes with no diagnostics. I made no file changes or commits.
