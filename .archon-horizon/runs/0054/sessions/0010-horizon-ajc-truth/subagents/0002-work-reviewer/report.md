All three items filed. Here is the audit.

# Verdict on I-0448

**`hbump` is not vacuous and not unsatisfiable-as-stated. `chi_eq_of_bump` is a real theorem.** But ajc-rr asked the wrong question about it, and the right question has a worse answer for their claim of progress. Everything below is machine-checked with `lake env lean` on `/tmp` scratch files, EXIT=0, no source edited. `lake build AlgebraicJacobian.RiemannRoch.Adelic.LedgerClosure` also came back EXIT=0 (its `.olean` was missing at session start, so this was a cold build, not a replay).

## 1. What `hbump` quantifies over

From `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/LedgerClosure.lean:204`:

```lean
(hbump : ∀ (P : X.PrimeDivisor) (E : X.WeilDivisor),
  chi k U₀ U₁ (pointDivisor P + E) = chi k U₀ U₁ E + residueDeg k P)
```

Two universal quantifiers: over **all** prime divisors, and over **all** Weil divisors as base — including non-effective ones. `U₀ U₁` are fixed section variables. `chi k U₀ U₁ D = ℓ(D) - h¹(D)` with both terms `Module.finrank` over `k` (`ChiLedger.lean:950,953,956`), `residueDeg k P = finrank k (localStepTgt k P 1)` (`ChiLedger.lean:638`), `degK` an honest `AddMonoidHom` via `Finsupp.liftAddHom` (`SectionBounds.lean:109`).

`chi_add_eq_residueDeg` (`ChiLedger.lean:1055`) concludes the same equation but carries `hPV : P.point ∈ U₀ ⊓ U₁`, `hstep`/`hle`/`hoff`, the strong-approximation `hsurj`, four exactness data and five finiteness instances. So `hbump` is the conclusion shape with every hypothesis stripped and universally quantified. That is the source of the trouble.

## 2. No bookkeeping trap — and a bigger problem instead

I checked the sign/degree trap you named specifically. **It is not there.** Every step strictly raises `degK` (I proved `degK k E < degK k (pointDivisor P + E)` from `1 ≤ residueDeg k P`), so the instantiation relation is graded by `degK` and acyclic — no chain returns to its start, so nothing can force `chi(D) = chi(D) + d`. The two telescope routes inside `chi_eq_of_bump` (`h1` onto base `D`, `h2` through the effective cone) meet through `degK_add` on the same decomposition `D⁺ = (−D)⁺ + D`. The arithmetic is consistent.

**The problem I found instead: `hbump` is equivalent to the closed ledger.** The converse is three lines:

```lean
rw [hledger (pointDivisor P + E), hledger E, degK_add, degK_pointDivisor]; ring
```

So `chi_eq_of_bump` transports no information — it is a reformulation, not a strengthening. "Is `hbump` satisfiable" *is* "is the closed ledger satisfiable". The lane's open-input count did not drop from three to two; one input was rewritten in one-point form. This is I-0399's re-indexing failure mode at one remove: not `Iff.rfl` dressed as content, but a genuine one-directional proof of something whose other direction is free. **Before claiming a hypothesis-elimination, try to prove the converse.**

## 3. `hbump` is refutable far more widely than §4/§5 says

Proved unconditionally — no `chi_add`, no exactness data:

- `h1dim_ge_of_bump`: `m·residueDeg k P − ℓ(0) ≤ h¹((−m)·P)`.
- `not_bump_of_h1dim_bounded`: if `∀ D, h¹(D) ≤ b` then `¬hbump`, given one prime divisor.
- At the degenerate cover `U₀ = U₁ = ⊤` the Čech H¹ vanishes identically (`χ = ℓ ≥ 0`), so `hbump` is **outright false** there once a single `X.PrimeDivisor` exists: `m = ℓ(0)+1` forces `ℓ(−m·P) < 0`.

`hbump` forces `χ(−m·P) = χ(0) − m[κ(P):k]` while `χ = ℓ − h¹` with `ℓ ≥ 0`, so `h¹` must grow linearly on the anti-effective cone. This is strictly stronger than `not_bump_of_notMem_overlap` (`LedgerClosure.lean:513`), which is **conditional** on `hchiAdd` — do not read that as an unconditional refutation. Nothing in the lane is contradicted (its vanishing results are high-degree only), but §4's "consistent (vacuously)" should read "consistent, refutable at `U₀=U₁=⊤` with one prime divisor, refutable on every bounded-h¹ cover".

## 4. `bump_of_isEmpty_primeDivisor` and the `primeDivisorOfNotGeneric` citation

The empty-scheme lemma is exactly what it claims (`[IsEmpty X.PrimeDivisor]`, body `fun P _ => isEmptyElim P`) and is correctly labelled degenerate.

The citation is **wrong twice over**. The real path is `AlgebraicGeometry.Adelic.primeDivisorOfNotGeneric` (`ResidueField.lean:262`) — `ResidueField.primeDivisorOfNotGeneric` does not resolve, there is no such namespace. And it takes a non-generic point as *input*, `(hx : x ≠ genericPoint C.left) : C.left.PrimeDivisor`; it does not produce one. No `Nonempty C.left.PrimeDivisor` instance exists in AJC. The existence of a non-generic point *is* proved, but inside `private lemma exists_pole` (`NonconstantToP1.lean:857`), unexported. So "the vacuous witness does not apply on a curve" (`LedgerClosure.lean:460,540`) is mathematically true but not a citable Lean fact.

## 5. The instance diamond: real, but not where I-0448 says

- `open scoped AlgebraicGeometry` alone does **not** activate `Scheme.functionFieldAlgebra` — synthesis fails. Only `open scoped AlgebraicGeometry.Scheme` does (it is declared inside `namespace AlgebraicGeometry.Scheme`, `GateInstances.lean:98`). Your wording names the wrong open.
- With that open, the found instance is `Scheme.functionFieldAlgebra C`, confirmed by `rfl`.
- **The diamond is real**, exactly as `ResidueField.lean:790-800` records in prose. Same consumer probe feeding `hbump` into `exists_bound_ell_eq_degree_of_bump`: without explicit `[Algebra k C.left.functionField] [IsConstantField k C.left]` binders it elaborates (EXIT=0); with them it fails on an application type mismatch, `@chi k … inst✝¹ inst✝ …` against `@chi k … (Scheme.functionFieldAlgebra C) …`.
- **LedgerClosure.lean itself does not trip it.** It uses explicit binders throughout and does not open the scoped namespace. ResidueField.lean does open it and correctly omits the binders. Each is internally consistent; breakage is caller-side only.

## Could not settle

Whether a third `Algebra k K(C)` path exists (`overStalkAlgebra`, `globalSectionsAlgebra` composing to the same type). I confirmed mathlib supplies none for a plain field `k`, matching `GateInstances.lean:40-42`, so `functionFieldAlgebra` was the only resolution candidate I found — but I did not exhaustively enumerate scoped instances project-wide. I also did not exhibit a curve where `hbump` *holds*; item 3 narrows where it could, and that still needs `hsurj`.

Filed: two `issue` items to `task:ajc-rr` (vacuity findings; diamond localisation) and one `memory` to `horizon` (the converse-check discipline).
