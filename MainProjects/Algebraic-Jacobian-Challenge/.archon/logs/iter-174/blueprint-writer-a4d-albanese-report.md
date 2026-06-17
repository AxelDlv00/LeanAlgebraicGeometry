# Blueprint Writer Report

## Slug
a4d-albanese

## Status
COMPLETE

The new chapter `blueprint/src/chapters/Albanese_AlbaneseUP.tex` is written
with all four required declaration blocks (`lem:abel_jacobi_morphism`,
`lem:poincare_bundle_pullback`, `lem:moduli_pullback_morphism`,
`thm:albanese_universal_property`), full citation discipline (verbatim Milne
+ Kleiman quotes, each pinned to a `references/<file>` parenthetical), and a
five-step moduli-theoretic proof of the main theorem accompanied by Milne's
verbatim symmetric-power proof. Two strategy-modifying findings are surfaced
below.

## Target chapter
`blueprint/src/chapters/Albanese_AlbaneseUP.tex` (NEW; 600 LaTeX lines)

## Changes Made
- **Created chapter** with `\chapter{The Albanese universal property of
  $\Pic^0_{C/k}$}` / `\label{chap:Albanese_AlbaneseUP}` and the
  `% archon:covers AlgebraicJacobian/Albanese/AlbaneseUP.lean` declaration
  at the top.
- **Added strategy note** at the chapter head explaining the A.4.d position
  in Route A and the dependencies on A.3 + A.4.c.
- **Added theorem** `\theorem`/`\label{thm:albanese_universal_property}`/
  `\lean{AlgebraicGeometry.Pic0.albanese_universal_property}` — main result:
  Milne III §6 Proposition 6.1 in project notation.
- **Added lemma** `\label{lem:abel_jacobi_morphism}`/
  `\lean{AlgebraicGeometry.Pic0.abelJacobi}` — Abel--Jacobi morphism
  $\iota_{P_0}\colon C \to \Pic^0_{C/k}$ as the moduli classifier of
  $\mathcal O_C(Q-P_0)$.
  - Proof sketch added: Y, via Pic⁰ representability + Summary 6.11 rigidified
    correspondence $\mathcal L^{P_0}$.
- **Added lemma** `\label{lem:poincare_bundle_pullback}`/
  `\lean{AlgebraicGeometry.Pic0.poincareBundlePullback}` — pullback of the
  Poincaré bundle along $\varphi \times \mathrm{id}_{A^\vee}$ to
  $C \times A^\vee$, trivialised along $\{P_0\} \times A^\vee$.
  - Proof sketch added: Y, via commutativity of the pullback diagram and
    the relative Picard presheaf definition.
- **Added lemma** `\label{lem:moduli_pullback_morphism}`/
  `\lean{AlgebraicGeometry.Pic0.moduliPullbackMorphism}` — moduli classifier
  $h_\mathcal L\colon T \to \Pic^0_{C/k}$ produced by representability from a
  trivialised relative degree-zero line bundle.
  - Proof sketch added: Y, Yoneda image of the rigidified $T$-point.
- **Added main-theorem proof** (`\begin{proof}[Proof of \cref{thm:...}]`)
  with both presentations: Milne's verbatim symmetric-power proof (transcribed
  via `% SOURCE QUOTE PROOF:`) and the project's five-step moduli-theoretic
  proof consuming the three sub-lemmas + `\cref{thm:rational_map_to_av_extends}`.
- **Added Lean-encoding section** describing the four target declarations and
  the import wiring (FGAPicRepresentability + Thm32RationalMapExtension).
- **Added witness-wiring section** describing how
  `thm:albanese_universal_property` slots into the
  `\texttt{isAlbaneseFor}` field of a positive-genus
  `JacobianWitness` (\cref{def:JacobianWitness}).
- **Added out-of-scope section** explicitly enumerating: A.2.c, A.3 (Pic⁰
  identity component + degree map), A.4.c, Milne 6.4 / 6.5 / 6.6 autoduality,
  Weil's reconstruction (§III.7), genus-0 case, descent to non-algebraically-
  closed $k$.

## Cross-references introduced
- `\uses{lem:abel_jacobi_morphism, lem:poincare_bundle_pullback,
  lem:moduli_pullback_morphism, thm:rational_map_to_av_extends,
  def:pic_scheme}` on `thm:albanese_universal_property` — all targets exist
  (the three sub-lemmas are local; `thm:rational_map_to_av_extends` is
  `chap:Albanese_Thm32RationalMapExtension`; `def:pic_scheme` is
  `chap:Picard_FGAPicRepresentability`).
- `\uses{def:pic_scheme, def:line_bundle_on_product}` on
  `lem:abel_jacobi_morphism` — verified (`def:line_bundle_on_product` exists
  in `chap:Picard_LineBundlePullback`).
- `\uses{lem:abel_jacobi_morphism, def:line_bundle_on_product}` on
  `lem:poincare_bundle_pullback` — verified.
