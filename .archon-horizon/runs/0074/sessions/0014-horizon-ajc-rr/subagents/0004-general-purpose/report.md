Posted. Investigation complete.

## Verdict

**The docstring claim is TRUE — and in fact understates the situation. AJC does have an unconditional, sorry-free producer of `C.left.AffineCoverMVSquare` for a general smooth proper geometrically integral curve over an arbitrary field.** The theorem is not conditional on anything a caller cannot supply.

I verified this by scratch elaboration (no files edited). This term elaborates clean:

```lean
(Adelic.p1LaurentChartData k).pullbackSquare (Adelic.finiteMapToP1 C)
-- 'probeSquare' depends on axioms: [propext, Classical.choice, Quot.sound]
```

under `[IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIntegral C.hom]`, and also under the challenge's own weaker set with `[GeometricallyIrreducible]` in place of `GeometricallyIntegral`. Both `genus_baseChangeField` and `uniformVanishing_of_uniformBaseDivisor` elaborate sorry-free with the square synthesised rather than bound.

## 1. The structure

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:51-63`

```lean
structure AffineCoverMVSquare (X : Scheme.{u}) where
  U₁ : X.Opens
  U₂ : X.Opens
  isAffineOpen_U₁ : IsAffineOpen U₁
  isAffineOpen_U₂ : IsAffineOpen U₂
  isAffineOpen_inf : IsAffineOpen (U₁ ⊓ U₂)
  cover : U₁ ⊔ U₂ = ⊤
```

## 2. Both inputs to `pullbackSquare` are discharged

This is where the premise of your question turns out to be outdated — several docstrings in the tree still describe these as open gates.

**`LaurentChartData Y`: unconditional instance.** `p1LaurentChartData` at `AlgebraicJacobian/RiemannRoch/Adelic/P1ChartData.lean:1128` is a plain `noncomputable def`, no gate, and `instP1HasLaurentChartData` at `:1150` registers it for every field `k`. No sorries in that file.

The docstring at `AlgebraicJacobian/RiemannRoch/Adelic/FinitenessP1.lean:730` still claims the class "carries **no instance** and is supplied at use sites". That clause is **stale** — contradicted by `P1ChartData.lean:1150`.

**A finite morphism from an arbitrary AJC curve: synthesises.** There *is* an effectively unconditional chain, all sorry-free:

- `existsNonconstantMapToProjInt_of_ajc` — `AlgebraicJacobian/RiemannRoch/Adelic/NonconstantToP1.lean:1067`, an `instance` under `[SmoothOfRelativeDimension 1] [IsProper] [GeometricallyIntegral]`, proved by the two-chart valuative construction
- → `existsNonconstantMapToP1_of_existsNonconstantMapToProjInt` — `NonconstantToP1.lean:136`
- → `hasFiniteMapToP1_of_existsNonconstantMapToP1` — `AlgebraicJacobian/RiemannRoch/Adelic/FiniteMapToP1.lean:462` (nonconstant + proper + smooth ⟹ finite)
- → `Adelic.finiteMapToP1` extracts the morphism — `AlgebraicJacobian/Picard/RigidPushforward.lean:560`

`FiniteMapToP1.lean:442` already self-corrects its own obsolete "carries no instance" clause. So the answer to your sub-question is: **yes, there is effectively an unconditional theorem that every AJC-hypothesis curve admits a finite map to P1** — not restricted to algebraically closed fields, not requiring a rational point, not restricted to P1.

## 3. Producer census — 7 total, complete

Only **two** can bootstrap:

| file:line | producer | hypotheses |
|---|---|---|
| `Adelic/FinitenessP1.lean:439` | `LaurentChartData.pullbackSquare` | `LaurentChartData Y` + `IsFinite π.left` — both dischargeable |
| `Adelic/FinitenessP1.lean:702` | `p1CoverSquare` | none (P1 itself) |

The other five require an `AffineCoverMVSquare` as **input**, so they cannot bootstrap — confirming your guess about the two you flagged:

- `Picard/RigidPushforward.lean:235` — `AffineCoverMVSquare.preimage`, the general engine (along any `IsAffineHom`)
- `Picard/RigidPushforward.lean:585` — `p1BaseChangeCoverSquare`
- `Picard/FinitePresentationFunctor.lean:521` — `baseChangeSpecOver` (needs `S` in)
- `RiemannRoch/CurveBaseChange.lean:340` — `AffineCoverMVSquare.baseChangeField` (needs `S` in)
- `Picard/RigidPushforwardTransfer.lean:1315` — `p1BaseChangeFiberCoverSquare` (needs `p1BaseChangeCoverSquare` in)

**Not gated anywhere:** there is no `HasAffineCoverMVSquare` class, no `Nonempty (_.AffineCoverMVSquare)` gate, and no `[_.AffineCoverMVSquare]` instance binder in the tree.

## 4. `CechComparisonGate.lean` — does not indicate the cover is open

Its `∀ S : C.left.AffineCoverMVSquare` quantifies over covers in order to gate a *different* thing: gate 4, `HasCechToHModuleIso` (the Čech-to-derived comparison). The file's own header enumerates four gates and explicitly lists `HasFiniteMapToP1` as gate 1 and `P1HasLaurentChartData` as gate 2, separately from cover existence — which is never a gate.

Worth noting that even gate 4 is superseded for the structure sheaf: `AlgebraicJacobian/RiemannRoch/Adelic/GenusUnconditional.lean` proves `hModuleOneEquivH1Cok_curve` gate-free and registers `instModuleFiniteHModuleOne` as an unconditional AJC instance. So `CechComparisonGate`'s "gate 4 NOT instantiable today" framing is itself partly stale for the genus carrier.

## Where the docstring is genuinely misleading

One phrase, and it errs toward *understating* the result: "on the challenge curve" reads as though `pullbackSquare` fires only on some distinguished curve object. **There is no concrete `challengeCurve` term in AJC** — I grepped; "the challenge curve" appears only as prose in docstrings (`Ledger/ChiCurve.lean:113`, `Ledger/FiberBound.lean:192`, `Ledger/GenusBridge.lean:111`, etc.), always meaning the ambient hypothesis triple. The producer fires on *every* curve satisfying the theorem's own hypotheses, i.e. at full stated generality.

So the explicit `(S : C.left.AffineCoverMVSquare)` binder is a convenience, not a conditionality. A caller reading only that docstring might think it must hunt for a witness it can now synthesise.

## Three stale docstrings for the owning lane

I made no edits (read-only task), and posted the finding to team thread I-0493:

1. `Adelic/FinitenessP1.lean:730` — "carries no instance" is false since `P1ChartData.lean:1150`
2. `Ledger/GenusFieldInvariance.lean:374-375` — "on the challenge curve" is too narrow
3. `Adelic/CechComparisonGate.lean:157` — gate-4 framing vs `GenusUnconditional.lean`
