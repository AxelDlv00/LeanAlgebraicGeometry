Filed I-1064, I-1065, I-1066. Probe files deleted, no Lean file touched.

## Verdict: CONVERGING, with two docstring defects — one of which understates the result

This is real work, not faked progress. Unusually for this project's prior, the mathematical content survives adversarial probing: the twelve declarations do what their names say, the carrier is right, no hypothesis is vacuous, and nothing is presented as closing a gate. Both defects I found are in prose, and the more important one makes the file's own achievement look *smaller* than it is — the opposite of the failure mode I was sent to find.

Coverage: rebuilt oleans first (`lake build AlgebraicJacobian.Picard.Pic0EtStructure` EXIT=0, 8628 jobs, only the two known `Pic0Et.lean:170/:223` sorry warnings), then ran nine scratch probes through `lake env lean` under `Probe/` with a deliberate `sorry` control that correctly printed `sorryAx` on every axiom pass. Probes deleted.

### Defect 1 (ranked first — the substantive one)
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0EtStructure.lean:364-366` claims the valuative and `k̄` properness hypotheses are "not interderivable by anything in this file." They are interderivable, both directions axiom-clean. Forward is two of the file's own theorems composed. Backward is one projection of the mathlib lemma the file already cites:

```lean
theorem ucGivesValuative {X Y : Scheme} (f : X ⟶ Y) [UniversallyClosed f] :
    ValuativeCriterion.Existence f := by
  have h : @UniversallyClosed = ValuativeCriterion.Existence ⊓ @QuasiCompact :=
    UniversallyClosed.eq_valuativeCriterion
  exact (h ▸ ‹UniversallyClosed f›).1
-- axioms: [propext, Classical.choice, Quot.sound]
```

`quasiCompact` (:171) is exactly what makes the `QuasiCompact` factor free here, so all three properness forms collapse into one equivalence class, and `isAbelianVariety_of_valuativeCriterion` (:367) is a corollary of `isAbelianVariety_of_baseChange` (:353). I re-derived the whole chain. The repair is to state the missing third iff and delete the sentence — a strengthening.

### Defect 2
`:84-85` and `:322-325` say only `IsProper`'s `UniversallyClosed` conjunct fpqc-descends. `IsProper` has three conjuncts (mathlib `Proper.lean:42`) and two descend — `LocallyOfFiniteType` closes by `inferInstance` via `LocalFlatDescent.lean:35`. Only `IsSeparated` fails. Separately, `:109-111` cites `Algebra.isGeometricallyReduced_iff` as *defining* geometric reducedness by `IsReduced (k̄ ⊗[k] A)`; that lemma is the prime-quantified general-base form. The declaration matching the sentence is `Algebra.isGeometricallyReduced_field_iff`, also in the closure.

### What survived, explicitly
- **Carrier.** `Pic0SchemeEt C = GroupScheme.IdentityComponent (PicSchemeEt C)` closes by `rfl`, so `quasiCompact`'s `.2.1` projection is about the right scheme. No mismatch.
- **Vacuity.** All four antecedents probed with the gate assumed: `IsReduced` of the `k̄` pullback, `UniversallyClosed` of `pullback.snd`, `GeometricallyReduced`, and `Smooth` each report `synthInstanceFailed`. None is free.
- **Both iffs are real.** Directions match the names; the `pullback` vs `pullback.snd` asymmetry is correct, not a bug — reducedness is a property of the pullback *scheme*, universal closedness of the projection *morphism*.
- **No self-projection.** The `infer_instance` converses genuinely route through `Smooth.geometricallyReduced` and base-change stability, not back through the binder.
- **Negatives (b) and (c) hold.** No `CharZero` in mathlib's `AlgebraicGeometry/Group/`, no `Cartier` anywhere in `AlgebraicGeometry/`, and `PerfectField + IsReduced ⇒ IsGeometricallyReduced` fails both `infer_instance` and `exact?`. `GeometricallyReduced` has no `DescendsAlong` instance, as claimed at :188.
- **Claim (d) holds.** `SmoothOfRelativeDimension.geometricallyReduced (genus C)` does discharge the reducedness target from obligation 4, so the "5 obligations are not 5 independent distances" correction is correct.
- **Sorry-accounting is accurate, not optimistic.** All 13 declarations are `[propext, Classical.choice, Quot.sound]` as implications; at an abstract `C` with the gate *not* assumed the gate fires anyway and instantiated conclusions report `sorryAx`, while the control `(inferInstance : HasPicScheme C)` correctly fails. The file states this shape at :126-133.