- `\uses{def:pic_scheme, lem:poincare_bundle_pullback}` on
  `lem:moduli_pullback_morphism` — verified.
- `\cref{chap:Jacobian}`, `\cref{def:Jacobian}`, `\cref{def:JacobianWitness}`,
  `\cref{def:IsAlbanese}`, `\cref{def:genusZeroWitness}`,
  `\cref{thm:rigidity_genus0_curve_to_AV}`, `\cref{thm:Jacobian_proper}`,
  `\cref{thm:Jacobian_geomIrred}` — all exist in `chap:Jacobian` or
  `chap:AbelianVarietyRigidity`.
- `\cref{chap:Picard_LineBundlePullback}` — exists.
- `\cref{thm:fga_pic_representability}` — exists in
  `chap:Picard_FGAPicRepresentability`.

## References consulted
- `references/abelian-varieties.md` — opened to verify PDF offset (+6) and
  locate Prop 6.1 / 6.4 / Summary 6.11 page numbers (doc p.104–107 → PDF
  p.110–113).
- `references/abelian-varieties.pdf` (PDF pages 110, 111, 112, 113, 114, 115)
  — verbatim source of Milne Proposition 6.1 (statement + proof),
  Proposition 6.4 (statement + proof), Summary 6.11. All `% SOURCE QUOTE`
  blocks in the chapter were copied directly from these PDF page renderings.
- `references/kleiman-picard-src/kleiman-picard.tex` (L1384–1399 [`th:cmp`],
  L2091–2110 [`ex:univshf` = universal/Poincaré sheaf], L3960–3988
  [`rmk:Alb` = Albanese map via Pic⁰]) — verbatim source for
  `lem:poincare_bundle_pullback` (`ex:univshf`) and
  `lem:moduli_pullback_morphism` (`rmk:Alb`); also informs the
  divisorial-correspondence terminology.
- `references/summary.md` — confirmed Milne and Kleiman are the two
  authoritative sources for §III.6.
- `blueprint/src/chapters/Jacobian.tex` (lines 1–333) — to align the
  positive-genus Albanese-witness wiring (`def:JacobianWitness` fields,
  the C.2.f Galois-descent sub-step, the marked-point quantifier-reversal
  convention).
- `blueprint/src/chapters/AbelJacobi.tex` (lines 1–100) — to align the
  `\iota_P / \alpha_P` notation, the basepoint convention, and the
  $\mathbf 1$-pointed-morphism encoding.
- `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` (lines
  1–250) — to model the chapter structure (Strategy note + Setup +
  Theorem + Proof + Lean encoding + Out of scope) and to verify the
  Lean signature target `extend_to_av`.
- `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` (lines 1–120)
  — to verify `def:pic_scheme`, `thm:fga_pic_representability` labels.
- `blueprint/src/chapters/Picard_LineBundlePullback.tex` (lines 1–80) — to
  verify `def:line_bundle_on_product` label and to align the relative
  Picard presheaf notation $\Pic^\sharp_{C/k}$.
- `blueprint/src/macros/common.tex` — confirmed `\Pic`, `\Spec`, `\Sym`,
  `\Jac`, `\struct{...}` are predefined and used as expected; no new
  macros required.

## Macros needed (if any)
None new. The chapter uses only macros already defined in
`blueprint/src/macros/common.tex`: `\Pic`, `\Spec`, `\Sym`, `\Jac`,
`\struct{...}`, `\genus`, `\hom`, `\cref`, and standard LaTeX/AMS commands.
`\Picz` (for $\Pic^0$) is not defined; I used the explicit `\Pic^0` instead
throughout. If the plan agent prefers a dedicated macro, the appropriate
addition would be `\DeclareMathOperator{\Picz}{Pic^{0}}` in `common.tex`
(out of my write-domain).

## Reference-retriever dispatches (if any)
None. All sources cited (Milne `abelian-varieties.pdf` and Kleiman
`kleiman-picard.tex`) were already present in `references/` at the start
of the session and contained the verbatim text needed for every citation
block.

## Notes for Plan Agent
- **Pic⁰ chapter (A.3) does not yet exist.** The chapter references
  $\Pic^0_{C/k}$ as the identity component of the representable Picard
  scheme but has no `chap:Picard_IdentityComponent` / `def:pic0_identity` to
  point at — I had to use `\cref{def:pic_scheme}` (the full Picard scheme,
  A.2.c) as the closest existing surrogate and describe the identity-component
  refinement in prose. **Recommend dispatching a separate blueprint-writer for
  A.3** (`Pic^0` identity component + degree map; Kleiman §4.18–4.20 and
  Lemma agps / Proposition pic0) before any prover work touches
  `chap:Albanese_AlbaneseUP`. Without it, every `\lean{...}` target in this
  chapter is gated on a not-yet-stated definition of `Pic^0_{C/k}` as a Lean
  object.
- **Albanese_Thm32RationalMapExtension chapter strategy note already alerts
  to A.4.d's dependency on `thm:rational_map_to_av_extends`.** My chapter
  consumes it as expected.
