# Blueprint Writer Directive

## Slug
differentials-iter114

## Target chapter
blueprint/src/chapters/Differentials.tex

## Strategy context

`Differentials.tex` is the load-bearing blueprint chapter for Phase B of the project (cotangent sheaves; smoothness ↔ Ω locally free; Serre-duality genus). The iter-113 Lean refactor for `AlgebraicJacobian/Differentials.lean` made two structural state changes that the chapter has NOT yet absorbed:

1. **Unique-gluing pivot for `relativeDifferentialsPresheaf_isSheaf`** (the load-bearing iter-114 prover lane target — deferred this iter, scheduled iter-115). The iter-113 Lean introduces a new top-level helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (Lean L168–L175, sorry body) and closes the prior helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (Lean L209–L234) via the Mathlib framework chain `TopCat.Presheaf.isSheaf_of_isSheafUniqueGluing_types` [verified] then `TopCat.Presheaf.IsSheaf.isSheafOpensLeCover` [verified]. The load-bearing mathematical content moved from "refinement-cofinality argument against `isSheaf_iff_isSheafOpensLeCover`" (chapter's current Route (a)) to "universal-property-of-`KaehlerDifferential` + structure-sheaf gluing on `iSup U` + uniqueness via `span_range_derivation`" (the new sub-helper's docstring recipe).

2. **Signature corrections landed iter-113 refactor** for three theorems: `smooth_iff_locally_free_omega` (L873–L880; now `IsSmoothOfRelativeDimension n f ↔ …`), `cotangent_at_section` (L889–L897; now `IsSmoothOfRelativeDimension n f` hypothesis), `serre_duality_genus` (L1033–L1039; now `H^0(Ω) = H^1(O_C)` indices). The chapter's three `% NOTE (iter-112 review)` blocks at L183–188, L209–212, L233–240 claim these signatures are still broken — they are now STALE and actively misleading.

## Required content

Address all four must-fix items from blueprint-reviewer-iter114:

### Item 1 — Add `\lean{...}` declaration block for the unique-gluing sub-helper

Add a new lemma block in §"The relative cotangent sheaf" (somewhere between the proof of `\thm:relative_kaehler_isSheaf` at chapter L28–54 and the definition `\def:relative_kaehler_sheaf` at chapter L56–62; the new block should logically *precede* the `\thm:relative_kaehler_isSheaf` proof, since the latter now delegates to it via Mathlib equivalences).

Block content (informal-mathematical, not Lean-syntactic):

```latex
\begin{lemma}\leanok
[Unique-gluing form of the sheaf condition for $\Omega_{X/S}$]
  \label{lem:relative_kaehler_isSheafUniqueGluing}
  \lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheafUniqueGluing_type}
  \uses{def:relative_kaehler_presheaf}
  The underlying type-valued presheaf of the relative cotangent presheaf
  $\Omega_{X/S}$ satisfies the unique-gluing characterisation of the
  sheaf condition (\texttt{TopCat.Presheaf.IsSheafUniqueGluing}): for
  every family of opens $U \colon \iota \to \mathrm{Opens}(X)$ and every
  compatible family of Kähler differentials
  $sf_i \in \Omega_{X/S}(U_i)$, there is a unique
  $s \in \Omega_{X/S}(\bigvee_i U_i)$ whose restriction to each $U_i$
  equals $sf_i$.
\end{lemma}

\begin{proof}
  \uses{def:relative_kaehler_presheaf, def:universal_derivation}
  Write $F = (\Omega_{X/S})^{\sharp}$ for the underlying type-valued
  presheaf and fix a compatible family $(sf_i)$ as above. The proof
  is in three steps.

  \emph{Step 1: Compatibility transports to the structure sheaf.} For
  each $i$, the universal derivation
  $d \colon \struct{X} \to \Omega_{X/S}$ (Definition~\ref{def:universal_derivation})
  is a morphism of sheaves of abelian groups on $X$; in particular
  $d|_{U_i} \colon \struct{X}(U_i) \to \Omega_{X/S}(U_i)$ is a derivation.
  Mathlib's \texttt{KaehlerDifferential.span\_range\_derivation}
  [verified] (\texttt{Mathlib.RingTheory.Kaehler.Basic}) asserts that
  $\Omega_{B/A}$ is spanned (as a $B$-module) by elements of the form
  $db$ for $b \in B$. Pull each $sf_i$ back to its representation as
  a finite combination of universal-derivation generators
  $\sum_j b_{i,j} \cdot d a_{i,j}$ with $a_{i,j}, b_{i,j} \in
  \struct{X}(U_i)$; the compatibility hypothesis on $sf$ restricts to
  a compatibility hypothesis on the families
  $(a_{i,j})_i, (b_{i,j})_i$ of structure-sheaf sections. The
  structure sheaf $\struct{X}$ is already a sheaf (\texttt{Scheme.ringCatSheaf}
  [verified]), so these compatible families glue uniquely to global
  sections $a_j, b_j \in \struct{X}(\bigvee_i U_i)$.

  \emph{Step 2: Universal property of $\Omega$.} The candidate
  glued section is $s = \sum_j b_j \cdot d a_j \in
  \Omega_{X/S}(\bigvee_i U_i)$. To make this canonical, factor the
  argument through the universal property of $\Omega$. Mathlib's
  \texttt{PresheafOfModules.DifferentialsConstruction.isUniversal'}
  [verified] (\texttt{Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf})
  exhibits $\Omega_{X/S}$ as the universal presheaf-of-modules-derivation
  target of $\struct{X} \to \Omega_{X/S}$; the existence of $s$ follows
  from descending the derivation $d \colon \struct{X}(\bigvee_i U_i) \to
  \Omega_{X/S}(\bigvee_i U_i)$ along the glued ring sections.
  Equivalently, on each affine chart this is
  \texttt{ModuleCat.Derivation.desc} [verified]
  (\texttt{Mathlib.Algebra.Category.ModuleCat.Differentials.Basic}).

  \emph{Step 3: Uniqueness.} If $s, s' \in \Omega_{X/S}(\bigvee_i U_i)$
  both restrict to $sf_i$ on each $U_i$, then $s - s'$ restricts to
  zero on each $U_i$. By Mathlib's
  \texttt{KaehlerDifferential.span\_range\_derivation} the module
  $\Omega_{X/S}(\bigvee_i U_i)$ is spanned by elements of the form
  $db$ for $b \in \struct{X}(\bigvee_i U_i)$; on each spanning
  element, $d b$'s restriction to $U_i$ is determined by $b|_{U_i}$,
  which equals the restriction of the unique gluing data. By
  \texttt{TopCat.Presheaf.Sheaf.eq\_of\_locally\_eq} [verified]
  (\texttt{Mathlib.Topology.Sheaves.SheafCondition.UniqueGluing})
  applied to the structure sheaf, $s$ and $s'$ agree on all spanning
  generators, hence on the whole module. Hence $s = s'$.
\end{proof}
```

