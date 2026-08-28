**Note on "at HEAD":** the workspace repo has zero commits — `git rev-parse HEAD` fails ("unknown revision"), `git rev-list --all --count` = 0. All measurements are of the **working tree**. Axiom facts below are real `lake env lean` `#print axioms` checks, not grep.

## (1) Yes — genuine, sorry-free `RepresentableBy` producers exist

All measured `[propext, Classical.choice, Quot.sound]`, no `sorryAx`:

- `AlgebraicGeometry.Grassmannian.represents` — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GrassmannianQuot.lean:5608`. Constructs `(functor d r).RepresentableBy (scheme d r)` for the absolute `Gr(d,r)` — full `homEquiv` + naturality. **The template.** (Its `_hd : 1 ≤ d`, `_hdr : d ≤ r` are underscore-prefixed, i.e. unused by the proof.)
- `Scheme.Grassmannian.prodRepresentableBy` — `GrassmannianRepresentability.lean:357` (base change via `Over.forgetAdjStar`)
- `Scheme.Grassmannian.representable_of_iso_free` — `:383`
- `Scheme.Grassmannian.representable_restrict` — `:560`
- `Scheme.Grassmannian.representable` — `:595`. Full relative Grassmannian from `IsLocallyFreeOfRank V r`, `1 ≤ d ≤ r`.
- `Scheme.representable_of_openCover` — `ZariskiDescentRepresentability.lean:1353` (Zariski descent of representability, Stacks 01JJ; engine `overRepresentableBy` at `:1259`) — a reusable general engine.
- `IdentityComponent.identityComponentRepresentableBy` — `IdentityComponent.lean:707` (`private`).

**Not** a producer: `Scheme.QuotScheme` — `QuotRepresentability.lean:78`, `sorry` at `:79`.

## (2) For `picEt`/`picSharp`: every one is a transport. Zero genuine producers.

The only declaration producing the seam existential without a representation as input is the `sorry` itself: `fgaPicardRepresentability`, `FGAPicRepresentability.lean:905`, `sorry` at `:913` → measured `sorryAx`. `instHasPicSchemeEt` (`:944`), `PicScheme.representableEt` (`:1006`) and `picSchemeOfHasRationalPoint` (`:1162`) are extractions from it — all measured `sorryAx`. `PicSharpRepresentable`/`instPicSharpRepresentable` (`:1530`/`:1540`) and `smoothProperQuotient` (`:1482`) are literally `P → P` (the file's own docstrings say so; `smoothProperQuotient` has zero instances and zero call sites).

**Larger field → base field.** Yes, a whole family — all sorry-free, all taking `rep : (picEt (Scheme.baseChangeField C k')).RepresentableBy X'` over `k'` and concluding over `k`:

- **Thinnest landed one:** `seamClauseOne_of_hasGaloisQuotient_lftFree` — `PicEtGaloisQuotient.lean:30`. Hypotheses: `[FiniteDimensional k k'] [IsGalois k k']`, the `k'`-rep, `[(semilinearGalActionOfRepresentableBy C rep).OrbitsInAffineOpen]`, `hX' : LocallyOfFiniteType X'.hom`. Concludes the **full 3-field seam existential** over `k`. Axiom-clean.
- `representableBy_picEt_of_galoisQuotient` `PicEtDescentGoal.lean:492`; `seamClauseOne_of_galoisQuotient` `:530`; `seamClauseOne_of_isGaloisQuotient` `:625`; `..._canonical` `:647`
- `representableBy_picEt_of_galoisQuotient_canonical` `PicEtInvariantMatch.lean:462`; `seamClauseOne_of_isGaloisQuotient_noMatch` `:501`
- `seamClauseOne_of_isGaloisQuotient_lftFree` `PicEtDescentNecessity.lean:383`
- `representableBy_picEt_of_degenerate` `PicEtDescentGoal.lean:679` — but its own docstring warns the satisfiable models are `k' = k`, so content is not established there.

**Two picEt producers that do NOT take a representation as input** (the only real picEt-side templates) — they need a `Y` plus a natural bijection instead: `representableBy_of_coverCompatibleEquiv` `PicEtDescentRepresentability.lean:348` and `representableBy_of_galInvariantEquiv` `:468`.

The catch for using (1) to feed (2): the descent family's input is a **picEt** representation over `k'`, not a Grassmannian/Div/Quot one, and there is **zero** `RepresentableBy` for `DivFunctor`/`DivFunctorDeg` anywhere in the project, plus no `Div → Grassmannian` natural transformation (`DivGrassmannianEmbedding.lean` has 5 declarations, no functor morphism, no `.olean`, and nothing imports it). So the Grassmannian producers are a template, not yet an ingredient.
