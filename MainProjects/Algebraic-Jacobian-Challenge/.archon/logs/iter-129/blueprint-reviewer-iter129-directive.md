# Blueprint Reviewer Directive

## Slug
iter129

## Strategy snapshot

The project aims for zero `sorry`, no axioms. The protected theorem `nonempty_jacobianWitness` decomposes via a `by_cases h : genus C = 0` into `genusZeroWitness` (M2) and `positiveGenusWitness` (M3-future). M2 closure goes via `rigidity_over_kbar` (over a base field `k` per the iter-127 over-k commitment) and the shared cotangent-vanishing pile: piece (i) group-scheme cotangent triviality, piece (ii) `df = 0 ⇒ factors-through-Spec-k`, piece (iii) characteristic-p Frobenius iteration. Piece (iv) Serre duality is deferred as a named gap.

Iter-128 added a new file `AlgebraicJacobian/Cotangent/GrpObj.lean` with `AlgebraicGeometry.GrpObj.lieAlgebra`, the first declaration of piece (i.a). The prover lane closed its body using a pullback-along-section bridge through `relativeDifferentialsPresheaf` evaluated at the top open + `ModuleCat.extendScalars`.

Iter-129 must:
- Fix two iter-128-review must-fix items on `Cotangent/GrpObj.lean`: signature hardcodes `[SmoothOfRelativeDimension 1 G.hom]` (should be `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`); docstring claims the result is the `k`-linear dual but the body returns the cotangent space itself (no dualisation) — either rename the declaration to `cotangentSpaceAtIdentity` or actually dualise in the body.
- Update `RigidityKbar.tex` to align the `\lean{...}` hint with whatever post-rename name is chosen + add a rank-lemma bridge sketch connecting the prover's evaluate-then-extend-scalars body construction to the iter-129+ rank lemma `lieAlgebra_finrank_eq_dim`.
- Possibly dispatch a prover lane on the rank lemma OR on piece (i.b) shear iso `mulRight_globalises_cotangent` after the refactor and blueprint-writer pass land.

## Routes

Single route. The strategy has a fallback (over-`k̄` baseline + restored M2.c Galois descent) which would activate only if one of the three concrete revert triggers fires; none did fire iter-128.

## Lean structure

```
AlgebraicJacobian/
├── AlgebraicJacobian.lean         (root module, just imports)
├── AbelJacobi.lean                (closed, no sorry)
├── Cohomology/
│   ├── MayerVietorisCore.lean     (closed)
│   ├── MayerVietorisCover.lean    (closed)
│   ├── SheafCompose.lean          (closed)
│   ├── StructureSheafAb.lean      (closed)
│   └── StructureSheafModuleK.lean (closed; large 878 LOC infrastructure file)
├── Cotangent/
│   └── GrpObj.lean                (NEW iter-128; closed: `lieAlgebra` body; review-flagged signature + docstring must-fix items for iter-129)
├── Differentials.lean             (excised iter-126; 5 standalone utilities)
├── Genus.lean                     (closed; `genus C := Module.finrank ...`)
├── Jacobian.lean                  (2 sorries: `genusZeroWitness` iter-127 scaffold + `nonempty_jacobianWitness` OFF-LIMITS)
├── Rigidity.lean                  (closed iter-125)
└── RigidityKbar.lean              (1 sorry: `rigidity_over_kbar` iter-126 scaffold)
```

Total 14 files; 3 active sorries (`Jacobian.lean:178` genusZeroWitness, `Jacobian.lean:197` nonempty_jacobianWitness OFF-LIMITS, `RigidityKbar.lean:87` rigidity_over_kbar).

## Blueprint chapters

All chapters live under `blueprint/src/chapters/`:

- `AbelJacobi.tex`, `Cohomology_MayerVietoris.tex`, `Cohomology_SheafCompose.tex`, `Cohomology_StructureSheafAb.tex`, `Cohomology_StructureSheafModuleK.tex`, `Differentials.tex`, `Genus.tex`, `Jacobian.tex`, `Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`, `Rigidity.tex`, `RigidityKbar.tex`.

Per the iter-128 blueprint-reviewer, four are likely orphan (`Modules_Monoidal.tex` + `Picard_*.tex`); the iter-127 strategy switch eliminated Route A/B-style genus-0 identification.

Iter-128 review-phase findings on `RigidityKbar.tex`:
- Chapter's `\begin{proof}` of `lem:GrpObj_lieAlgebra` sketches only the `𝔪/𝔪²`-stalk route via `IsRegularLocalRing.cotangentSpace`, but the Lean body actually computed `Γ(G, Ω_{G/k}) ⊗_{Γ(G)} k` (evaluate-first, extend-scalars-second). The rank lemma `lieAlgebra_finrank_eq_dim` needs the bridge between these two presentations and the chapter does not preview it.
- Per the iter-128 `lean-vs-blueprint-checker`: the `\lean{...}` hint should pin a fully-specified signature stub, not just the prose.

## Specific concerns

1. **`RigidityKbar.tex` § Piece (i)** — does the chapter adequately describe the iter-129+ rank lemma? Specifically:
   - Is the bridge between the evaluate-first construction (the actual Lean body) and the `𝔪/𝔪²` stalk presentation previewed?
   - Does the chapter need a signature stub on `\lean{...}` to prevent the "hardcoded `1`" regression that iter-128 incurred?
2. **`Jacobian.tex` § C.2.a–C.2.e** — known iter-128 soon-item: prose still says "ℙ¹_{k̄}" / `k̄` framing; should shift to over-k. Is this blocking the iter-129+ work, or genuinely deferrable?
3. **Orphan chapter pruning** — `Modules_Monoidal.tex` + 3 Picard_*.tex files are orphan post-iter-127 strategic shift. Should they be deleted this iter, or retained as historical?
4. **`Jacobian.tex` § def:genusZeroWitness** — iter-127 added this block; is the proof sketch detailed enough to guide an iter-145+ prover lane?

## Output format

Per § "What you check" of `.archon/subagents/blueprint-reviewer.md`. Per-chapter checklist of complete/correct + must-fix-this-iter findings + cross-cutting summary. The plan agent will use the per-chapter checklist as the HARD GATE for any prover dispatch this iter.