**Important caveats for the writer**:

- Mark this lemma with `\leanok` on the statement line because the Lean declaration exists with a sorry body (per blueprint conventions, `\leanok` on a *statement* means "formalised with at least a sorry"). Do **NOT** put `\leanok` on the proof block.
- The mathlib-analogist-iter114 dispatch is *also* in flight this iter, auditing the `Scheme.PresheafOfModules`-from-affine-basis bridge. If that dispatch surfaces an off-the-shelf Mathlib API that supersedes the 3-step recipe above, the iter-115 plan will request a follow-up writer revision. For now, document the iter-113 prover's recipe (the one in the Lean docstring at L148–L167) as the chapter's recipe.
- Add `\uses{def:relative_kaehler_presheaf, def:universal_derivation}` to keep the dependency graph honest.

### Item 2 — Update the proof of `\thm:relative_kaehler_isSheaf`

Current proof at chapter L28–L54 enacts Route (a) (refinement-cofinality against `isSheaf_iff_isSheafOpensLeCover`). After iter-113, the Lean delegates to `lem:relative_kaehler_isSheafUniqueGluing` via the framework Mathlib chain. Either:

- **Option (i, preferred)** — Replace the proof body with a short delegation:

  > "By Mathlib's \texttt{TopCat.Presheaf.isSheaf\_iff\_isSheaf\_comp} [verified] applied to the forgetful chain $\mathrm{ModuleCat}\,\struct{X} \to \mathrm{AddCommGrp} \to \mathrm{Type}$, it suffices to verify the sheaf condition on the underlying type-valued presheaf $F$. Mathlib's \texttt{TopCat.Presheaf.isSheaf\_of\_isSheafUniqueGluing\_types} [verified] reduces this further to the unique-gluing condition, which is the content of Lemma~\ref{lem:relative_kaehler_isSheafUniqueGluing}."

  Keep `\uses{lem:relative_kaehler_isSheafUniqueGluing, def:relative_kaehler_presheaf}` in the proof block.

- **Option (ii, only if you cannot land Option (i) due to LaTeX structure conflicts)** — Retain Route (a) prose as a `\begin{remark}` block titled "Historical route (a)" and add a new `\begin{proof}` body enacting the unique-gluing delegation. Less preferred (chapter grows).

Pick (i). The old Route (a) prose (refinement-cofinality + Step 2 + Step 3) is moot now that the load-bearing math is parked in `lem:relative_kaehler_isSheafUniqueGluing`; preserving it as historical clutter is not justified.

