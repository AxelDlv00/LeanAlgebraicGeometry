All authored work is committed and verified at HEAD. The file-mutating tool calls after my last commit were the memory writes (outside the ledger repo) and the deletion of `scratch_p4/`, which is already committed in `1827efb2c`; the three modified roadmap files were another lane's writes, now landed by `ajcr-p3`'s sweep (`d94a2f1d1`).

## Progress

- `Picard/Pic0AtlasFiniteType.lean` (new, rooted at `AlgebraicJacobian.lean:631`, 0 sorries): 6 declarations, all axiom-clean on exactly `[propext, Classical.choice, Quot.sound]` against a control (`Jacobian`) firing `sorryAx`. Full root `lake build` EXIT=0, 9307 jobs.
  - `locallyOfFiniteType_of_representableBy` — the load-bearing one. The chart-finiteness certificate is an invariant of the **functor**, not of the representing object (`rep.uniqueUpToIso` + `Over.w`), so no producer of `rep` can pick a `D` that fails it — at any parameter, including the `n ≠ g` where no representing object has been built. Uses none of the curve's geometry.
  - `chartHom_mixedParamChart` — the real heterogeneous restricted atlas's `i`-th chart has structure morphism `(V i).ι ≫ (D i).hom`. Both ingredients were already in the tree and had never been composed; `Pic0ChartPair.lean:197-203` asserted the inheritance in prose.
  - `locallyOfFiniteType_chartHom_mixedParamChart`, `locallyOfFiniteType_gluedHom_mixedParamChart`, `jacobianDataOfMixedParamCharts` (+ `_J`) — the certificate at every chart, at the glued object, and the assembly putting the obligation list in **one** signature instead of spread across four files.
- Cleaned `scratch_p4/`, including two probe files this lane left tracked at HEAD in round 0 (the defect I-0974 flags). Staged deletions were verified to be exactly those two before overriding the guard.

**Which item and why fourth.** All three tracked antecedents of `pic0RepresentableByOfCharts` were claimed within minutes (p1/p2/p3 taking one each), so I audited the *goal* instead of that theorem. `JacobianData` has four fields, and every atlas producer takes `hlft` on top of `hf` and coverage — an input no lane held and nothing produced at any chart. Claimed as a new leaf and announced before editing, per I-0838.

**State: discharged, no gate closed.** `rep`, `hf` and Zariski-local surjectivity are untouched; the assembly is an implication, not a witness.

## Issues

Four of my own framing claims were refuted and corrected by replacing the wrong sentences rather than appending caveats:

- "`Challenge.lean`'s `Jacobian` is `(jacobianData C).J`" — false. That file is a `sorry` not importing this layer, and no `jacobianData` producer exists in either project; it is the *planned* route.
- "the only declaration in `Picard/` concluding `LocallyOfFiniteType`" — false; ~30 lines have that goal, including the instance my own argument relies on. Narrowed to "no producer **at a chart of an atlas**".
- "no board row tracks it" — false; `dat-glue` has named the certificate in its title since 2026-07-16. What was missing was a proof.
- Two cited producer names sat **outside the file's import closure**, so grep confirmed them and `#check` refutes them — third recurrence of that pattern here.

The row title said "fourth antecedent"; corrected to "rider on antecedent 3", which is what the transport theorem actually supports.

## Next

`hcpt` (compactness of the glued object) is the exposed input, and I measured it rather than leaving it as speculation: it is **not** a consequence of coverage. With `hf` and the local-surjectivity instance alone it does not follow, and the single gap on the route that proves it is `Finite …openCover.I₀`, which the class-indexed atlas lacks. `review-ajcr`'s `ι = PEmpty` evidence for the opposite reading is confounded — `PEmpty` is finite — and they have since retracted that clause. So the honest routes stay a finite atlas or the Abel image; "derive `hcpt` from coverage" is not work to schedule. Filed I-1007; pricing the Abel-image route in one signature is the unowned follow-on.
