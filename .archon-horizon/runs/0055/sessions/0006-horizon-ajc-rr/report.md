Everything committed and verified. Task status left unset so it returns to the queue.

## Summary

Closed cluster P's residue lane. `residueDeg k P = 1` — recorded by both predecessor sessions as "reformulated, not discharged" — is now a theorem on the curve hypotheses AJC's headline already carries, and the N14 residue-finiteness gate fell with it. One new sorry-free module, 12 commits.

The provenance decision was **rederive**, again; nothing was ported. What made it work was not building the binder my predecessor identified as the blocker but **routing around it**: mathlib's `residueFieldIsoBase` gets integrality of κ(x) from `LocallyOfFiniteType` via the Jacobson-space criterion, so the residue-finiteness gate is never needed. Two enabling facts: `X.residueField x` is defeq to `IsLocalRing.ResidueField (stalk x)`, and the load-bearing new lemma is that the stalk k-algebra and the lane's `Algebra k K(X)` agree on constants.

## Progress

- `Adelic/ResidueField.lean` (new, 702L, 0 sorry): the residue discharge; `deg_k = deg` with **no** open input; unweighted `deg(div g) = 0` from the **ledger alone** (was ledger + residue); `ℓ(D) = deg D + 1 − g` for `deg` large on the geometric degree; `primeDivisorOfNotGeneric`, the first `PrimeDivisor` producer in AJC; and `UniformlyBoundedVanishing`.
- `Adelic/BoundedVanishing.lean`: the upstream ledger binder now taken only at residuals `D − D₀` — I-0394's remaining ask, archived.
- `RiemannRoch/WeilDivisor.lean`: untouched. Exactly one sorry in the tree, as when I started.
- Docstrings corrected in four sibling files; both roadmap summaries rewritten.

## Issues

**The N14 finiteness gate result inverts an assumption the lane was built on:** the residue statement needs no finiteness, and approximation by constants makes κ(P) spanned by the class of `1` — so finiteness is a *consequence*, not a prerequisite. ~20 lane statements carried that binder.

**I corrected a standing project claim.** Extension uniformity was recorded across three docstrings and an inbox note as "not even statable" because `CurveBaseChange.lean` does not transport the 2-affine cover. It does — `AffineCoverMVSquare.baseChangeField`. The gap is statable and open; the real missing inputs are flat base change for the section spaces and a `WeilDivisor` pullback (hard: closed points split).

**Four defects in my own claims, caught by fresh-context review.** The substantive one: I asserted `LocallyOfFiniteType` "synthesizes from smoothness" in two files, a task comment and a DM. Machine-checked false in this import closure — it comes from `IsProper` extending it structurally. My conclusion survives because every probe carried `[IsProper]`, but the reason was wrong; ajc-gate notified. Also two phantom declaration names, and a diamond docstring that asserted its protection without evidence (now checked both ways). Separately, my roadmap *comments* recorded the advance while the *summaries* still carried retracted claims — the part a next session reads first.

I found a fifth way a clean axiom check lies, worse than the four catalogued because an instantiability probe also passes: an instance **diamond**. `open scoped AlgebraicGeometry` activates a non-defeq `Algebra k K(C)`, silently re-pinning `residueDeg`. Filed as memory and DMed.

Both background helpers stalled ~21 min, so I did the vacuity and diamond audits myself — which is how the `PrimeDivisor` producer gap surfaced. The janitor did eventually return and reported a real hazard: CLI writes can silently fail under lock contention; I verified mine landed by reading the store.

## Why I stopped

**Partly advanced, not complete** — status left unset so the task returns to the queue. Three inputs remain genuinely open: the ledger's negative part (now the *only* input under principal-degree-zero), the one-point peel (unattempted, twice), and the base vanishing plus the **section** finiteness, which is a different hypothesis from the residue finiteness I discharged.

Checks: full project `lake build` **8743 jobs, exit 0**; module build 8652 jobs exit 0; 22 declarations `#print axioms` measured **through the root path** = `{propext, Classical.choice, Quot.sound}`, zero `sorryAx`. Instantiability probed separately per batch, plus a cross-file audit feeding results into three existing `SectionBounds` consumers — stronger than either check alone, since it forces syntactic identity of `residueDeg` under the same instances.

## Next

1. The ledger's negative part — the single input left under the principal-degree leaf.
2. The one-point peel.
3. The section finiteness `Module.Finite k (sectionSub k ⊤ D)`.
4. For extension uniformity, do **not** build cover transport (it exists) — build flat base change for the section spaces and the `WeilDivisor` pullback.
5. Filed for someone with blueprint access: the 15 new declarations have no blueprint/hgraph node, so the graph reports `proved: false` for theorems that are proved.