Drop the `[gap]` callout at chapter L51 (it was describing the old Route (a) "basis-to-opens descent gap"; that's no longer the load-bearing step). If the mathlib-analogist-iter114 surfaces a NEW gap on the unique-gluing recipe (e.g. no Mathlib API for descending structure-sheaf gluing to differential gluing), iter-115 may re-add a `[gap]` callout pointing at THAT.

### Item 3 — Remove three stale `% NOTE (iter-112 review)` blocks

Delete the following blocks:

- L183–L188 — stale claim that `smooth_iff_locally_free_omega` uses `Smooth f` + free `n`.
- L209–L212 — stale claim that `cotangent_at_section` has the same issue.
- L233–L240 — stale claim that `serre_duality_genus` writes `HModule k _ 0 = HModule k _ 0`.

These were `% NOTE` annotations from the iter-112 review, addressed by the iter-113 refactor. The Lean signatures are now correct (verified by lean-vs-blueprint-checker-differentials-iter113 and re-verified by blueprint-reviewer-iter114). The `% NOTE` blocks now misdirect a prover reading the chapter, claiming refactor work is still needed when in fact it has landed.

### Item 4 — Relax `\thm:serre_duality_genus` prose to match the Lean hypothesis form

Current prose at L241–L251 says "smooth proper geometrically irreducible curve over a field $k$". The Lean signature at `Differentials.lean:1033–L1037` uses:

```
[IsIntegral C.left] [IsProper C.hom] (hsmooth : Smooth C.hom)
```

— i.e. *integral* (NOT geometrically irreducible), proper, smooth (NOT `IsSmoothOfRelativeDimension 1` — dimension-1 is implicit).

`AlgebraicGeometry.IsGeometricallyIntegral` for schemes is a verified `[gap]` in Mathlib b80f227 (strategy-critic-iter114 confirmed). Resolution: relax the prose to match the Lean. Concretely:

- Replace "smooth proper geometrically irreducible curve over a field $k$" with "smooth proper integral curve over a field $k$" (or "smooth proper integral $k$-scheme of dimension 1" — pick the cleanest LaTeX phrasing that's mathematically equivalent to what the Lean encodes).
- Add a one-sentence `\begin{remark}` immediately after the theorem statement noting: "The classical statement of Serre duality on curves assumes geometric irreducibility; on a generic base field $k$ the project's `IsIntegral` hypothesis is the closest Mathlib-available stand-in (the geometric-irreducibility predicate at the scheme level is absent from Mathlib b80f227). For the dimension equation $\dim_k H^0(\Omega) = \dim_k H^1(\struct{C})$ the integrality hypothesis suffices."

Do NOT add a `\lean{...}` correction; the Lean is the source of truth here.

### Optional opportunistic cleanup (only if you're already in the file)

- **Stale Lean line-reference at L51**: chapter says "lines~113--122"; the new Lean structure is at L168–L284 (the unique-gluing helper + helper #1 body + helper #2 + main theorem body). Either update or drop the reference. Suggest: drop the reference (you're rewriting the proof anyway per Item 2).
- **Quasi-coherence claim**: `\def:relative_kaehler_sheaf` (L56–62) asserts the sheaf "is quasi-coherent". The Lean (`Differentials.lean:290–291`) packages it only as `X.Modules` without an explicit `IsQuasicoherent` data field. Soften to "morally quasi-coherent (the presheaf is locally a Mathlib `KaehlerDifferential` module, but the Lean does not currently carry the `IsQuasicoherent` typeclass on the sheaf object)" or drop the QC adjective entirely.

## Out of scope

- Do **NOT** edit any other chapter (`Picard_*.tex`, `Modules_Monoidal.tex`, `Cohomology_*.tex`, etc.). Cross-chapter inconsistencies you spot go in "Notes for Plan Agent".
- Do **NOT** touch `content.tex` (top-level blueprint file).
- Do **NOT** edit any `.lean` file.
- Do **NOT** add or remove `\leanok` or `\mathlibok` markers anywhere except as explicitly specified in Item 1 (statement-line `\leanok` on the new lemma). The `sync_leanok` phase manages other `\leanok` updates.
- Do **NOT** speculate on iter-115+ recipe changes that depend on the mathlib-analogist-iter114 verdict (still in flight). The chapter should document the iter-113 Lean state; if the analogist surfaces a different recipe iter-115 will reverse-engineer the chapter.
- Do **NOT** dispatch a reference-retriever this iter; the recipe is grounded in Mathlib idiomatic names already verified upstream, no external source is needed.

## References

- `references/challenge.lean`: authoritative source for the 9 protected declarations (no direct content for §Sheaf condition, but the chapter must remain compatible with the protected signatures).

## Expected outcome

After your edits, the chapter:

- Contains a new declaration block `\lem:relative_kaehler_isSheafUniqueGluing` with informal-mathematical prose detailing the 3-step closure recipe (universal derivation + structure-sheaf gluing + span_range_derivation uniqueness), `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheafUniqueGluing_type}`, and `\uses{def:relative_kaehler_presheaf, def:universal_derivation}`.
- Has the proof of `\thm:relative_kaehler_isSheaf` rewritten to delegate cleanly to the new lemma via the Mathlib framework chain (Option (i) above).
- Drops the 3 stale `% NOTE (iter-112 review)` blocks.
- Has `\thm:serre_duality_genus` prose relaxed to match the Lean (`IsIntegral` + `Smooth` + `IsProper`, dimension-1 implicit; with explanatory remark on the geometric-irreducibility gap).
- Is valid LaTeX (balanced begin/end; balanced braces in `\lean{...}`, `\uses{...}`, `\label{...}`).

After your dispatch returns, the iter-114 plan agent will re-verify the chapter passes the HARD GATE for iter-115's prover lane re-opening on L175 (subject also to the mathlib-analogist-iter114 verdict).