- **`def:pic_scheme` in `chap:Picard_FGAPicRepresentability` is labeled but
  not yet `\leanok`** — the sync_leanok phase will reflect this. Downstream
  consumers (the present chapter) should expect dependencies to remain
  unmarked until A.2.c lands.
- **The chapter's main theorem proof presents two routes** (Milne's verbatim
  symmetric-power proof and the project's moduli-theoretic proof). The
  symmetric-power route is mentioned because the verbatim Milne source is
  preserved unedited; the project's Lean formalisation is the moduli route.
  If the plan agent prefers a single-route presentation, the symmetric-power
  paragraph can be excised after the `% SOURCE QUOTE PROOF:` block — but
  the verbatim Milne quote should stay (it is the citation-discipline anchor
  for the theorem block).

## Strategy-modifying findings
- **The directive's moduli-theoretic proof outline implicitly invokes Milne's
  autoduality Theorem~III~6.6 ($J \cong J^\vee$ + canonical principal
  polarisation $\varphi_{\mathcal L(\Theta)}$).** The directive describes the
  construction as: pullback the Poincaré bundle $\mathcal P_A$ on
  $A \times A^\vee$ to $C \times A^\vee$ via $\varphi \times \mathrm{id}$ →
  obtain an $A^\vee$-point of $\Pic^0_{C/k}$ → "the expected adjoint is
  $g\colon \Pic^0_{C/k} \to A$". The unstated step is the duality:
  $\mathrm{Hom}(A^\vee, J) \cong \mathrm{Hom}(J^\vee, A) \cong \mathrm{Hom}(J, A)$,
  where the second isomorphism uses the principal polarisation $J \cong J^\vee$.
  **This is a substantial additional Mathlib-side gap** (the full duality
  theory of abelian varieties + the canonical polarisation of a Jacobian)
  that the directive does not enumerate. The project has two routes to
  address it:
  - **Route (i): full Milne III~6.6 autoduality** (= a new chapter
    `chap:AbelianVariety_Autoduality` packaging the
    $\varphi_{\mathcal L(\Theta)}\colon J \to J^\vee$ isomorphism, gated on
    Milne I §8 et seq.: theorem of the cube → ample sheaves → polarisations).
    Estimated ~10–15 iters, includes the cube which the project explicitly
    excised at iter-163 ([[route-c-cube-not-needed-iter163]]). Re-introducing
    the cube on the A.4.d critical path would be a strategy reversal.
  - **Route (ii): the symmetric-power Milne 6.1 proof** (= Sym^g C ⇢ A
    regular by `thm:rational_map_to_av_extends`, descend to $J$ along the
    birational $\sigma\colon C^{(g)} \dashrightarrow J$). This is Milne's
    actual proof of Prop 6.1, requires NO autoduality and NO theorem of
    the cube, but requires `Sym^g C` (= quotient of $C^g$ by the $S_g$
    action). Symmetric powers of schemes are not in Mathlib (Jacobian.tex
    L21–22 already notes this); the project would need to formalise them
    as a project-specific construction. Estimated ~8–12 iters for `Sym^g`
    + the descent through $\sigma$, but no architectural reversal.

  **The choice is strategy-level.** I drafted the chapter with the
  moduli-theoretic route as the project formalisation and presented Milne's
  symmetric-power proof as the verbatim source; the existing chapter
  Albanese_Thm32RationalMapExtension §`thm32_application_to_a4d` (L151–173)
  describes the symmetric-power route, so there is already plan-level
  precedent for Route (ii). **Recommend the plan agent (a) decide between
  Route (i) and Route (ii) before any A.4.d prover work**, and
  **(b) re-issue the writer directive** if Route (ii) is chosen, since the
  moduli sub-lemmas (`lem:poincare_bundle_pullback`,
  `lem:moduli_pullback_morphism`) would then be off the critical path and
  the sub-lemmas would need to be replaced with: `lem:symmetric_product_av_map`
  (the symmetric map $C^{(g)} \to A$), `lem:symmetric_product_to_jacobian`
  (the rational map $C^{(g)} \dashrightarrow J$ from the universal divisor),
  and `lem:descent_through_birational_sigma` (the regular map $J \to A$ by
  Stein factorisation + `thm:rational_map_to_av_extends`).
- **The chapter assumes $C(\bar k)$ is non-empty so $P_0$ exists.** This is
  always true over $\bar k$ algebraically closed for a smooth proper
  irreducible curve, so no genuine constraint, but the project's
  `nonempty_jacobianWitness` signature does NOT require $C(k) \neq \emptyset$
  over the base $k$. The descent of the Albanese property from $\bar k$ back
  to $k$ via the C.2.f Galois-descent step (already in `chap:Jacobian`'s
  proof sketch) is what handles the basepoint-free case at the base field.
  The present chapter operates entirely over $\bar k$ and is silent on the
  descent — this matches the project's split between A.4.d (over $\bar k$)
  and C.2 (Galois descent), and is not a strategy issue.
