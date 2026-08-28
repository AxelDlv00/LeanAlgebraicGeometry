Census complete. One correction to the brief: `HasRationalPoint` is inhabitable, so the "doubly unreachable" hypothesis does not hold.

## Counts

**Legacy `[HasPicScheme C]` binders: 76 declarations** in `AlgebraicJacobian/` + `scripts/` (79 including 3 in root-level scratch probes). Each declaration has exactly one binder line, so line count = declaration count.

| File | Count |
|---|---|
| `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` | 34 |
| `AlgebraicJacobian/Picard/IdentityComponent.lean` | 14 |
| `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` | 9 |
| `AlgebraicJacobian/Picard/Pic0Dimension.lean` | 6 |
| `AlgebraicJacobian/Picard/GroupSchemeHomogeneity.lean` | 5 |
| `AlgebraicJacobian/Jacobian.lean` | 4 |
| `AlgebraicJacobian/Picard/HomogeneityOrbitCollapse.lean` | 2 |
| `scripts/axiom-frontier.lean` | 2 |
| (`Probe3.lean` 1, `Probe4.lean` 2 — scratch, outside scope) | 3 |

Raw grep gives 191 hits for `HasPicScheme`; only 79 are code lines. **112 of 191 (59%) are docstring prose.** That gap is the whole census: `Pic0AbelianVariety.lean` alone has 44 mentions for 34 binders, and `scripts/axiom-frontier.lean` has 16 mentions for 2 binders.

Key names — Jacobian.lean: `smoothOfRelativeDimension_genus_pic0` (:390), `finrank_tangentSpace_pic0_eq_genus` (:481), `isAlbanese_pic0` (:511), `isAlbanese_pic0_of_isAlgClosed` (:588). IdentityComponent.lean: `Pic0Scheme` (:1386), `classOfSection`, `degreeOfSection`, `degreeOfSectionPinned`, `degree` (:1702), `finrank_eq_genus` (:1910), `kPoints_iff_kerDegree` (:1953), `inclusion`. Pic0AbelianVariety.lean: `grpObj`, `tangentSpaceIso`, `tangentSpaceCotangentDual`, `smooth`, `proper`, `universallyClosed`, `geometricallyIrreducible`, `isAbelianVariety` (twice, :1605 and :1624). No `*Witness*` declaration takes the legacy binder — `picardJacobianWitness` (:685) is clean.

## Kinds (76 scoped)

60 `theorem`, 9 `def`, 5 `instance`, 2 `class`. The 2 classes (`PicSharpRepresentable` :792, `PicSchemeLocallyOfFiniteType` :902) and 5 instances are plumbing. Roughly 20 are statements a human reads as project results — the `Pic0.{smooth, proper, universallyClosed, geometricallyIrreducible, isAbelianVariety, tangentSpaceIso}` group plus the `Pic0Dimension`/`GroupSchemeHomogeneity` genus-dimension theorems. The remaining ~40 theorems are transport/helper steps.

## Q3 — added beside, not replacing

**15 étale declarations vs 76 legacy: ratio 1:5.1.** The étale side is a thin parallel spine (`Pic0Et.lean` 10, `FGAPicRepresentability.lean` 5) covering only the 6 witness fields plus 4 structural instances. It has no counterpart for the tangent-space chain, the degree API, `kPoints_iff_kerDegree`, `Pic0Dimension`, `GroupSchemeHomogeneity`, or `HomogeneityOrbitCollapse`. Every `Et` declaration in the project is one of 9 names, all listed at `Pic0Et.lean` / `FGAPicRepresentability.lean:355-443`.

## Q4 — yes, reachable, at 4 real sites

`picSchemeOfHasRationalPoint` has 40 grep hits, of which **4 are actual call sites** (rest docstrings/`#print axioms`): `AlgebraicJacobian/Jacobian.lean:635` (`picardJacobianWitnessOfHasRationalPoint`), `AlgebraicJacobian/Albanese/AlbaneseUP.lean:366` (`Pic0.bundle`), `scripts/ajcrr-genusfieldinvariance-axioms.lean:163`, and `scripts/axiom-frontier.lean` (14 `haveI` in probe examples). Zero `instance` producers of `HasPicScheme` exist — confirmed, `instHasPicScheme` survives only in prose.

## Q5 — `HasRationalPoint` IS inhabitable; the subtree is NOT doubly unreachable

`class HasRationalPoint` at `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:153` asks for a section `σ : Spec k ⟶ C.left` with `σ ≫ C.hom = 𝟙`. `hasRationalPoint_of_curve` is confirmed deleted (prose-only). But two producers remain:

- `hasRationalPoint_of_isAlgClosed` (`AlgebraicJacobian/Albanese/AlbaneseUP.lean:289`) — **unconditional, sorry-free, fully proved** via Jacobson space + closed point over `k̄`.
- `hasRationalPoint_of_curve_of_isAlgClosed` (`AlgebraicJacobian/Jacobian.lean:377`) — one-line wrapper on the above.
- Plus `instance hasRationalPoint_baseChangeField` (`AlgebraicJacobian/RiemannRoch/CurveBaseChange.lean:285`), propagating along base change.

So the legacy subtree is **singly** gated, not doubly: reachable over algebraically closed fields, unreachable over a general field. Your premise that `picSchemeOfHasRationalPoint` "cannot fire" is wrong for the `k̄` case, and `AlbaneseUP.lean:360-372` is a live consumer that fires today.

## Q6 — legacy side

`Pic0Scheme`, `degree`/`degreeOfSection`/`degreeOfSectionPinned`, `classOfSection`, `kPoints_iff_kerDegree`, `finrank_eq_genus`, and the whole tangent chain (`tangentSpaceIso`, `tangentSpaceCotangentDual`, `cotangentSpaceDual_equiv_relPicKernel`, `pointedDualNumberPoints_equiv_*`) are **all legacy**. Only `Pic0SchemeEt` exists on the étale side, with no degree map and no tangent space.

## Surprises

**The stated sorry count is wrong.** Your brief says "the project's one bare `sorry` at line 347". `AlgebraicJacobian/` contains **26 sorry code lines across 11 files**, including 4 in `Jacobian.lean` itself (:394, :427, :519, :548 — the four leaf theorems `smoothOfRelativeDimension_genus_pic0`, `..._pic0Et`, `isAlbanese_pic0`, `isAlbanese_pic0Et`), 6 in `AlbaneseUP.lean`, 3 in `Pic0AbelianVariety.lean`, 2 each in `Pic0Et.lean`, `IdentityComponent.lean`, `QuotFunctorDef.lean`, `SerreFiniteness.lean`. Notably `IdentityComponent.lean:1916` and `:1963` are the bodies of `finrank_eq_genus` and `kPoints_iff_kerDegree` — two legacy consumers that are themselves unproved, so they are gated *and* sorry-bodied.

**`isAbelianVariety` is declared twice** in `Pic0AbelianVariety.lean` (:1605, :1624), both taking the legacy binder, in what appear to be different namespaces.

**`Pic0AbelianVariety.lean:359-362` documents the legacy binder as a deliberate choice**, stating the declarations carry `[HasPicScheme C]` "rather than the PR's `haveI := instHasPicScheme C` pattern, which needs the absent `[HasRationalPoint C]`" — accurate, but it names a producer (`instHasPicScheme`) that no longer exists.

**`scripts/axiom-frontier.lean:447` is stale**: it calls `instHasPicScheme` the "`sorry`-bodied" sole producer of `HasPicScheme`, describing the deleted instance as if live. Same file :538 and :86 carry the same stale framing.
