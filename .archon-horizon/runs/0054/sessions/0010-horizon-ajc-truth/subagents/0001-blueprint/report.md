Item 1 and 2 are complete. Here is the report.

## Item 1 + 2: route-claim fixes (all applied)

I found four places in the slice that described the Quot/quotient endgame as the live path to Picard representability without noting it is off-path, plus three adjacent framings that leaked project process into the mathematics. All are in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/`.

**`Picard_QuotScheme.tex:4484`** (section "The relative-divisor functor"). Was: *"Grothendieck constructed the Picard scheme by taking a suitable family of effective divisors and forming the quotient modulo linear equivalence. This section defines the parameter functor of that family..."* — flat present-tense assertion that this is how the Picard scheme gets built. Re-aimed to name it as Grothendieck's *quotient* route, cross-referencing `\cref{sec:fga_pic_setup}`, and to say the functor stands as mathematics whose divisor substrate is shared with the committed route.

**`Picard_QuotScheme.tex:8409`** (Dependencies summary). Was: *"The Picard construction in \cref{chap:Picard_FGAPicRepresentability} applies \cref{thm:quot_representable} to the special case \(E = \mathcal{O}_C\)... giving the Hilbert scheme..."* — asserts the downstream Picard construction consumes Quot. Rewritten to identify `Div`/`Hilb` as the engine of the quotient route that `\cref{sec:fga_pic_setup}` sets beside Milne–Kollár, and to note the chapter's substrate is consumed by either route.

**`Picard_QuotScheme.tex:8435`** ("Out of scope" bullet). Was *"not consumed by Route A"* — an internal route label with no referent in the document. Now "consumed by nothing in this development."

**`Picard_FlatteningStratification.tex:7-15`** (Setup and motivation). The chapter opened by framing its entire content as a step inside the Quot-scheme construction ("The construction of the Quot scheme … proceeds by … Cutting out this locus uses, as a primary technical input, the existence of the flattening stratification"). Reversed the order: the chapter now states what it proves (flattening stratification and its universal property) as a theorem of commutative algebra and scheme theory independent of any moduli construction, then records that it is the input Nitsure's Quot construction uses.

**`Picard_FlatteningStratification.tex:2743`** ("Relation to adjacent constructions"). Was: *"Combining the resulting Quot spaces with the relative Picard functor is a separate representability argument"* — treats the Quot→Picard passage as simply pending. Now names it as the quotient route of `\cref{sec:fga_pic_setup}` resting on a descent step the formalisation avoids via Milne–Kollár.

**`Picard_LineBundleCoherence.tex:5-21`** (chapter STRATEGY NOTE). Was an "on-path" claim: *"This chapter supplies the cheap, on-path half of the line-bundle coherence requirement of the A.2.c Quot-scheme embedding … The embedding's input is a point of the relative Picard scheme \(\Pic^0_{C/k}\)…"*. Replaced with a SCOPE note stating only what the chapter proves; the load-bearing mathematical caveat (the 0B8M converse spreading-out is not crossed) is kept verbatim.

**`Picard_LineBundleCoherence.tex:36`** and **`:329`**. Body prose "coherent *in the sense the Quot construction consumes*" → "coherent"; and the section note justifying chart-local recording by "the data the Quot embedding actually consumes … this is flagged for the plan agent" → a purely mathematical justification (rank-one freeness and flatness are local conditions).

**`Picard_SectionGradedRing.tex:12`**: "The Hilbert-polynomial *route* of \cref{chap:Picard_QuotScheme}" → "development". Single word; "route" here reads as a route-choice claim it is not.

### Not changed, deliberately

- `Picard_QuotScheme.tex:12-20` — already the correct model note; left alone.
- `Picard_QuotScheme.tex:4947` ("The Quot construction proceeds by embedding \(\Quot\) as a locally closed subfunctor of a Grassmannian") and `8347` ff. ("Construction overview", Phases 1–3) — these describe the internal architecture of the Quot construction itself, which is what the chapter is about. They make no claim about the Picard route, and the chapter head note plus the two fixed passages now bracket them.
- `Picard_GrassmannianQuot.tex` and `Picard_GrassmannianCells.tex` — swept for route claims and found clean. Both chapters talk only about the Grassmannian scheme and its universal property; `GrassmannianCells.tex:2338-2357` ("Out of scope") points forward to the Grassmannian representability theorem, never to Picard. `Picard_LineBundleCoherence.tex:373` mentions "the Quot-scheme embedding consumes" inside a proof body — I left it, since your constraint was not to touch proof bodies.
- `Picard_FlatteningStratification.tex:17-22` — retains "The conclusion of Nitsure's theorem … applies in particular to \(X = C \times_k T\)". That is a true statement of generality, not a route claim.
- `Picard_GrassmannianQuot.tex:151-153` — a `% HISTORICAL (abandoned route)` comment about an earlier *gluing implementation*, not about the Picard route. It is project history and against house style, but it is outside the route-claim scope you gave me and removing it is a judgment call for the chapter's owner.

LaTeX verified: all six files balance braces (depth 0, no extra closers) and all `\begin`/`\end` environments pair correctly, checked with comments stripped. No `\lean{}`, `\label{}`, `\uses{}`, `\leanok`, `\notready`, statement, or proof body was touched. I did not run `lake build`.

## Item 3: `\leanok` and pin findings (reported, not fixed)

Seven nodes in `Picard_QuotScheme.tex` carry `\leanok` on the **statement** while the pinned Lean declaration's body contains a reachable `sorry`. Under the convention that statement-`\leanok` means only "the signature is formalized", these are defensible — and five of them correctly withhold `\leanok` from the `proof` block. Flagging them because the boundary is thin and one is the chapter's headline theorem:

- `thm:quot_representable` (L6518) → `AlgebraicGeometry.Scheme.QuotScheme` at `AlgebraicJacobian/Picard/QuotRepresentability.lean:73`, body is `sorry`. Statement-`\leanok` only; proof block has no `\leanok`, and an inline comment already says "the PROOF is the sub-lemmas below". Honest, but this is the node a reader is most likely to misread as done.
- `lem:sectionGradedModule_fg` (L334) → `SerreFiniteness.lean:66`, `sorry`.
- `lem:gradedHilbert_fiber` (L6423) → `SerreFiniteness.lean:259`, `:= sorry`.
- `lem:pullback_tensor_map_isiso` (L4070) → `QuotFunctorDef.lean:458`, `sorry`.
- `lem:gamma_fiber_baseChange_field` (L4311) → `QuotFunctorDef.lean:690`, `sorry` on the residual quasi-coherence obligation.
- `def:quot_pullback_app_isoTensor` (L7486) and `def:pullback_app_isoTensor_sigma` (L7603) — these two have **no proof block at all**, so their `\leanok` is a bare statement claim; the pinned defs at `QuotScheme.lean:4967` and `:4611` are themselves sorry-free, closing through the private helper `pullback_app_isoTensor_isBaseChange` (also sorry-free at `:4937`). These two are fine; listed for completeness because a naive scan flags them.

Six nodes in `Picard_SectionGradedRing.tex` carry `\leanok` on **both statement and proof** but their `\lean{}` pin does not resolve under the namespace path given. The declarations exist, in `AlgebraicJacobian/Picard/SectionGradedRing.lean`, but not at `AlgebraicGeometry.Scheme.Modules.*`:

- `lem:sectionsCast_refl` (L2133) → `sectionsCast_refl` is at `SectionGradedRing.lean:2131`
- `lem:sectionGradedRing_gsemiring` (L2444) → `SectionGradedRing.lean:3481`
- `lem:sectionGradedModule_gmodule` (L2967) → `SectionGradedRing.lean:4326`
- plus `lem:sectionGradedRing_gmonoid` (L2417), `lem:sectionGradedRing_gcommSemiring` (L2550), `lem:moduleSectionsCast_refl` (L2756)

Most likely these live under a `Scheme.Modules` namespace opened differently than the pin spells it, or the pin carries a stale prefix — worth a `horizon search` on each before editing, since my resolver is a regex over `namespace` blocks and can miss `open`-scoped or `variable`-section forms.

Four `\lean{}` pins in `Picard_QuotScheme.tex` point at a `AlgebraicGeometry.TODO.*` namespace that does not exist anywhere in the project: `quotReductionToPiStarW` (L6650), `quotBoundedness` (L6728), `quotAlphaInjective` (L6801), `quotValuativeCriterion` (L6866). All four correctly lack `\leanok`, so nothing is falsely claimed — but they are placeholder pins to a namespace that was never created, i.e. the four load-bearing sub-lemmas of the Quot representability proof have no Lean target at all. Same shape at `Picard_GrassmannianQuot.tex:293` (`def:gr_modules_glueHom` → `Scheme.Modules.glueHom`, absent), which at least says so in a comment: "forward declaration (planned work)".

Two `\lean{}` pins in `Picard_FlatteningStratification.tex` carry `\leanok` and name `Module.*` declarations that read as mathlib but are **in-project** `_root_` declarations: `Module.Flat.of_isLocalizedModule_algebra` (L371, actually `AlgebraicJacobian/Picard/GenericFlatnessGeometric.lean:131`) and `Module.FinitePresentation.exists_matrixPresentation` (L1976, actually `FlatteningStratificationUniversal.lean:433`). I checked the pinned mathlib tree at `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib` — neither name exists there. The `\leanok` is honest (both are proved in-project), but neither node carries `\mathlibok`, which is correct; the naming just invites a reader to assume mathlib provides them. `Module.Flat.of_isPushout` (L871) is a genuine name collision: it exists both in-project at `GenericFlatnessGeometric.lean:681` and in mathlib, so which one the node means is ambiguous.

Cone hygiene is clean otherwise: no dangling `\uses{}` targets anywhere in the slice, and no node with a `\leanok` proof transitively depends on a sorried leaf through `\uses{}` edges.
