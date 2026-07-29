Audit complete. Both inbox items filed (I-0991 issue, and the memory item). Temp probes cleaned up; I edited nothing.

## Verdict: CONVERGING, with real content — but the file over-claims twice in its own docstring

The Lean is sound and sorry-free (`#print axioms jacobianDataOfMixedParamCharts` → `[propext, Classical.choice, Quot.sound]`, zero diagnostics). The structural finding — that the board's three-antecedent count was measured against the wrong theorem — is correct and worth the round. The defects are all in prose, plus one real repricing the file missed.

Note: the file grew from 146 lines (`67c8d24d5`) to **295** at HEAD via two later commits from the same session (`5ab728316`, `878d30dca`). I audited HEAD. All line numbers below are HEAD.

File: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AtlasFiniteType.lean`

### 1. Hypothesis drift — REFUTED (no drift)
`locallyOfFiniteType_chartHom_mixedParamChart` (:147) concludes `LocallyOfFiniteType (chartHom C (mixedParamChart C π nn D rep m Z hdeg V) i)`. `JacobianData.ofChartsOfCompactSpace` (`JacobianDataCharts.lean:209`) consumes `hlft : ∀ i, LocallyOfFiniteType (chartHom C f i)` at the *same* `f`. The assembly (:221) passes it directly with `f := _` unified to the mixed atlas, and it elaborates. Same atlas, not an adjacent one. The `chartHom_mixedParamChart` composition (`chartHom_restrictChart` ∘ `chartHom_abelSigmaChart`) checks out.

### 2. Fourth antecedent, or rider on `rep`? — **RIDER. This is the substantive correction.**
`hD` is not merely "suppliable by the same lane" — it is a **invariant of the functor at the parameter**, provable outright. I proved (EXIT=0, axiom-clean):

```lean
theorem probe_hD_is_functor_invariant {n : ℕ} {D D' : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (rep' : (divFunctor C π n).RepresentableBy D')
    (h : LocallyOfFiniteType D'.hom) : LocallyOfFiniteType D.hom
```
via `rep.uniqueUpToIso rep'` and `rw [← Over.w e.hom]`. So no producer of `rep` can choose a `D` failing `hD`. The file's own justification at :224-238 (the carrier `DivOver` happens to have a global instance) is weaker and *contingent* — true today, re-measurable if divRep returns a different object. The unconditional argument was available and not taken. `hD` belongs on the `rep` row.

### 3. The count — CONFIRMED contradiction
- **:80** — "everything in it other than `hf`, the local-surjectivity instance and `rep` is now discharged" (three open).
- **:204** — same file, docstring of the same `def`: "until the **four** open inputs above are produced".
- **:199-201** and **:262-265** call `hcpt` Open, while `hcpt` is an explicit hypothesis at **:219**.

`:80` is the wrong one. It survived two later commits that added the correct wording elsewhere.

### 4. Vacuity — CONFIRMED degeneracy, but the output IS falsifiable
At `ι := PEmpty`, *four of five* inputs are free: `hf`, `hdeg`, `V`, `hD`, `m`, `Z`, `nn` by `PEmpty.elim`, and `hcpt` free too — the empty family glues to an **empty space** (`openCover.exists_eq` yields an index; `IsEmpty → CompactSpace` by `inferInstance`). All content sits in the single `IsLocallySurjective` instance.

It sits there soundly. I proved `False` from that instance at `PEmpty` (EXIT=0, axiom-clean): `JacobianData.rep` gives a point of `J` over every test (`d.homEquiv.symm 1`) while `J.left` is empty. So the assembly is **not vacuous** and its output is falsifiable. What this does reprice: `hcpt` is not an independent gate of this shape but a consequence of coverage, and any future "hcpt discharged" claim measured at a small atlas measures nothing.

### 5. Is `hD` cheap? — CONFIRMED cheap, but the supporting absolute at :31-33 is FALSE
Cheap: `locallyOfFiniteType_divSchemeOverHom` (`DivSchemeQProj.lean:199`) is a global instance closing it by `inferInstance` at arbitrary window data, axiom-clean, and `DivOver` (what every `divFunctor` producer returns) is that shape.

But **:31-33** claims "the only declaration in `Picard/` whose conclusion is `LocallyOfFiniteType` is `locallyOfFiniteType_gluedHom`". Enumerated: **five** non-local ones plus 38 `local instance` re-derivations. Omitted are `locallyOfFiniteType_grStructMap` (`GrassmannianScheme.lean:165`) and `_grPairStructMap`/`_carveSchemeOverHom`/`_divSchemeOverHom` (`DivSchemeQProj.lean:93/:149/:199`) — the last being the one **this same file imports at line 8** and cites at :230 as the reason `hD` is free. The opening is refuted by the closing section. The defensible claim ("no producer at a *chart*") is true and is what it should say. The same absolute is live on roadmap row `AJCR.w4-rep.datum.dat-glue.atlas-lft` ("exactly ONE declaration").

### Throughput / avoidance
No churn: three commits, one file, no helper proliferation, no sorries, no axioms, no placeholder definitions. The commit message is accurate about closing no gate, and the file says so plainly at :82-90 and :203-207 — no gate-inflation. The `Discharged` section at :240-274 correctly refuses to overclaim `hcpt` from per-chart compactness. Not avoidance; the lane repeatedly marks its own limits. The one pattern worth flagging is that both defects are of the workspace's recorded shape: a confident absence claim (I-0978's own lesson, filed by this task) and a caveat pass that fixed the hedged wording downstream while leaving the flatly-overstated line at :80 in place.
